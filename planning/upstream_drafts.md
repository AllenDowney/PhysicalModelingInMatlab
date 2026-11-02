# Drafts of upstream issues and PRs (for Allen to review before posting)

Task 4. All three posted 2026-11-02.

---

## 1. xeus-octave PR: show axes titles with the plotly toolkit

**Posted:** https://github.com/jupyter-xeus/xeus-octave/pull/146

**Repo:** jupyter-xeus/xeus-octave, from `AllenDowney:plotly-axes-title` (commit `cb09add`)

**Title:** Show axes titles with the plotly toolkit

**Body:**

With the plotly toolkit (the default in JupyterLite), `title` has no visible effect:

```octave
plot(1:3, 1:3)
title('My title')
```

The plot appears without its title. This was reported in #113, which was closed without a fix. The toolkit draws the x, y and z labels but never reads the axes' `title` property.

This PR draws the title as an annotation centered above the axes, using the title's font size, color and interpreter, and bold when its `fontweight` is bold (Octave's default). It works for 2-D and 3-D axes and for subplots (each title goes above its own axes). Legends, which are axes too, are skipped.

Tested:
- A new test, `test_plot_plotly_title`, fails without the change and passes with it; the rest of the suite passes.
- Desktop build (conda-forge Octave 10.3) and WebAssembly build (emscripten-forge), in JupyterLite: titles on single plots, subplots, a 3-D plot, with a legend, with TeX (`x^2`, `\alpha`), and with `'fontweight', 'normal'`.

(The WebAssembly build needed the change in #145 to link with the current libflang.)

---

## 2. xeus-octave PR: find the Fortran runtime under its new name

**Posted:** https://github.com/jupyter-xeus/xeus-octave/pull/145

**Repo:** jupyter-xeus/xeus-octave, from `AllenDowney:wasm-flang-runtime-name` (commit `c2eed0e`)

**Title:** Find the Fortran runtime under its new name in the WebAssembly build

**Body:**

With the current emscripten-forge `libflang` (22.x), the WebAssembly build fails to link:

```
wasm-ld: error: unable to find library -lFortranDecimal
wasm-ld: error: unable to find library -lFortranRuntime
```

Recent flang releases ship the Fortran runtime as one library, `libflang_rt.runtime.a`, instead of `FortranRuntime` and `FortranDecimal`. This PR looks the library up under either name with `find_library`, and adds `FortranDecimal` to the link only when it exists, so the build works with old and new versions of libflang.

Tested: a WebAssembly build against emscripten-forge-4x (libflang 22.1.6) links, and in JupyterLite the kernel runs `ode45`, plots, and linear algebra (`\`, `eig`), which goes through the Fortran libraries.

---

## 3. emscripten-forge issue: Octave queues every graphics listener

**Posted 2026-11-02:** https://github.com/emscripten-forge/recipes/issues/8228 (issue only, Allen's choice; the fix is not verified by a rebuild)

**Repo:** emscripten-forge/recipes

**Title:** octave: patch 0015 makes graphics listeners run late, which hangs `legend`

**Body:**

`recipes/recipes_emscripten/octave/patches/0015-Disable-multithreading.patch` changes `gh_manager::execute_listener` from

```cpp
if (octave::thread::is_thread ())
```

to `if (false)`, so every property listener is posted to the event queue and runs after the code that triggered it, instead of immediately. In a single-threaded build, the interpreter is always on "the" thread, so the listener should always run immediately: `if (true)`.

How to see it, in JupyterLite with xeus-octave:

```octave
ax = axes;
addlistener (ax, 'xlim', @(~,~) disp ('listener'));
disp ('before'); set (ax, 'xlim', [0 2]); disp ('after')
```

Desktop Octave prints before, listener, after. The WebAssembly build prints before, after, listener.

Consequences, with xeus-octave's plotly toolkit:

- `legend` hangs the kernel for some labels and font sizes, for example:

  ```octave
  plot(1:3, 1:3); hold on; plot(1:3, 2:4)
  legend('euler', 'ode45')
  ```

  `legend.m` guards its layout with an `__updating_layout__` flag, which assumes listeners run during `set`. Run later, the legend's position listener (`update_position_cb`) treats the layout's own change as the user moving the legend, sets `location` to `none`, and `update_position_cb` and `update_layout_cb` then call each other forever. (Traced with an instrumented copy of `legend.m`; the desktop kernel never calls `update_position_cb` here.)

- `legend` followed by `clf` fails with `getappdata: H must be a scalar or vector of graphic handles` (from `legend>update_displayname_cb`, which runs after `clf` deleted the legend) and hangs:

  ```octave
  plot(1:3, 1:3); legend('a'); clf; plot(1:3, 3:-1:1)
  ```

Proposed fix: change the patch to `if (true)` (or define `thread::init` and `thread::is_thread` in the `__EMSCRIPTEN__` branch that patch 0013 adds to `oct-mutex.cc`, returning true, and drop 0015).

(Status: the cause is confirmed by the trace and the listener-order test. The fix itself is not yet verified, which needs a rebuild of the Octave package.)

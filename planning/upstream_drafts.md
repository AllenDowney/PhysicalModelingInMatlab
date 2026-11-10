# Drafts of upstream issues and PRs (for Allen to review before posting)

Task 4. Items 1–5 posted 2026-11-02; item 6 posted 2026-11-10, fixed the same day (Allen's confirming reply: https://github.com/emscripten-forge/recipes/issues/8354#issuecomment-6778831694).

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

---

## 4. plotly.py PR: redraw a figure when its output is updated

**Posted:** https://github.com/plotly/plotly.py/pull/5865 (changelog entry added after opening); merged 2026-11-06

**Repo:** plotly/plotly.py, from `AllenDowney:mimerenderer-update-display` (commit `a96f8330`). After opening, add the changelog entry with the PR number (their CI requires one), under "Unreleased / Fixed".

**Title:** Redraw a figure in JupyterLab when its output is updated

**Body** (their template):

### Link to issue

Closes #3053, which was closed as stale in 2024; it still happens with jupyterlab-plotly 7.1.0.

### Description of change

When a kernel updates a displayed figure with `update_display_data` (for example IPython's `DisplayHandle.update`), JupyterLab calls `renderModel` again on the existing renderer, and `renderModel` returned early because it already had a graph, so the figure never changed. Now it redraws (with `Plotly.react`, through `createGraph`) when the figure in the new model differs from the one it drew. It still returns early when the figure is the same, which is what happens when `createGraph` stores the PNG of the figure in the model.

### Demo

The example from #3053, in JupyterLab 4 with plotly 7.1.0:

```python
from IPython.display import display
out = {'application/vnd.plotly.v1+json': {'data': [{'x': ['giraffes', 'orangutans', 'monkeys'], 'y': [20, 14, 23], 'type': 'bar'}], 'layout': {}}}
h = display(out, raw=True, display_id=True)
```

```python
import time
for y0 in [10, 5, 1]:
    out['application/vnd.plotly.v1+json']['data'][0]['y'][0] = y0
    h.update(out, raw=True)
    time.sleep(0.5)
```

Before: the first bar stays at 20. After: it goes to 10, 5, then 1.

This also fixes animations in the Octave kernel [xeus-octave](https://github.com/jupyter-xeus/xeus-octave) (its issue #2), which draws figures with this renderer and updates them on each `drawnow`; checked in JupyterLite with an 8-frame loop: before, the plot stays on the first frame; after, it steps through all eight.

### Testing strategy

I didn't find tests for the mime renderer to extend, so I tested by hand: the two examples above, before and after, in JupyterLab 4 and in JupyterLite 0.8, checking the plot's data in the page; and a plot with no updates still renders.

---

## 5. Comment on plotly.py #3053

**Posted:** https://github.com/plotly/plotly.py/issues/3053#issuecomment-6590290427

**Where:** https://github.com/plotly/plotly.py/issues/3053 (closed; the closing comment asks for a comment with a recent version to reopen it)

**Body:**

This still happens with jupyterlab-plotly 7.1.0 in JupyterLab 4 (and JupyterLite 0.8), with the example above. The cause is in `js/src/mimeExtension.ts`: `renderModel` returns early whenever the widget already has a graph, so an `update_display_data` never reaches `Plotly.react`. #5865 redraws when the figure has changed. It also affects the Octave kernel xeus-octave, whose animations stay on their first frame.

---

## 6. Follow-up on emscripten-forge #8228: the 6x kernel doesn't start in Chromium

**Posted 2026-11-10:** https://github.com/emscripten-forge/recipes/issues/8354

**Where:** a new issue in emscripten-forge/recipes (Allen, 2026-11-10), following up on https://github.com/emscripten-forge/recipes/issues/8228 (closed 2026-11-10)

**Title:** xeus-octave (6x): xoctave.wasm doesn't compile in Chromium (mix of legacy and new exception handling)

**Body:**

Follow-up to #8228. Thanks for the quick fix, @IsabelParedes! I tried the new packages from `emscripten-forge/6x` in a JupyterLite build: octave 11.3.0 `hac827d2_0` and xeus-octave 0.7.0 `h4739749_0`. In Firefox, listeners now run immediately, and both `legend` examples from #8228 work.

In Chromium (156), though, the kernel doesn't start, because `xoctave.wasm` fails to compile:

```
CompileError: WebAssembly.instantiate(): Compiling function #795 failed: module uses a mix of legacy and new exception handling instructions @+770779
```

Only the main module fails. In Chromium, `libxeus.so`, `liboctave.so` and `liboctinterp.so` compile, and so does `xoctave.wasm` from the 4x packages (xeus-octave 0.7.0 `h6cd6e3e_0`). The 6x `xoctave.wasm` is much larger (8 MB, up from 3 MB), so maybe one of the static libraries now linked into it was built with the legacy exception handling.

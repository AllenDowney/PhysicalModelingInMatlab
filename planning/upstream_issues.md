# Issues to report upstream

Problems found while putting the book's code in the browser (Task 2). Each one is reproduced in xeus-octave 0.7.0 and Octave 10.3.0 (WebAssembly), built from emscripten-forge, on our site, and checked on the upstream demo site where noted. The repo is [jupyter-xeus/xeus-octave](https://github.com/jupyter-xeus/xeus-octave), and its issues are at https://github.com/jupyter-xeus/xeus-octave/issues.

For each issue: status (not reported / reported, with a link / fixed in version) and how we work around it.

## 1. `legend` hangs the kernel for some labels and font sizes

**Status:** reported to emscripten-forge, [recipes#8228](https://github.com/emscripten-forge/recipes/issues/8228) (2026-11-02; cause below). Found 2026-11-01. Also happens on the upstream demo site.

**Reproduce** (the cell never finishes, and the kernel has to be restarted):

```
plot(1:3, 1:3)
hold on
plot(1:3, 2:4)
legend('euler', 'ode45')
```

It depends on the label text together with the font size, which suggests a loop in measuring the legend's text:

| Labels | Font size 8 | 9 | 10 (default) | 11 | 12 |
|---|---|---|---|---|---|
| `'euler', 'ode45'` | works | hangs | hangs | works | works |
| `'rabbits', 'foxes'` | | | works | hangs | |
| `'X position', 'Y position'` | | | works | works | |
| `'a', 'b'`, `'a', 'ode45'`, `'euler', 'b'`, `'abcde', 'fghij'` | | | work | | |

Blank cells weren't tested. The same thing happens with `legend({...})` and with `'Location', 'northwest'`.

**Workaround:** in the cell that calls `legend`, set a font size that works for those labels, for example `set(gca, 'fontsize', 11)` (Chapter 9). Check each chapter's legends when converting it.

**Possibly related:** open PR [#144 "Interactive legend"](https://github.com/jupyter-xeus/xeus-octave/pull/144) (2026-06-29) changes legend handling.

**Cause (found 2026-11-02, Task 4):** not xeus-octave but the Octave package it's built on. emscripten-forge's recipe patches Octave with [`0015-Disable-multithreading.patch`](https://github.com/emscripten-forge/recipes/blob/main/recipes/recipes_emscripten/octave/patches/0015-Disable-multithreading.patch), which changes `gh_manager::execute_listener` from `if (octave::thread::is_thread ())` to `if (false)`. So every property listener is queued and runs after the code that triggered it, instead of immediately (in a single-threaded browser, the right answer is always "run now"). Shown with `ax = axes; addlistener (ax, 'xlim', @(~,~) disp ('listener')); disp ('before'); set (ax, 'xlim', [0 2]); disp ('after')`: the browser prints before, after, listener; desktop Octave prints before, listener, after.

`legend.m` guards its layout with an `__updating_layout__` flag, which assumes listeners run during the `set`. Run later, the legend's position listener (`update_position_cb`) sees the flag cleared, treats the layout's own change as the user moving the legend, sets `location` to `none`, and the layout and position callbacks then call each other forever. An instrumented `legend.m` stopped after 300 calls showed `update_position_cb update_layout_cb` repeating; the desktop kernel never calls `update_position_cb`. Why only some labels and font sizes: the queued `update_displayname_cb` and `update_string_cb` re-run the layout, and whether that changes the position depends on the text's size.

The desktop xeus-octave kernel (built from source, plotly toolkit, also with no display so it has the browser's 72 pixels per inch) doesn't hang.

## 2. `legend` followed by `clf` raises an error and hangs

**Status:** included in [recipes#8228](https://github.com/emscripten-forge/recipes/issues/8228) (2026-11-02). Found 2026-11-01.

**Reproduce:**

```
plot(1:3, 1:3)
legend('a')
clf
plot(1:3, 3:-1:1)
```

The result is `error: getappdata: H must be a scalar or vector of graphic handles`, called from `legend>update_displayname_cb`, and the cell doesn't finish. `code/chap10/lotka.m` does this: it draws a time series with a legend, then calls `clf` to draw the phase plot.

**Workaround:** none yet. For Chapter 10, split the two plots into separate cells, since each cell starts a new figure anyway.

**Cause (likely, 2026-11-02):** the same queued listeners as issue 1: `update_displayname_cb` runs after `clf` has deleted the legend.

## 3. Plot titles don't appear

**Status:** fixed in our fork, branch [`plotly-axes-title`](https://github.com/AllenDowney/xeus-octave/tree/plotly-axes-title) (2026-11-02); PR [#146](https://github.com/jupyter-xeus/xeus-octave/pull/146), 2026-11-02. Not a regression: the plotly toolkit never drew the axes title. [#113](https://github.com/jupyter-xeus/xeus-octave/issues/113) reported it and was closed in 2024 without a fix.

**Reproduce:** `plot(1:3, 1:3); title('My title')` shows the plot with no title. Axis labels and legends do appear.

**Workaround:** none needed for the book so far, since most of its figures have no titles.

## 4. Plots don't update while a cell runs, so animations show only the first frame

**Status:** reported upstream as xeus-octave [#2 "Plotly renderer does not update"](https://github.com/jupyter-xeus/xeus-octave/issues/2) (open since 2021). Confirmed 2026-11-01. Fixed on our site 2026-11-02 (below).

**Reproduce:** this loop takes 2 s (so `pause` works), but the figure shows only the first point:

```
for i = 1:5
    clf; hold on
    axis([0 6 0 6])
    plot(i, i, 'o')
    drawnow;
    pause(0.2);
end
```

**Cause (found 2026-11-02, Task 4):** not xeus-octave, which sends an `update_display_data` for each frame in real time (checked in the browser's message log), but plotly.py's JupyterLab renderer (jupyterlab-plotly 7.1.0): `renderModel` returns early when it already has a graph, so every update after the first frame is ignored. The same bug was reported to plotly.py in 2021 as [#3053](https://github.com/plotly/plotly.py/issues/3053) (by xeus-octave's original author), closed as stale in 2024. Fix on the fork's branch [`mimerenderer-update-display`](https://github.com/AllenDowney/plotly.py/tree/mimerenderer-update-display): redraw when the figure changes. Checked with Python display-handle updates in JupyterLab 4 and with Octave animations in JupyterLite. PR [plotly.py#5865](https://github.com/plotly/plotly.py/pull/5865) and a comment on #3053, 2026-11-02; merged 2026-11-06, awaiting a release. Our site patches the renderer until then (`site/build.sh`).

**Workaround (2026-11-02, Allen):** `site/build.sh` patches the built renderer the same way (and fails if a new version changes the code), so animations play on our site; Chapter 13's `animate(T, M)` is a runnable cell again (the note and the still picture removed). Remove the patch when plotly.py releases a fix.

## Differences from desktop Octave that aren't bugs

These are worth knowing when converting chapters, but there's nothing to report:

- **Each cell starts a new figure.** `xlabel`, `legend` and `hold on` in a later cell don't act on an earlier plot. Workaround: the plot and its decorations go in the same cell (Chapter 9: `plot_solutions`).
- **`saveas` and `print` to EPS can't work:** there's no Ghostscript in the browser, and no folder to save to. These examples are shown as text.
- **Run All stops at the first error**, including errors the book makes on purpose. That's JupyterLab's behavior: the `raises-exception` tag only affects `nbconvert`. Readers step past errors with Shift+Enter.
- **`help` fails for built-in functions** (`help sin`: "unable to start subprocess for 'makeinfo'"); it works for functions and scripts with a comment header. Chapter 1's `help sin` is shown as text with a note.
- **Nested functions can't be defined in a cell** ("nested functions not implemented in this context"); that's Octave's rule for code outside a file. `code/chap14/binary.m` uses them.
- **`comet3` is very slow:** `code/chap04/lorenz.m` takes about 150 s in the browser and shows one dot (it animates); `plot3` takes about 5 s.
- **`ls` fails** ("unable to start subprocess"), because a browser can't run shell commands. `dir` works.

## The project's health (2026-11-01)

From the GitHub API:

- **Who maintains it:** in practice QuantStack, three people: Isabel Paredes (68 of the 95 commits since 2025), Johan Mabille and Sylvain Corlay.
- **Activity comes in bursts:**
  - 2022–2023, the first version
  - August–September 2025, the WebAssembly build and releases 0.3–0.6
  - January and March 2026, a few commits (0.6.3 was released 2026-01-26)
  - Nothing since 2026-03-11, eight months
- **Backlog:** 41 open issues, many from 2021–2023 with no reply. Four PRs are unmerged, the oldest from 2025-11.
- **Size and license:** 82 stars, 20 forks. GPL-3.0.

So it works, but reports may sit for a while. A fork is feasible:
- Upstream CI already builds the WebAssembly kernel from source (`.github/workflows/deploy-github-page.yml`: emscripten, `environment-wasm-host.yml`, then `jupyter lite build`).
- A fork could carry fixes and build the kernel for our site the same way, instead of installing the `xeus-octave` package from emscripten-forge.
- The cost: we'd own a build of Octave for WebAssembly. Do it only if the bugs above block chapters and upstream doesn't respond.

## Next steps

1. Report issues 1–3 upstream, each with its reproduction, and link them here; comment on #2 for issue 4.
2. If issue 1 stays open, consider a fork. Issue 1 is the most serious, because it hangs the kernel.

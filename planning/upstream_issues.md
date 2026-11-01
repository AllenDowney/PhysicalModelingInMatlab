# Issues to report upstream

Problems found while putting the book's code in the browser (Task 2). Each one is reproduced in xeus-octave 0.7.0 and Octave 10.3.0 (WebAssembly), built from emscripten-forge, on our site, and checked on the upstream demo site where noted. The repo is [jupyter-xeus/xeus-octave](https://github.com/jupyter-xeus/xeus-octave), and its issues are at https://github.com/jupyter-xeus/xeus-octave/issues.

For each issue: status (not reported / reported, with a link / fixed in version) and how we work around it.

## 1. `legend` hangs the kernel for some labels and font sizes

**Status:** not reported. Found 2026-11-01. Also happens on the upstream demo site.

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

## 2. `legend` followed by `clf` raises an error and hangs

**Status:** not reported. Found 2026-11-01.

**Reproduce:**

```
plot(1:3, 1:3)
legend('a')
clf
plot(1:3, 3:-1:1)
```

The result is `error: getappdata: H must be a scalar or vector of graphic handles`, called from `legend>update_displayname_cb`, and the cell doesn't finish. `code/chap10/lotka.m` does this: it draws a time series with a legend, then calls `clf` to draw the phase plot.

**Workaround:** none yet. For Chapter 10, split the two plots into separate cells, since each cell starts a new figure anyway.

## 3. Plot titles don't appear

**Status:** not reported. This looks like a regression of [#113](https://github.com/jupyter-xeus/xeus-octave/issues/113) ("Title of a plot does not show when using graphics_toolkit("plotly")"), closed in 2024.

**Reproduce:** `plot(1:3, 1:3); title('My title')` shows the plot with no title. Axis labels and legends do appear.

**Workaround:** none needed for the book so far, since most of its figures have no titles.

## Differences from desktop Octave that aren't bugs

These are worth knowing when converting chapters, but there's nothing to report:

- **Each cell starts a new figure.** `xlabel`, `legend` and `hold on` in a later cell don't act on an earlier plot. Workaround: the plot and its decorations go in the same cell (Chapter 9: `plot_solutions`).
- **`saveas` and `print` to EPS can't work:** there's no Ghostscript in the browser, and no folder to save to. These examples are shown as text.
- **Run All stops at the first error**, including errors the book makes on purpose. That's JupyterLab's behavior: the `raises-exception` tag only affects `nbconvert`. Readers step past errors with Shift+Enter.
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

1. Report issues 1–3 upstream, each with its reproduction, and link them here.
2. If issue 1 stays open, consider a fork. Issue 1 is the most serious, because it hangs the kernel.

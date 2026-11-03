# PhysicalModelingInMatlab Project Board

Numbered tasks for tracking work. Each task has a permanent number; add new tasks at the end. Update status as work progresses.

**Status values:** `Pending`, `In progress`, `DONE`

This is the repo for *Physical Modeling in MATLAB*, 4th edition: the LaTeX source (`book/`), the code for each chapter (`code/chapNN/`), the PDF (`PhysicalModelingInMatlab4.pdf`, committed) and the code ZIP the book links to (`PhysicalModelingInMatlab.zip`). The book page is <https://greenteapress.com/wp/physical-modeling-in-matlab/> (support code `matlab`). Last commit 2021-06-16. No GitHub Pages site.

### Current focus (2026-11-02)

- **Task 1:** Refresh — **DONE** 2026-11-01, tag `2026-refresh`. Chapter code fixed to match the book and tested in Octave in CI; ZIP rebuilt; README, license, links, Figure 12.2 and the Makefile fixed. PDF version 4.1 released 2026-11-01 (GitHub release `v4.1.0`). Content issues all settled 2026-11-01
- **Task 2:** Investigate running the examples online (Octave) — **report written** 2026-11-01 ([planning/online_execution_report.md](planning/online_execution_report.md)): recommends JupyterLite + xeus-octave (Octave 10.3 in WebAssembly) on GitHub Pages. Test site live at allendowney.github.io/PhysicalModelingInMatlab (2026-11-01); next: Allen's browser checks
- **Task 3:** Jupyter Book site — **DONE** 2026-11-02: the book's chapters as web pages at allendowney.github.io/PhysicalModelingInMatlab, with the notebooks on JupyterLite at `/run/`

---

## Task 1: Refresh

**Status:** DONE 2026-11-01 (tag `2026-refresh`; board created 2026-10-31)

**Context:** Same steps as the recent refreshes of the workshop and book repos. The guide is the "Refresh checklist" in `~/GreenTeaPress/plans/workshops.md`; the Python- and Colab-specific steps are adapted here for a MATLAB book (Octave in place of Python, no notebooks to run in CI). Related GreenTeaPress board items: Task 7 (PDF as a GitHub release asset; this book is the one remaining), Task 9 (`.tex` sources with lost-domain URLs, at the next build), Task 19 (support link, code `matlab`).

**0. Set up**
- [x] `git fetch` and `git status`: up to date with `origin/master` (2026-10-31)
- [x] `PROJECT_BOARD.md` and `CLAUDE.md`, committed (`cb5f018`, not pushed: Allen). Pages: none (`gh api …/pages` returns 404), so committed `.md` files are not published
- [x] Triage uncommitted edits and untracked files with Allen (2026-10-31; see Decisions). Discarded files backed up to the session scratchpad (`discarded-2026-10-31/discarded.tar.gz`)
- [x] `pre-refresh-2026` at `26c259d`, pushed 2026-10-31
- [x] A tag for each published edition if the commit can be found (4th edition PDF committed 2021-05-26). `v4.0.0` at 2320f7f (2026-11-01); no commits for earlier editions (the 2014 Octave edition is `archive/thinkoctave`)
- [x] Branches (2026-10-31): `modsim` (2013, draft modeling-and-simulation book), `thinkoctave` (2014, Octave edition) and `wiki` (2015, Google Code wiki page) tagged `archive/modsim`, `archive/thinkoctave`, `archive/wiki` and deleted on GitHub; `master` is the only branch
- [x] Environment (2026-10-31): `environment.yml` on conda-forge only, env `PhysicalModelingInMatlab` created: GNU Octave 10.3.0, `octave_kernel`, Jupyter

**1. Runs in a current environment**
- [x] Every script and function in `code/chap02`–`chap15` run in Octave 10.3.0, headless (2026-10-31; 58 files; scripts that expect variables, and functions that take arguments, called with inputs like the book's). **No Octave incompatibilities found**: everything runs except the three below (content issues 1–2). Not checked in MATLAB
  - Fail: `chap06/fib_triple.m`, `find_triples.m` call `hypotenuse`, which is only in `chap05/`, so they fail when run from their own folder; `chap10/plot_lorenz.m` expects a rate function `lorenz(t, V)` but `chap10/lorenz.m` takes no arguments (older edition)
  - Warnings: function name doesn't match file name in `chap08/exists2.m`, `chap12/proj1.m`, `proj2.m`, `chap13/golden.m` (`optimize`), `manny2.m`; `chap09/rats.m` shadows Octave's built-in `rats`, `chap15/odeplot.m` shadows the core `odeplot`
  - `chap10/lorenz_update.m` is a fragment (needs `sigma`, `r`, `b`, `dt` set first)
  - About 25 files are never named in the book (e.g. `fibonacci3`, `fibonacci_ratio`, `logchaos`, `plot_cheby6`, `exists2`, `runge`, `lorenz_diff`, `lorenz_loop`, `lorenz_update`, `plot_lorenz`, `penny2`, `baseball2`, `diagram`, `optimize`, `proj1`, `proj2`, `baseball3`, `baseball_anim`, `golden`, `manny`, `manny2`, `binary`, `odeplot`, `planet`); some may be the book's figure scripts (content issue 3)
- [x] Do the files match the book's listings? Compared all chapters 2026-10-31; the book is the source of truth (Allen). Fixed in `0da1450` (chapters 4–8) and the following commit (9–14): `find_triples.m` and a new `is_pythagorean.m`; duck mass r³ (it was r²) and a bracketed root search; `myfunc.m` header; `logmap.m` to the exercise spec; helpers copied where a chapter uses them (`hypotenuse.m` in chap06 and chap08, `myfunc.m` in chap08); the duck first draft moved to chap09; `a_gravity`; Manny wall constants (310 ft, 37 ft); axis labels and typos. Everything changed was rerun in Octave and matches the book's output where it shows any. Judgement calls left: content issues 6–9
- [x] `code/data/`: the files the examples read are in the repo; no dead URLs. The chapter code reads none of them; `baseball_drag.png` is linked from chap12 (short link `drag`, live); the CSVs are for the `.mlx` notebooks
- [x] The ZIP (2026-11-01): 8 of its files had the bugs fixed in step 1 and `find_triples.m`, `bike_loop.m` lacked helpers. `build.sh` fixed (adds `is_pythagorean.m`, `bike_update.m`; replaces the ZIP instead of adding to it; own README, since the repo README's links are relative) and the ZIP rebuilt; its 23 test cases pass on the unzipped ZIP. 2026-11-01: 7 of its scripts ended with an error for readers (`saveas` to `../../book/figs/`, which only exists in the repo; also true of the 2021 ZIP; the test runner masked it by creating `book/figs`); `build.sh` now drops those lines from the ZIP's copies (`code/` unchanged, per content issue 8), and the ZIP's 25 cases pass without `book/figs`. 2026-11-02: the ZIP had missed the changes to `lorenz.m` (chap04, `plot3`), `binary.m` and `bike_update.m`; rebuilt (its 20 cases that apply pass on the unzipped ZIP), attached to release `v4.2.0`, and CI now fails if the ZIP doesn't match `build.sh`'s output; releases include the ZIP (CLAUDE.md)
- [x] `code/other/` (about 100 scripts, mostly older editions and student work) and `code/notebooks/` (`.mlx` live scripts): which does the book use? Default for leftovers: remove from `master`; they stay in the tags and history. Allen, 2026-11-01: `code/other/` (93 scripts) and the root `ModSimMatlabCode.zip` (2019, unlinked) removed, both in `pre-refresh-2026`; `code/notebooks/` kept for MATLAB users (untested; Octave can't open `.mlx`)
- [ ] `PhysicalModelingInMatlab.zip` matches `code/` (the untracked `PhysicalModelingInMatlab/` folder looks like the ZIP's contents, a subset of `code/`); a script that builds it

**2. Tests and CI**
- [x] `tests/run_tests.sh [octave]` runs `tests/cases.txt` (63 cases: every chapter file, with inputs like the book's and expected output where the book shows it) headless, on a copy of `code/`, with `pause` stubbed; `XFAIL` marks `plot_lorenz` (leftover, content issue 9). 62 pass locally (Octave 10.3, 70 s). Locally: `tests/run_tests.sh` with the env's octave on the PATH (`mamba activate PhysicalModelingInMatlab`). **Run it on a copy of `code/`:** 14 scripts save figures to `../../book/figs/` (`saveas`), so running them in place overwrites the book's figures (happened once in step 1, 2026-10-31; restored with `git checkout`)
- [x] GitHub Actions `tests.yml` (2026-10-31): push, pull request, monthly, `workflow_dispatch`; Octave 8.4 from apt on Ubuntu 24.04, plus `gnuplot-nox`, fonts and Ghostscript (headless plotting and `saveas` need all three); green, 62 passed, tests take under a minute. A stalled apt mirror once took 21 min, so apt has a timeout and retries
- [x] Status badge in the README
- [ ] Optional: the LaTeX build in CI

**3. Running online** (in place of the Colab step)
- [ ] See Task 2. Until it is decided, the book and README tell readers to install MATLAB or Octave

**4. Text**
- [x] codespell and a link check over `book/*.tex`, `book/links/urls.csv` and the README; fix clear typos and broken links only (http → https where it works). 2026-11-01: all 31 links resolve (the MathWorks, Fandom, gnu.org and StackExchange 403s are bot blocks; checked by hand; the YouTube videos still exist). The book text had no codespell hits apart from MATLAB words (`ans`, `whos`) and no doubled words; fixed eight comment typos in `code/`. `urls.csv` and `htaccess`: `license` and `book` now https, and `fzero` (used in chap07, live on the server, missing from the CSV) added. The server's `.htaccess` was not touched; it already redirects correctly
- [x] Everything else goes in the **content issues** list below for Allen
- [x] License: the text is CC BY-NC 4.0 (`LICENSE` and the copyright page agree); code MIT. Fixed "4.0 Unported" to "4.0 International" in both. The README doesn't state a license yet (step 5)

**5. README in a standard shape**
- [x] Title; badge; author; abstract; who it is for and prerequisites; table of contents with links to each chapter's code; the PDF (release asset) and the printed book; running the code (MATLAB, Octave, and online if Task 2 says so); support link (`/support/?book=matlab`); license. Done 2026-11-01. The PDF link is still `raw/master/…pdf` until step 6 makes it a release asset; add the online link if Task 2 finds one

**6. Book, releases and visibility**
- [x] The book builds from a clone (`book/Makefile`; `book/titlepages.tex` is untracked but `main.tex` inputs it). 2026-11-01: `make` ran pdflatex once, so a clean build had no contents, index or references; now makeindex and two more passes. 178 pages, the same as the 2021 PDF
- [ ] PDF as a GitHub release asset (GreenTeaPress Task 7 pattern); the book page links `releases/latest/download/…`. **Released v4.1.0 2026-11-01** (Allen's request, after first deferring): `\theversion` 4.1, copyright 2026; built from a clean export, 178 pages, text diff against 4.0 = only the errata below; release at `62f6056`, asset identical to the root `PhysicalModelingInMatlab4.pdf` (the book page's `raw/master` link). Makefile fix: `makeindex` must run after the second pass (after only the first, index pages from Chapter 12 on were 2 low). Same file on greenteapress.com (`/matlab/PhysicalModelingInMatlab4.pdf`, deployed by Allen, GreenTeaPress `19cf913`, verified identical 2026-11-01); the WP page still links the `raw/master` copy, which is also identical
- [x] PR #7 ("Resolving build errors", Brian Bingham, 2024-08-23): both fixes already on `master`; closed with thanks 2026-10-31
- [x] Repo description and topics (`scripts/repo_about.sh` in GreenTeaPress). Set 2026-11-01 with `gh repo edit`: description "Physical Modeling in MATLAB: a free textbook on programming, modeling and simulation in MATLAB and GNU Octave", website the Green Tea Press book page, topics matlab, octave, modeling, simulation, physics, textbook
- [ ] Site: none now. A web version is part of Task 2's decision; if it goes ahead, the SEO checklist (`~/GreenTeaPress/plans/seo.md`) applies

**7. Close**
- [x] Tag `2026-refresh` and push; note what was done and what is on the content issues list on the GreenTeaPress board (2026-11-01)

### Inventory (2026-10-31)

- **Modified, uncommitted (committed 2026-10-31, `06c5221`):** `.gitignore` (stops ignoring `*.pdf`), `book/Makefile` (`distrib` commits the PDF here instead of rsyncing to the old site), `book/chap00.tex` (ZIP name; Carey Smith in the acknowledgments), `book/chap06.tex` (escaped `find\_triples.m`), `book/links/urls.csv` (ZIP link), `book/figs/baseball3.eps`, `baseball4.eps` (regenerated)
- **Untracked (sorted 2026-10-31, see Decisions):** `PhysicalModelingInMATLAB.pdf` (2021-01-25, 2.7 MB; an earlier build?), `PhysicalModelingInMatlab/` (ZIP contents), `book/PhysicalModelingInMatlab4.pdf`, `book/backup/`, `book/chap15.md`, `book/images/*-eps-converted-to.pdf` (build output), `book/links/htaccess*`, `book/links/links.html`, `book/main.mtc0`, `book/replace.py`, `book/replace.sh`, `book/titlepages.tex`, `code/shift.sh`, `environment.yml`, `notebooks/chap01.ipynb` (a 2021 start on a notebook version of Chapter 1), `octave-workspace` (two copies)
- **Tracked at the root:** `ModSimMatlabCode.zip` (2019, removed 2026-11-01), `PhysicalModelingInMatlab.zip`, `PhysicalModelingInMatlab4.pdf`, `build.sh`, `fonts/`, `CONTRIBUTING.md`, `LICENSE`
- **GitHub:** 96 stars; no open issues; PR #7 open (closed 2026-10-31); branches `modsim`, `thinkoctave`, `wiki` (archived as tags 2026-10-31); no tags; no Pages

### Decisions

- 2026-10-31: the 2021 uncommitted book edits (ZIP name and link, acknowledgment, `find\_triples`, Makefile `distrib`, `.gitignore`, regenerated `baseball3/4.eps`) committed as `06c5221`
- 2026-10-31: board files committed locally, not pushed
- 2026-10-31: continue Task 1 before starting Task 2
- 2026-10-31: untracked files: committed `book/titlepages.tex`, `environment.yml`, `book/links/htaccess` (the short-link redirects on GTP); build output ignored and deleted (`*-eps-converted-to.pdf`, `*.mtc0`, `book/*.pdf`); deleted the 2021 conversion leftovers (`book/backup/`, `replace.py`, `replace.sh`, `chap15.md`, `code/shift.sh`), `PhysicalModelingInMATLAB.pdf` (Jan 2021 build), `PhysicalModelingInMatlab/` (same as the ZIP's contents), `octave-workspace` (ignored), `htaccess.old`, `links.html`; `notebooks/chap01.ipynb` kept local and ignored, as input for Task 2

### Content issues

1. **DONE 2026-10-31 (step 1 drift fixes).** **The code has drifted from the 4th-edition text.** `code/chap06/find_triples.m` is not the book's final listing: the book's version calls `is_pythagorean` (not in `code/`), the file calls `hypotenuse`. Compare every listing in `book/*.tex` with the `.m` files and decide which is right. Matters for Task 2: the single-source question is whether listings can be included from the `.m` files
2. **DONE 2026-10-31 (helpers copied in step 1).** **Chapter folders aren't self-contained:** `chap06/` needs `hypotenuse.m` from `chap05/`; `chap10/plot_lorenz.m` needs a different `lorenz.m`. Copy helpers into each folder that uses them (as `bike_update.m` already is in `chap02/` and `chap03/`), or delete the stale file
3. **DONE (see 9 and `code/other/` in step 1).** **Files the book never names** (list in step 1): book figure scripts, solutions, or leftovers? Keep, move or delete
4. **DONE 2026-11-01 (Allen: rename both).** `rats.m` → `rat_pop.m` (chap09.tex listing, prose, REPL and error messages updated), `odeplot.m` → `plot_ode.m` (not named in the book). **Name clashes:** `rats.m` shadows Octave's `rats` (a reader who runs `rats` in that folder gets the book's function, which is intended, but Octave warns); `odeplot.m` shadows the core `odeplot`. Rename?
5. **DONE 2026-11-01 (Allen: rename to match).** **Function names that don't match file names** (`exists2.m`, `proj1.m`, `proj2.m`, `golden.m`, `manny2.m`): MATLAB uses the file name; Octave warns. Rename the functions to match
6. **DONE 2026-10-31 (Allen: [40; 30] everywhere).** Chapter 12 initial velocity: `baseball.m` has `V = [30; 40]`, the book's listing (chap12.tex:188, prose :180) has `[40; 30]`. But the prose at :226 ("ends just before the ball lands, having traveled almost 250 m") and the Chapter 13 animation (`W = [0 1 30 40]`, chap13.tex:268) fit `[30; 40]`; with `[40; 30]` the ball lands at 6.2 s and is underground at 8 s. So the listing may be the error
7. **DONE 2026-10-31 (Allen: listing in `series.m`; solution moved to `series_recurrent.m`; REPL fixed to `ans =`).** Chapter 3 `series.m`: the file solves the exercise at chap03.tex:404 (recurrent version), but :437 says `series.m` holds Listing `lst:series_n` (direct version); the REPL at :440–452 shows `total =` where both print `ans =`
8. **Leave as is (Allen, 2026-10-31).** Figure scripts write to `book/figs/`, which the book no longer uses** (it includes `images/figureNN_MM_new.eps`). Keep the `saveas` lines, point them at `images/`, or remove them. `fibonacci4.m` writes an unused figure
9. **Keep for now (Allen, 2026-10-31).** Leftovers from earlier editions (not in the book): `chap03/old/`, `chap03/fibonacci3.m`, `chap05/junk/`, `chap10/plot_lorenz.m` (broken), `lorenz_loop.m`, `lorenz_update.m`, `lorenz_diff.m` (duplicates `chap04/lorenz.m`), `chap11/freefall.m`, `chap12/optimize.m`, `proj1.m`, `proj2.m`, `chap13/golden.m`, `chap15/planet.m`
10. **DONE 2026-11-01 (Allen).** Fixed: chap10:293, chap13:140 (new caption "Range of a baseball as a function of launch angle"), chap13:165 (`x = 1.4142`), chap09:345 (semicolon). Left as is: the penny2 time span. `skydiver.m` now takes the opening altitude (default 1000 m, part 4); 8 m was the answer to part 5, not a bug (lands at 5.7 m/s; 7 m gives 6.5). `bike_loop.m` and `lorenz.m` left partial. **Book typos found on the way:** chap10.tex:293 `[drdt; dfdt]` vs the listing's `[dxdt; dydt]`; chap13.tex:140 repeats the caption of :81; chap13.tex:164–165 `x = fzero(...)` displays `ans =`; chap09.tex:345 vs :402 semicolon after `ode45`; chap11 penny2 needs a time span longer than the 10 s the text implies (:322, :327). Also exercise solutions that only partly do the exercise: `bike_loop.m` (no plot, chap03.tex:305), `lorenz.m` (no test call or time-series plot, chap10), `skydiver.m` (parachute at 8 m, not 1000 m)
11. **DONE 2026-11-01 (Allen: use the Octave redraw).** Redrawn by `book/images/figure12_02.m` in the style of the Illustrator figures (Helvetica, not their Futura-like font). **Figure 12.2 needs regenerating:** it shows the old `[30; 40]` trajectory (peak 82 m at 4 s, 240 m at 8 s). With `[40; 30]` and `tspan = [0 6]` the peak is 47 m near 3 s and the ball is at (240, 4.6) at 6 s

### Errata (book changes; in version 4.1, released 2026-11-01, unless marked "Not in 4.1"; those are in 4.2, released 2026-11-01)

- chap00.tex:85: "Anaconda Prompt", not "Jupyter Prompt" (2026-11-01)
- chap10.tex:397 and chap12.tex:211: `hold on` before the two `plot` calls, so both curves appear, as in Figures 10.1 and 12.2 (2026-11-01). **Not in 4.1**
- Typos found converting the chapters (2026-11-01): chap02:151 `fibonacci` → `fibonacci1`; chap04 exercise comment names `fibonacci_ratio.m`; chap05:374 missing `>> ` prompt; chap08:325 and chap11:286, :287, :314 stray space before punctuation; chap14:33 area in m → m². **Not in 4.1**
- Cross-references (2026-11-01, found by the notebook converter): 6 "Section N" that point to exercises → "Exercise N" (chap03:13, chap08:144, :286, chap09:29, chap11:55, chap14:192); 4 "Chapter N.M" → "Section N.M" (chap07:202, chap12:20, chap13:33, :70); 2 `\nameref` to exercises, which have no title, so they printed nothing ("In in the previous chapter") → "Exercise N" (chap04:246, chap13:4). **Not in 4.1**
- chap09: `rats.m` renamed `rat_pop.m` (:317–401); :345 semicolon after `ode45(...)`
- chap10.tex:293: `res = [dxdt; dydt];`
- chap13.tex:140: caption of Figure 13.2; :165 `x = 1.4142`
- Figure 12.2 redrawn for `V = [40; 30]` (2026-11-01)
- chap12.tex:197: "run the simulation for 6 s" (was 8) (2026-11-01)
- titlepages.tex: "4.0 International", not "4.0 Unported" (2026-11-01)
- chap03.tex:440–452: REPL shows `ans =`, not `total =` (2026-10-31)
- chap12.tex:191: `tspan = [0 6]` (was `[0 8]`, which ran the ball underground) (2026-10-31)
- chap13.tex:268: `W = [0 1 40 30]` (was `[0 1 30 40]`) (2026-10-31)
- Figure 12.2: regenerate (content issue 11)

---

## Task 2: Investigate running the examples online (Octave)

**Status:** In progress — report written 2026-11-01: [planning/online_execution_report.md](planning/online_execution_report.md)

**Findings (2026-11-01):** JupyterLite with the xeus-octave kernel (Octave 10.3 compiled to WebAssembly) runs the book's code and plots in the browser with no account or server (verified with `lorenz.m`); recommended, as a GitHub Pages site built from `code/`. Octave Online: guests can open and run buckets, but buckets are made by hand (no API), guests get ~5 s per command, little maintenance since 2025-01. Colab works (verified on a real runtime: apt Octave 8.4 + `oct2py` `%%octave`, ~70 s setup, needs fonts) but needs a Google account. Binder builds but the kernel never connected in tests. SageMathCell can't plot. CoCalc and MATLAB Online need accounts.

**Test site (2026-11-01, Allen: in this repo):** `site/` (JupyterLite + xeus-octave, all chapter folders, `saveas` lines stripped at build time because `../../book/figs` doesn't exist in the browser), deployed to <https://allendowney.github.io/PhysicalModelingInMatlab/> by `.github/workflows/site.yml` (Pages source: Actions). Local build: 2 min, 233 MB on disk; a reader downloads ~38 MB and gets a prompt in ~8 s (localhost). Tested in headless Chromium: `rat_pop`, `baseball2`, `baseball3`, `binary` run and plot. **Known issue:** `legend` followed by `clf` in one run (`lotka.m`) errors in xeus-octave's graphics (`legend>update_displayname_cb`); fine in desktop Octave; report upstream. Plot titles don't show (plotly).

**Chapter notebook prototype (2026-11-01, Allen: "turn each chapter into a notebook with all of the text, and all of the REPL examples runnable", if this environment works out):** `site/tex2nb.py` converts a chapter's LaTeX to a notebook: prose through pandoc (cross-references numbered from `main.aux`), listings and REPL examples as Octave code cells (`>>` prompts and shown results dropped; MATLAB error messages kept as text), figures embedded as PNG. Per-chapter edits in `site/notebooks/chapNN.json`. Chapter 9 done (`site/notebooks/chap09.ipynb`, 57 cells): every cell runs in headless Chromium, apart from the intentional errors. Findings:
- Functions defined in cells work (and later definitions replace earlier ones), so "put this in a file" listings run as cells; cells that only define functions get a call added after them
- Each cell starts a new figure, so `xlabel`/`legend` examples need the plot in the same cell (Chapter 9: a small `plot_solutions` helper)
- **`legend` hangs the kernel for some labels at some font sizes** (also on the upstream demo); worked around per cell with `set(gca, 'fontsize', 11)` (Chapter 9). Tracked with the other upstream bugs in [planning/upstream_issues.md](planning/upstream_issues.md)
- `saveas` can't work in the browser (no Ghostscript); shown as static text
- Run All stops at the first intentional error (JupyterLab ignores `raises-exception`), so readers step through with Shift+Enter

- Each heading starts a new markdown cell (Allen, 2026-11-01)
- **Solutions (Allen, 2026-11-01):** the generated notebook is the solution version; exercise solutions come from the files in `code/` (Chapter 9: `coffee.m`), in cells starting `% Solution`. `site/remove_soln.py` makes the student version (`% Solution goes here`, as in ModSimPy) at build time. On the site: `chapNN/chapNN.ipynb` (student), `solutions/chapNN.ipynb`
- Upstream bugs and xeus-octave's health: [planning/upstream_issues.md](planning/upstream_issues.md). Maintained by QuantStack in bursts; quiet since 2026-03; a fork is feasible if needed

**Decision (Allen, 2026-11-01):** this is the way to go: convert each chapter to a notebook with all the text and runnable examples.

- **Intentional errors (Allen, 2026-11-01):** shown as text, not run, so Run All goes through. Each carries a check in its cell metadata (the code and Octave's message); `tests/test_notebooks.py` runs every notebook's code cells in desktop Octave and confirms each error example fails with the message shown (in CI). The notebook shows MATLAB's message (from the book) and Octave's
- **Chapter 13 (2026-11-01):** a setup cell defines Chapter 12's baseball model (from `code/chap13/baseball3.m`), since the chapter uses it without listing it. Results match the text (lands at 5.09 s, 131 m; best angle 0.692 rad, 131.6 m). The animation can't play (plots don't update during a cell: upstream #2), so the call is text with a note; Exercise 13.1's solution is `manny.m`; 13.2 (golf) has no solution in `code/`, so an empty cell
- Converting found 12 wrong cross-reference words in the book (fixed; see Errata)

- **All 15 chapters converted (2026-11-01, Allen: "convert all chapters"):** four agents wrote the per-chapter edits (`site/notebooks/chapNN.json`) and found solutions in `code/`; every notebook passes `tests/test_notebooks.py` (Octave 10) and runs in the browser. Converter fixes from that pass: exercise numbers, `\keycap`, `\textunderscore`, `\textdegree`, footnotes, units (², ³, g, kg), straight quotes and `~` in inline code, captions with braces, description lists as bullets, REPL loops keep their continuation lines, list text after a code block. The test leaves out chapter files that a cell redefines (in the browser the cell's function wins even through a handle; in desktop Octave the file does). Solution notebooks are in the chapter folders (`chapNN_soln.ipynb`), since solutions call the chapter's scripts
- Agents' additions to the book's code, accepted by default: Ch4 `n = 10` before Listing 4.1 and `clear Y` before Listing 4.3; Ch7 a version of `error_func` that displays `x`, and the working version restored before the bracketing example; Ch8 calls `exists(-3:3)`; Ch10 `V_init` and `hold on`; Ch11 `X = [381, 0]` and a rerun with drag (tspan 30 s); Ch12 `hold on` and a rerun with drag; Ch15 a cell for Figure 15.1 and a note that Octave's `ode45` takes 29 steps and 177 evaluations (the book: 10 and 61)

- **Allen's decisions (2026-11-01):** `hold on` added to the book's listings for Figures 10.1 and 12.2 (the notebooks' additions dropped); `code/chap04/lorenz.m` uses `plot3` (`comet3` in a comment; the solution notebook went from 155 s to 26 s in the browser); `bike_loop2.m` moved out of `code/chap03/old/` (Exercise 3.2's solution; test case added); `code/chap14/binary.m` rewritten with local functions instead of nested ones (same energy loss, -1.8505e-05) and an optional input: `binary(false)` plots the orbits instead of animating; it is Exercise 14.5's solution

- **Landing page and visibility (2026-11-01, Allen):** `site/landing.html` replaces JupyterLite's root page (the build copies JupyterLite's `#jupyter-config-data` block into it; without it the app pages fail to load). Chapters open in the single-notebook view (`notebooks/index.html?path=chapNN/chapNN.ipynb`), with links to the solutions and the full workspace. Description, canonical, Open Graph tags (cover from greenteapress.com), `sitemap.xml` with the landing page only (the notebooks are a JS app), page-view counter on the landing, lab and notebook pages. README links the site; repo website → the site, topic `jupyterlite`; hub: Books entry, `robots.txt` Sitemap line, sitemap index (AllenDowney.github.io `ba753de`). **Allen:** submit `https://allendowney.github.io/PhysicalModelingInMatlab/sitemap.xml` in Search Console; add a link to the site on the WordPress book page
- **PDF 4.2 (2026-11-01):** all the errata marked "Not in 4.1", plus a paragraph in the preface ("Working with the Code") pointing to the online version. greenteapress.com copy deployed by Allen (GreenTeaPress `89d18d8`), verified identical to the release asset 2026-11-02

**Next:** report the upstream issues (when Allen says)

**Goal:** Find the easiest reliable way for readers to run and modify the book's examples in a browser, with no install and ideally no account, without creating a maintenance burden. Feasibility study and a small proof of concept on Chapter 2 (Scripts), not an implementation.

**Plan:** [planning/online_execution.md](planning/online_execution.md)

**First experiment:** open a real Octave Online bucket from a fresh browser session. If a reader can immediately see, modify and run a complete example, that may be enough to justify a GitHub Pages version that links to buckets, without inline execution.

**Deliverable:** a feasibility report in `planning/`: verified capabilities with links, comparison table, recommended architecture, a working demo link for one real example, maintenance strategy, open questions.

---

## Task 3: Jupyter Book site from the chapter notebooks

**Status:** DONE 2026-11-02: deployed; checked live (pages, run links, old links forward, a notebook runs under /run/); hub entry has both links

An indexable, static HTML version of the book, built from `site/notebooks/`, readable without running anything; the JupyterLite part stays for running the code. JupyterLite can't be indexed, so its sitemap lists only the landing page.

**Layout (Allen, 2026-11-02):** one Pages site, one workflow:
- `/`: the Jupyter Book. The intro page explains the two options (read here; run the code online at `/run/`, or download the ZIP for MATLAB/Octave) and links the PDF
- `/chapNN.html`: each chapter, with outputs; at the top "Run this chapter online (or with solutions)", linking to its notebooks on JupyterLite (solution link for chapters 2–7, 9–11, 13, 14). The link is added at JB build time only, not in the notebooks (in JupyterLite it would point to itself)
- `/run/`: today's `site/landing.html`, with a new section near the top on the two views (one chapter at a time vs the full workspace) and on saving (browser storage on this computer; survives reloads; shared by both views; not in another browser, computer or private window; lost when site data is cleared; File → Download to keep a copy, upload in the workspace to bring it back; an edited chapter shadows later site updates until deleted). Behaviour checked on the live site 2026-11-02 (reload, both views, another profile, File → Download); the last three points are from JupyterLite's documented behaviour, not tested
- `/run/notebooks/`, `/run/lab/`: JupyterLite, moved down a level
- `/notebooks/…`, `/lab/…`: redirect pages to `/run/…` (keep the query string)

**Build (Allen, 2026-11-02: run the notebooks locally, as in the other books):** `python site/run_notebooks.py` runs each solution notebook in desktop Octave (`octave_kernel`, the `PhysicalModelingInMatlab` env) in a copy of its chapter folder, as `tests/test_notebooks.py` does, and writes `site/jb/chapNN.ipynb` with outputs and a hash of its inputs; it reruns only chapters whose notebook or code changed (all 15: 54 s, 1.1 MB). CI (`tests.yml`) fails if they're out of date (`--check`). At build time `site/jb/prep_notebooks.py` adds the run links, tags solution cells `hide-cell` ("Show solution"), writes the figures (notebook attachments, which Jupyter Book can't read) to `figs/`, and sets page descriptions (`descriptions.yml`); `jb build` (Jupyter Book 1, Think Python's `jb/_config.yml` adapted: sitemap, Open Graph, support note, counter) into `dist/`; redirect pages; upload and deploy as now (Pages stays on GitHub Actions).

**Allen's choices:** keep all outputs, plots included (2026-11-01); solutions collapsed under a click-to-show toggle (2026-11-01); `/run/` and the link placement (2026-11-02).

**Tested locally (2026-11-02):** full build; book pages with outputs, figures, solution toggles and run links; intro page; `/run/` page with the new sections (draft text, [planning/run_page_text.md](planning/run_page_text.md), Allen revising); old `/notebooks/` link forwards to `/run/` and the notebook runs; chapter page at phone width has no horizontal scroll; sitemap lists the book's pages and `/run/`.

Sitemap resubmitted in Search Console by Allen (2026-11-02).

---

## Task 4: Fix the browser Octave bugs upstream (xeus-octave)

**Status:** Waiting on upstream replies (all filed 2026-11-02; check back around 2026-11-09)

The bugs in [planning/upstream_issues.md](planning/upstream_issues.md), in xeus-octave (the Octave kernel the site runs in the browser).

**Allen's decisions (2026-11-02):**
- Fork it (`AllenDowney/xeus-octave`) and try to fix each bug; file each issue with its PR. Time-boxed: if a fix doesn't come together, file the issue with the reproduction and what was learned
- Order: titles (3), `legend` hang (1), `legend` then `clf` (2), animation (4; comment on upstream #2, maybe a draft PR)
- Issue and PR texts go to Allen for review before anything is posted
- The site stays on the official package from emscripten-forge; the fork is for developing and testing fixes

**Approach:** reproduce each bug in a desktop build from source (quick to rebuild; the plotting code is shared with the browser build); then test fixes in a WebAssembly build on a copy of the site, with the book's notebooks that use legends and titles.

**Progress (2026-11-02):**
- Fork: https://github.com/AllenDowney/xeus-octave, clone in `~/xeus-octave`; work files (test harnesses, local WebAssembly build envs, test site) in `~/xeus-octave-work`. Desktop build: env `xeus-octave-dev`. Browser build: `micromamba` envs `wasm-build` and `wasm-host` under `~/xeus-octave-work/mamba`
- **Titles (3):** fixed on branch `plotly-axes-title`, with a test (fails before, passes after); checked on desktop and in the browser. Not a regression: the plotly toolkit never drew titles (#113 was closed without a fix). PR text ready
- **Build break:** with the current emscripten-forge libflang (22.x), the WebAssembly build doesn't link (the Fortran runtime libraries were renamed). Fixed on branch `wasm-flang-runtime-name` (Allen: a separate PR); PR text ready
- **`legend` hang (1) and `legend` then `clf` (2):** cause found in emscripten-forge's Octave recipe, not xeus-octave: patch 0015 queues every graphics listener (`if (false)` in place of the main-thread check), and `legend.m` assumes listeners run during `set`. Issue posted (Allen: issue only, no rebuild): https://github.com/emscripten-forge/recipes/issues/8228
- PRs opened 2026-11-02: [#145](https://github.com/jupyter-xeus/xeus-octave/pull/145) (build fix, first, so the titles PR could cite it) and [#146](https://github.com/jupyter-xeus/xeus-octave/pull/146) (titles). Texts: [planning/upstream_drafts.md](planning/upstream_drafts.md). Watch the PRs and the issue for replies
- **Animation (4):** cause is plotly.py's JupyterLab renderer, which ignores updates to a drawn figure (plotly.py #3053, closed as stale). Fix on `AllenDowney/plotly.py` branch `mimerenderer-update-display`, checked in JupyterLab 4 (Python) and JupyterLite (Octave). PR [plotly.py#5865](https://github.com/plotly/plotly.py/pull/5865) and a comment on #3053 posted 2026-11-02 (Allen); our site's build patched meanwhile; Chapter 13's animation plays again. 2026-11-02 (Allen): Chapter 14's notebook now calls `binary()`, which animates the orbit (checked in Chromium on a local build); `binary.m` opens a new figure after the animation, so the energy plot no longer replaces its last frame

**When checking back:**
- xeus-octave [#145](https://github.com/jupyter-xeus/xeus-octave/pull/145) and [#146](https://github.com/jupyter-xeus/xeus-octave/pull/146): their CI needs a maintainer's approval to run. Answer review comments on the fork's branches (desktop build: env `xeus-octave-dev`; browser build: `~/xeus-octave-work`)
- emscripten-forge [recipes#8228](https://github.com/emscripten-forge/recipes/issues/8228): if they ask for a PR, change patch 0015 to `if (true)`, rebuild Octave, and rerun the legend examples
- plotly.py [#5865](https://github.com/plotly/plotly.py/pull/5865): when a jupyterlab-plotly release includes it, remove the renderer patch from `site/build.sh`. The site gets jupyterlab-plotly unpinned, so once a fixed release is out the patch no longer matches and the build stops with a message, which is the cue
- When a fixed xeus-octave or Octave package reaches emscripten-forge, the site picks it up on its next build; then recheck titles and legends on the live site and update [planning/upstream_issues.md](planning/upstream_issues.md)
- Keep `~/xeus-octave-work` (3.8 GB: build envs, test site, harnesses) until the PRs are settled; then it can be deleted

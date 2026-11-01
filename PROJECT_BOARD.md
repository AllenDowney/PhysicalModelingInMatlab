# PhysicalModelingInMatlab Project Board

Numbered tasks for tracking work. Each task has a permanent number; add new tasks at the end. Update status as work progresses.

**Status values:** `Pending`, `In progress`, `DONE`

This is the repo for *Physical Modeling in MATLAB*, 4th edition: the LaTeX source (`book/`), the code for each chapter (`code/chapNN/`), the PDF (`PhysicalModelingInMatlab4.pdf`, committed) and the code ZIP the book links to (`PhysicalModelingInMatlab.zip`). The book page is <https://greenteapress.com/wp/physical-modeling-in-matlab/> (support code `matlab`). Last commit 2021-06-16. No GitHub Pages site.

### Current focus (2026-11-01)

- **Task 1:** Refresh — step 0 nearly done: board, tags, 2021 edits committed, untracked files sorted, old branches archived; env created (Octave 10.3.0). Steps 1, 2, 4 and 5 done: chapter code runs in Octave and matches the book; CI green; typos, links and license checked; README rewritten. Next, step 6 (book builds from a clone, PDF as a release asset, repo description)
- **Task 2:** Investigate running the examples online (Octave) — planning doc written, not started

---

## Task 1: Refresh

**Status:** In progress (board created 2026-10-31)

**Context:** Same steps as the recent refreshes of the workshop and book repos. The guide is the "Refresh checklist" in `~/GreenTeaPress/plans/workshops.md`; the Python- and Colab-specific steps are adapted here for a MATLAB book (Octave in place of Python, no notebooks to run in CI). Related GreenTeaPress board items: Task 7 (PDF as a GitHub release asset; this book is the one remaining), Task 9 (`.tex` sources with lost-domain URLs, at the next build), Task 19 (support link, code `matlab`).

**0. Set up**
- [x] `git fetch` and `git status`: up to date with `origin/master` (2026-10-31)
- [x] `PROJECT_BOARD.md` and `CLAUDE.md`, committed (`cb5f018`, not pushed: Allen). Pages: none (`gh api …/pages` returns 404), so committed `.md` files are not published
- [x] Triage uncommitted edits and untracked files with Allen (2026-10-31; see Decisions). Discarded files backed up to the session scratchpad (`discarded-2026-10-31/discarded.tar.gz`)
- [x] `pre-refresh-2026` at `26c259d`, pushed 2026-10-31
- [ ] A tag for each published edition if the commit can be found (4th edition PDF committed 2021-05-26).
- [x] Branches (2026-10-31): `modsim` (2013, draft modeling-and-simulation book), `thinkoctave` (2014, Octave edition) and `wiki` (2015, Google Code wiki page) tagged `archive/modsim`, `archive/thinkoctave`, `archive/wiki` and deleted on GitHub; `master` is the only branch
- [x] Environment (2026-10-31): `environment.yml` on conda-forge only, env `PhysicalModelingInMatlab` created: GNU Octave 10.3.0, `octave_kernel`, Jupyter

**1. Runs in a current environment**
- [x] Every script and function in `code/chap02`–`chap15` run in Octave 10.3.0, headless (2026-10-31; 58 files; scripts that expect variables, and functions that take arguments, called with inputs like the book's). **No Octave incompatibilities found**: everything runs except the three below (content issues 1–2). Not checked in MATLAB
  - Fail: `chap06/fib_triple.m`, `find_triples.m` call `hypotenuse`, which is only in `chap05/`, so they fail when run from their own folder; `chap10/plot_lorenz.m` expects a rate function `lorenz(t, V)` but `chap10/lorenz.m` takes no arguments (older edition)
  - Warnings: function name doesn't match file name in `chap08/exists2.m`, `chap12/proj1.m`, `proj2.m`, `chap13/golden.m` (`optimize`), `manny2.m`; `chap09/rats.m` shadows Octave's built-in `rats`, `chap15/odeplot.m` shadows the core `odeplot`
  - `chap10/lorenz_update.m` is a fragment (needs `sigma`, `r`, `b`, `dt` set first)
  - About 25 files are never named in the book (e.g. `fibonacci3`, `fibonacci_ratio`, `logchaos`, `plot_cheby6`, `exists2`, `runge`, `lorenz_diff`, `lorenz_loop`, `lorenz_update`, `plot_lorenz`, `penny2`, `baseball2`, `diagram`, `optimize`, `proj1`, `proj2`, `baseball3`, `baseball_anim`, `golden`, `manny`, `manny2`, `binary`, `odeplot`, `planet`); some may be the book's figure scripts (content issue 3)
- [x] Do the files match the book's listings? Compared all chapters 2026-10-31; the book is the source of truth (Allen). Fixed in `0da1450` (chapters 4–8) and the following commit (9–14): `find_triples.m` and a new `is_pythagorean.m`; duck mass r³ (it was r²) and a bracketed root search; `myfunc.m` header; `logmap.m` to the exercise spec; helpers copied where a chapter uses them (`hypotenuse.m` in chap06 and chap08, `myfunc.m` in chap08); the duck first draft moved to chap09; `a_gravity`; Manny wall constants (310 ft, 37 ft); axis labels and typos. Everything changed was rerun in Octave and matches the book's output where it shows any. Judgement calls left: content issues 6–9
- [ ] `code/data/`: the files the examples read are in the repo; no dead URLs
- [ ] `code/other/` (about 100 scripts, mostly older editions and student work) and `code/notebooks/` (`.mlx` live scripts): which does the book use? Default for leftovers: remove from `master`; they stay in the tags and history
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
- [ ] The book builds from a clone (`book/Makefile`; `book/titlepages.tex` is untracked but `main.tex` inputs it)
- [ ] PDF as a GitHub release asset (GreenTeaPress Task 7 pattern); the book page links `releases/latest/download/…`
- [x] PR #7 ("Resolving build errors", Brian Bingham, 2024-08-23): both fixes already on `master`; closed with thanks 2026-10-31
- [ ] Repo description and topics (`scripts/repo_about.sh` in GreenTeaPress)
- [ ] Site: none now. A web version is part of Task 2's decision; if it goes ahead, the SEO checklist (`~/GreenTeaPress/plans/seo.md`) applies

**7. Close**
- [ ] Tag `2026-refresh` and push; note what was done and what is on the content issues list on the GreenTeaPress board

### Inventory (2026-10-31)

- **Modified, uncommitted (committed 2026-10-31, `06c5221`):** `.gitignore` (stops ignoring `*.pdf`), `book/Makefile` (`distrib` commits the PDF here instead of rsyncing to the old site), `book/chap00.tex` (ZIP name; Carey Smith in the acknowledgments), `book/chap06.tex` (escaped `find\_triples.m`), `book/links/urls.csv` (ZIP link), `book/figs/baseball3.eps`, `baseball4.eps` (regenerated)
- **Untracked (sorted 2026-10-31, see Decisions):** `PhysicalModelingInMATLAB.pdf` (2021-01-25, 2.7 MB; an earlier build?), `PhysicalModelingInMatlab/` (ZIP contents), `book/PhysicalModelingInMatlab4.pdf`, `book/backup/`, `book/chap15.md`, `book/images/*-eps-converted-to.pdf` (build output), `book/links/htaccess*`, `book/links/links.html`, `book/main.mtc0`, `book/replace.py`, `book/replace.sh`, `book/titlepages.tex`, `code/shift.sh`, `environment.yml`, `notebooks/chap01.ipynb` (a 2021 start on a notebook version of Chapter 1), `octave-workspace` (two copies)
- **Tracked at the root:** `ModSimMatlabCode.zip` (2019), `PhysicalModelingInMatlab.zip`, `PhysicalModelingInMatlab4.pdf`, `build.sh`, `fonts/`, `CONTRIBUTING.md`, `LICENSE`
- **GitHub:** 96 stars; no open issues; PR #7 open (closed 2026-10-31); branches `modsim`, `thinkoctave`, `wiki` (archived as tags 2026-10-31); no tags; no Pages

### Decisions

- 2026-10-31: the 2021 uncommitted book edits (ZIP name and link, acknowledgment, `find\_triples`, Makefile `distrib`, `.gitignore`, regenerated `baseball3/4.eps`) committed as `06c5221`
- 2026-10-31: board files committed locally, not pushed
- 2026-10-31: continue Task 1 before starting Task 2
- 2026-10-31: untracked files: committed `book/titlepages.tex`, `environment.yml`, `book/links/htaccess` (the short-link redirects on GTP); build output ignored and deleted (`*-eps-converted-to.pdf`, `*.mtc0`, `book/*.pdf`); deleted the 2021 conversion leftovers (`book/backup/`, `replace.py`, `replace.sh`, `chap15.md`, `code/shift.sh`), `PhysicalModelingInMATLAB.pdf` (Jan 2021 build), `PhysicalModelingInMatlab/` (same as the ZIP's contents), `octave-workspace` (ignored), `htaccess.old`, `links.html`; `notebooks/chap01.ipynb` kept local and ignored, as input for Task 2

### Content issues

1. **The code has drifted from the 4th-edition text.** `code/chap06/find_triples.m` is not the book's final listing: the book's version calls `is_pythagorean` (not in `code/`), the file calls `hypotenuse`. Compare every listing in `book/*.tex` with the `.m` files and decide which is right. Matters for Task 2: the single-source question is whether listings can be included from the `.m` files
2. **Chapter folders aren't self-contained:** `chap06/` needs `hypotenuse.m` from `chap05/`; `chap10/plot_lorenz.m` needs a different `lorenz.m`. Copy helpers into each folder that uses them (as `bike_update.m` already is in `chap02/` and `chap03/`), or delete the stale file
3. **Files the book never names** (list in step 1): book figure scripts, solutions, or leftovers? Keep, move or delete
4. **Name clashes:** `rats.m` shadows Octave's `rats` (a reader who runs `rats` in that folder gets the book's function, which is intended, but Octave warns); `odeplot.m` shadows the core `odeplot`. Rename?
5. **Function names that don't match file names** (`exists2.m`, `proj1.m`, `proj2.m`, `golden.m`, `manny2.m`): MATLAB uses the file name; Octave warns. Rename the functions to match
6. **DONE 2026-10-31 (Allen: [40; 30] everywhere).** Chapter 12 initial velocity: `baseball.m` has `V = [30; 40]`, the book's listing (chap12.tex:188, prose :180) has `[40; 30]`. But the prose at :226 ("ends just before the ball lands, having traveled almost 250 m") and the Chapter 13 animation (`W = [0 1 30 40]`, chap13.tex:268) fit `[30; 40]`; with `[40; 30]` the ball lands at 6.2 s and is underground at 8 s. So the listing may be the error
7. **DONE 2026-10-31 (Allen: listing in `series.m`; solution moved to `series_recurrent.m`; REPL fixed to `ans =`).** Chapter 3 `series.m`: the file solves the exercise at chap03.tex:404 (recurrent version), but :437 says `series.m` holds Listing `lst:series_n` (direct version); the REPL at :440–452 shows `total =` where both print `ans =`
8. **Leave as is (Allen, 2026-10-31).** Figure scripts write to `book/figs/`, which the book no longer uses** (it includes `images/figureNN_MM_new.eps`). Keep the `saveas` lines, point them at `images/`, or remove them. `fibonacci4.m` writes an unused figure
9. **Keep for now (Allen, 2026-10-31).** Leftovers from earlier editions (not in the book): `chap03/old/`, `chap03/fibonacci3.m`, `chap05/junk/`, `chap10/plot_lorenz.m` (broken), `lorenz_loop.m`, `lorenz_update.m`, `lorenz_diff.m` (duplicates `chap04/lorenz.m`), `chap11/freefall.m`, `chap12/optimize.m`, `proj1.m`, `proj2.m`, `chap13/golden.m`, `chap15/planet.m`
10. **Book typos found on the way:** chap10.tex:293 `[drdt; dfdt]` vs the listing's `[dxdt; dydt]`; chap13.tex:140 repeats the caption of :81; chap13.tex:164–165 `x = fzero(...)` displays `ans =`; chap09.tex:345 vs :402 semicolon after `ode45`; chap11 penny2 needs a time span longer than the 10 s the text implies (:322, :327). Also exercise solutions that only partly do the exercise: `bike_loop.m` (no plot, chap03.tex:305), `lorenz.m` (no test call or time-series plot, chap10), `skydiver.m` (parachute at 8 m, not 1000 m)
11. **Figure 12.2 needs regenerating:** it shows the old `[30; 40]` trajectory (peak 82 m at 4 s, 240 m at 8 s). With `[40; 30]` and `tspan = [0 6]` the peak is 47 m near 3 s and the ball is at (240, 4.6) at 6 s

### Errata (book changes, for the next build)

- chap00.tex:85: "Anaconda Prompt", not "Jupyter Prompt" (2026-11-01)
- titlepages.tex: "4.0 International", not "4.0 Unported" (2026-11-01)
- chap03.tex:440–452: REPL shows `ans =`, not `total =` (2026-10-31)
- chap12.tex:191: `tspan = [0 6]` (was `[0 8]`, which ran the ball underground) (2026-10-31)
- chap13.tex:268: `W = [0 1 40 30]` (was `[0 1 30 40]`) (2026-10-31)
- Figure 12.2: regenerate (content issue 11)

---

## Task 2: Investigate running the examples online (Octave)

**Status:** Pending

**Goal:** Find the easiest reliable way for readers to run and modify the book's examples in a browser, with no install and ideally no account, without creating a maintenance burden. Feasibility study and a small proof of concept on Chapter 2 (Scripts), not an implementation.

**Plan:** [planning/online_execution.md](planning/online_execution.md)

**First experiment:** open a real Octave Online bucket from a fresh browser session. If a reader can immediately see, modify and run a complete example, that may be enough to justify a GitHub Pages version that links to buckets, without inline execution.

**Deliverable:** a feasibility report in `planning/`: verified capabilities with links, comparison table, recommended architecture, a working demo link for one real example, maintenance strategy, open questions.

# Running the examples online: feasibility study

Board: Task 2. Status: report written 2026-11-01 ([online_execution_report.md](online_execution_report.md)); plan written 2026-10-31.

## Goal

Convert chapters of *Physical Modeling in MATLAB* into web pages on GitHub Pages where readers can run and modify the code examples with GNU Octave, without installing anything. The model is Google Colab: open a chapter, read, run the examples, change them, experiment, ideally without creating an account.

**Guiding principle:** minimize friction for readers without creating a maintenance burden for the author.

This is an investigation and a small proof of concept. Don't convert the whole chapter or build a larger system yet. Prefer testing actual behavior over product descriptions, especially for Octave Online buckets, authentication, embedding and shareable links. Mark every capability as **verified** (with a link or a description of the test) or **reported, not confirmed**.

## The decisive first experiment

Open a real Octave Online bucket from a fresh browser session (private window, not signed in). Can a reader immediately see, modify and run a complete example? If so, that may be enough to justify a GitHub Pages version that links to buckets, without inline execution.

## What's in the repo (2026-10-31)

- Chapter 2, *Scripts*, is `book/chap02.tex` (511 lines, about ten `code` listings). Its code is `code/chap02/`: `fibonacci1.m`, `myscript.m`, `swap.m`, `bike_update.m`. Check that it is still a good test case (no toolboxes, no input, short).
- Listings are `\begin{code}` environments in the LaTeX, typed separately from the `.m` files, so the book and the code can already drift.
- `environment.yml` has Octave, `octave_kernel` and Jupyter; `notebooks/chap01.ipynb` (local only, gitignored; 2021) is an earlier start on a notebook version of Chapter 1. Tag `archive/thinkoctave` (2014, formerly a branch) is an older Octave edition.
- Octave 10.3.0 is in the mamba env `PhysicalModelingInMatlab` (not installed system-wide).

## Options to investigate

### 1. GitHub Pages + Octave Online (initial favorite)

[Octave Online](https://octave-online.net/) runs GNU Octave in the browser. It reportedly supports **buckets**: shared sets of scripts and data files, possibly with a main script that runs when the bucket opens.

- How do buckets work? Can someone open a shared bucket without an account?
- Can a link open a specific script, or run it automatically?
- Can readers edit and run examples without changing the original?
- Are buckets persistent and public?
- Is there an API or other way to publish or update buckets from files in GitHub?
- Can Octave Online be embedded in a page with an iframe, or is embedding blocked (`X-Frame-Options`, CSP)?
- Limits: authentication, quotas, availability, licensing.

Key question: can a reader click **Run this example** in a chapter and start experimenting right away?

### 2. GitHub Pages + CoCalc

[CoCalc](https://cocalc.ai/) supports Octave through Jupyter notebooks.

- Does running code require registration? Is there a useful free tier?
- Can a notebook be opened from a GitHub URL? Can a reader make a runnable copy with one click?
- Can CoCalc notebooks be embedded in other sites?
- Could `.ipynb` files be generated automatically from the chapter source?
- Compare with Octave Online for student experience and author maintenance.

### 3. Google Colab with Octave

Colab doesn't support arbitrary kernels, but its Python runtime can install Octave:

```
!apt-get -qq install octave
!octave --quiet example.m
```

- Is there a better workflow (IPython cell magics such as `oct2py`'s `%%octave`, or installing `octave_kernel` and switching the runtime) that makes Octave feel native?
- Startup time, plotting (inline figures?), sharing, compatibility, and how much Python scaffolding students see.

Colab is already the target for the other books (see `~/GreenTeaPress/plans/workshops.md`, step 3), so this is the option with the most existing tooling.

### 4. Other hosted environments

Look for actively maintained browser-based Octave, preferring: native Octave, runnable Jupyter notebooks, free for students, no install, preferably no registration, permanent shareable URLs, GitHub integration. Don't assume a platform that supports Jupyter can host an Octave kernel (Binder can, from `environment.yml`, but check whether it is still reliable).

### 5. Fully embedded execution (secondary)

Could examples run directly on the GitHub Pages site, with output and plots below the code, without a dedicated server? Consider WebAssembly builds of Octave, browser-side execution, or an existing execution service. Separate established solutions from speculation. Allen does not want to build and maintain an execution platform.

## Chapter conversion

- How hard is it to convert one chapter to Quarto Markdown (Allen uses Quarto elsewhere) and publish it on GitHub Pages? Keep math, figures, code listings, exercises and prose. (A 2021 pandoc export of Chapter 15 to Markdown was deleted in the refresh; pandoc can regenerate one.)
- Single source: runnable code should come from the same files used for the book and the hosted examples, so copies don't drift. Options: listings included from the `.m` files (`\lstinputlisting` in LaTeX, include shortcodes in Quarto), Quarto executable blocks with an Octave/Jupyter engine, or a shortcode that generates the "Run this example" link.

## Proof of concept (Chapter 2)

1. Inspect the chapter source, code examples and dependencies.
2. Pick two or three examples suited to browser execution (e.g. `fibonacci1.m`, `myscript.m`).
3. Test the most promising platforms with those examples.
4. Check whether the examples open through stable, shareable links.
5. Test from a clean browser session, without signing in.
6. Assess whether a single-source publishing workflow is possible.

A small test page that shows the proposed reader experience is enough.

## Evaluation criteria

| Criterion | Importance |
| --- | --- |
| Reader can run code without installing anything | Essential |
| Reader can edit code and rerun it | Essential |
| Works with the book's existing MATLAB code | Essential |
| Convenient links from GitHub Pages | High |
| No registration required | High |
| Low friction for first-time readers | High |
| Stable, shareable examples | High |
| Minimal ongoing maintenance | High |
| Free or inexpensive for readers | High |
| Automated publishing from GitHub | Desirable |
| Inline execution within the chapter | Desirable |

Distinguish free access for individual readers from costs at classroom scale.

## Deliverable

A concise feasibility report, `planning/online_execution_report.md`:

1. **Verified capabilities** of each platform, with links to current docs or working examples; capabilities reported but not confirmed, marked as such.
2. **Comparison table** of the viable options.
3. **Recommended architecture** for a first implementation.
4. **Demonstration** with one real example from the book, with a working link if the platform supports it.
5. **Maintenance strategy** for keeping published examples in sync with the repo.
6. **Open questions** and the smallest experiments that would resolve them.

Then: recommend the next step, and update Task 2 on the board.

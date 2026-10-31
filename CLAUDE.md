# PhysicalModelingInMatlab

The repo for *Physical Modeling in MATLAB*, 4th edition, by Allen Downey (Green Tea Press): LaTeX source in `book/` (`make` builds `PhysicalModelingInMatlab4.pdf`; `make distrib` copies it to the root and commits it), code for each chapter in `code/chapNN/`, data in `code/data/`. Readers download `PhysicalModelingInMatlab.zip` (linked from the book via `book/links/urls.csv`). Book page: <https://greenteapress.com/wp/physical-modeling-in-matlab/>.

- Work is tracked in `PROJECT_BOARD.md`; plans go in `planning/`.
- Task 1 is a refresh; the guide is the "Refresh checklist" in `~/GreenTeaPress/plans/workshops.md`, adapted for a MATLAB book (Octave instead of Python and Colab).
- Code examples should run in both MATLAB and GNU Octave. Octave is not installed system-wide; use the mamba env from `environment.yml`.
- Keep `master` as the default branch (links in the book point to it).
- No GitHub Pages site, so committed `.md` files are not published. Check again before adding one.
- Ask Allen's decisions in a dialog (AskUserQuestion), in batches.

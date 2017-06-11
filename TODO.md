This is a list of things that need doing. A **!!!** next to an item indicates
that the item must be resolved before the current branch can be merged into
**stable**.

## Low hanging fruit

+ In the "Functions" chapter, there is a section called "Documentation", which
doesn't use MATLAB best-practices for function docstrings; modify this to be
consistent with the style guide.
+ Add figures to demonstrate the dot and cross product; this is located in the
"Final Thoughts" chapter.
+ Synchronize the code in the `/code` directory so that its consistent with the
changes that have been made in the book.
+ Label the axes for the plots in the book. (E.g., in the "Second Order
Systems" chapter.)

## High hanging fruit

+ Significantly revise the "Celestial Mechanics chapter". It needs work.
+ Reorganize the code in the `/code` directory so its obvious for each script
where it is used in the book.
+ Make sure every single line of output is written in a consistent style. Better
still if the output matches a recent version of MATLAB (most of the revisions
for this book are written in the context of the 2016 releases). There may be a
way to automate this.
+ Create an answer key for the end of section/chapter problems.
+ Create an appendix containing the information from the removed
"Nested Functions" section (was contained in the "Second Order Systems" chapter
prior to commit `38c7b97`).
+ Make an index.

# Contributing
This page contains information for *collaborators* to contribute to this
repository. For non-collaborators, all of these guidelines apply—you'll
just need to create feature branches on your own fork.

## Help! I don't know Git!
Don't panic!  Git is easy. That's why everyone uses it.  ["Pro
Git"](https://git-scm.com/book/en/v2) by Scott Chacon and Ben Straub is
a great resource to learn from; the first three chapters should tell you
everything you need to know to be Git pro.

## Style
+ **MATLAB** code should conform to the guidelines laid out in
  ["MATLAB Style
  Guidelines"](https://www.mathworks.com/matlabcentral/fileexchange/46056-matlab-style-guidelines-2-0)
  by Richard Johnson.

+ **TeX** code should aim to be consistent with existing code.

+ **Writing** should mimic Downey's informal writing style, and should be
appropriate for first-year undergraduate students. Also, use the
[Oxford comma](https://en.wikipedia.org/wiki/Serial_comma) when writing lists.

## General guidelines
1. Atomize your commits. This means each change you commit should
   contain one logically connected change set. This takes intuition and
   practice. See [this post](http://elnur.pro/make-atomic-commits) for
   some ideas.
2. Create commit messages religiously following [this
   guide](https://chris.beams.io/posts/git-commit/). Consistency is
   important, as are best practices.
3. Each logically connected change set should be contained in the same
   commit. (This is implicit in [1] but made explicit here.) If you find
   that you've violated this guideline, the `squash` option for `git
   rebase` may come in useful, but be careful with rebasing if you've
   already pushed upstream.
4. Simple typos and grammar fixes should ideally be bundled in a single
   commit, but use judgement with this.
5. Earlier commits should not rely on later commits.

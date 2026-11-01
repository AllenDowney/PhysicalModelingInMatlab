# Physical Modeling in MATLAB: run the code

This site runs GNU Octave in your browser, so you can run and change the code from *Physical Modeling in MATLAB* without installing anything. The book is at https://greenteapress.com/wp/physical-modeling-in-matlab/.

**Chapters 9 (Ordinary Differential Equations) and 13 (Optimization) are runnable notebooks:** open `chap09/chap09.ipynb` or `chap13/chap13.ipynb` and run the cells in order with Shift+Enter. Each has the text of the chapter, and you can change any example and run it again. Solutions to the exercises are in `solutions/`. (A test: more chapters to come.)

To run the code for other chapters:

1. In the file browser on the left, open a chapter folder, like `chap09`.
2. Open a console: **File → New → Console**, and choose **Octave**.
3. In the console, change to the chapter folder and run a script or function, for example:

```
cd /drive/chap09
rat_pop
```

You can open any `.m` file, edit it and save it, then run it again in the console. Your changes are saved in this browser only.

The first time, the site downloads Octave (compiled to WebAssembly), which can take a minute.

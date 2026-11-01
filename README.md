# Physical Modeling in MATLAB

[![tests](https://github.com/AllenDowney/PhysicalModelingInMatlab/actions/workflows/tests.yml/badge.svg)](https://github.com/AllenDowney/PhysicalModelingInMatlab/actions/workflows/tests.yml)

by Allen B. Downey

*Physical Modeling in MATLAB* is an introduction to programming in MATLAB and simulation of physical systems. By reading it and working on the exercises, you will learn some programming, some modeling, and some simulation. It presents the entire modeling process, including model selection, analysis, simulation, and validation, with examples from falling pennies and baseballs to predators and prey, bungee jumps, and the orbit of the Earth.

The fourth edition is free:

* [Read the book and run the code online](https://allendowney.github.io/PhysicalModelingInMatlab/): each chapter is a notebook that runs in your browser, with nothing to install.
* [Download the PDF](https://github.com/AllenDowney/PhysicalModelingInMatlab/raw/master/PhysicalModelingInMatlab4.pdf).
* [Download the code](https://github.com/AllenDowney/PhysicalModelingInMatlab/raw/master/PhysicalModelingInMatlab.zip) for all chapters.

The [home page for this book at Green Tea Press](https://greenteapress.com/wp/physical-modeling-in-matlab/) has links to printed copies of the first edition.

## Who it is for

The book is for people who have never programmed before. It starts from the beginning, defines new terms as they are introduced, and presents only the features you need, when you need them.

It assumes you know trigonometry and some calculus, but not very much: if you understand that a derivative represents a rate of change, that's enough. It also assumes basic physics (force, acceleration, velocity and position); if you know Newton's second law in the form F = ma, that's enough. You will learn about differential equations and some linear algebra along the way.

## Contents

| Chapter | Code |
| --- | --- |
| 1. Modeling and Simulation | none |
| 2. Scripts | [chap02](code/chap02) |
| 3. Loops | [chap03](code/chap03) |
| 4. Vectors | [chap04](code/chap04) |
| 5. Functions | [chap05](code/chap05) |
| 6. Conditionals | [chap06](code/chap06) |
| 7. Zero-Finding | [chap07](code/chap07) |
| 8. Functions of Vectors | [chap08](code/chap08) |
| 9. Ordinary Differential Equations | [chap09](code/chap09) |
| 10. Systems of ODEs | [chap10](code/chap10) |
| 11. Second-Order Systems | [chap11](code/chap11) |
| 12. Two Dimensions | [chap12](code/chap12) |
| 13. Optimization | [chap13](code/chap13) |
| 14. Springs and Things | [chap14](code/chap14) |
| 15. Under the Hood | [chap15](code/chap15) |

Data files used in the book are in [code/data](code/data). The LaTeX source of the book is in [book](book).

## Running the code

The easiest way is [online](https://allendowney.github.io/PhysicalModelingInMatlab/): each chapter is a notebook, and the code runs in GNU Octave in your browser.

On your own computer, the code runs in [MATLAB](https://www.mathworks.com/products/matlab.html) and in [GNU Octave](https://octave.org/), which is free. The preface explains how to install either one.

To run a chapter's code, make its folder your current folder, then type the name of a script or function at the prompt.

If you use conda or mamba, `environment.yml` creates an environment with Octave:

```bash
mamba env create -f environment.yml
conda activate PhysicalModelingInMatlab
octave
```

The tests run all of the chapter code in Octave, on every change to this repository: see [tests](tests).

## Support

If you find this book useful, please consider [supporting free, open educational materials from Green Tea Press](https://greenteapress.com/support/?book=matlab).

Suggestions and corrections are welcome: please [create an issue](https://github.com/AllenDowney/PhysicalModelingInMatlab/issues).

## License

The text of the book is under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/). The code is under the [MIT License](https://opensource.org/license/MIT). See [LICENSE](LICENSE).

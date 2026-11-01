# Build PhysicalModelingInMatlab.zip, the code download linked from the book
# (greenteapress.com/matlab/zip), from the files in code/.

rm -rf PhysicalModelingInMatlab PhysicalModelingInMatlab.zip
mkdir PhysicalModelingInMatlab
cp LICENSE PhysicalModelingInMatlab
cat > PhysicalModelingInMatlab/README.md <<'END'
# Physical Modeling in MATLAB

Code for *Physical Modeling in MATLAB* by Allen B. Downey, an introduction to programming in MATLAB and simulation of physical systems.

The book is available from https://greenteapress.com/wp/physical-modeling-in-matlab/ and its source and code from https://github.com/AllenDowney/PhysicalModelingInMatlab
END

CODE="chap02/myscript.m \
chap02/fibonacci1.m \
chap03/bike_loop.m \
chap03/bike_update.m \
chap03/sequence.m \
chap03/series.m \
chap03/fibonacci2.m \
chap04/fibonacci4.m \
chap04/lorenz.m \
chap04/logmap.m \
chap05/myfunc.m \
chap06/find_triples.m \
chap06/is_pythagorean.m \
chap07/cheby6.m \
chap08/exists.m \
chap09/euler.m \
chap09/rats.m \
chap10/lotka.m \
chap10/lorenz.m \
chap11/skydiver.m \
chap12/baseball.m \
chap13/baseball3.m \
chap14/binary.m \
chap15/odeplot.m"

cd code
rsync -aR ${CODE} ../PhysicalModelingInMatlab

cd ..
zip -qrX PhysicalModelingInMatlab.zip PhysicalModelingInMatlab
rm -rf PhysicalModelingInMatlab

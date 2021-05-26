rm -rf PhysicalModelingInMatlab
mkdir PhysicalModelingInMatlab
cp LICENSE README.md PhysicalModelingInMatlab

CODE="chap02/myscript.m \
chap02/fibonacci1.m \
chap03/bike_loop.m \
chap03/sequence.m \
chap03/series.m \
chap03/fibonacci2.m \
chap04/fibonacci4.m \
chap04/lorenz.m \
chap04/logmap.m \
chap05/myfunc.m \
chap06/find_triples.m \
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
zip -r PhysicalModelingInMatlab.zip PhysicalModelingInMatlab

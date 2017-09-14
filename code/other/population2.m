% According to
% https://en.wikipedia.org/wiki/Paleodemography
% the world population in 4000 BCE was about 7 million.
% By 2000 it had grown to 7 billion.  The growth rate during
% that interval was not constant, but if we pretend it was,
% what growth rate would match these observed end points?
% Assume that the average generation time is twenty years.

generations = 6000 / 20

n = 7          % millions
a = 0.0232       % growth rate
clf
hold on

for i=1:generations
    n = n + a * n;
    plot(i, n, 'ro')
end

n
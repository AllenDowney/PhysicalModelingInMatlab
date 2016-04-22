% Suppose we put one cell on a petri dish (which supplies a nutrient
% that allows the cell to reproduce).  During each generation time,
% each cell divides into two cells, so the number of new cells
% equals the number of current cells.

% After 10 generations, how many cells are there?

n = 1
a = 1
clf
hold on

for i=1:10
    n = n + a * n
    plot(i, n, 'ro')
end
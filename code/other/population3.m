% Suppose we put one cell on a petri dish (which supplies a nutrient
% that allows the cell to reproduce).  During each generation time,
% each cell divides into two cells, so the number of new cells
% equals the number of current cells.

% Now suppose that each cell consumes one unit of nutrient during
% each generation time, and suppose that the petri dish contains
% 1000 units of nutrient.

% When the food is exhausted, the cells become dormant and stop
% dividing.  Plot the number of cells over time.

n = 1
a = 1
food = 1000
clf
hold on

for i=1:12
    eaten = min(n, food);
    food = food - eaten
    n = n + a * eaten;
    plot(i, n, 'ro')
end
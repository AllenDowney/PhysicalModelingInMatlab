% Suppose we put one cell on a petri dish (which supplies a nutrient
% that allows the cell to reproduce).  During each generation time,
% each cell divides into two cells, so the number of new cells
% equals the number of current cells.

% Now suppose that each cell consumes one unit of nutrient during
% each generation time, and suppose that the petri dish contains
% 1000 units of nutrient.

% When the food is exhausted, the cells become dormant and stop
% dividing.  Plot the number of cells over time.

% Suppose that the natural death rate of cells is 10%.
% Plot the number of cells over time.

% Now suppose we add food to the petri dish at a rate of 50
% units per generation

n = 1
a = 1
death_rate = 0.1
food = 1000
food_rate = 50
clf
hold on

for i=1:30
    eaten = min(n, food);
    food = food - eaten + food_rate;
    n = n + a * eaten - death_rate * n;
    plot(i, n, 'ro')
    plot(i, food, 'bd')
end
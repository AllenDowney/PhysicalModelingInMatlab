% Simulates the bike share system for one month

b = 100
c = 100

clf
hold on
for i=1:30
    plot(i, b, 'ro')
    plot(i, c, 'bd')
    bike_update
end
hold off
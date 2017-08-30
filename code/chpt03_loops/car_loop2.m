a = 150
b = 150
clf
hold on

for i=1:52
    car_update
    plot(i, a, 'ro')
    plot(i, b, 'bd')
end
[T, M] = ode45(@lorenz, [0,30], [3, 2, 23]);
X = M(:,1);
Y = M(:,2);
Z = M(:,3);
plot3(X, Y, Z);
P = [0,0,0]';
V = [1,0,0]';
[T, M] = ode45(@particle, [0, 10], [P;V]);
x = M(:,1);
y = M(:,2);
z = M(:,3);
plot3(x,y,T);
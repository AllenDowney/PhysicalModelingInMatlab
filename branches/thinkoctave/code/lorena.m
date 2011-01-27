function dVdt = f(t, V)
x = V(1);  
y = V(2);   
z = V(3);

sigma = 10; 
b = 8/3;
r = 99.96;

dxdt = sigma * (y-x);                          
dydt = x * (r-z) - y;
dzdt = x*y - b*z;

dVdt = [dxdt; dydt; dzdt];    % pack the results in a column vector
end

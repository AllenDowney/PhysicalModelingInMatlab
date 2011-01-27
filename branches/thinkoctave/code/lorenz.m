function res = lorenz()
    [T, M] = ode45(@rate_func, [0 30], [1 2 3]);
    X = M(:,1);
    Y = M(:,2);
    Z = M(:,3);
    comet3(X,Y,Z);
end

function res = rate_func(t, V)
    x = V(1);  
    y = V(2);   
    z = V(3);

    sigma = 10; 
    b = 8/3;
    r = 28;

    dxdt = sigma * (y-x);                          
    dydt = x * (r-z) - y;
    dzdt = x*y - b*z;

    res = [dxdt; dydt; dzdt];    % pack the results in a column vector
end

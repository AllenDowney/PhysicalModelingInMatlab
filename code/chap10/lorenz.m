% Solve the Lorentz system and plot the results.

function res = lorenz()
    % Run the ode solver
    [T, M] = ode45(@rate_func, [0 30], [1 2 3]);

    % plot the results
    X = M(:,1);
    Y = M(:,2);
    Z = M(:,3);
    plot3(X, Y, Z)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')

    % uncomment this to see the trajectory animated
    % comet3(X, Y, Z);
end

function res = rate_func(t, V)
    % unpack the state vector
    x = V(1);
    y = V(2);
    z = V(3);

    % set the parameters
    sigma = 10;
    b = 8/3;
    r = 28;

    % compute the derivatives
    dxdt = sigma * (y-x);
    dydt = x * (r-z) - y;
    dzdt = x*y - b*z;

    % pack the results in a column vector
    res = [dxdt; dydt; dzdt];
end

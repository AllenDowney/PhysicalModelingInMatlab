% Simulate a penny falling from the Empire State Building.

function penny()
    t = 0;
    X = [381, 0];
    rate_func(t, X)
   
    tspan = [0, 10];
    [T, M] = ode45(@rate_func, tspan, X);
   
    Y = M(:, 1);
    V = M(:, 2);
    
    plot(T, Y)
    xlabel('Time (s)')
    ylabel('Altitude (m)')
    saveas(gcf, '../../book/figs/penny.eps', 'epsc')
   
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, X, options);
    T(end)
    M(end, :)
end

function res = rate_func(t, X)
    % unpack position and velocity
    y = X(1);      
    v = X(2);      
    
    % compute the derivatives
    dydt = v;
    dvdt = -9.8;

    % pack the derivatives into a column vector
    res = [dydt; dvdt];
end

function [value, isterminal, direction] = event_func(t,X)
    value = X(1);
    isterminal = 1;
    direction = -1;
end
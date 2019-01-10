% Simulate the descent of a skydiver.

function skydiver()
    t = 0;
    X = [4000, 0];
    rate_func(t, X)
   
    tspan = [0, 1000];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, X, options);
    
    Y = M(:, 1);
    V = M(:, 2);
    
    plot(T, Y)
    xlabel('Time (s)')
    ylabel('Altitude (m)')
    
    T(end)
    M(end, :)
end

function res = rate_func(t, X)
    % unpack position and velocity
    y = X(1);      
    v = X(2);      
    
    % compute the derivatives
    dydt = v;
    dvdt = acceleration(t, X);

    % pack the derivatives into a column vector
    res = [dydt; dvdt];
end

function res = acceleration(t, X)
    b_free = 0.2;             % drag constant in kg/m
    b_parachute = 29;
    
    y = X(1);
    if y < 8
        b = b_parachute;
    else
        b = b_free;
    end
    
    v = X(2);                 % velocity in m/s
    f_d = -sign(v) * b * v^2; % drag force in N

    m = 75;                   % mass in kg
    a_d = f_d / m;            % drag acceleration in m/s^2

    a_g = -9.8;               % acceleration due to gravity in m/s^2
    res = a_g + a_d;          % total acceleration
end

function [value, isterminal, direction] = event_func(t,X)
    value = X(1);
    isterminal = 1;
    direction = -1;
end
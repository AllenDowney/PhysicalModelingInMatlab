% Simulate the Earth falling into the Sun.

function earth()
    y0 = 150e9;           % meters
    t_end = 1e7;          % seconds
    
    t = 0;
    X = [y0, 0];
    rate_func(t, X)
   
    tspan = [0, t_end];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, X, options);
    
    % convert time to days
    % convert distance to millions of km
    T = T / 60 / 60 / 24;
    Y = M(:, 1) / 1e9;
    
    plot(T, Y)
    xlabel('Time (s)')
    ylabel('Distance from sun (million km)')
    % saveas(gcf, '../../book/figs/earth.eps', 'epsc')
    
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
    G=6.674e-11;          % N / kg^2 * m^2,
    m_sun = 1.989e30;     %  kg,
    m_earth = 5.972e24;   % kg,

    y = X(1);
    f_g = -G * m_earth * m_sun / y^2;
    a_g = f_g / m_earth;
    res = a_g;
end

function [value, isterminal, direction] = event_func(t, X)
    r_earth = 6.371e6;           % meters
    r_sun = 695.508e6;           % meters
    y_final = r_sun + r_earth;
    y = X(1);
    
    value = y - y_final;
    isterminal = 1;
    direction = -1;
end
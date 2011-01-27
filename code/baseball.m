function res = optimal_angle(velocity)
    % find the angle that yields the maximum range for
    % a given velocity
    angles = 20:70;
    for i=1:length(angles)
        angle = angles(i);
        ranges(i) = range(velocity, angle);
    end
    plot(angles, ranges);
    [m, i] = max(ranges);
    best_angle = angles(i);
    res = best_angle;
end

function res = range(velocity, angle)
    % compute the horizontal distance in the air of a baseball
    % with initial velocity in m/s and angle in degrees
    theta = angle * pi / 180;
    vx = velocity * cos(theta);
    vy = velocity * sin(theta);

    options = odeset('Events', @events);
    [T, M] = ode45(@slope, [0, 100], [0, 1, vx, vy], options);
    
    X = M(:,1);
    Y = M(:,2);
    plot(X, Y)
    res = X(end);
end

function [value,isterminal,direction] = events(t,W)
    % Locate the time when height passes through zero in a 
    % decreasing direction and stop integration.
    value = W(2);        % 
    isterminal = 1;      % Stop the integration
    direction = -1;      % Negative direction only
end

function res = slope(t, W)
    % this is a slope function invoked by ode45
    % W contains 4 elements, Rx, Ry, Vx, and Vy
    R = W(1:2);
    V = W(3:4);

    dRdt = V;                          
    dVdt = acceleration(t, R, V);

    res = [dRdt; dVdt];
end

function res = acceleration(t, R, V)
    % compute acceleration due to gravity and drag
    Ag = [0; -9.8];

    mass = 0.145;                     % kg
    Ad = drag_force(V) / mass;
    res = Ag + Ad;
end

function Fd = drag_force(V)
    % compute the drag force of a baseball
    C = 0.3;      % dimensionless
    rho = 1.3;    % kg / m^3
    A = 0.0042;   % m^2
    v = norm(V);  % m/s
    
    Fd = - 1/2 * C * rho * A * v * V;
end


e = 


function res = manny()
    % find the velocity that _just_ gets the ball over the wall
    initial_guess = 45;         % m/s
    velocity = fzero(@crossover_func, initial_guess);
    res = velocity;
end

function res = crossover_func(velocity)
    % this function crosses through zero when the height of the ball at
    % the wall is equal to the goal
    goal = 12;         % height of the wall in meters
    res = optimal_height_at_wall_func(velocity) - goal;
end

function res = optimal_height_at_wall_func(velocity)
    % search for the angle that maximizes the height of the
    % ball when it reaches the Green Monster, and return the height
    angle = optimal_angle_func(velocity);
    height = height_func(velocity, angle);
    res = height;
end

function res = optimal_angle_func(velocity)
    % find the optimal launch angle in degrees for the given
    % velocity in m/s

    function res = minimization_func(angle)
        % return the height of the ball at the wall, negated
        % so that we can find a _minimum_
        res = -height_func(velocity, angle);
    end

    angle = fminsearch(@minimization_func, 45);
    res = angle;
end

function res = height_func(velocity, angle)
    % compute the height of the ball when it reaches the wall,
    % for a baseball with initial velocity in m/s and angle in degrees
    theta = angle * pi / 180;
    vx = velocity * cos(theta);         % m/s
    vy = velocity * sin(theta);         % m/s

    options = odeset('Events', @events_func);
    [T, M] = ode45(@slope_func, [0, 100], [0, 1, vx, vy], options);
    
    X = M(:,1);
    Y = M(:,2);
    %plot(X, Y)
    res = Y(end);      % the result is the final Y position in meters
end

function [value,isterminal,direction] = events_func(t,W)
    % stop the integration when the ball gets to the wall.
    wall_range = 97;                  % distance to the wall in meters
    value = W(1) - wall_range;        % equals 0 when you hit the wall 
    isterminal = 1;
    direction = 1;
end

function res = slope_func(t, W)
    % this is a slope function invoked by ode45
    % W contains 4 elements, Px, Py, Vx, and Vy
    P = W(1:2);             % position of the ball in meters
    V = W(3:4);             % velocity of the ball in m/s

    dPdt = V;                          
    dVdt = acceleration_func(t, P, V);

    res = [dPdt; dVdt];
end

function res = acceleration_func(t, P, V)
    % compute acceleration due to gravity and drag
    Ag = [0; -9.8];                   % m / s^2

    mass = 0.145;                     % kg
    Ad = drag_force_func(V) / mass;   % m / s^2
    res = Ag + Ad;
end

function Fd = drag_force_func(V)
    % compute the drag force of a baseball, given the velocity in m/s
    C = 0.3;      % dimensionless
    rho = 1.3;    % kg / m^3
    A = 0.0042;   % m^2
    v = norm(V);  % m/s
    
    Fd = - 1/2 * C * rho * A * v * V;       % kg m / s^2
end


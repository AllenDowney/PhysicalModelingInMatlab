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
    res = height_at_wall_func(velocity) - goal;
end

function res = height_at_wall_func(velocity)
    % search for the angle that maximizes the height of the
    % ball when it reaches the Green Monster, and return the height
    angle = golden_angle_func(velocity);
    height = height_func(velocity, angle);
    res = height;
end

function res = golden_angle_func(velocity)
    % find the launch angle that yields the maximum height when
    % the ball reaches the wall.  For simplicity, this function
    % uses bisection rather than the golden ratio.
    a = 20;
    b = 40;
    c = 60;
    
    fa = height_func(velocity, a);
    fb = height_func(velocity, b);
    fc = height_func(velocity, c);
   
    for i=1:20
        if c-b > b-a
            x = (b+c) / 2;
            fx = height_func(velocity, x);
            if fx > fb
                a = b;  fa = fb;
                b = x;  fb = fx;
            else
                c = x;  fc = fx;
            end
        else
            x = (a+b) / 2;
            fx = height_func(velocity, x);
            if fx > fb
                c = b;  fc = fb;
                b = x;  fb = fx;
            else
                a = x;  fa = fx;
            end
        end

        % loop until the interval is smaller than 1/10th of a degree
        if abs(c-a) < 0.1
            break
        end
    end
    res = (a+c) / 2;
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
    % W contains 4 elements, Rx, Ry, Vx, and Vy
    R = W(1:2);             % position of the ball in meters
    V = W(3:4);             % velocity of the ball in m/s

    dRdt = V;                          
    dVdt = acceleration_func(t, R, V);

    res = [dRdt; dVdt];
end

function res = acceleration_func(t, R, V)
    % compute acceleration due to gravity and drag
    Ag = [0; -9.8];                   % m / s^2

    mass = 0.145;                     % kg
    Ad = drag_force_func(V) / mass;   % m / s^2
    res = Ag + Ad;
end

function Fd = drag_force_func(V)
    % compute the drag force of a baseball, given the velocity
    % in m/s
    C = 0.3;      % dimensionless
    rho = 1.3;    % kg / m^3
    A = 0.0042;   % m^2
    v = norm(V);  % m/s
    
    Fd = - 1/2 * C * rho * A * v * V;       % kg m / s^2
end


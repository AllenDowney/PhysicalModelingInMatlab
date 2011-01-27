function res = optimize(V)
    x1 = V(1);
    x2 = V(2);
    x3 = V(3);
    
    fx1 = height_func(x1);
    fx2 = height_func(x2);
    fx3 = height_func(x3);
   
    for i=1:50
        if x3-x2 > x2-x1
            x4 = (x2+x3) / 2;
            fx4 = height_func(x4);
            if fx4 > fx2
                x1 = x2;  fx1 = fx2;
                x2 = x4;  fx2 = fx4;
            else
                x3 = x4;  fx3 = fx4;
            end
        else
            x4 = (x1+x2) / 2;
            fx4 = height_func(x4);
            if fx4 > fx2
                x3 = x2;  fx3 = fx2;
                x2 = x4;  fx2 = fx4;
            else
                x1 = x4;  fx1 = fx4;
            end
        end

        if abs(x3-x1) < 1e-1
            break
        end
    end
    i
    res = [x1 x2 x3];
    height_func(44.4)
end

function res = height_func(angle)
    % compute the horizontal distance in the air of a baseball
    % with initial velocity in m/s and angle in degrees
    velocity = 42;
    theta = angle * pi / 180;
    vx = velocity * cos(theta);
    vy = velocity * sin(theta);

    options = odeset('Events', @events);
    [T, M] = ode45(@slope, [0, 100], [0, 1, vx, vy], options);
    
    X = M(:,1);
    Y = M(:,2);
    plot(X, Y)
    res = Y(end);
end

function [value,isterminal,direction] = events(t,W)
    % Locate the time when height passes through zero in a 
    % decreasing direction and stop integration.
    value = W(1) - 97;        % 
    isterminal = 1;      % Stop the integration
    direction = 1;      % Negative direction only
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



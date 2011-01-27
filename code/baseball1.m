function distance = baseball1(velocity, angle)

    % compute the initial conditions
    theta = angle * pi / 180;
    vx = velocity * cos(theta);
    vy = velocity * sin(theta);

    % call ode45 to compute the trajectory
    [T, M] = ode45(@baseproj, [0, 10], [0, 1, vx, vy]);
    
    % rifle through the results to see where the ball landed
    X = M(:,1);
    Y = M(:,2);
   
    for i=1:length(Y)
        if Y(i)<0
            distance = X(i);
            break
        end
    end
    plot(X, Y)
end

function dWdt = baseproj(t, W)
    R = W(1:2);
    V = W(3:4);

    dRdt = V;                          
    dVdt = acceleration(t, R, V);

    dWdt = [dRdt; dVdt];
end

function dVdt = acceleration(t, R, V)
    g = 9.8;                       % acceleration of gravity in m/s^2
    gravity = [0; -g];

    m = 0.145;                     % mass in kilograms
    drag = drag_force(V) / m;
    dVdt = gravity + drag;
end

function Fd = drag_force(V)
    C = 0.3;      % dimensionless
    rho = 1.3;    % kg / m^3
    A = 0.0042;   % m^2
    v = norm(V);  % m/s
    
    Fd = - 1/2 * C * rho * A * v * V;
end


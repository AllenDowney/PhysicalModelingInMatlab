function dWdt = proj(t, W)
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

function res = freefall(t, X)
    p = X(1);      % the first component is position
    v = X(2);      % the second component is velocity

    dpdt = v;                          
    dvdt = acceleration(t, p, v);

    res = [dpdt; dvdt];    % pack the results in a column vector
end

function res = acceleration(t, p, v)
    g = -9.8;          % acceleration of gravity in m/s^2
    c = 0.2;           % drag constant
    m = 75;            % mass in kg
    F_drag = c * v^2;           % drag force in N
    a_drag = F_drag / m;        % drag acceleration in m/s^2
    res = g + a_drag;           % total acceleration
end

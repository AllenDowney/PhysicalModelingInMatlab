function res = freefall(t, X)
    y = X(1);      % the first component is position
    v = X(2);      % the second component is velocity

    dydt = v;
    dvdt = acceleration(t, y, v);

    res = [dydt; dvdt];    % pack the results in a column vector
end

function res = acceleration(t, y, v)
    a_g = -9.8;              % acceleration due to gravity in m/s^2
    b = 0.2;                 % drag constant
    m = 75;                  % mass in kg
    F_d = b * v^2;           % drag force in N
    a_d = F_d / m;           % drag acceleration in m/s^2
    res = a_g + a_d;         % total acceleration
end

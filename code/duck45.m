function duck45(beta)
    [t, M] = ode45(@slope, [0,2], [0,10]); 
    H = M(:,1); 
    V = M(:,2); 
    plot(t,H)
    
    function res = slope(t, X)
        p = X(1);      % the first component is position
        v = X(2);      % the second component is velocity

        dpdt = v;                          
        dvdt = acceleration(t, p, v);

        res = [dpdt; dvdt];    % pack the results in a column vector
    end

    function res = acceleration(t, p, v)
        a_grav = -9.8;                    % acceleration of gravity in m/s^2
        m = duck_mass(10);                % mass in kg
        F_drag = -beta * v^2 * sign(v);    % drag force in N
        a_drag = F_drag / m;              % drag acceleration in m/s^2
        res = a_grav + a_drag;            % total acceleration
    end

    function res = duck_mass(radius)
        rho = 0.3;                                 % duck density in g/cm^3
        res = rho * 4/3 * pi * radius^3 / 1000;    % mass in kg
    end
end
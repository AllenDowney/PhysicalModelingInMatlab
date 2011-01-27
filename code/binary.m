function orbit_func()
    % calculate and plot the trajectories of two bodies with
    % the given parameters, acting under the force of gravity.
    % by Allen Downey, available from http://wb/icb/studio/code/

    au = 150e9;                % astronomical unit in meters
    day = 24 * 60 * 60;        % year in seconds
    sunmass = 2.0e30;          % mass of the sun in kg
    
    d = 779e9;                 % initial distance in meters
    v = 13e3;                  % initial velocity in meters per second
    m1 = 2.0e30;               % mass of the sun in kg
    m2 = 1.9e27;               % mass of Jupiter
    G = 6.67e-11;              % gravitation constant in N m^2 / kg^2
    period = 4332;             % one orbit in days
    end_time = period * day;   % period in seconds
    
    % scaling distances
    d = d / au;
    v = v / au;
    G = G / au^3;
    
    % scaling times
    end_time = end_time / day;
    v = v * day;
    G = G * day^2;
    
    % scaling masses
    m1 = m1 / sunmass;
    m2 = m2 / sunmass;
    G = G * sunmass;
    
    P1 = [0;0];       % simple initial conditions
    P2 = [d;0];
    V1 = [0;0];
    V2 = [0;v];
    
    options = odeset('RelTol', 1e-5);
    step = end_time/period*100;
    [T, M] = ode45(@rate_func, [0:step:end_time], [P1; P2; V1; V2], options);
    animate_func(T,M);
    energy_func(T,M);
    
    function animate_func(T,M)
        % animate the positions of the planets, assuming that the
        % columns of M are x1, y1, x2, y2.
        X1 = M(:,1);
        Y1 = M(:,2);

        X2 = M(:,3);
        Y2 = M(:,4);

        minmax = [min([X1;X2]), max([X1;X2]), min([Y1;Y2]), max([Y1;Y2])];

        for i=1:length(T)
            clf;
            hold on;
            axis(minmax);
            draw_func(X1(i), Y1(i), X2(i), Y2(i));
            drawnow;
            if i < length(T)
                dt = T(i+1) - T(i);
                speedup = 1000;
                pause(dt/speedup);
            end
        end
        hold off
    end

    function energy_func(T,M)
        for i=1:length(T)
            P1 = M(i,1:2);
            P2 = M(i,3:4);
            pe = potential_func(P1, P2);
            V1 = M(i,5:6);
            V2 = M(i,7:8);
            ke = kinetic_func(V1, m1) + kinetic_func(V2, m2);
            E(i) = ke + pe; 
        end
        plot(T, E);
        loss = (E(1) - E(end)) / E(1)
    end

    function res = potential_func(P1, P2)
        r = norm(P1-P2);
        pe = -G * m1 * m2 / r;
        res = pe;
    end

    function res = kinetic_func(V, m)
        v = norm(V);
        ke = m * v^2 / 2;
        res = ke;
    end

    function draw_func(x1, y1, x2, y2)
        plot(x1, y1, 'r.', 'MarkerSize', 50);
        plot(x2, y2, 'b.', 'MarkerSize', 20);
    end

    function res = rate_func(t, W)
        % this is a slope function invoked by ode45
        n = length(W)/2;
        P = W(1:n);
        V = W(n+1:end);

        dRdt = V;                          
        dVdt = acceleration_func(t, P, V);

        res = [dRdt; dVdt];
    end

    function res = acceleration_func(t, P, V)
        % compute acceleration due to gravity
        P1 = P(1:2);
        P2 = P(3:4);
        
        F12 = gravity_force_func(P1, P2, m1, m2);
        
        A1 = F12 / m1;
        A2 = -F12 / m2;
        res = [A1; A2];
    end

    function Fg = gravity_force_func(P1, P2, m1, m2)
        % compute the force of gravity acting on a body at
        % P1 with mass m1, due to a body at P2 with mass m2
        R = P2 - P1;
        r = norm(R);
        Rhat = R/r;
        
        Fg = G * m1 * m2 / r^2 * Rhat;
    end

end
function orbit_func()
    % calculate and plot the trajectories of two bodies with
    % the given parameters, acting under the force of gravity.
    % by Allen Downey, available from http://wb/icb/studio/code/

    d = 1;             % initial distance between stars
    v = 0.6;           % initial velocity of the small one
    m1 = 1;            % mass of the large star
    m2 = 1;            % mass of the small star
    
    P1 = [-d;0];       % simple initial conditions
    P2 = [d;0];
    V1 = [0;v];
    V2 = [0;-v];
    
    years = 10;
    [T, M] = ode45(@slope_func, [0, years*2*pi], [P1; P2; V1; V2]);
    animate_func(T,M);
    
    function animate_func(T,M)
        % animate the positions of the planets, assuming that the
        % columns of M are.  Playback is in real time with speedup.
        X1 = M(:,1);
        Y1 = M(:,2);

        X2 = M(:,3);
        Y2 = M(:,4);

        for i=1:length(T)-1
            clf;
            hold on;
            axis([min([X1;X2]), max([X1;X2]), min([Y1;Y2]), max([Y1;Y2])]);
            plot(X1(i), Y1(i), 'r.', 'MarkerSize', 50);
            plot(X2(i), Y2(i), 'b.', 'MarkerSize', 50);
            hold off;
            drawnow;
            dt = T(i+1) - T(i);
            speedup = 3.0;
            pause(dt / speedup);
        end
    end

    function res = slope_func(t, W)
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
        
        Fg = gravity_force_func(P1, P2, m1, m2);
        
        A1 = -Fg / m1;
        A2 = Fg / m2;
        res = [A1; A2];
    end

    function Fg = gravity_force_func(P1, P2, m1, m2)
        % compute the force of gravity acting on a body at
        % P2 with mass m2, due to a body at P1 with mass m1
        G = 1;
        V = P1 - P2;
        Vhat = V/norm(V);
        dist = norm(V);
        
        Fg = G * m1 * m2 / dist^2 * Vhat;
    end

end

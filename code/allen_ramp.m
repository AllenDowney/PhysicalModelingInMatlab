function res = bisection_func(flag)
    % if flag is 1, run the animation at the critical velocity
    % (minimum that gets over the ramp)
    % otherwise, run a bisection search for the critical velocity
    if flag
        v = 8.360417154065374;       % initial velocity of the rider/board
        ramp_func(v, 1.0);
        return
    end
    
    u = 8.0;
    v = 9.0;
    
    for i=1:50
        w = (u+v) / 2
        xend = ramp_func(w, 100.0);
        if xend < 0
            u = w;
        else
            v = w;
        end
        if xend > 0 && abs(v-u)/u < 1e-15
            break
        end
    end
    res = w;
end


function res = ramp_func(v, speedup)
    % run a simulation with the given initial velocity and
    % display the animation with the given speedup.
    % Run until the rider gets to one end of the ramp or the
    % other and return the final x position.

    % ramp_height is the height of the ramp in meters
    % ramp_dist is the horizontal distance from the tip of the
    % ramp to the post, so half_length is half the length of the ramp
    ramp_height = 2.5;
    ramp_dist = 10;  
    half_length = norm([ramp_height,ramp_dist]);   
    
    % compute the max and min angles
    maxth = atan2(ramp_height, ramp_dist);
    minth = -maxth;

    % compute the initial unit vectors
    ihat = [1 0]';
    jhat = [0 1]';
    rhat = [cos(maxth) sin(maxth)]';
    that = [-sin(maxth) cos(maxth)]';
    
    m = 75;        % mass of rider/board in kg
    g = 9.8;       % acceleration of gravity in m/s^2
    d = 1.0;       % height of the rider's CG in m
    I = 1000.0;       % moment of inertia of the ramp

    % start at left side of ramp, velocity horizontal
    IP = -half_length * rhat + d * jhat;
    IV = v * ihat;
    init = [IP; maxth; IV; 0];
    
    % run the simulation, then show the results
    tend = 100;
    options = odeset('Events', @events_func);    
    [T, M] = ode45(@slope_func, [0:0.05:tend], init, options);
    animate_func(T,M);
    
    % return the final x position
    xend = M(end,1);
    res = xend;
    
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
        % unpack P
        R = P(1:2);
        th = P(3);
        thdot = V(3);
        
        % compute unit vectors rhat and that
        rhat = [cos(th) sin(th)]';
        that = [-sin(th) cos(th)]';

        % compute r, the distance from the pivot to the contact point
        r = dot(R, rhat);

        % find the restoring force that moves the center of mass
        % toward where it is supposed to be.
        dx = dot(R, that) - d;
        k = 10000.0;
        Fr = -k * dx * that;

        % if the rider is too high, the ramp doesn't pull down.
        if dx > 0
            Fr = 0 * that;
        end
        
        % compute the total acceleration
        Ag = -g * jhat;
        Ar = Fr / m;
        A = Ag + Ar;

        % torque calculation can be scalar because we
        % know that R and Fr are in the plane of the ramp
        % and rhat is perpendicular to that.
        aa = r * dot(-Fr, that) / I;

        % if the ramp is touching the ground, simulate
        % a restoring torque
        k = 100000.0;
        if th > maxth
            dth = th - maxth;
        elseif th < minth
            dth = th - minth;
        else
            dth = 0;
        end
        ar = -k * dth / I;
        
        % add some damping to the ramp
        c = 100;
        adamp = -c * thdot^2 * sign(thdot);

        % add up the angular accelerations
        aa = aa + ar + adamp;
        
        % pack the acceleration vector
        res = [A; aa];
    end

    function [value,isterminal,direction] = events_func(t,W)
        % stop the simulation if the rider leaves the ramp
        % in either direction
        R = W(1:2);                  
        th = W(3);
        rhat = [cos(th) sin(th)]';
        r = dot(R, rhat);
        value = [r+half_length, r-half_length];  
        isterminal = [1, 1];
        direction = [-1, 1];
    end

    function animate_func(T,M)
        % show an animation of the data in M in real time (if possible)
        X = M(:,1);
        Y = M(:,2);
        TH = M(:,3);

        for i=1:length(T)-1
            clf;
            hold on;
            f = 1.5;
            unit = f*half_length;
            axis([-unit, unit, -unit, unit]);

            % draw the rider
            plot(X(i), Y(i), 'r.', 'MarkerSize', 50);

            % draw the ramp
            th = TH(i);
            rhat = [cos(th) sin(th)]';
            
            left = -half_length * rhat;
            right = half_length * rhat;
            line_func(left, right);
            
            orig = [0,0];
            bottom = -ramp_height * jhat;
            line_func(orig, bottom);
            
            hold off;
            drawnow;
            dt = T(i+1) - T(i);
            pause(dt / speedup);
        end
    end

    function line_func(A, B)
        % draw a blue line from point A to point B
        plot([A(1), B(1)], [A(2), B(2)], 'b-', 'LineWidth', 5)
    end    
end

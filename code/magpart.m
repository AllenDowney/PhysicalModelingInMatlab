function magpart(te)
% te is the duration of the time range

    % initial conditions
    P = [-0.1 0 0]';
    V = [0.1 0.1 0]';
    
    % call ode45
    [T, M] = ode45(@part, [0, te], [P; V]);
    
    % plot the results
    X = M(:,1);
    Y = M(:,2);
    Z = M(:,3);
    comet3(X, Y, Z);
    
    %XY = M(:, 1:2)
    %plot(T,X)
end

function dXdt = part(t, X)
% t is the current time; X contains the position and velocity
% vectors; evaluate the derivative dXdt
    P = X(1:3);
    V = X(4:6);      
    A = acceleration(t, P, V);
    dXdt = [V; A];
end

function A = acceleration(t, P, V)
% t is the current time, P is the position of the particle in
% 3-space, V is the velocity of the particle.  Return the
% total acceleration of the particle.
    m = 0.001;                 % kilograms
    g = 9.8;
    Amag = mag_force(t, P, V) / m;
    Adrag = drag_force(V) / m;
    Agrav = [0 0 -g]';
    A = Amag + Agrav + Adrag;
end

function F = mag_force(t, P, V)
 % t is the current time, P is a position in 3-space
 % V is the current velocity; compute and return the
 % resulting magnetic force
    q = 1;                 % coulomb
    B = mag_field(t, P);
    F = q * cross(V, B);
end

function B = mag_field(t, P)
% t is the current time, P is a position in 3-space
% compute and return B, the magnetic field at the given position
    R = P;
    R(3) = 0;
    r = norm(R);
    mu0 = 4* pi * 1e-7;
    I = 10;
    b = mu0 * I / 2 / pi / r^2;
    L = [0 0 -1]';
    B = b * cross(L, R);
end

function F = drag_force(V)
% V is the current velocity; return the resulting drag force
    C = 0.0000;                % drag constant = Cd * A * rho
    F = -C * norm(V) * V;
end

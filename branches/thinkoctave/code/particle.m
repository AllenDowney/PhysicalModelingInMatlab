function dXdt = particle(t, X)
    P = X(1:3);      
    V = X(4:6);      

    A = acceleration(t, P, V);

    dXdt = [V; A];
end

function A = acceleration(t, P, V)
% t is the current time, P is the position of the particle in
% 3-space, V is the velocity of the particle.
    q = 1;
    m = 1;
    B = mfield(t, P);
    F = q * cross(V, B);
    Amag = F / m;
    Agrav = [0 0 -9.8]';
    Adrag = drag(V) / m;
    A = Amag + Adrag;
end

function B = mfield(t, P)
% t is the current time, P is a position in 3-space
% compute and return B, the magnetic field at the given position
    B = [0 0 1]';
end

function F = drag(V)
    F = -norm(V) * V;
end

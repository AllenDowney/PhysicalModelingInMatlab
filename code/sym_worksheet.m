function res = sym_examples(func) 
    f = str2func(func);
    f();
end

function res = example_3_1()
% page 51 of Wolfson and Pasachoff
    r = 160;        % km
    degrees = 35;   % degrees
    R = degr2vec(degrees, r)
end
   
function res = example_3_2()
% page 52 of Wolfson and Pasachoff
end
    
function res = example_3_4()
% page 55 of Wolfson and Pasachoff
end

function res = example_3_5()
% page 56 of Wolfson and Pasachoff
end

function res = example_3_6()
% page 58 of Wolfson and Pasachoff
    syms v_air positive
    syms theta real
    syms v_land v_wind
    
    v_land = 960.0;           % km / hour
    v_wind = 190.0;           % km / hour

    vprime = degr2vec(theta, v_land);
    V = degr2vec(0, v_wind);
    v = degr2vec(90, v_air);

    E = vprime + V - v;
    [val1 val2] = solve(E(1), E(2), v_air, theta);
    double(val1(1))
    double(val2(1))
    
end

function res = example_6_2()
% page 127 of Wolfson and Pasachoff
end


function res = example_6_3()
% page 128 of Wolfson and Pasachoff
end


function res = example_6_5()
% page 132 of Wolfson and Pasachoff
    syms g mc mr t a x time
    ihat = [1; 0];
    jhat = [0; 1];

    Tc = t * jhat;
    Fgc = -g * mc * jhat;
    Ac = -a * jhat;
    E1 = Tc + Fgc - mc * Ac;
    %simplify(E1);

    Tr = t * ihat;
    Ar = a * ihat;
    E2 = Tr - mr * Ar;
    %simplify(E2);

    % there are only two equations, 
    % which we can solve for a and t
    % warning: the results from solve come back in alphabetical order
    [a t] = solve(E2(1), E1(2), a, t);
    a = simplify(a)

    % given acceleration, solve for time
    E3 = x - 1/2 * a * time^2;
    time = solve(E3, time);
    time = time(1);              % keep just the positive solution
    time = simplify(time)

    % substitute in the values
    vars = {x mc mr g};
    vals = {51 70 940 9.8};
    subs(time, vars, vals)
end


function res = example_6_9()
% page 142 of Wolfson and Pasachoff
    syms g m n t theta muk
    ihat = [1; 0];
    jhat = [0; 1];

    N = n * jhat;
    Fg = -g * m * jhat;
    T = pol2vec(theta, t);
    Fk = - muk * n * ihat;
    E = N + Fg + T + Fk;
    simplify(E);
    
    [n t] = solve(E(1), E(2), n, t);
    t = simplify(t)
end


function res = example_7_6()
% page 168 of Wolfson and Pasachoff
end


function res = example_7_7()
% page 171 of Wolfson and Pasachoff
    syms k x dx
    vars = {k dx};
    vals = {11 20};

    f = k * x;
    w1 = int(f, x, 0, dx);
    w1 = subs(w1, vars, vals)
    
    w2 = int(f, x, 0, 1);
    w2 = subs(w2, vars, vals)
    
    w3 = int(f, x, 19, 20);
    w3 = subs(w3, vars, vals)    
end

function res = example_8_6()
% page 196 of Wolfson and Pasachoff
    syms th0 th1 real
    syms a l m g h v positive

    h = l * (1 - cos(th0));
    U = m * g * h;
    E0 = U;

    K = m * v^2 / 2;
    E1 = K;
    v = solve(E1-E0, v);
    v(1)

    h = a * (1 - cos(th1));
    U = m * g * h;
    E2 = U;
    th1 = solve(E2-E0, th1);
    th1
end


function res = section_9_3()
% page 219 of Wolfson and Pasachoff
    syms G M m r v T

    % derive the equation for v
    Fc = m * v^2 / r;
    Fg = G * M * m / r^2;
    E = Fc - Fg;
    v = solve(E, v);
    v = v(1);
    simplify(v^2)

    % and the equation for T
    E2 = v - 2 * pi * r / T;
    T = solve(E2, T);
    simplify(T^2)

    % and plug in the values from exercise 9.3
    vars = {G M r};
    vals = {6.67e-11 5.97e24 6.37e6+250e3};
    v = subs(v, vars, vals)
    T = subs(T, vars, vals)
end


function res = section_9_4()
% page 225 of Wolfson and Pasachoff
    syms G M m r v

    % integrate force to get U
    Fg = G * M * m / r^2;
    U = int(Fg, r);

    % solve for escape velocity
    K = m * v^2 / 2;
    E = U + K;
    v = solve(E, v);
    simplify(v(1)^2);
end


function res = example_11_6()
% page 273 of Wolfson and Pasachoff
end

function res = example_12_11()
% page 298 of Wolfson and Pasachoff
    syms M m g t a aa R I positive

    I = M * R^2 / 2;
    E = m * g - t - m * a;
    F = aa - R * t / I;
    G = a - aa * R;

    % unbelievably, aa comes before a in whatever &$*(&ed
    % lexicographical order MATLAB uses.
    [aa a t] = solve(E, F, G, a, aa, t);
    a = simplify(a)
    aa = simplify(aa)
    t = simplify(t)
end



function res = example_12_14()
% page 304 of Wolfson and Pasachoff
    syms M R g h omega v positive

    I = 2 / 5 * M * R^2;
    E = M * g * h - I * omega^2 / 2 - M * v^2 / 2;
    F = omega - v / R;

    % unbelievably, aa comes before a in whatever &$*(&ed
    % lexicographical order MATLAB uses.
    [omega v] = solve(E, F, omega, v);
    simplify(v(1)^2)
end


function res = example_13_1()
% page 318 of Wolfson and Pasachoff
    ihat = [1; 0; 0];
    jhat = [0; 1; 0];
    khat = [0; 0; 1];

    F = 3^(1/2) * ihat + jhat;
    r = 3 * ihat;
    tau = cross(r, F)
end

function res = example_13_2()
% page 319 of Wolfson and Pasachoff
    syms v r m
    
    ihat = [1; 0; 0];
    jhat = [0; 1; 0];
    khat = [0; 0; 1];

    V = v * jhat;
    P = m * V
    R = r * ihat

    L = cross(R, P)
end

function res = example_13_5()
% page 327 of Wolfson and Pasachoff
    syms theta phi Omega omega real
    syms l t I M R g positive
    
    ihat = [1; 0; 0];
    jhat = [0; 1; 0];
    khat = [0; 0; 1];

    % find position of center of mass as a function of time
    theta = Omega * t;
    [x y z] = sph2cart(theta, phi, 1);
    Xhat = [x; y; z];
    X = l/2 * Xhat

    % compute torque due to gravity
    Fg = - M * g * jhat;
    tau = cross(X, Fg)

    % compute angular momentum
    I = M * R^2 / 2;
    L = I * omega * Xhat             % only approximate
    dLdt = diff(L, t)

    % solve for Omega
    E = dLdt - tau;
    simplify(E)

    % ok, now what?
    
end

function res = example_13_5a()
% page 127 of Wolfson and Pasachoff
    syms theta phi OMEGA om1 om2 om3 omega real
    syms l t I M R g positive
    
    ihat = [1; 0; 0];
    jhat = [0; 1; 0];
    khat = [0; 0; 1];

    % find the position of the center of mass
    theta = 0
    phi = 0
    [x y z] = sph2cart(theta, phi, 1);
    Xhat = [x; y; z];
    X = l/2 * Xhat;

    % compute torque due to normal force at the pivot
    Fn = M * g * jhat;
    tau = cross(-X, Fn)

    % compute angular momentum
    I = M * R^2 / 2;
    L = I * omega * Xhat;

    % solve for OMEGA
    OMEGA = [om1; om2; om3];
    E = tau - cross(OMEGA, L);
    simplify(E)
    
    [om1 om2 om3] = solve(E(1), E(2), E(3), om1, om2, om3);
    OMEGA = [om1; om2; om3];
    simplify(OMEGA)

    % this sort of works for (theta = phi = 0), but it the
    % first element of OMEGA is undermined.

    % for non-zero theta and phi, it doesn't seem to work.
end


function res = example_14_3()
% page 343 of Wolfson and Pasachoff
    syms fn1 fn2 real
    syms L m g t positive

    jhat = [0; 1];

    % define the angles (in degrees)
    theta1 = 30;
    phi2 = 15;
    theta2 = 180 + theta1 - phi2;

    % define the force vectors
    Fn = [fn1; fn2];
    Fg = - m * g * jhat;
    T = degr2vec(theta2, t);

    % and the moment arms
    R1 = degr2vec(theta1, L/2);
    R2 = degr2vec(theta1, L);

    % write the equilibrium equations
    E = Fn + Fg + T;
    F = cross2(R1, Fg) + cross2(R2, T);

    % solve
    [a b c] = solve(E(1), E(2), F(3), fn1, fn2, t);

    % plug in the values
    vars = {fn1 fn2 t L m g};
    vals = {a b c 14 11e3 9.8};

    t = subs(t, vars, vals);
    Fn = subs(Fn, vars, vals);

    t = double(t)
    Fn = double(Fn)
    n = norm(Fn)
end


function res = example_14_6()
% page 349 of Wolfson and Pasachoff
    syms a b positive
    syms x real

    % potential energy 
    U = a * x^2 - b * x^4

    % find the roots
    dUdt = diff(U, x)
    roots = solve(dUdt)

    % plug in the values
    vars = {a b};
    vals = {8 1};
    subs(roots, vars, vals)

    % check the stability of each 
    dUdt2 = diff(U, x, 2)
    subs(dUdt2, x, roots)
end

function res = section_15_2()
% page 364 of Wolfson and Pasachoff
    syms A t real
    syms k m omega positive

    % derive the frequency of simple harmonic motion
    xoft = A * cos(omega*t);
    dxdt2 = diff(xoft, t, 2);
   
    E = m * dxdt2 + k * xoft;
    [omega] = solve(E, omega);
    simplify(omega)
end

function res = section_15_6()
% page 380 of Wolfson and Pasachoff
    syms A t phi real
    syms k m b omega positive

    % derive the frequency of damped harmonic motion
    xoft = A * exp(-b * t / 2 / m) * cos(omega*t + phi);
    dxdt = diff(xoft, t);
    dxdt2 = diff(xoft, t, 2);
   
    E = m * dxdt2 + b * dxdt + k * xoft;
    [omega] = solve(E, omega);
    simplify(omega)
end

function res = section_15_7()
% page 382 of Wolfson and Pasachoff
    syms A t phi real
    syms k m b omega omegad F0 positive

    % try to derive the amplitude of driven oscillation
    xoft = A * cos(omegad*t);
    dxdt = diff(xoft, t);
    dxdt2 = diff(xoft, t, 2);
   
    E = m * dxdt2 + b * dxdt + k * xoft - F0 * cos(omegad * t);
    [A] = solve(E, A);

    % but it doesn't do much
    A = simplify(A)
    pretty(A)
end


function res = section_16_7()
% page 407 of Wolfson and Pasachoff
    syms A x t phi real
    syms k m b omega v positive

    % show that yoft is a solution of the wave equation
    yoft = A * cos(k*x - omega*t);
    dydx2 = diff(yoft, x, 2);
    dydt2 = diff(yoft, t, 2);
   
    E = dydx2 - dydt2 / v^2;
    [v] = solve(E, v);

    simplify(v)
end


function res = example_23_6()
% page 582 of Wolfson and Pasachoff
    syms x y q real
    syms a positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    % place the charges
    V1 = -a * ihat;
    V2 = a * ihat;

    % compute the field
    X = [x; y];
    E1 = efield(X, V1, -q);
    E2 = efield(X, V2, q);
    E = E1 + E2;

    % find the field along the y-axis
    E = subs(E, x, 0);
    simplify(E)

    % find the field at the origin
    E = subs(E, y, 0);
    simplify(E)
end

function res = example_23_7()
% page 584 of Wolfson and Pasachoff
    syms px py y dq dy Q real
    syms a l positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    % place the charges
    Y = y * jhat;

    % compute the field
    P = [px; py];
    E = efield(P, Y, dq);
    E = simplify(E)

    % ideally we should not have to plug in
    % px and py here, but if we postpone it,
    % we get a division by zero error
    E = subs(E, {px py}, {0 0})

    % integrate along the line
    % before integrating, we have to divide by dy because
    % int puts it back in implicitly
    E = subs(E, {dq}, {Q*dy/l})
    F = int(E/dy, y, a, a+l);    
    F = simplify(F)

    % but we can do the general version for px != 0
    F = subs(F, {px py}, {1 1})
    F = simplify(F)

end

function res = example_23_9()
% page 586 of Wolfson and Pasachoff
    syms px py x y dq dx lambda real
    syms a l positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    % place the charge
    X = x * ihat;

    % compute the field
    P = [px; py];
    E = efield(P, X, dq);
    E = simplify(E)

    % integrate along the line
    E = subs(E, {dq}, {lambda * dx});
    F = int(E/dx, x, -inf, inf);    
    F = simplify(F)

    % notice that px drops out of the solution, so
    % there is no need to substitute in
end

function res = efield(X, Y, q)
    % find the electric field at X due to a charge q at Y
    syms k positive
    
    R = X - Y;
    r = mynorm(R);
    Rhat = R / r;
    E = k * q / r^2 * Rhat;
    res = E;
end


function [x y] = projectile()
% page 312 of Gilat, MATLAB: An Introduction with Applications
    syms V X ang real
    syms v0 g t positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    X0 = [0; 0];
    V0 = pol2vec(ang, v0);
    A = -g * jhat;
    V = V0 + int(A, t);
    X = X0 + int(V, t);

    Y = [2600; 350];
    E = X-Y;
    [angles ts] = solve(E(1), E(2), ang, t);
    angles = subs(angles, {v0 g}, {210 9.8});

    for i = 1:length(angles)
        a = angles(i)
	t = ts(i)
        if a < 0
	    continue
	end
	P = subs(X, {ang v0 g}, {a 210 9.8})
	x = P(1)
	y = P(2)
	%ezplot(x, y, [0, t])
	%hold on
    end
end

function res = circuit()
% example from Oscar Mur-Miranda
    syms L R1 R2 C positive
    syms s

    z1 = L * s;
    z2 = R2;
    z3 = R1;
    z4 = 1 / (C*s);
    
    H = z4 / (z4 + z2) * parallel(z3, z2+z4) / (z1 + parallel(z3, z2+z4))
    H = simplify(H)
    [N D] = numden(H)
    collect(D)
    poles = solve(D)

    poles = subs(poles, R2, R1)
    simplify(poles)

    
end

function res = parallel(a, b)
    res = 1 / (1/a + 1/b)
end

function res = beam()
% page 315 of Gilat, MATLAB: An Introduction with Applications
    syms b h R positive

    E = mynorm([b/2 h/2]) - R
    b = solve(E, b)
    b = b(1)

    I = b * h^3 / 12
    dIdb = diff(I, h)
    solve(dIdb, h)
end

function res = tank()
% page 316 of Gilat
    syms w y L h R positive

    E = mynorm([w/2 R-y]) - R
    w = solve(E, w)
    w = w(1)

    S = L*w
    V = int(S,y,0,h)

    % if we don't plug in some numbers at this point, the solver fails!
    V = subs(V, {R L}, {3 8})

    Vscale = [40:40:200]
    for i=1:length(Vscale)
        E = V-Vscale(i);
	hans(i) = solve(E, h);
    end
    hans
end


function res = skateboard()
    syms m g I height positive
    syms t tr tth r theta v positive

    ath = g * cos(theta)
    ar = g * sin(theta)

    E = r - ar * tr^2 / 2
    tr = solve(E, tr)

    F = theta - r * m * ath / I / 2 * tth^2
    tth = solve(F, tth)

    G = tr(1) - tth(1)
    r = solve(G, r)
    r = r(1)

    h = height + r * sin(theta)
    H = m * v^2 /2 - m * g * h
    v = solve(H, v)
    v = v(1)

    ramp_height = 2.5;
    ramp_dist = 10;  
    th = atan2(ramp_height, ramp_dist);
    
    v = subs(v, {m g I height theta}, {75 9.8 1000 ramp_height th})
end
    

% Utility functions below this line

function res = pol2vec(theta, r)
% convert (r, theta) to a vector with cartesian components
    [x y] = pol2cart(theta, r);
    R = [x; y];
    res = R;
end

function res = degr2vec(degrees, r)
% convert (r, degrees) to a vector with cartesian components
    res = pol2vec(degrees*pi/180.0, r);
end

function res = mynorm(V)
    res = (V(1)^2 + V(2)^2) ^ (1/2);
end

function res = cross2(V, W)
   % compute the cross product of two vectors with length 2
   % assume that the third element is zero and return a 3-vector
   % (of which only the third element is non-zero)
   res = cross([V;0], [W;0]);
end


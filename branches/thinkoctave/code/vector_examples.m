function res = sym_examples(func) 
    f = str2func(func);
    f();
end

function res = example_3_1()
% Example 3-1 on page 51 of Wolfson and Pasachoff
    r = 160;        % km
    degrees = 35;   % degrees
    R = degr2vec(r, degrees)
end
   
function res = example_3_2()
% Example 3-2 on page 52 of Wolfson and Pasachoff
    R1 = degr2vec(2, 30);
    R2 = degr2vec(1, 0);
    R = R1 + R2;
    [r degrees] = vec2pol(R)
end
    
function res = example_3_4()
% Example 3-4 on page 55 of Wolfson and Pasachoff
    ihat = [1; 0];
    jhat = [0; 1];

    V1 = 15 * ihat;              % km/s
    V2 = degr2vec(19, 28);	 % km/s
    dt = 10;                     % min
    dt = dt * 60;		 % now seconds
    A = (V2 - V1) / dt;		 % km / s^2
    A = A * 1000		 % now m / s^2
end

function res = example_3_5()
% Example 3-5 on page 56 of Wolfson and Pasachoff
    syms t b c f g real
    
    ihat = [1; 0];
    jhat = [0; 1];
    R = (b*t^3 + c*t) * ihat + (f*t^2 + g) * jhat
    V = diff(R, t)
    A = diff(V, t)
end

function res = example_3_6()
% Example 3-6 on page 58 of Wolfson and Pasachoff
    syms v_air positive
    syms theta real 

    v_land = 960.0;           % km / hour
    v_wind = 190.0;           % km / hour

    vprime = degr2vec(v_land, theta);
    V = degr2vec(v_wind, 0);
    v = degr2vec(v_air, 90);

    E = vprime + V - v;
    [val1 val2] = mysolve(E, v_air, theta);
    double(val1(1))
    double(val2(1))
    
end

function res = section_4_4()
    syms r v a omega t
    
    R = pol2vec(r, omega*t)
    V = diff(R, t)
    A = diff(V, t)

    E1 = v - mynorm(V)
    E2 = a - mynorm(A)

    % warning: the results from solve come back in alphabetical order
    [a omega] = solve(E1, E2, omega, a);
    a = simplify(a(1))
end


function res = section_9_3()
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




function res = example_6_2()
    syms g m n a theta
    ihat = [1; 0];
    jhat = [0; 1];
    Ag = -g * jhat;
    Fg = m * Ag;
    N = pol2vec(n, pi/2-theta);
    A = pol2vec(a, -theta);
    E = N + Fg - m * A;
    [val1 val2] = mysolve(E, n, a);
    simplify(val1)
    simplify(val2)
end


function res = example_6_3()
    syms g m t theta
    ihat = [1; 0];
    jhat = [0; 1];
    Fg = -g * m * jhat;
    T1 = pol2vec(t, theta);
    T2 = pol2vec(t, pi-theta);
    E = Fg + T1 + T2;

    % the first equation is 0, so we only have to
    % solve the second
    val = solve(E(2), t);
    simplify(val)
end


function res = example_6_5()
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
    syms g m n t theta muk
    ihat = [1; 0];
    jhat = [0; 1];

    N = n * jhat;
    Fg = -g * m * jhat;
    T = pol2vec(t, theta);
    Fk = - muk * n * ihat;
    E = N + Fg + T + Fk;
    simplify(E);
    
    [n t] = solve(E(1), E(2), n, t);
    t = simplify(t)

end


function res = example_7_6()
    syms f theta r w
    ihat = [1; 0];
    jhat = [0; 1];

    F = pol2vec(f, theta);
    R = r * ihat;
    E = w - dot(F, R);
    theta = solve(E, theta);
    
    vars = {f r w};
    vals = {830e3 0.38e3 290e6};
    theta = subs(theta, vars, vals);

    % display in degrees
    theta * 180 / pi
end


function res = example_7_7()
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


function res = example_11_6()
    syms v1 v1f v2f m1 m2 m positive
    syms th1 th2 real

    % write equations to conserve momentum and energy
    ihat = [1;0];
    V1 = v1 * ihat;
    V1f = pol2vec(v1f, th1);
    V2f = pol2vec(v2f, th2);
    E = m1 * V1 - m1 * V1f - m2 * V2f;
    F = m1 * v1^2 - m1 * v1f^2 - m2 * v2f^2;

    % solve (and pick the third solution :)
    [th1 v1f v2f] = solve(E(1), E(2), F, th1, v1f, v2f)
    th1 = simplify(th1(3))

    % now set the masses equal and plug in th2
    th1 = subs(th1, {m1 m2}, {1 1})
    th1 = simplify(th1)
    th1 = subs(th1, th2, -30*pi/180)
end

function res = example_12_11()
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
    ihat = [1; 0; 0];
    jhat = [0; 1; 0];
    khat = [0; 0; 1];

    F = 3^(1/2) * ihat + jhat;
    r = 3 * ihat;
    tau = cross(r, F)
end

function res = example_13_2()
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
    T = degr2vec(t, theta2);

    % and the moment arms
    R1 = degr2vec(L/2, theta1);
    R2 = degr2vec(L, theta1);

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
    % example from page 312 of Gilat,
    % MATLAB: An Introduction with Applications
    syms V X ang real
    syms v0 g t positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    X0 = [0; 0];
    V0 = pol2vec(v0, ang);
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
    
    H = z4 / (z4 + z2) * parallel(z3, z2+z4) / parallel(z3, z2+z4)
    H = simplify(H)
    [N D] = numden(H)
    solve(D)
end

function res = parallel(a, b)
    res = 1 / (1/a + 1/b)
end

function res = beam()
    syms b h R positive

    E = mynorm([b/2 h/2]) - R
    b = solve(E, b)
    b = b(1)

    I = b * h^3 / 12
    dIdb = diff(I, h)
    solve(dIdb, h)
end

function res = tank()
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

function res = cross2(V, W)
   % compute the cross product of two vectors with length 2
   % assume that the third element is zero and return a 3-vector
   % (of which only the third element is non-zero)
   res = cross([V;0], [W;0]);
end

function res = pol2vec(r, theta)
    res = r * [cos(theta); sin(theta)];
end

function res = degr2vec(r, degrees)
    [x y] = pol2cart(degrees*pi/180.0, r);
    R = [x; y];
    res = R;
end

function [r degrees] = vec2pol(R)
    [theta r] = cart2pol(R(1), R(2));
    degrees = theta * 180.0 / pi;
end

function [val1 val2] = mysolve(E, var1, var2)
    % E is a vector of two symbolic expressions;
    % var1 and var2 are the symbols we want to solve for.
    % returns values for var1 and var2.

    % solve the first expression for var1
    F = solve(E(1), var1);

    % substitute into the second expression
    G = subs(E(2), var1, F);

    % solve for var2 (keep only the first solution)
    val2 = solve(G, var2);
    val2 = val2(1);            

    % now back-substitute into the first expression
    H = subs(E(1), var2, val2);

    % and solve for var1
    val1 = solve(H, var1);
    val1 = val1(1);
end

function res = mysubs(E, var, F)
    for i=1:length(E)
        G(i) = subs(E(i), var, F(i));
    end
    res = G;
end

function res = mynorm(V)
    res = (V(1)^2 + V(2)^2) ^ (1/2);
end

function res = pendulum()

    % declare the symbols
    syms g m1 l1
    syms x1 y1 t
    syms V T L
    syms th1 om1 aa1
 
    X = pol2vec(l1, th1-pi/2);
    V = mydiff(X, t);
    vsq = dot(V, V);
    
    V = m1 * g * X(2);
    T = m1 * vsq / 2;
    L = T - V
    
    % take derivatives 
    dLdom1 = diff(L, om1);
    ddt1 = mydiff(dLdom1, 1);
    dLdth1 = diff(L, th1);

    % find and solve the Euler-Lagrange equation
    EL1 = simplify(ddt1 - dLdth1)
    solve(EL1, aa1)    
end

function res = pol2vec(r, theta)
    res = r * [cos(theta); sin(theta)];
end

function res = mydiff(f, n)
    % take the nth time derivative of f, with the understanding
    % that th1 and om1 are functions of time

    syms dot1 t
    syms th1 om1

    % replace th1 and om1 with exponential functions of time
    th1ft = exp(dot1*t);
    om1ft = diff(th1ft, t);
    aa1ft = diff(th1ft, t, 2);
    temp = subs(f, {om1, th1}, {om1ft, th1ft});

    % take the time derivative
    temp = diff(temp, t, n);

    % replace the exponentials with the corresponding symbols
    temp = subs(temp, {aa1ft, om1ft, th1ft}, {'aa1', 'om1', 'th1'});

    res = temp;
end

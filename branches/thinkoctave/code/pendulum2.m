function res = pendulum()

    % declare the symbols
    syms g m1 l1 positive
    syms x1 y1 t real
    syms X V T L real
    syms th1 om1 aa1 real

    th1ft = sym('th1(t)');
    om1ft = sym('om1(t)');
    
    X = pol2vec(l1, th1ft-pi/2);
    V = diff(X, t);
    vsq = dot(V, V);
    
    V = m1 * g * X(2);
    T = m1 * vsq / 2;
    L = T - V
    
    % take derivatives 
    L1 = subs(L, {diff(th1ft,t)}, {om1}); 
    dLdom1 = diff(L1, om1)

    dLdom1 = subs(dLdom1, om1, om1ft)
    ddt1 = diff(dLdom1, t)

    L2 = subs(L, {th1ft diff(th1ft,t)}, {th1 om1}) 
    dLdth1 = diff(L2, th1)

    % find and solve the Euler-Lagrange equation
    EL1 = simplify(ddt1 - dLdth1)
    EL1 = subs(EL1, {th1ft}, {th1}) 
    EL1 = subs(EL1, {diff(th1,t)}, {om1}) 
    EL1 = subs(EL1, {diff(om1,t)}, {aa1}) 
    solve(EL1, aa1)
    
end

function res = pol2vec(r, theta)
    res = r * [cos(theta); sin(theta)];
end

function res = mynorm(V)
    res = (V(1)^2 + V(2)^2) ^ (1/2);
end
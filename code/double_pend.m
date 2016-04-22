function res = double_pendulum()
    syms x1 y1 x2 y2 t real
    syms g m1 m2 l1 l2 real
    syms V T L real
    syms th1 th2 om1 om2 aa1 aa2 real
    
    x1 = l1 * sin(th1);
    y1 = -l1 * cos(th1);
    x2 = x1 + l2 * sin(th2);
    y2 = y1 - l2 * cos(th2);

    vx1 = mydiff(x1, 1)
    vy1 = mydiff(y1, 1)
    vx2 = mydiff(x2, 1)
    vy2 = mydiff(y2, 1)

    v1sq = vx1^2 + vy1^2;
    v2sq = vx2^2 + vy2^2;
    
    V = m1 * g * y1 + m2 * g * y2;
    T = m1 * v1sq / 2 + m2 * v2sq / 2; 
    L = T - V;
    pretty(simplify(L))

    dLdom1 = diff(L, om1);
    ddt1 = mydiff(dLdom1, 1);
    dLdth1 = diff(L, th1);
    EL1 = simplify(ddt1 - dLdth1)
    solve(EL1, aa1)
    
    dLdom2 = diff(L, om2);
    ddt2 = mydiff(dLdom2, 1);
    dLdth2 = diff(L, th2);
    EL2 = simplify(ddt2 - dLdth2)
    solve(EL2, aa2)

    res = L
end



function res = mydiff(f, n)
    syms dot1 dot2 t real
    syms th1 th2 om1 om2 aa1 aa2 real
    
    th1ft = exp(dot1*t);
    om1ft = diff(th1ft, t);
    aa1ft = diff(th1ft, t, 2);

    th2ft = exp(dot2*t);
    om2ft = diff(th2ft, t);
    aa2ft = diff(th2ft, t, 2);

    FT = {aa1ft, om1ft, th1ft, aa2ft, om2ft, th2ft};
    SYM = {aa1, om1, th1, aa2, om2, th2};
    STR = {'aa1', 'om1', 'th1', 'aa2', 'om2', 'th2'};
    
    temp = subs(f, SYM, FT); 
    temp = diff(temp, t, n);
    temp = subs(temp, FT, STR);

    res = temp;
end

function res = pol2vec(r, theta)
    res = r * [cos(theta); sin(theta)];
end

function res = mynorm(V)
    res = (V(1)^2 + V(2)^2) ^ (1/2);
end

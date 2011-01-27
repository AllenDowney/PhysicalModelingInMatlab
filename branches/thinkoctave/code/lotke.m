function dVdt = lotke(t, V)
    R = V(1);
    F = V(2);

    a = 0.04;
    b = 0.005;
    c = 0.2;
    e = 0.1;
    
    dRdt = a*R - b*R*F;
    dFdt = e*b*R*F - c*F;
    
    dVdt = [dRdt; dFdt];
end

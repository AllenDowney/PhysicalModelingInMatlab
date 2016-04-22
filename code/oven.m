function dxdt = oven(t, x)
    T = 293.15; 
    g = 50; 
    d = 2e-7; 
    el = 800; 
    u=21;
    dxdt = g * (T - x) + d * (T^4 - x^4) + el * u^2;
end

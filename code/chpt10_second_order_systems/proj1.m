function res = proj(t, W)
    R = W(1:2);
    V = W(3:4);

    dRdt = V;
    dVdt = acceleration(t, R, V);

    res = [dRdt; dVdt];
end

function res = acceleration(t, R, V)
    g = -9.8;             % acceleration of gravity in m/s^2
    res = [0; g];
end

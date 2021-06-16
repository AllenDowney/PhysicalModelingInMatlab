% Rate function for a projectile with no drag.

function dWdt = proj(t, W)
    R = W(1:2);
    V = W(3:4);

    dRdt = V;
    dVdt = acceleration(t, R, V);

    dWdt = [dRdt; dVdt];
end

function dVdt = acceleration(t, R, V)
    g = -9.8;             % acceleration of gravity in m/s^2
    dVdt = [0; g];
end

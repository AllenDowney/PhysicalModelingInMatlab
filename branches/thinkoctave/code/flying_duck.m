function [t, h] = duck(v0)
    exact = 2 * 10 / 9.8
    dts = [0.0001 0.001 0.01 0.1];
    for i = 1:length(dts)
        [T, V, H] = euler(v0, dts(i));
        h(i) = max(H);
        t(i) = (T(end) - exact) / exact
    end
    loglog(dts, t)
end

function [T, V, H] = euler(v0, dt)
    T(1) = 0;
    H(1) = 0;
    V(1) = 10;
    
    i = 2;
    while 1
        T(i) = T(i-1) + dt;
        V(i) = V(i-1) + acceleration() * dt;
        H(i) = H(i-1) + V(i-1) * dt;
        if H(i) < 0
            break
        end
        i = i + 1;
    end
end

function res = acceleration()
    res = -9.8;
    r = 10;
end

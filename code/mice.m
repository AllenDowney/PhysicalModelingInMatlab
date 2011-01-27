function res = mice(t, n)
    a = 0.9;
    b = interpolate_b(t);
    res = a * n - b * n^1.7;
end

function res = interpolate_b(t)
    T = 0:8;
    B = [70 36 11 1 4 13 28 43 56] * 1e-4;
    res = interp1(T, B, t);
end
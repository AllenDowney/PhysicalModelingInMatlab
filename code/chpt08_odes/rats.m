function res = rats(t, y)
    a = 0.02;
    omega = 2 * 2*pi / 365;
    res = a * y * (1 - cos(omega * t)) / 2;
end
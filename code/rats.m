function res = rats(t, y)
    a = 0.01;
    omega = 2 * pi / 365;
    res = a * y * (0.5 + sin(omega * t));
end

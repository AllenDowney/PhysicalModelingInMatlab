function res = rats_bad(t, y)
    a = 0.02;
    omega = 2 * 2*pi / 365;
    r = a * y * (1 - cos(omega * t)) / 2;    % WRONG
end
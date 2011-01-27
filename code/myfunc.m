% res = myfunc (x)
% compute the Manhattan distance from the origin to the
% point on the unit circle with angle (x) in radians.

function res = something_else (x)
    s = sin(x);
    c = cos(x);
    res = abs(s) + abs(c);
end
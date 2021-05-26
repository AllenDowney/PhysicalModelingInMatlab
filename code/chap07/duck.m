function res = duck()
    error = error_func(2)
    ezplot(@error_func, [0, 20])
    res = fzero(@error_func, 2);
end

function res = error_func(d)
    rho = 0.3;      % density in g / cm^3
    r = 10;         % radius in cm
    mass_duck = 4/3 * pi * r.^2 * rho;;
    mass_water = pi / 3  * (3*r*d.^2 - d.^3);
    res = mass_water - mass_duck;
end
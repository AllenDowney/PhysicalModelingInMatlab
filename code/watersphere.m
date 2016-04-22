function res = watersphere( volume )
    r = 6.1;                           % meters
    height_at_bottom = 65 - 2*r;       % meters
    
    height = fzero(@error_func, [0, 2*r]);
    res = height_at_bottom + height;
    
    %ezplot(@error_func, [0, 2*r])

    function res = error_func(h)
        res = pi * h^2 * (3*r - h) / 3 - volume;
    end

end


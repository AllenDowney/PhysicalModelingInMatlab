% Demonstrate fzero and fminsearch.

function optimization()
    x = fzero(@error_func, 1)

    x = fminsearch(@error_func, 1)

    [x, fval] = fminsearch(@error_func, 1)

end

function res = error_func(x)
    res = x^2 - 2;
end

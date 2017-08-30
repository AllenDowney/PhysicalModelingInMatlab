function res = finitewell( u0, start )
% Finds a root of the finite well equation for given u0,
% with start as an initial guess.

    res = fzero(@error_func, start);

    function res = error_func(v)
    % This inner function is passed to fzero.
    % It uses elementwise operators (.* and .^), so it works
    % for both scalars and vectors.
        res = sqrt(u0^2 - v.^2) - v .* tan(v);
    end

end


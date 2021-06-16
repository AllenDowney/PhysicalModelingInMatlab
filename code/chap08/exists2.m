% Use find to check where any elements of an array are positive.

function res = exists(X)
    L = find(X>0)
    res = length(L) > 0
end

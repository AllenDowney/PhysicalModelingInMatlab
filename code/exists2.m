function res = exists(X)
    L = find(X>0)
    res = length(L) > 0
end

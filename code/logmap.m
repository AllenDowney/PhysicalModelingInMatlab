function M = logmap(r, x1)
    X(1) = x1;

    for i=1:19
        X(i+1) = r * X(i) * (1 - X(i));
    end
    
    M = X;
end

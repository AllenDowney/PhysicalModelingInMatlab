function res = fibonacci_seq (n)
    F(1) = 1;
    F(2) = 1;
    for i=3:n
        F(i) = F(i-1) + F(i-2);
    end
    res = F;
end


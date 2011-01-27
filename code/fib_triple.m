function res = fib_triple (n)
    F = fibonacci_seq(n+3);
    for i = 1:n
        a = F(i) * F(i+3);
        b = 2 * F(i+1) * F(i+2);
        c = F(i+1)^2 + F(i+2)^2;
        res(i) = istriple(a, b, c);
        %disp([i, res(1)]);
    end
end


    



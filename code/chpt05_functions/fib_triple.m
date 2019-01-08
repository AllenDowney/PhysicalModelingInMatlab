% Find Pythagorean triples using the first `n` Fibonacci numbers.

function res = fib_triple (n)
    F(1) = 1;
    F(2) = 1;
    for i = 3:n
        F(i) = F(i-1) + F(i-2);
    end
        
    for i = 1:n-3
        a = F(i) * F(i+3);
        b = 2 * F(i+1) * F(i+2);
        c = F(i+1)^2 + F(i+2)^2;
        if hypotenuse(a, b) ~= c
            [a b c]
        end
    end
end
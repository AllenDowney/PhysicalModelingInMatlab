% Find Pythagorean triples up to `n`.

function res = find_triples (n)
    for a=1:n-1
        for b=a:n
            if gcd(a,b) > 1
                continue
            end
            c = hypotenuse(a, b);
            if a^2 + b^2 == c^2
                [a, b, c]
            end
        end
    end
end

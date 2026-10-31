% Find Pythagorean triples up to `n`.

function res = find_triples(n)
    for a=1:n
        for b=a:n
            for c=b:a+b
                if gcd(a,b) > 1
                    continue
                end
                if is_pythagorean(a, b, c)
                    disp([a,b,c])
                end
            end
        end
    end
end

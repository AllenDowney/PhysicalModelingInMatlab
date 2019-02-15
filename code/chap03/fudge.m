% Compute the sum of `n` elements of a geometric sequence

a = 1;
total = a;
r = 1/4;

for i=2:n
    a = a * r;
    total = total + a;
end
ans = total
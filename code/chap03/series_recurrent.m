% Compute the sum of `n` elements of a geometric sequence, recurrently
% (exercise solution; series.m computes the elements directly)

a = 1;
total = a;

for i=2:n
    a = a/2;
    total = total + a;
end
ans = total
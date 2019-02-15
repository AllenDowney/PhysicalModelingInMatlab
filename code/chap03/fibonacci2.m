% Computes the nth Fibonacci number.  
% Precondition: n must be a positive integer.
% Postcondition: the result is stored in ans.

prev1 = 1;
prev2 = 1;
f = 1;

for i=3:n
    f = prev1 + prev2;
    prev2 = prev1;
    prev1 = f;
end
ans = f

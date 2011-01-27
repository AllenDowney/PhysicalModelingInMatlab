% computes a the nth Fibonacci
% number.  Precondition: you must assign a value to n before
% running this script.  Postcondition: the result is stored
% in ans.

prev1 = 1;
prev2 = 1;
for i=3:n
    f = prev1 + prev2;
    prev2 = prev1;
    prev1 = f;
end
ans = f

% computes a numerical approximation of the nth Fibonacci
% number.  Precondition: you must assign a value to n before
% running this script.  Postcondition: the result is stored
% in ans.

s5 = sqrt(5);
t1 = (1 + s5) / 2;
t2 = (1 - s5) / 2;
diff = t1^n - t2^n;
ans = diff / s5

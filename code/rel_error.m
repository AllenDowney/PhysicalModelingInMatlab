% compute the relative error of the estimated value of Fn;
% precondition: n is in the workspace
% postcondition: the answer is stored in ans
fibonacci1;
estimate = ans;
fibonacci2;
exact = ans;
ans = (estimate - exact) / exact;

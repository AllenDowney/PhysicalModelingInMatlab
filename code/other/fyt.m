function e = solvand (i)
% if I am trying to reach a balance of a, how much will I be off by?
a = 300000;
e = balance(i) - a;
end

function b = balance (i)
% given interest rate i, monthly payment p, how much money
% will I have after n months?
p = 200;
n = 300;
b = p/i * ((i+1)^n - 1);
end

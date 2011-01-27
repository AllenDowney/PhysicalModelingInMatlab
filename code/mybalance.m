function a = mybalance (i, p, n)
% given interest rate i, monthly payment p, how much money
% will I have after n months?
a = p/i * ((i+1)^n - 1);
end

function logistic_table
lambda = [2 3.2 3.83 3.9];
N = length(lambda);
x(1,1:N) = 0.25;
for t = 1:40
x(t+1,1:N) = lambda(1:N).*x(t,1:N).*(1-x(t,1:N));
endfor
latex(x,'%.4f','nomath')
endfunction

function dXdt = f(t, X)
% this function take a vector with 4 components, [x, y, x', y']
% and returns a column vector with components [x', y', x'', y'']
% it uses the function acceleration to compute x'' and y''.
V = X(3:4);

A = acceleration(V)
                          
dXdt = [vx; vy; A];   
end

function A = acceleration(V)
% this function takes a vector with components [x', y']
% and returns a vector with [x'', y'']
A = blah, blah...
end


function [ av ] = rand_av (Phi)
% generate a random angle-vector quaternion with the
% given theta and a random normalized vector.

% choose a random normalized vector w
n = 0;
while n==0;
    w = randn(3,1);
    n = norm(w);
end
w = w/n;

av = [ Phi ; w  ];


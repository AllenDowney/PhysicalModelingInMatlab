% Calculates the first n terms of geometric sequence A_i+1 = A_i/2
% where A_1 = 1
   % Precondition: n must be defined

A(1) = 1;

if n > 1
   for i=2:n
	   A(i) = A(i-1)/2;
   end
end

ans = A(n)

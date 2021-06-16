n = 35;
A(1) = 150;
B(1) = 150;

for i=1:n-1
   fromA = round(0.03 * A(i));
   fromB = round(0.05 * B(i));
   A(i+1) = A(i) - fromA + fromB;
   B(i+1) = B(i) - fromB + fromA;
end

hold on
plot(A, 'ro-')
plot(B, 'bx-')

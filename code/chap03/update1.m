clf
hold on

a = 300
b = 100

for i=1:100
   froma = round(0.03 * a);
   fromb = round(0.05 * b);
   a = a - froma + fromb;
   b = b - fromb + froma;
   % fprintf('%f\t%f\n', a, b)
   plot(i, a, 'bx')
   plot(i, b, 'ro')
end


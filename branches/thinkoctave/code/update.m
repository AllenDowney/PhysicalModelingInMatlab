
for i=1:10
   froma = round(0.03 * a);
   fromb = round(0.05 * b);
   a = a - froma + fromb;
   b = b - fromb + froma;
   fprintf('%f\t%f\n', a, b)
end

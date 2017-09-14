function x = iterate(tol)
   x0 = 4;
   while true
       x1 = g(x0);
       if abs(x0-x1) < tol
           break
       end
       x0 = x1;
   end
   x = x1;
end

function y = g(x)
   y = sqrt(2*x + 3);
end
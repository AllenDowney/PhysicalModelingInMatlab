X = [1, 2, 5, 4.4, -pi, 3, exp(1), 0];

index = -1;
for i=1:length(X)
   if X(i) < 0
	index = i;
        break;
   end
end

ans = index

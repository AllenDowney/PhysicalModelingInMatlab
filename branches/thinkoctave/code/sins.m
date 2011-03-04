X = linspace(0, 2*pi, 100);

for i=1:length(X)
	Y(i) = sin(X(i));
end

plot(X,Y);

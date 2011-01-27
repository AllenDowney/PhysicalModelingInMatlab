function plot_cheby6(low, high)
    X = linspace(low, high, 100);
    for i=1:length(X)
        Y(i) = cheby6(X(i));
    end
    plot(X, Y)
end

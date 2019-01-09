function res = euler()
    T(1) = 0;
    Y(1) = 5;
    dt = 0.1;
    
    for i=1:40
        r = rate_func(T(i), Y(i));
        T(i+1) = T(i) + dt;
        Y(i+1) = Y(i) + r * dt;
    end
    plot(T, Y)
    xlabel('Time (hours)')
    ylabel('Population (billions of cells)')
    saveas(gcf, '../../book/figs/euler.eps', 'epsc')
end

function res = rate_func(t, y)
   a = 0.2;
   res = a * y;
end
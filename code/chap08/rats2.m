function rats2
%RATS2 Summary of this function goes here
%   Detailed explanation goes here

    clf; hold on
    xlabel('t (days)')
    ylabel('y (rat population)')
    [T, Y] = ode45(@rats_point, [0,365], 2000);
    for i=1:length(T)
        plot_point(T(i), Y(i), NaN)
    end
    hold off
    print -deps 'ode45bw.eps'
end

function res = rats_point(t, y)
    res = rats(t, y);
    plot_point(t, y, res)
end

function plot_point(t, y, r)
    if t<280 || t>365
        return
    end
    dt = 1;
    ts = [t-dt, t+dt];
    ys = [y-r*dt, y+r*dt];
    if isnan(r)
        plot(t, y, 'bo')
    else
        plot(ts, ys, 'r-')
        %plot(t, y, 'r.')
        plot(t, y, 'r.', 'MarkerSize', 10)
    end
end


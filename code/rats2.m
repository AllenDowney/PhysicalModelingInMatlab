function rats2
    clf; hold on
    xlabel('t (days)')
    ylabel('y (rat population)')
    [T, Y] = ode45(@rats, [0,365], 2);
    for i=1:length(T)
        plot_point(T(i), Y(i), NaN)
    end
    hold off
    print -deps 'matlab/ode45.eps'
end

function res = rats(t, y)
    a = 0.01;
    omega = 2 * pi / 365;
    res = a * y * (1 + sin(omega * t));
    plot_point(t, y, res)
end

function plot_point(t, y, r)
    if t<100 || t>170
        return
    end
    dt = 1;
    ts = [t-dt, t+dt];
    ys = [y-r*dt, y+r*dt];
    if isnan(r)
        plot(t, y, 'rs')
    else
        plot(ts, ys, 'b-')
        plot(t, y, 'bo')
    end
end
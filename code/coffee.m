function res = coffee()
    %t = fzero(@temp_func1, 480)
    %t = fzero(@temp_func2, 480)
    
    temp_func1(440)
    temp_func2(440)
end

function res = temp_func1(t)
    % mix first, then run for t seconds and report the final temp.
    y_final = mix_func(90, 8, 20, 1)
    diff = 90 - y_final
    [T, Y] = ode45(@slope_func, [0,t], y_final);
    diff = Y(end) - y_final
    res = Y(end) - 60;
end

function res = temp_func2(t)
    % run for t seconds, then mix and report final temp.
    [T, Y] = ode45(@slope_func, [0,t], 90);
    diff = Y(end) - 90
    y = Y(end)
    y_final = mix_func(y, 8, 20, 1);
    diff = y_final - y
    res = y_final - 60;
end

function res = slope_func(t,y)
    r = 0.001;
    e = 20;
    res = -r * (y - e);
end

function res = mix_func(y1, v1, y2, v2)
    res = (v1*y1 + v2*y2) / (v1+v2);
end


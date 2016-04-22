function moody()
    [T, Y] = ode45(@test_func, [0,1.5], 1);
    plot(T, Y)
end

function res = test_func(t, y)
    res = y ^ 2;
end

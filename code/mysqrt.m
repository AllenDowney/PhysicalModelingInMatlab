function root = mysqrt(a)
    est = a;

    for i=1:8
        est = est - f(est, a) / fp(est);
    end
    root = est;
end

function y = f(x, b)
    y = x^2 - b;
end

function y = fp(x)
    y = 2*x;
end

function root = mysqrt(a)

    function y = f(x)
        y = x^2 - a;
    end

    function y = fp(x)
        y = 2*x;
    end 

    est = a;

    for i=1:5
        est = est - f(est) / fp(est);
    end
    root = est;
end


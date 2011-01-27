function res = myfunc1(x)
    y = helper(x+1);
    res = y;
    
    function res = helper(x)
        res = x^2;
    end
end

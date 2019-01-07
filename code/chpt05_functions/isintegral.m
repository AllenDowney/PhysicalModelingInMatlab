function res = isintegral(x)
    if round(x) == x
        res = 1;       % or... res = true
    else
        res = 0;       % or... res = false
    end
end
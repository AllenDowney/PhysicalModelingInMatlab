function rel_err = testsqrt(V)
    for i=1:length(V)
        x = V(i);
        mine = mysqrt(x);
        theirs = sqrt(x);
        diff = mine-theirs;
        rel_err(i) = diff / theirs;
    end
end


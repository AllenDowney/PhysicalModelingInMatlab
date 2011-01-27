function res = lotka(t, V)
    % unpack the elements of V
    r = V(1);
    f = V(2);

    % set the parameters
    a = 0.1;
    b = 0.01;
    c = 0.1;
    e = 0.2;
    
    % compute the derivatives
    drdt = a*r - b*r*f;
    dfdt = e*b*r*f - c*f;
    
    % pack the derivatives into a vector
    res = [drdt; dfdt];
end

function res = lotka(t, V)
    % unpack the elements of V
    r = V(1);
    f = V(2);

    % set the parameters
    a = 0.1;
    b = 0.01;
    c = 0.1;
    d = 0.002;

    % compute the derivatives
    drdt = a*r - b*r*f;
    dfdt = -c*f + d*r*f;

    % pack the derivatives into a vector
    res = [drdt; dfdt];
end

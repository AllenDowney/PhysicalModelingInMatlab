function logchaos
    clf
    hold on
    
    % each time through the loop we try a different value of r
    for r=2.4:0.01:4.0
        
        % compute the first 50 values of the sequence
        V = logmap(r, 0.5, 50);
        
        % trim off the first 10 values
        V = trim(V, 10);
        
        % make another vector the same length, all equal to r
        R = make_vector(r, length(V));
        
        % plot a column of points showing all the values in V
        plot(R, V, 'b.')
    end
end


function M = logmap(r, x1, n)
% use the logistic map function to compute the
% first (n) values of the sequence, starting wih
% (x1) and using parameter (r)
    X(1) = x1;

    for i=1:n-1
        X(i+1) = r * X(i) * (1 - X(i));
    end
    
    M = X;
end

function W = trim(V, skip)
% make a new vector that has all but the first (skip)
% elements from (V)
    n = length(V);
    for i=1:n-skip
        W(i) = V(i+skip);
    end
end

function V = make_vector(value, len)
% make a new vector with (len) elements all equal to (value)
    for i=1:len
        V(i) = value;
    end
end
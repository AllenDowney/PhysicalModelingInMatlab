function angle=optimal_angle(velocity)
    as = linspace(0, 90);
    for i=1:length(as)
        distance(i) = baseball(velocity, as(i));
    end

    plot(as, distance);
    
    [max_dist, i] = max(distance);
    angle = as(i);
    return
    
    % OR
    
    max_dist = max(distance);
    i = find(distance==max_dist);
    angle = as(i);
    
    % OR
    
    for i=1:length(as)
        if distance(i) == max_dist
            angle = as(i);
            return
        end
    end
end


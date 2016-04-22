function res = ramp()

    % ramp_height is the height of the ramp in meters
    % ramp_dist is the horizontal distance from the tip of the
    % ramp to the post, so half_length is half the length of the ramp
    ramp_height = 1;
    ramp_dist = 4;  
    half_length = norm([ramp_height,ramp_dist]);   
    
    % compute the max and min angles
    th = atan2(ramp_height, ramp_dist);

    m = 75;        % mass of rider/board in kg
    g = 9.8;       % acceleration of gravity in m/s^2
    I = 100.0;       % moment of inertia of the ramp

    ath = g * cos(th);
    ar = g * sin(th);

    r2 = (I * th * ar) / (m * ath);
    r = sqrt(r2);
    
    x = r * cos(th);
    y = r * sin(th);
    disp([x,y]);

    h = ramp_height + y;
    v = sqrt(2 * g * h);
    res = v;
    
end

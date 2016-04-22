t_end = 24 * 3600;       % 24 hours in seconds
n = 4000;                % number of time steps
timestep = t_end / n;    % size of timestep in seconds

T(1) = 30;               % initial temperature in degC

for i = 1:n
    dTdt = copper_func(0, T(i));
    T(i+1) = T(i) + dTdt * timestep;
end

T(end)
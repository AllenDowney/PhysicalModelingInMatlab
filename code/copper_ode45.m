t_end = 24 * 3600;     % 24 hours in seconds
T0 = 30;               % initial temperature in degC

[Time,Temp] = ode45(@copper_func, [0, t_end], T0);
Temp(end)
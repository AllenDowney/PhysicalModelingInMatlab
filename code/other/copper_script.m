
m = 10;          % mass of the block in kg
T_block = 30;    % temperature of the block in degC
T_out = 0;       % temperature of the environment    degC

% find the size and area of the block
density = 8.94 * 0.001 / 0.01^3;   %  g/cm3 * (kg/g) / (m/cm)^3
volume = m / density;              %  m^3

length = volume^(1/3);             % m
area = 6 * length^2;               % m^2

% convert american r-value to SI r-value
r_value_english = 30;                   % dram fathoms per fortnight
r_value = r_value_english * 0.1761;     % K m^2 / W

% compute the rate of heat (energy) flow, dU/dt
deltaT = T_out - T_block;               % K (also degC)
dUdt = 1/r_value * area * deltaT;       % W (aka J/s)

% compute the rate of temperature change, dT/dt
c = 386;                      % specific heat of copper in J / (kg K)
dTdt = dUdt / m / c;          % K / s


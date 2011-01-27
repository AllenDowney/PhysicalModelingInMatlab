function res = rate_func(t, Q)
    m = 10;          % mass of the block in kg
    T_block = 30;    % temperature of the block in degC
    T_out = 0;       % temperature of the environment    degC

    density = 8.94 * 0.001 / 0.01^3;   %  g/cm3 * (kg/g) / (m/cm)^3
    volume = m / density;              %  m^3

    length = volume^(1/3);             % m
    area = 6 * length^2;               % m^2

    r_value = 30;
    resistivity = r_value * 0.1761;     % K m^2 / W

    deltaT = T_out - T_block;             % K (also degC)
    
    % compute the rate of change for internal energy, dUdt
    dUdt = 1/resistivity * area * deltaT;   % W (aka J/s)

    c = 386;         % specific heat of copper in J / (kg K)

    % compute the rate of change in temperature, dQdt
    dQdt = dUdt / m / c;      
    res = dQdt;
end
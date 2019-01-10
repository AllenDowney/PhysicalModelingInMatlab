% Simulate the Lotka-Volterra model and plot the results.

function res = lotka()
    % test the rate function
    t = 0;
    V_init = [80, 20];
    R = rate_func(t, V_init)
    
    % run the ODE solver
    tspan = [0, 200];
    [T, M] = ode45(@rate_func, tspan, V_init);
    
    % plot the time series
    clf; hold on
    R = M(:, 1);
    W = M(:, 2);
    plot(T, R, 'LineWidth', 2)
    plot(T, W, '--', 'LineWidth', 2)
    xlabel('Time (weeks)')
    ylabel('Polulation')
    legend('rabbits', 'weasels')
    saveas(gcf, '../../book/figs/lotka.eps', 'epsc')

    % plot the trajectory
    clf; hold on
    plot(R, W)
    xlabel('Rabbit population')
    ylabel('Weasel population')
    saveas(gcf, '../../book/figs/phase.eps', 'epsc')
end


function res = rate_func(t, V)
    % unpack the elements of V
    r = V(1);
    w = V(2);

    % set the parameters
    a = 0.1;
    b = 0.01;
    c = 0.1;
    d = 0.002;

    % compute the derivatives
    drdt = a*r - b*r*w;
    dfdt = -c*w + d*r*w;

    % pack the derivatives into a vector
    res = [drdt; dfdt];
end

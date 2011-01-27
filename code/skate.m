function [T,X] = skateboarder()
    I = 500;
    m = 70;
    g = 9.8;
    Pi = [0;pi/4];
    Vi = [4.1;0];
    [T,X]=ode45(@slope_func,[0 10],[Pi;Vi]);
    plot(T,X(:,2)), grid on

    function res = slope_func(t,W)
        P = W(1:2);
        V = W(3:4);
        dPdt = V;
        dVdt = acceleration_func(t,W);
        res = [dPdt;dVdt];
    end

    function res = acceleration_func(t,W)
        r = W(1);
        theta = W(2);
        rdot = W(3);
        thdot = W(4);
        rdotdot = -g*sin(theta) + r*thdot^2;
        thdotdot = (-m*g*r*cos(theta) - 2*m*r*rdot*thdot)/(m*r^2 + I);
        res = [rdotdot;thdotdot];
    end

end
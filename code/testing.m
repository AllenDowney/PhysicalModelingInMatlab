function [x y] = projectile()
    % example from page 312 of Gilat,
    % MATLAB: An Introduction with Applications
    syms V X ang real
    syms v0 g t positive
    
    ihat = [1; 0];
    jhat = [0; 1];

    X0 = [0; 0];
    V0 = pol2vec(v0, ang);
    A = -g * jhat;
    V = V0 + int(A, t);
    X = X0 + int(V, t);

    Y = [2600; 350];
    E = X-Y;
    [angles ts] = solve(E(1), E(2), ang, t);
    angles = subs(angles, {v0 g}, {210 9.8});

    for i = 1:length(angles)
        a = angles(i)
	t = ts(i)
        if a < 0
	    continue
	end
	P = subs(X, {ang v0 g}, {a 210 9.8})
	x = P(1)
	y = P(2)
	% due to a bizarre bug, the following line generates
	% ??? Attempt to reference field of non-structure array.
	%ezplot(x, y, [0, t])
	break
    end
end

function res = pol2vec(r, theta)
    res = r * [cos(theta); sin(theta)];
end


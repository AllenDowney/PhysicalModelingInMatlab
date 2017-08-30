function [ ] = tiax_sphere (noise, ang_error)

k = 3;
n = 2^k-1;
[x,y,z] = sphere(n);
[theta, phi, r] = cart2sph(x, y, z);
psi = 0.1;

for i=1:n
    for j=1:n
        ang = [phi(i,j) theta(i,j) psi]';
        [err, rms] = comp_err2 (ang, noise, ang_error);
        a(i,j) = rms;
    end
end

    for j=1:2

        subplot(3,2,(i-1)*2+j)
        h = surf(x,y,z,errs{i});
        if j==1
            % rotate the view 180 degrees around the z axis
            [az,el] = view;
            view (az+180, el);
        end
        xlabel('x')
        ylabel('y')
        zlabel('z')
    end
end


end


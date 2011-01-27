function [ ] = tiax_sphere (noise)

k = 5;
n = 2^k-1;
[x,y,z] = sphere(n);
[theta, phi, r] = cart2sph(x, y, z);
psi = 0.1;

for i=1:n
    for j=1:n
        ang = [phi(i,j) theta(i,j) psi]';
        rms = comp_err (ang, noise, @direct);
        a(i,j) = rms(1);
        b(i,j) = rms(2);
        c(i,j) = rms(3);
    end
end

errs{1} = a;
errs{2} = b;
errs{3} = c;

for i=1:3
    for j=1:2

        subplot(3,2,(i-1)*2+j)
        h = surf(x,y,z,errs{i});
        [az,el] = view;

        if j==1
            % rotate the view 180 degrees around the z axis
            view (az+180, el);
        end
        xlabel('x')
        ylabel('y')
        zlabel('z')
    end
end


end


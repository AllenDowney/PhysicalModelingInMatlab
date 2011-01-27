function [rms] = comp_err (ang, noise, ang_error)
   sum = zeros(size(ang));
   N=2;
   for i=1:N
        [ G, H ] = data_gen (ang, noise, ang_error);
        rot = ang_rot(ang)
        [ rot_out, quat, ang_out, av ] = tiax_Joel (G,H);
        rot_out = quat_rot(quat)
        
        % rot_err is the rotation that takes rot onto rot_out
        rot_err = rot_out * rot'
        
        % ang_err is the error rotation in terms of euler angles
        ang_err = rot_ang(rot_err)
        
        sum = sum + ang_err.^2
   end
   rms = sqrt(sum/N);
end


function [ M ] = squash (M)
low = M < -6;
M = M + low * 2*pi;
high = M > 6;
M = M - high * 2*pi;
end

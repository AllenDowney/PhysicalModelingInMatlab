function [rms] = comp_err (ang, noise, func)
% ang is the set of euler angles we are interested in.
% noise is the level of instrumentation error (0.01 seems to
% be an interesting value)
% func is a handle for a function that takes G, H and returns
% two values; the first is the recovered rotation
% matrix and the second is ignored.

% generate N sets of simulated data with random noise
% added, then invoke the given function to try to recover
% the rotation matrix.

% Compute the difference between the original (correct) rot
% and the recovered rot_out, in terms of euler angles.

% return the root-mean-squared error as a 3-vector with
% elements dphi, dtheta, dpsi.

   sum = zeros(size(ang));
   N = 2;
   for i=1:N
        [ G, H ] = data_gen (ang, noise);
        rot = ang_rot(ang);
        [ rot_out, other ] = feval(func, G, H);
        
        % rot_err is the rotation that takes rot onto rot_out
        rot_err = rot_out * rot';
        
        % ang_err is the error rotation in terms of euler angles
        ang_err = rot_ang(rot_err);
        
        sum = sum + ang_err.^2;
   end
   rms = sqrt(sum/N);
end

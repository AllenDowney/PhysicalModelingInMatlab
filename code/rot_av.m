function [ av ] = rot_av ( rot )
% given a rotation matrix, compute a quaternion
% of the angle-vector variety using eigenvector analysis

% there is probably a more efficient way to do this, based
% on the algorithm here:
% http://skal.planet-d.net/demo/matrixfaq.htm
% which converts a 4x4 rotation matrix to a quaternion

% solve for w matrix from finding eigenvalue problem
% that rot*w = w, where w is the vector we're rotating around
% and the compex eigenvals are e^{i Phi} and e^{-i Phi}
% and Phi is the vector we're rotating about
[eigvec, eigval] = eig(rot);

for i=1:3
    v = eigval(i,i);
    if imag(v) == 0
        w = eigvec(:,i);
        index = i;
    else
        Phi = angle(v);
    end
end

% stuff the components into a quaternion
av(1) = Phi;
av(2:4) = w;

% At this point we're not sure whether Phi needs to
% be negated.  There must be a smart way to figure it
% out, but for now we are doing something dumb.

% use av to compute the rotation matrix, and compare
% it with what we were given
r = av_rot(av);
n = norm(r - rot);

% if we didn't get the right rotation matrix, negate
% Phi and try again
if n > 1e-7
    av(1) = -av(1);
    r = av_rot(av);
    n = norm(r - rot);
end

if n > 1e-7
    disp('unexpected badness in rot_av.m')
end
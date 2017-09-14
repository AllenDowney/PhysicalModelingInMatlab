function [ quat ] = av_quat(av)
% convert from angle vector form to quaterion  
% [ q0, q1, q2, q3 ] 
% = [ cos(Phi/2), sin(Phi/2) w1, sin(Phi/2) w2, sin(Phi/2) w3 ]

Phi = av(1);
w = av(2:4);

c = cos(Phi/2); 
s = sin(Phi/2); 
quat = [c, w(1)*s, w(2)*s, w(3)*s];

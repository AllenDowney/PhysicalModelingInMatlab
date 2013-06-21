% moose_fun.m
% Author:  Lynn Andrea Stein
% Edited by Mark Somerville to incorporate carrying capacity and net
% birth/death rates in absence of other population
% Simulates the evolution of moose and wolf populations

function [M,W] = moose_fun(m0, w0, beta, w_crit, cc_m, gamma, m_crit, num_iterations)
    % assumptions:
    % Net birth rate of beta if no wolves, below CC
    % Net starvation rate of gamma if no moose (positive number)
    % Carrying capacity of cc_m in absence of wolves
    % Critical number of wolves/moose imply balance between birth and death
    % Carrying capacity applies to moose, but not to wolves
    
    % Initialize Moose and Wolf vectors...
    M(1) = m0;
    W(1) = w0;
    % ...and calculate generations.
    for i = 1:num_iterations
        M(i+1) = M(i) + beta * M(i) * (1-W(i)/w_crit) * (1 - M(i)/cc_m);
        W(i+1) = W(i) + gamma * W(i) * (M(i)/m_crit - 1);
    end
end

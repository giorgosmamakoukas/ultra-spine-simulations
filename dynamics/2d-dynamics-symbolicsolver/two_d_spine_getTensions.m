function [ Te ] = two_d_spine_getTensions(x2,z2,T2,dx2,dz2,dT2,...
    inp1,inp2,inp3,inp4)
%two_d_spine_getTensions.m
%   Calculates the tension forces for this 2D tensegrity spine.
%   Note that we wrote this function ourselves, it was not auto-generated by MATLAB.
%   -Drew Sabelhaus 2016-11-27

% Inputs:
%   x2...dT2 are the system states (Drew calls this \xi)
%   inp1...inp4 are the system dynamics inputs, which are the delta rest-lengths to be added or subtracted from each cable.
%   rest1...rest4 are the rest lengths of the cables

% spring and damping constants
K = 2000;
c = -50;

% correct for... something?
x2 = x2 + (abs(x2)<1e-8)*1e-6;
z2 = z2 + (abs(z2)<1e-8)*1e-6;
T2 = T2 + (abs(T2)<1e-8)*1e-6;

% calculate the lengths of all the cables
L = two_d_spine_lengths(x2,z2,T2);

% calculate the velocities of all the cables
dlengths = two_d_spine_dlengths_dt(x2,z2,T2,dx2,dz2,dT2);

% index into the 'lengths' result to get the distances between nodes
% for the correct vertebra. (note, here, we only have 2 vertebrae, so 
% we just want the second column from these matrices.
L = L(:, 2);
dlengths = dlengths(:, 2);

% calculate the \delta x for each cable/spring
stretch_length = [L(1) - inp1;
                  L(2) - inp2;
                  L(3) - inp3;
                  L(4) - inp4];
              
% The tensions are then k \delta x - c * dx/dt
Te = (stretch_length>=0).*(K*stretch_length-c*dlengths);
% make sure that tensions are always positive.
Te = (Te>=0).*Te;    
end


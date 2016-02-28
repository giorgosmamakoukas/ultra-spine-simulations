% get_ref_traj_circletop.m
% Copyright 2015 Andrew P. Sabelhaus, Abishek Akella
% This function returns a trajectory for the topmost spine vertebra that is an circle in (x, z), offset by some z amount.

function [traj, L] = get_ref_traj_circletop()
% No inputs.
% Outputs:
%   traj = the output trajectory of the topmost tetrahedron
%   L = number of waypoints in the trajectory

% Radius of the circle
r = 0.04; % meters
% z-height offset for the circle
circle_height = 0.3; % meters

L = 180;
theta = linspace(-pi, pi, L);

traj = [r*cos(theta) + r; ...
        zeros(1, L); ...
        r*sin(theta) + circle_height; ...
        zeros(1, L); ...
        zeros(1, L); ... 
        zeros(1, L); ...
        zeros(1, L); ...
        zeros(1, L); ...
        zeros(1, L); ...
        zeros(1, L); ...
        zeros(1, L); ...
        zeros(1, L)];
%plot3(traj(1, :), zeros(1, L), traj(3, :), 'r', 'LineWidth', 2);
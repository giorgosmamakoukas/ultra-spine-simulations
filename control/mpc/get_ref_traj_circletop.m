% get_ref_traj_circletop.m
% Copyright 2015 Andrew P. Sabelhaus, Abishek Akella
% This function returns a trajectory for the topmost spine vertebra that is an circle in (x, z), offset by some z amount.

function [traj, num_points] = get_ref_traj_circletop()
% No inputs.
% Outputs:
%   traj = the output trajectory of the topmost tetrahedron
%   L = number of waypoints in the trajectory

% Radius of the circle
r = 0.04; % meters
% z-height offset for the circle
circle_height = 0.3; % meters

% Multiplier here: used to be just 180
num_points = 100;
theta = linspace(-pi, pi, num_points);

traj = [r*cos(theta) + r; ...
        zeros(1, num_points); ...
        r*sin(theta) + circle_height; ...
        zeros(1, num_points); ...
        zeros(1, num_points); ... 
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points)];
%plot3(traj(1, :), zeros(1, L), traj(3, :), 'r', 'LineWidth', 2);
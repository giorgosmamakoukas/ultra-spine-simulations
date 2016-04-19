% get_ref_traj_quartercircletop.m
% Copyright 2015 Andrew P. Sabelhaus, Abishek Akella
% This function returns a trajectory for the topmost spine vertebra that is a quarter of a circle in (x, z), offset by some z amount.

function [traj, num_points] = get_ref_traj_quartercircletop()
% No inputs.
% Outputs:
%   traj = the output trajectory of the topmost tetrahedron
%   L = number of waypoints in the trajectory

% Radius of the circle
r = 0.04; % meters
% z-height offset for the circle
circle_height = 0.3; % meters

% Want 2 degrees per timestep, for a quarter turn of a circle in the top tetra
num_points = 45;
theta = linspace(-pi, -pi/2, num_points);

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
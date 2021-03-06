% get_ref_traj_topbending_YZ.m
% Copyright 2015 Andrew P. Sabelhaus
% This function returns a trajectory for the topmost spine vertebra that is along a constant-bending radius for the whole spine.

function [traj, num_points] = get_ref_traj_topbending_YZ()
% No inputs.
% Outputs:
%   traj = the output trajectory of the topmost tetrahedron
%   num_points = number of waypoints in the trajectory

% The whole spine will bend along a circle of radius (total spine length).
% Like the other trajectories (as of 2016-02-27), this assumes 4 spine vertebra.
r = 3 * 0.1; % this is tetra_vertical_spacing as of 2016-02-27

% how many degrees of movement should the top tetrahedron have?
% Note, this circle starts at theta = pi/2, and we are bending forwards here.
start_deg = pi/2;
max_deg = pi/3;

% Number of points to have in this trajectory. 
% Note that it's been estimated that timesteps should only be about 0.0014 units distance away from each other for the optimization to work.
% For pi/3 end: (0.3 * pi/6) / 0.0014
%num_points = 115;
num_points = 50;

% Create a sequence of successive angles between min and max
theta = linspace(start_deg, max_deg, num_points);

% For the T rotation: since it starts at zero radians, we need a new variable CHECK ME
theta_G_rotation = linspace(0, (start_deg - max_deg), num_points);

% This trajectory bends in (?) and z.
traj = [zeros(1, num_points); ...
        -r*cos(theta); ...
        r*sin(theta); ...
        zeros(1, num_points); ... 
        zeros(1, num_points); ... 
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points)];

% traj = [r*cos(theta); ...
%         zeros(1, num_points); ...
%         r*sin(theta); ...
%         zeros(1, num_points); ...
%         theta_G_rotation; ... 
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points)];
    
% traj = [zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         theta_T_rotation; ... % bend backwards in the T direction.
%         zeros(1, num_points); ... 
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points); ...
%         zeros(1, num_points)];
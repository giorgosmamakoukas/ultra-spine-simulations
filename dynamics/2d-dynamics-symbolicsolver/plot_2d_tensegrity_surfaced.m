function handles = plot_2d_tensegrity_surfaced( xi, geometry, ax )
%% plot_2d_tensegrity_surfaced.m Plots an N-unit 2D tensegrity structure with a nice surface visualization of the bars
%   This function plots a nice illustration of an N-unit 2D tensegrity,
%   using some surfaces to make the bars "thick." Thanks to Jeff Friesen
%   for the initial code on surfacing.
%   It assumes that the plotting window is open and ready to be 
%   drawn on. (So, for simulations, it would be good to clear the window inside a loop 
%   before calling this function - use the 'handles' that are returned.)
%   Inputs:
%       xi, the system state vector, \in R^((N-1)*6). 
%           This is (x, z, theta, dx, dz, dtheta) for each rigid body.
%       geometry, a struct that has the geometric parameters of the tensegrity
%           system's rigid bodies. See below.
%       ax, the axis handle for the figure. needed for surf.
%
%   Outputs:
%       handles, the handles to each of the elements that was drawn this timestep.
%           These are used in the calling function to clear what was drawn this timestep.

% First, pull out the geometry of the spine.
% (See the two_d_dynamics_* scripts, where this struct is defined.)
% The struct has the locations of each of the point masses in one of the
% repeated "units" (e.g., a single rigid body.)
N = geometry.N;
a = geometry.a;
num_pm_unit = geometry.num_pm_unit;
bars = geometry.bars;
connections_locations = geometry.connections_locations;
num_states_per_unit = geometry.num_states_per_unit;

% From the xi state vector passed in, calculate the number of states:
num_states = length(xi);
% A check: the number of states via the xi vector should equal the number of states
% saved into the geometry struct.
assert( num_states == geometry.num_states, ...
    'Error! The number of states is inconsistent between the geometry vector and state vector. Cannot plot tensegrity.');
 
% The handles array can be a cell array:
handles = {};

% The surfaces are discretized. Let's specify the (amount of discretization
% of the surfaces?) Default is 20?
surf_discretization = 20;

% We also need to specify the radius of the cylinders/spheres.
rad = 0.005; % as per 3D model.

%% 1) Plot the bottom (not-moving) spine

% We assume here that there's always a stationary unit at the origin.

% Make a unit sphere that we'll move and scale to place at each of the
% nodes.
% Note that we don't plan to plot this sphere (since there may not be a
% (0,0) node in the configuration matrix.)
[sphere_x, sphere_y, sphere_z] = sphere(surf_discretization); 

% ALSO - we want to plot the 2D tensegrity in the X-Z plane. So, we'll need
% the y-positions, but won't have to translate them at all.

% Each sphere will be at rad*(output of sphere) + position offset.
% NOTE that Jeff Friesen's code makes the center sphere larger. We're not
% going to do that here, since there's no "center sphere."
x_sphere_outer = rad * sphere_x;
y_sphere_outer = rad * sphere_y;
z_sphere_outer = rad * sphere_z;

% again, note that since this is in the X-Z plane, the Y won't need to be
% adjusted (but will still be needed for surf.)

% First, the nodes, as circles:
% Note that "a" has 2 rows, for the (x,z) position of each node.
for i=1:size(a,2)
    % Calculate the translates sphere positions for surf
    x_translated = x_sphere_outer + a(1,i);
    y_translated = y_sphere_outer;
    z_translated = z_sphere_outer + a(2,i);
    % Plot the surface
    handles{end+1} = surf(ax, x_translated, y_translated, ...
        z_translated, 'LineStyle', 'none');
end

% x4 = rad*x + spineCoord(1,1); y4 = rad*y + spineCoord(1,2); z4 = rad*z + spineCoord(1,3);

% OLD CODE:
% First, the four nodes, as circles:
% Note that "a" has 2 rows, for the (x,z) position of each node.
for i=1:size(a,2);
    handles{end+1} = plot(a(1,i), a(2,i), 'k.', 'MarkerSize', 40);
end

% Plot the vertebra itself (lines between nodes)
% The "bars" matrix is lower-triangular, with NaN
% in the upper triangle to remind us that any rod/bar that
% connects node 2 to node 3 also by definition connects node 3
% to node 2.
for i=1:size(bars,1)
    for j=1:size(bars,2)
        % If there is a one here,
        if bars(i,j) == 1
            % Plot a line, storing the handle.
            % Note that 'line' takes the x postions as the
            % first argument, and the z positions as the second.
            handles{end+1} = line( [a(1,i), a(1,j)], ...
                [a(2,i), a(2,j)], 'Color', 'k');
        end
    end
end

%% 2) Plot each of the moving vertebrae

% We'll be storing the locations of all the nodes
% of the spine as we iterate through the units (vertebrae),
% so that cable plotting is easier.
% Call the locations of the moving nodes "b".
% In order to not have a special case for unit 2,
% let's insert the "a" matrix as the first element of b.
b = zeros([size(a), N]);
b(:,:,1) = a;

% For each moving unit:
for unit = 2:N
    % 2.1) Calculate the node locations for this unit.
    % The theta coordinate for this unit is:
    % unit=2, theta=3
    % unit=3, theta=9
    % unit=4, theta=15
    % ...
    % Example: -(2-3) * 3 + 6 == -1*3 + 6 == -3 + 6 == 3.
    theta_index = (unit-3)*(num_states_per_unit/2) + num_states_per_unit;
    theta = xi(theta_index);
    % Also pick out the x,z states for this unit.
    % TO-DO: clean up this code, bad indexing.
    x = xi(theta_index-2);
    z = xi(theta_index-1);
    % Next, calculate the nodes of the moving vertebra.
    % These are the locations a, translated by (x,z), and rotated by theta.
    % The rotation matrix for this given angle of theta is:
    rot = [ cos(theta),    -sin(theta);
            sin(theta),     cos(theta)];
    % 17-06: try
%     rot = [ cos(theta),    sin(theta);
%             -sin(theta),     cos(theta)];
    % We need to multiply each point in a by rot,
    % and add the (x,z) offset from the xi state vector.
    % To make this easier, so that we can use matrix algebra,
    % copy out the (x,z) states to a 2 x num_pm_unit matrix:
    % (For example, this is a 2x4 for the single-vertebra spine.)
    xz_offset = repmat( [x; z], 1, num_pm_unit);
    % Now, the locations of the nodes of this unit are
    b(:,:,unit) = rot*a + xz_offset;
    % 2.2) Plot the node locations of this vertebra. As circles:
    for i=1:size(b,2);
        handles{end+1} = plot(b(1,i,unit), b(2,i,unit), 'k.', 'markersize', 40);
    end
    % 2.3) Plot the bars between nodes, just like with the static unit:
    for i=1:size(bars,1)
        for j=1:size(bars,2)
            % If there is a one here,
            if bars(i,j) == 1
                % Plot a line, storing the handle.
                % Note that 'line' takes the x postions as the
                % first argument, and the z positions as the second.
                handles{end+1} = line( [b(1,i,unit), b(1,j,unit)], ...
                    [b(2,i,unit), b(2,j,unit)], 'Color', 'k');
            end
        end
    end
    % 2.4) Plot the cables between this unit and the one
    % below it. Iterate through the connections_locations matrix,
    % and if there is a nonzero entry, plot a line.
    for i=1:size(connections_locations,1)
        for j=1:size(connections_locations,2)
            % If there is a cable to plot,
            if connections_locations(i,j) == 1
                % Plot between this unit
                % and the one below it.
                % The "from", at unit i, comes first, then the "to" at unit j.
                handles{end+1} = line( [b(1,i,unit-1), b(1,j,unit)], ...
                    [b(2,i,unit-1), b(2,j,unit)], 'Color', 'b');
            end
        end
    end
end

end


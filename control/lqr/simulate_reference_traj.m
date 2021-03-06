% simulate_reference_traj
% Abishek Akella 2015
% This function simulates the MPC to build a reference trajectory for the LQR controller

function [x_ref, u_ref, M] = simulate_reference_traj(controller, systemStates, restLengths, links, dt, x, y, z, T, G, P, dx, dy, dz, dT, dG, dP, traj, N)
% Simulate the MPC controller and find reference trajectory to follow
% provided waypoints. 

% This function calls the following functions related to the spine
% dynamics:
%   linearize_dynamics
%   simulate_dynamics

disp('Simulating reference trajectory')

% Initializing states for each link based on default resting location of
% each individual link. Initial input to linearize around is u = {0}.
x_initial = [];
for k = 1:links
    x_initial = [x_initial; x(k); y(k); z(k); T(k); G(k); P(k); dx(k); dy(k); dz(k); dT(k); dG(k); dP(k)];
end
u_initial = zeros(8*links, 1);

% Linearize model around initial state/input.
[A, B, c] = linearize_dynamics(x_initial, u_initial, restLengths, links, dt);

M = 1;

prev_in = u_initial;

% Begin running MPC controller on the desired trajectory. The controller
% generates a dynamically feasible input and state trajectory which can
% later be followed using a faster control strategy.

for index = 1:(size(traj, 2) - N + 1)
    disp(strcat('Simulating reference trajectory, timestep no.:',num2str(index)));
    for k = 1:links
        systemStates(k, 1) = x(k); systemStates(k, 2) = y(k); systemStates(k, 3) = z(k);
        systemStates(k, 4) = T(k); systemStates(k, 5) = G(k); systemStates(k, 6) = P(k);
        systemStates(k, 7) = dx(k); systemStates(k, 8) = dy(k); systemStates(k, 9) = dz(k);
        systemStates(k, 10) = dT(k); systemStates(k, 11) = dG(k); systemStates(k, 12) = dP(k);
    end

    noise = 0; % Case where no noise is present
    tic;
    % Use N-step horizon controller
    outputs = controller{N}{{prev_in, reshape(systemStates', 36, 1), A, B, c, traj(:, index:(index+N-1))}}; 

    control = outputs{1}(:, 1);
    prev_in = control;

    % Simulate system using MPC controller
    systemStates = simulate_dynamics(systemStates, restLengths, reshape(control, 8, 3)', dt, links, noise);
    x_ref{M} = reshape(systemStates', 36, 1);
    u_ref{M} = control;
    [A, B, c] = linearize_dynamics(reshape(systemStates', 36, 1), control, restLengths, links, dt);
    toc

    for k = 1:links
        x(k) = systemStates(k, 1); y(k) = systemStates(k, 2); z(k) = systemStates(k, 3);
        T(k) = systemStates(k, 4); G(k) = systemStates(k, 5); P(k) = systemStates(k, 6);
        dx(k) = systemStates(k, 7); dy(k) = systemStates(k, 8); dz(k) = systemStates(k, 9);
        dT(k) = systemStates(k, 10); dG(k) = systemStates(k, 11); dP(k) = systemStates(k, 12);
    end

    M = M + 1;
end

% Simulate states in the last N values of the desired trajectory (using the
% shrinking horizon controller)
for index = M:(size(traj, 2)-1)
    disp(strcat('Simulating reference trajectory, timestep no.:',num2str(index)));
    for k = 1:links
        systemStates(k, 1) = x(k); systemStates(k, 2) = y(k); systemStates(k, 3) = z(k);
        systemStates(k, 4) = T(k); systemStates(k, 5) = G(k); systemStates(k, 6) = P(k);
        systemStates(k, 7) = dx(k); systemStates(k, 8) = dy(k); systemStates(k, 9) = dz(k);
        systemStates(k, 10) = dT(k); systemStates(k, 11) = dG(k); systemStates(k, 12) = dP(k);
    end

    noise = 0; % Case where no noise is present
    tic;
    % Calculate number of states in traj from current state onwards
    shrinking_horizon = size(traj, 2) - M + 1;
    ref_traj = zeros(12, N);
    % Zero-pad reference trajectory passed into the controller (zero states
    % are ignored)
    ref_traj(:, 1:shrinking_horizon) = traj(:, index:end);
    % Use shrinking_horizon-step horizon controller
    outputs = controller{shrinking_horizon}{{prev_in, reshape(systemStates', 36, 1), A, B, c, ref_traj}}; 

    control = outputs{1}(:, 1);
    prev_in = control;

    % Simulate system dynamics based on MPC control input
    systemStates = simulate_dynamics(systemStates, restLengths, reshape(control, 8, 3)', dt, links, noise);
    x_ref{M} = reshape(systemStates', 36, 1);
    u_ref{M} = control;
    [A, B, c] = linearize_dynamics(reshape(systemStates', 36, 1), control, restLengths, links, dt);
    toc

    for k = 1:links
        x(k) = systemStates(k, 1); y(k) = systemStates(k, 2); z(k) = systemStates(k, 3);
        T(k) = systemStates(k, 4); G(k) = systemStates(k, 5); P(k) = systemStates(k, 6);
        dx(k) = systemStates(k, 7); dy(k) = systemStates(k, 8); dz(k) = systemStates(k, 9);
        dT(k) = systemStates(k, 10); dG(k) = systemStates(k, 11); dP(k) = systemStates(k, 12);
    end

    M = M + 1;
end
M = M - 1;
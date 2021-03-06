% ultra_spine_mpc_2d.m
%
% Copyright 2016 Mallory Daly, Andrew P. Sabelhaus, Ellande Tang, Shirley
% Zhao, Edward Zhu, Berkeley Emergent Space Tensegrities Lab
%
% This is the primary script file that runs MPC on a 2d spine

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script outline

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script initialization

clear all;
close all;
clc;

disp('ULTRA Spine MPC 2D')

% Add various paths

% System dynamics path, spine geometric parameters file is also in this
% directory
dynamics_path = '../../dynamics/2d-dynamics-symbolicsolver';
addpath(dynamics_path)
% Inverse kinematics solver
inv_kin_path = '../../kinematics/2D-inv-kinematics';
addpath(inv_kin_path)
% Reference trajectories path
ref_traj_path = './reference_trajectories';
addpath(ref_traj_path)
% YALMIP controllers path
yalmip_controllers_path = './yalmip_controllers';
addpath(yalmip_controllers_path)

% Since the individual simulations will save their own videos and data, this script
% passes in the paths to the data and videos folders to the mpc function.
% Call this struct 'paths'.

% The path to our videos repository now needs to be set, since we're no longer pushing videos to this simulations repository.
% Drew (on 2016-04-19) put the ultra-spine-videos repository in the same folder as ultra-spine-simulations, which means
% the path to the MPC videos folder will be:
% paths.path_to_videos_folder = '../../../ultra-spine-videos/simulations/control/mpc/';

% The path to the folder where we'll store the .mat data from this simulation also needs to be set:
paths.path_to_data_folder = '../../data/mpc_2d_data/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define optimization and spine parameters

% Load spine gemetric parameters. This loads a struct called
% spine_geometric_parameters into the workspace. Contains the fields 'g',
% 'N', 'l', 'h', and 'm'
load('two_d_geometry.mat')

% Create a struct of optimization parameters
opt_params.num_pts = 4000;
opt_params.num_states = 6;
opt_params.num_inputs = 4;
opt_params.horizon_length = 4;
opt_params.opt_time_lim = 1.5;
opt_params.spine_params = two_d_geometry;
% Note: it seems that the discretization of dt=0.001 sec
% leads to instability. Choose 1e-5 or lower, ideally 1e-6.
%opt_params.dt = 0.001;
%opt_params.dt = 1e-7;
%opt_params.dt = 1e-6;
opt_params.dt = 1e-5;

% Define initial states
% xi_0 = [-0.05; 0.15; pi/4; 0; 0; 0];
% u_0 = zeros(opt_params.num_inputs,1);
% opt_params.xi = [-0.01; 0.1; 0; 0; 0; 0];
% opt_params.xi = [-0.001+0.01; 0.1237+0.01; 0.0657+0.01; 0; 0; 0];
opt_params.u = zeros(opt_params.num_inputs,1);
% opt_params.u = [0.12;0.12;0.06;0.06];


% Define output matrix
C = eye(opt_params.num_states);
opt_params.num_outputs = size(C,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get trajectory for top vertebra

% Generate state reference trajectory. Functions for doing this should be 
% placed in the reference_trajectories folder and called here.
% [traj, ~] = get_ref_traj_zero(opt_params.num_pts,opt_params.horizon_length,opt_params.num_states);
% [xi_traj, u_traj, ~] = get_ref_traj_eq(opt_params.num_pts,opt_params.horizon_length);
[xi_traj, ~] = get_ref_traj_invkin_XZG(0.1,opt_params.num_pts+opt_params.horizon_length,1,opt_params.dt);
u_traj = zeros(opt_params.num_inputs,opt_params.num_pts+opt_params.horizon_length);
% Adding a minimum tension:
min_tension = 30; %newtons
for i = 1:opt_params.num_pts+opt_params.horizon_length
    disp(strcat('Calculating inverse kinematics for trajectory point #', num2str(i), '...'));
    [~, u_traj(:,i)] = getTensions(xi_traj(:,i),opt_params.spine_params,min_tension);
%     disp(xi_traj(:,i))
end
opt_params.xi = xi_traj(:,1);
opt_params.u = u_traj(:,1);

prev_u = opt_params.u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create controller

xi = sdpvar(opt_params.num_states,opt_params.horizon_length+1,'full');
u = sdpvar(opt_params.num_inputs,opt_params.horizon_length,'full');
xi_ref = sdpvar(opt_params.num_states,opt_params.horizon_length+1,'full');
u_ref = sdpvar(opt_params.num_inputs,opt_params.horizon_length+1,'full');
A_k = sdpvar(opt_params.num_states,opt_params.num_states);
B_k = sdpvar(opt_params.num_states,opt_params.num_inputs);
c_k = sdpvar(opt_params.num_states,1);
prev_u = sdpvar(opt_params.num_inputs,1);
% xi_0 = sdpvar(opt_params.num_states,1);

% Create N-step controller
[controller,~,~,~,~] = get_yalmip_controller_XZT(opt_params.horizon_length, ...
    xi,u,xi_ref,u_ref,A_k,B_k,c_k,prev_u,opt_params.spine_params, ...
    opt_params.opt_time_lim);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MPC Setup

% Define matrices for saving all states and inputs
xi_step = zeros(opt_params.num_states,opt_params.horizon_length+1,opt_params.num_pts);
u_step = zeros(opt_params.num_inputs,opt_params.horizon_length,opt_params.num_pts);
xi_cl = zeros(opt_params.num_states,opt_params.num_pts+1);
u_cl = zeros(opt_params.num_inputs,opt_params.num_pts);
A_step = zeros(opt_params.num_states,opt_params.num_states,opt_params.num_pts);
B_step = zeros(opt_params.num_states,opt_params.num_inputs,opt_params.num_pts);
c_step = zeros(opt_params.num_states,opt_params.num_pts);
% As an extra check, let's record the stability of the A matrix,
% as well as a controllability check on A, B.
% This will help determine if, for example, the system is becoming
% unstable due to a large discretization error.
A_step_stability = zeros(1,opt_params.num_pts);
AB_step_ctrb = zeros(1,opt_params.num_pts);

xi_cl(:,1) = opt_params.xi;
% With recification (nonnegative cable tensions):
dyn_type = 2;
% Without recification (cables can push):
%dyn_type = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MPC Loop

% Main loop iterating through the length of the trajectory
for i = 1:opt_params.num_pts
    
    fprintf('MPC Iteration: %g\n',i)
    
    assign(xi_ref,xi_traj(:,i:i+opt_params.horizon_length));
    assign(u_ref,u_traj(:,i:i+opt_params.horizon_length));
    % These seem to need to be doubles, not sdpvars.
    xi_ref_current = xi_traj(:,i:i+opt_params.horizon_length);
    u_ref_current = u_traj(:,i:i+opt_params.horizon_length);
    
    % Linearize dynamics about current state and input
    [A_k, B_k, c_k] = linearize_dynamics_2d(opt_params.xi,opt_params.u,opt_params.dt,dyn_type);

    % Linearize dynamics about state and input references
%     [A_k, B_k, c_k] = linearize_dynamics_2d(opt_params.xi,u_traj(:,i),opt_params.dt,dyn_type);
    A_step(:,:,i) = A_k;
    B_step(:,:,i) = B_k;
    c_step(:,i) = c_k;
    
    % For later reference, check the stability and controllability of
    % this linearization.
    % Unstable (0) if any of the eigenvalues of A_k lie inside the unit disc.
    A_step_stability(i) = ~any( abs(eig(A_k)) >= 1);
    % The controllability matrix for this timestep is
    Co = ctrb(A_k,B_k);
    % Uncontrollable (0) if this matrix has less than rank n.
    AB_step_ctrb(i) = (length(A_k) - rank(Co) <= 0);
    
    % Generate state and input reference trajectory for the current
    % timestep with length of the horizon window
%     for j = 1:opt_params.horizon_length+1
%         r = traj(:,i+j-1);
%         z_ref = [eye(opt_params.num_states)-A_k -B_k;
%                  C zeros(opt_params.num_outputs,opt_params.num_inputs)]\...
%                  [zeros(opt_params.num_states,1); r];
%         xi_ref(:,j) = z_ref(1:opt_params.num_states);
%         u_ref(:,j) = z_ref(opt_params.num_states+1:end);
%     end

%     for j = 1:opt_params.horizon_length+1
%         r = traj(:,i+j-1);
%         xi_s = sdpvar(opt_params.num_states,1);
%         u_s = sdpvar(opt_params.num_inputs,1);
%         Qs = eye(opt_params.num_states);
%         
%         constraints = [];
%         constraints = [constraints xi_s==A_k*xi_s+B_k*u_s+c_k u_s>=0];
%         objective = (C*xi_s-r)'*Qs*(C*xi_s-r);
%         
%         options = sdpsettings('verbose',1,'solver','quadprog');
%         sol = optimize(constraints,objective,options);
%         
%         xi_ref(:,j) = xi_s;
%         u_ref(:,j) = u_s;
%     end
    
    % Solve and save results
    %outputs = controller{{A_k B_k c_k xi_ref u_ref opt_params.xi}};
    % Using the references as doubles and not sdpvars:
    outputs = controller{{A_k B_k c_k xi_ref_current u_ref_current opt_params.xi}};
%     outputs = controller{{A_k B_k c_k xi_ref opt_params.xi}};
    
    u_step(:,:,i) = outputs{2}(:,1:opt_params.horizon_length);
    control = outputs{2}(:,1);
    u_cl(:,i) = control;
    opt_params.u = control;
    prev_u = control;
    
    %xi_kp1 = simulate_2d_spine_dynamics(opt_params.xi,opt_params.u,opt_params.dt,1,dyn_type);
    xi_kp1 = simulate_2d_spine_dynamics(opt_params.xi,opt_params.u,opt_params.dt,10,dyn_type);
    xi_cl(:,i+1) = xi_kp1;
    opt_params.xi = xi_kp1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot results

% Set up the window.
figure;
hold on;
axis([-0.2, 0.2, -0.1, 0.3]);
% Plot the first location of the spine:
%handles = plot_2d_spine(xi(:,1), two_d_geometry);
handles = plot_2d_tensegrity(xi_cl(:,1), opt_params.spine_params);
plot(xi_traj(1,:),xi_traj(2,:),'or','lineWidth',2)
drawnow;

for i=1:opt_params.num_pts
    fprintf('Plot iteration: %g\n',i)
    % Plot the vertebrae at this timestep:
    % clear the window
    for j = 1:length(handles)
        delete(handles{j});
    end
    % plot:
    %handles = plot_2d_spine(xi(:,i+1), two_d_geometry);
    handles = plot_2d_tensegrity(xi_cl(:,i+1), opt_params.spine_params);
    drawnow;
end

% Plot the closed-loop trajectories
figure;
subplot(6,1,1)
plot(1:opt_params.num_pts+1,xi_cl(1,:))
ylabel('x')
title('State Trajectories')
subplot(6,1,2)
plot(1:opt_params.num_pts+1,xi_cl(2,:))
ylabel('z')
subplot(6,1,3)
plot(1:opt_params.num_pts+1,xi_cl(3,:))
ylabel('theta')
subplot(6,1,4)
plot(1:opt_params.num_pts+1,xi_cl(4,:))
ylabel('v_x')
subplot(6,1,5)
plot(1:opt_params.num_pts+1,xi_cl(5,:))
ylabel('v_z')
subplot(6,1,6)
plot(1:opt_params.num_pts+1,xi_cl(6,:))
ylabel('omega')

% Plot the closed-loop inputs
figure;
subplot(4,1,1)
plot(1:opt_params.num_pts,u_cl(1,:))
ylabel('u1')
title('Input Trajectories')
subplot(4,1,2)
plot(1:opt_params.num_pts,u_cl(2,:))
ylabel('u2')
subplot(4,1,3)
plot(1:opt_params.num_pts,u_cl(3,:))
ylabel('u3')
subplot(4,1,4)
plot(1:opt_params.num_pts,u_cl(4,:))
ylabel('u4')

% Plot the original reference inputs
figure;
subplot(4,1,1)
plot(1:opt_params.num_pts+opt_params.horizon_length,u_traj(1,:))
ylabel('u1')
title('Reference Inputs')
subplot(4,1,2)
plot(1:opt_params.num_pts+opt_params.horizon_length,u_traj(2,:))
ylabel('u2')
subplot(4,1,3)
plot(1:opt_params.num_pts+opt_params.horizon_length,u_traj(3,:))
ylabel('u3')
subplot(4,1,4)
plot(1:opt_params.num_pts+opt_params.horizon_length,u_traj(4,:))
ylabel('u4')

% Plot the errors in state between the closed-loop and reference
% Errors are:
xi_errors = abs(xi_cl - xi_traj(:, 1:size(xi_cl,2)));
figure;
hold on;
subplot(3,1,1);
plot(1:opt_params.num_pts+1, xi_errors(1,:));
ylabel('x');
title('Tracking Errors, abs(State - Ref)');
subplot(3,1,2);
plot(1:opt_params.num_pts+1, xi_errors(2,:));
ylabel('z');
subplot(3,1,3);
plot(1:opt_params.num_pts+1, xi_errors(3,:));
ylabel('theta');
% subplot(6,1,4);
% plot(1:opt_params.num_pts+1, xi_errors(4,:));
% ylabel('v_x');
% subplot(6,1,5);
% plot(1:opt_params.num_pts+1, xi_errors(5,:));
% ylabel('v_z');
% subplot(6,1,6);
% plot(1:opt_params.num_pts+1, xi_errors(6,:));
% ylabel('omega');

% end script.

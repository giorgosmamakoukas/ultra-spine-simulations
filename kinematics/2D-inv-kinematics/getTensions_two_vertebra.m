%% Find Cable Forces and Rest Lengths in 2D Spine
% This function minimizes the force density values of the cables in a 2D
% spinr consisting of two stacked tetrahedra. The bottom tetra is fixed,
% and the location of the top tetra is defined by the input xi. We assume
% that the spine is sitting on a surface, so that there are vertical
% reaction forces at each of the two bottom nodes in contact. The function
% returns the cable tensions and the corresponding rest lengths.
%
% Authors: Mallory Daly and Ellande Tang
% Created: 12/8/16
% Modified: 12/10/16

function [tensions, restLengths] = getTensions_two_vertebra(xi, spineParameters, minCableTension)

%% Spine Parameters

% Number of bars, cables, and nodes
% r = 6; % bars
% s = 4; % cables
% n = 8; % nodes

% With 2 moving vertebrea:
r = 9; % bars
s = 8; % cables
n = 12; % nodes

% Geometric parameters
ll = spineParameters.l; % m, length of long bars
h = spineParameters.h; % m, height from top to bottom of tetra
ls = h/2; % m, length of short bar
w = sqrt(ll^2-(h/2)^2); % m, width from center of tetra

% Mass and force parameters
g = spineParameters.g; % m/s^2, acceleration due to gravity
M = spineParameters.total_m; % kg/tetra
springConstant = spineParameters.k_vert; % structure has vertical and horizontal k, but they're the same, so ignore for now
% m = spineParameters.m; % kg/node
M = spineParameters.total_m; % kg/tetra
springConstant = spineParameters.k_vert;

%% Connectivity Matrix
% See H.-J. Schek's "The Force Density Method for Form Finding and
% Computation of General Networks."

% Full connectivity matrix
% Rows 1-4 are cables
% Rows 5-7 are bottom tetra bars
% Rows 7-10 are top tetra bars
% Columns 1-4 are bottom tetra nodes
% Columns 5-8 are lower tetra nodes

% C_1: cables (rows 1-4) x bottom_nodes (columns 1-4) 
%      1  2  3  4  
C_1 = [0  1  0  0 ;   %  1
       0  0  1  0 ;   %  2
       0  0  0  1 ;   %  3
       0  0  0  1];   %  4
%
% C_2: bars (rows 5-10) x bottom_nodes (columns 1-4)
%      1  2  3  4  
C_2 = [1 -1  0  0 ;   % 1  %  5
       1  0 -1  0 ;   % 2  %  6
       1  0  0 -1 ;   % 3  %  7
       0  0  0  0 ;   % 4  %  8
       0  0  0  0 ;   % 5  %  9
       0  0  0  0];   % 6  %  10
%   
% C_3: cables (rows 1-4) x lower_top_nodes (columns 5-8)    
%      5  6  7  8  
C_3 = [0 -1  0  0 ;   %  1
       0  0 -1  0 ;   %  2
       0 -1  0  0 ;   %  3
       0  0 -1  0];   %  4
%
% C_4: bars (rows 5-10) x lower_top_nodes (columns 5-8)
%      5  6  7  8  
C_4 = [0  0  0  0 ;   % 1  %  5
       0  0  0  0 ;   % 2  %  6
       0  0  0  0 ;   % 3  %  7
       1 -1  0  0 ;   % 4  %  8
       1  0 -1  0 ;   % 5  %  9
       1  0  0 -1];   % 6  %  10
   
% Put everything together:  
%        1-4   5-8
% C_m = [ C_1   C_2 ;    %  1-4
%         C_3   C_4];    %  5-10
  
% Full connectivity matrix
% Rows 1-4 are bottom-to-lower-top cables
% Rows 5-8 are bottom-to-higher-top cables(should I use lower-to-higher-top
% cables instead?)
% Rows 9-11 are bottom tetra bars (top_1)
% Rows 12-14 are lower moving tetra bars (top_1)
% Rows 15-17 are higher moving tetra bars (top_2)
% 
% Columns 1-4 are bottom tetra nodes
% Columns 5-8 are lower moving tetra nodes (top_1)
% Columns 9-12 are higher moving tetra nodes (top_2)

% Try 2 moving vertebrae:
% C_1: bottom-to-lower-top cables (rows 1-4) x bottom_nodes (columns 1-4) 
% C_2: bottom and lower-top bars (rows 9-14) x bottom_nodes (columns 1-4)
% C_3: bottom-to-lower-top cables (rows 1-4) x lower_top_nodes (columns 5-10)
% C_4: bottom and lower-top bars (rows 9-14) x lower_top_nodes (columns 5-10)
%
% C_5: bottom-to-higher-top cables (rows 5-8) x bottom_nodes (columns 1-4)
% Horizontal Cables (row 5-6): Bottom-to-Higher-Top;
% Saddle Cables (row 7-8): Lower-Top-to-Higher-Top;
%      1  2  3  4  
C_5 = [0  1  0  0 ;   %  1  % 5
       0  0  1  0 ;   %  2  % 6
       0  0  0  1 ;   %  3  % 7
       0  0  0  1];   %  4  % 8
% C_6: bottom-to-higher-top cables (rows 5-8) x lower_top_nodes (columns 1-4)
%      5  6  7  8 
C_6 = [0  0  0  0 ;   %  1  % 5
       0  0  0  0 ;   %  2  % 6
       0  0  0  0 ;   %  3  % 7
       0  0  1  1];   %  4  % 8
% C_7: 

%     1-4   5-8  9-12
C = [ C_1   C_2  C_7 ;   % 1-4
      C_5   C_6  C_8 ;   % 5-8
      C_3   C_4  C_9 ;   % 9-14
      C_10  C_12 C_11];  % 15-17

% Connection matrix of cables
% Cs = C(1:s,:);0

%% Nodal Positions
% Coordinate system such that nodes 3 and 4 are on the x axis and nodes 1
% and 2 are centered on the z axis.

% Nodal positions of bottom tetrahedra
%           1    2    3    4
x_bot = [   0   -w    w    0]';
z_bot = [   0 -h/2 -h/2  h/2]';

% Nodal positions and rotation of top tetra
x_top_1 = xi(1);
z_top_1 = xi(2);
theta_1 = xi(3);

x_top_2 = xi(7);
z_top_2 = xi(8);
theta_2 = xi(9);

% Rotation matrix for given angle of theta
rot = [cos(theta_1), -sin(theta_1);
       sin(theta_1),  cos(theta_1)];
   
% Need to multiply each node by the rotation matrix and add the (x,z)
% offset from the xi state vector. Copy out (x,z) offset to a 2x4 matrix to
% make this easier.
xz_offset = repmat([x_top_1; z_top_1], 1, 4);

% Translate and rotate position of fixed nodes to get coordinates of free
% nodes
xz_top = rot*[x_bot'; z_bot'] + xz_offset;

% Extract x and z of free nodes
x_top_1 = xz_top(1,:)';
z_top_1 = xz_top(2,:)';

% Combined nodal positions
x = [x_bot; x_top_1; x_top_2];
z = [z_bot; z_top_1; z_top_2];

% Plot nodal positions
% figure
% plot(x_bot,z_bot,'k.','MarkerSize',10)
% hold on
% plot(x_top,z_top,'r.','MarkerSize',10)

%% Lengths of Bars and Cables

% Rows 1-6 are bars
% Rows 7-10 are cables
l = [norm([x(2),z(2)]-[x(6),z(6)]); %  1
     norm([x(3),z(3)]-[x(7),z(7)]); %  2
     norm([x(4),z(4)]-[x(6),z(6)]); %  3
     norm([x(4),z(4)]-[x(7),z(7)]); %  4
     ll;                            %  5
     ll;                            %  6
     ls;                            %  7
     ll;                            %  8
     ll;                            %  9
     ls];                           % 10

% Cable diagonal length matrix
l_cables = l(1:s);
L_cables = diag(l_cables);

%% Solve for Reaction Forces
% Assume spine is sitting on a surface. Then there are vertical reaction
% forces at nodes 2 and 3.

% Solve AR*[R2; R3] = bR, where AR will always be invertible
AR = [1 1; 0 (x(3)-x(2))];
bR = [2*M*g; M*g*(x(1)-x(2))+M*g*(x(5)-x(2))];
R = AR\bR;
R2 = R(1);
R3 = R(2);

% Note R2 and R3 cannot be negative, but this constraint is not imposed
% here. However, a condition under which R2 or R3 becomes negative creates
% an infeasible problem for the cable tensions, so the issue solves itself.
% It's possible that a more generalized problem would need to solve for
% reaction forces using a solver in order to impose this constraint.

%% Equilibrium Force Equations

% Create vector of distance differences
dx = C*x;
dz = C*z;

% Define A*q = p, where q is a vector of the cable force densities and p is
% a vector of the external forces. Note that A is not a full rank matrix
% (not invertible).
A = [ -dx(1) -dx(2) -dx(3) -dx(4);  % horizontal forces, bottom tetra
       dx(1)  dx(2)  dx(3)  dx(4);  % horizontal forces, top tetra
      -dz(1) -dz(2) -dz(3) -dz(4);  % vertical forces, bottom tetra
       dz(1)  dz(2)  dz(3)  dz(4)]; % vertical forces, top tetra

% Moments about each tetra (actually only need moment about one because we
% already took the system moment, but it's not hurting anything to have it.
qfun = @(a,b,c) (x(b)-x(a))*(z(c)-z(b)) - (z(b)-z(a))*(x(c)-x(b));
A = [A;
     qfun(5,6,2) qfun(5,7,3) qfun(5,6,4) qfun(5,7,4);
     qfun(1,2,6) qfun(1,3,7) qfun(1,4,6) qfun(1,4,7)];
 
p = [ 0; 0; M*g-R2-R3; M*g; 0; (R2-R3)*w];

%% Solve Problem for Minimized Cable Tension

% % Solve with YALMIP
% yalmip('clear')
% q = sdpvar(s,1);
% obj = q'*q;
% constr = [A*q == p, L_cables*q >= minCableTension*ones(s,1)];
% options = sdpsettings('solver','quadprog','verbose',0);
% sol = optimize(constr,obj,options);

% Solve with QUADPROG
H = 2*eye(8);
f = zeros(8,1);
Aeq = A;
beq = p;
Aineq = -L_cables;
bineq = -minCableTension*ones(s,1);
% opts = optimoptions(@quadprog,'Display','notify-detailed');
[qOpt, ~, exitFlag] = quadprog(H,f,Aineq,bineq,Aeq,beq);

if exitFlag == 1
    tensions = L_cables*qOpt; % N
    restLengths = l_cables - tensions/springConstant;
    if any(restLengths <= 0)
        display('WARNING: One or more rest lengths are negative. Position is not feasible with current spring constant.')
    end
else
    display(['Quadprog exit flag: ' num2str(exitFlag)])
    tensions = Inf*ones(s,1);
    restLengths = -Inf*ones(s,1);
end

%% Check Distance Vectors Symbollically

% x1 = sym('x1','real');
% x2 = sym('x2','real');
% x3 = sym('x3','real');
% x4 = sym('x4','real');
% x5 = sym('x5','real');
% x6 = sym('x6','real');
% x7 = sym('x7','real');
% x8 = sym('x8','real');
% x = [x1 x2 x3 x4 x5 x6 x7 x8]';
% 
% z1 = sym('z1','real');
% z2 = sym('z2','real');
% z3 = sym('z3','real');
% z4 = sym('z4','real');
% z5 = sym('z5','real');
% z6 = sym('z6','real');
% z7 = sym('z7','real');
% z8 = sym('z8','real');
% z = [z1 z2 z3 z4 z5 z6 z7 z8]';
% 
% C*x
% C*z
% 
% q1 = sym('q1','real');
% q2 = sym('q2','real');
% q3 = sym('q3','real');
% q4 = sym('q4','real');
% qs = [q1 q2 q3 q4]'

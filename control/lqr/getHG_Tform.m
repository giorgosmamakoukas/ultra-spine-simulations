function RR1 = getHG_Tform(x,y,z,T,G,P)
%GETHG_TFORM
%    RR1 = GETHG_TFORM(X,Y,Z,T,G,P)

%    This function was generated by the Symbolic Math Toolbox version 6.1.
%    21-May-2015 11:52:08

t2 = cos(P);
t3 = sin(P);
t4 = sin(T);
t5 = cos(T);
t6 = sin(G);
t7 = cos(G);
RR1 = reshape([t2.*t7,t3.*t7,-t6,0.0,-t3.*t5+t2.*t4.*t6,t2.*t5+t3.*t4.*t6,t4.*t7,0.0,t3.*t4+t2.*t5.*t6,-t2.*t4+t3.*t5.*t6,t5.*t7,0.0,x,y,z,1.0],[4, 4]);

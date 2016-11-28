function lengths = two_d_spine_lengths(x2,z2,T2,x3,z3,T3)
%TWO_D_SPINE_LENGTHS
%    LENGTHS = TWO_D_SPINE_LENGTHS(X2,Z2,T2,X3,Z3,T3)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    27-Nov-2016 16:31:00

t4 = pi.*(1.0./6.0);
t5 = T2+t4;
t6 = cos(t5);
t7 = t6.*(3.0./2.0e1);
t14 = sqrt(3.0);
t15 = t14.*(3.0./4.0e1);
t2 = abs(-t7+t15+x2);
t9 = pi.*(1.0./3.0);
t10 = T2-t9;
t11 = cos(t10);
t12 = t11.*(3.0./2.0e1);
t3 = abs(-t12+z2+3.0./4.0e1);
t32 = T3+t4;
t33 = cos(t32);
t34 = t33.*(3.0./2.0e1);
t8 = abs(t7-t34-x2+x3);
t28 = T3-t9;
t29 = cos(t28);
t30 = t29.*(3.0./2.0e1);
t13 = abs(t12-t30-z2+z3);
t17 = T2+t9;
t22 = sin(t17);
t23 = t22.*(3.0./2.0e1);
t16 = abs(-t15+t23+x2);
t19 = cos(t17);
t20 = t19.*(3.0./2.0e1);
t18 = abs(-t20+z2+3.0./4.0e1);
t24 = T3+t9;
t40 = cos(t24);
t41 = t40.*(3.0./2.0e1);
t21 = abs(t20-t41-z2+z3);
t45 = sin(t24);
t46 = t45.*(3.0./2.0e1);
t25 = abs(t23-t46+x2-x3);
t26 = abs(t12-z2+3.0./4.0e1);
t27 = abs(-t7+x2);
t38 = cos(T2);
t39 = t38.*(3.0./4.0e1);
t31 = abs(t30+t39+z2-z3);
t43 = sin(T2);
t44 = t43.*(3.0./4.0e1);
t35 = abs(t34-t44+x2-x3);
t36 = abs(t20-z2+3.0./4.0e1);
t37 = abs(t23+x2);
t42 = abs(t39+t41+z2-z3);
t47 = abs(t44+t46-x2+x3);
lengths = reshape([0.0,0.0,0.0,0.0,sqrt(t2.^2+t3.^2),sqrt(t16.^2+t18.^2),sqrt(t26.^2+t27.^2),sqrt(t36.^2+t37.^2),sqrt(t8.^2+t13.^2),sqrt(t21.^2+t25.^2),sqrt(t31.^2+t35.^2),sqrt(t42.^2+t47.^2)],[4,3]);
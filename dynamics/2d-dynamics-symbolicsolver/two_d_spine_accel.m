function d2xi_solved_un = two_d_spine_accel(in1,in2)
%TWO_D_SPINE_ACCEL
%    D2XI_SOLVED_UN = TWO_D_SPINE_ACCEL(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.0.
%    07-Jun-2018 11:41:55

tensions_un1 = in2(1,:);
tensions_un2 = in2(2,:);
tensions_un3 = in2(3,:);
tensions_un4 = in2(4,:);
xi1 = in1(1,:);
xi2 = in1(2,:);
xi3 = in1(3,:);
xi6 = in1(6,:);
t2 = cos(xi3);
t3 = sin(xi3);
t4 = t3.^2;
t5 = xi6.^2;
t6 = sqrt(2.0);
t7 = pi.*(1.0./4.0);
t8 = t7+xi3;
t9 = cos(t8);
t10 = sin(t8);
t11 = t2.^2;
t12 = t4+t11-2.0e1;
t13 = 1.0./t12;
t14 = tensions_un2.*4.0e2;
d2xi_solved_un = [t13.*(t14-tensions_un1.*4.0e2+t3.*t5.*2.0e1+t4.*tensions_un1.*2.0e1-t4.*tensions_un2.*2.0e1-tensions_un1.*xi1.*2.0e3-tensions_un2.*xi1.*2.0e3-tensions_un3.*xi1.*2.0e3-tensions_un4.*xi1.*2.0e3-t3.*t4.*t5-t3.*t5.*t11+t2.*t3.*tensions_un1.*1.4e2+t2.*t3.*tensions_un2.*1.4e2+t2.*t3.*tensions_un3.*2.0e1+t2.*t3.*tensions_un4.*2.0e1+t6.*t9.*tensions_un1.*4.0e2+t6.*t9.*tensions_un3.*4.0e2-t6.*t10.*tensions_un2.*4.0e2-t6.*t10.*tensions_un4.*4.0e2+t4.*tensions_un1.*xi1.*1.0e2+t4.*tensions_un2.*xi1.*1.0e2+t4.*tensions_un3.*xi1.*1.0e2+t4.*tensions_un4.*xi1.*1.0e2+t11.*tensions_un1.*xi1.*4.0e2-t11.*tensions_un1.*xi2.*4.0e2+t11.*tensions_un2.*xi1.*4.0e2+t11.*tensions_un2.*xi2.*4.0e2+t2.*t6.*t9.*tensions_un3.*8.0e1-t4.*t6.*t9.*tensions_un1.*2.0e1-t2.*t6.*t10.*tensions_un4.*8.0e1-t4.*t6.*t9.*tensions_un3.*2.0e1+t4.*t6.*t10.*tensions_un2.*2.0e1+t4.*t6.*t10.*tensions_un4.*2.0e1+t2.*t3.*tensions_un1.*xi1.*4.0e2+t2.*t3.*tensions_un1.*xi2.*3.0e2-t2.*t3.*tensions_un2.*xi1.*4.0e2+t2.*t3.*tensions_un2.*xi2.*3.0e2-t2.*t3.*tensions_un3.*xi2.*1.0e2-t2.*t3.*tensions_un4.*xi2.*1.0e2+t2.*t3.*t6.*t9.*tensions_un2.*2.0e1+t2.*t3.*t6.*t10.*tensions_un1.*2.0e1+t2.*t3.*t6.*t9.*tensions_un4.*2.0e1+t2.*t3.*t6.*t10.*tensions_un3.*2.0e1-t2.*t6.*t9.*tensions_un3.*xi2.*4.0e2+t2.*t6.*t9.*tensions_un4.*xi1.*4.0e2+t2.*t6.*t10.*tensions_un3.*xi1.*4.0e2+t2.*t6.*t10.*tensions_un4.*xi2.*4.0e2).*(-1.0./2.0e1);t13.*(t4.*1.96e2+t11.*1.96e2-t14-tensions_un1.*4.0e2+tensions_un3.*4.0e2+tensions_un4.*4.0e2-t2.*t5.*2.0e1+t4.*tensions_un1.*1.6e2+t4.*tensions_un2.*1.6e2+t11.*tensions_un1.*2.0e1+t11.*tensions_un2.*2.0e1-t11.*tensions_un3.*2.0e1-t11.*tensions_un4.*2.0e1-tensions_un1.*xi2.*2.0e3-tensions_un2.*xi2.*2.0e3-tensions_un3.*xi2.*2.0e3-tensions_un4.*xi2.*2.0e3+t2.*t4.*t5+t2.*t5.*t11-t2.*t3.*tensions_un1.*2.0e1+t2.*t3.*tensions_un2.*2.0e1+t6.*t9.*tensions_un2.*4.0e2+t6.*t10.*tensions_un1.*4.0e2+t6.*t9.*tensions_un4.*4.0e2+t6.*t10.*tensions_un3.*4.0e2+t4.*tensions_un1.*xi1.*4.0e2+t4.*tensions_un1.*xi2.*4.0e2-t4.*tensions_un2.*xi1.*4.0e2+t4.*tensions_un2.*xi2.*4.0e2+t11.*tensions_un1.*xi2.*1.0e2+t11.*tensions_un2.*xi2.*1.0e2+t11.*tensions_un3.*xi2.*1.0e2+t11.*tensions_un4.*xi2.*1.0e2+t3.*t6.*t9.*tensions_un3.*8.0e1-t3.*t6.*t10.*tensions_un4.*8.0e1-t6.*t9.*t11.*tensions_un2.*2.0e1-t6.*t10.*t11.*tensions_un1.*2.0e1-t6.*t9.*t11.*tensions_un4.*2.0e1-t6.*t10.*t11.*tensions_un3.*2.0e1+t2.*t3.*tensions_un1.*xi1.*3.0e2-t2.*t3.*tensions_un1.*xi2.*4.0e2+t2.*t3.*tensions_un2.*xi1.*3.0e2+t2.*t3.*tensions_un2.*xi2.*4.0e2-t2.*t3.*tensions_un3.*xi1.*1.0e2-t2.*t3.*tensions_un4.*xi1.*1.0e2+t2.*t3.*t6.*t9.*tensions_un1.*2.0e1+t2.*t3.*t6.*t9.*tensions_un3.*2.0e1-t2.*t3.*t6.*t10.*tensions_un2.*2.0e1-t2.*t3.*t6.*t10.*tensions_un4.*2.0e1-t3.*t6.*t9.*tensions_un3.*xi2.*4.0e2+t3.*t6.*t9.*tensions_un4.*xi1.*4.0e2+t3.*t6.*t10.*tensions_un3.*xi1.*4.0e2+t3.*t6.*t10.*tensions_un4.*xi2.*4.0e2-3.92e3).*(-1.0./2.0e1);t13.*(-t2.*tensions_un1+t2.*tensions_un2+t3.*tensions_un1.*7.0+t3.*tensions_un2.*7.0+t3.*tensions_un3+t3.*tensions_un4+t6.*t9.*tensions_un3.*4.0-t6.*t10.*tensions_un4.*4.0+t2.*tensions_un1.*xi1.*1.5e1-t2.*tensions_un1.*xi2.*2.0e1+t2.*tensions_un2.*xi1.*1.5e1+t3.*tensions_un1.*xi1.*2.0e1+t2.*tensions_un2.*xi2.*2.0e1-t2.*tensions_un3.*xi1.*5.0+t3.*tensions_un1.*xi2.*1.5e1-t3.*tensions_un2.*xi1.*2.0e1-t2.*tensions_un4.*xi1.*5.0+t3.*tensions_un2.*xi2.*1.5e1-t3.*tensions_un3.*xi2.*5.0-t3.*tensions_un4.*xi2.*5.0+t2.*t6.*t9.*tensions_un1+t2.*t6.*t9.*tensions_un3-t2.*t6.*t10.*tensions_un2+t3.*t6.*t9.*tensions_un2+t3.*t6.*t10.*tensions_un1-t2.*t6.*t10.*tensions_un4+t3.*t6.*t9.*tensions_un4+t3.*t6.*t10.*tensions_un3-t6.*t9.*tensions_un3.*xi2.*2.0e1+t6.*t9.*tensions_un4.*xi1.*2.0e1+t6.*t10.*tensions_un3.*xi1.*2.0e1+t6.*t10.*tensions_un4.*xi2.*2.0e1).*2.0e1];

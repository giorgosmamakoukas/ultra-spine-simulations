function lengths = lengths(x2,y2,z2,T2,G2,P2,x3,y3,z3,T3,G3,P3,x4,y4,z4,T4,G4,P4)
%LENGTHS
%    LENGTHS = LENGTHS(X2,Y2,Z2,T2,G2,P2,X3,Y3,Z3,T3,G3,P3,X4,Y4,Z4,T4,G4,P4)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    23-Feb-2016 18:08:09

t2 = sin(P2);
t4 = sqrt(3.0);
t5 = sin(T2);
t6 = cos(G2);
t7 = cos(P2);
t8 = cos(T2);
t9 = sin(G2);
t17 = t5.*t7.*(3.0./4.0e1);
t19 = t2.*t4.*t6.*(3.0./4.0e1);
t22 = t2.*t8.*t9.*(3.0./4.0e1);
t3 = abs(-t17-t19+t22+y2);
t12 = t2.*t5.*(3.0./4.0e1);
t13 = t4.*t6.*t7.*(3.0./4.0e1);
t14 = t7.*t8.*t9.*(3.0./4.0e1);
t47 = t4.*(3.0./4.0e1);
t10 = abs(t12-t13+t14+t47-x2);
t26 = t4.*t9.*(3.0./4.0e1);
t27 = t6.*t8.*(3.0./4.0e1);
t11 = abs(-t26-t27+z2+3.0./4.0e1);
t15 = cos(P3);
t18 = sin(T3);
t20 = cos(G3);
t21 = sin(P3);
t23 = cos(T3);
t24 = sin(G3);
t29 = t18.*t21.*(3.0./4.0e1);
t30 = t4.*t15.*t20.*(3.0./4.0e1);
t31 = t15.*t23.*t24.*(3.0./4.0e1);
t16 = abs(-t12+t13-t14+t29-t30+t31+x2-x3);
t34 = t15.*t18.*(3.0./4.0e1);
t36 = t4.*t20.*t21.*(3.0./4.0e1);
t39 = t21.*t23.*t24.*(3.0./4.0e1);
t25 = abs(-t17-t19+t22+t34+t36-t39+y2-y3);
t43 = t4.*t24.*(3.0./4.0e1);
t44 = t20.*t23.*(3.0./4.0e1);
t28 = abs(-t26-t27+t43+t44+z2-z3);
t32 = cos(P4);
t35 = sin(T4);
t37 = cos(G4);
t38 = sin(P4);
t40 = cos(T4);
t41 = sin(G4);
t53 = t35.*t38.*(3.0./4.0e1);
t54 = t4.*t32.*t37.*(3.0./4.0e1);
t55 = t32.*t40.*t41.*(3.0./4.0e1);
t33 = abs(-t29+t30-t31+t53-t54+t55+x3-x4);
t57 = t32.*t35.*(3.0./4.0e1);
t58 = t4.*t37.*t38.*(3.0./4.0e1);
t59 = t38.*t40.*t41.*(3.0./4.0e1);
t42 = abs(-t34-t36+t39+t57+t58-t59+y3-y4);
t61 = t4.*t41.*(3.0./4.0e1);
t62 = t37.*t40.*(3.0./4.0e1);
t45 = abs(-t43-t44+t61+t62+z3-z4);
t46 = abs(-t17+t19+t22+y2);
t48 = abs(t12+t13+t14-t47-x2);
t49 = abs(t26-t27+z2+3.0./4.0e1);
t50 = abs(-t12-t13-t14+t29+t30+t31+x2-x3);
t51 = abs(-t17+t19+t22+t34-t36-t39+y2-y3);
t52 = abs(t26-t27-t43+t44+z2-z3);
t56 = abs(-t29-t30-t31+t53+t54+t55+x3-x4);
t60 = abs(-t34+t36+t39+t57-t58-t59+y3-y4);
t63 = abs(t43-t44-t61+t62+z3-z4);
t74 = t7.*t8;
t75 = t2.*t5.*t9;
t76 = t74+t75;
t77 = t4.*t76.*(3.0./4.0e1);
t64 = abs(t17-t22-t47+t77+y2);
t67 = t4.*t5.*t6.*(3.0./4.0e1);
t65 = abs(t27-t67+z2-3.0./4.0e1);
t69 = t2.*t8;
t70 = t5.*t7.*t9;
t71 = t69-t70;
t72 = t4.*t71.*(3.0./4.0e1);
t66 = abs(t12+t14+t72+x2);
t79 = t4.*t18.*t20.*(3.0./4.0e1);
t68 = abs(t27-t44-t67+t79+z2-z3);
t81 = t21.*t23;
t82 = t15.*t18.*t24;
t83 = t81-t82;
t84 = t4.*t83.*(3.0./4.0e1);
t73 = abs(t12+t14-t29-t31+t72-t84+x2-x3);
t86 = t15.*t23;
t87 = t18.*t21.*t24;
t88 = t86+t87;
t89 = t4.*t88.*(3.0./4.0e1);
t78 = abs(t17-t22-t34+t39+t77-t89+y2-y3);
t97 = t4.*t35.*t37.*(3.0./4.0e1);
t80 = abs(t44-t62-t79+t97+z3-z4);
t99 = t38.*t40;
t100 = t32.*t35.*t41;
t101 = t99-t100;
t102 = t4.*t101.*(3.0./4.0e1);
t85 = abs(t29+t31-t53-t55+t84-t102+x3-x4);
t104 = t32.*t40;
t105 = t35.*t38.*t41;
t106 = t104+t105;
t107 = t4.*t106.*(3.0./4.0e1);
t90 = abs(t34-t39-t57+t59+t89-t107+y3-y4);
t91 = abs(t17-t22+t47-t77+y2);
t92 = abs(t27+t67+z2-3.0./4.0e1);
t93 = abs(t12+t14-t72+x2);
t94 = abs(t27-t44+t67-t79+z2-z3);
t95 = abs(t12+t14-t29-t31-t72+t84+x2-x3);
t96 = abs(t17-t22-t34+t39-t77+t89+y2-y3);
t98 = abs(t44-t62+t79-t97+z3-z4);
t103 = abs(t29+t31-t53-t55-t84+t102+x3-x4);
t108 = abs(t34-t39-t57+t59-t89+t107+y3-y4);
t118 = -t12+t13-t14+x2;
t109 = abs(t118);
t120 = t26+t27-z2+3.0./4.0e1;
t110 = abs(t120);
t111 = abs(t17+t19-t22+t47-y2);
t123 = t2.*t4.*t8.*(3.0./4.0e1);
t124 = t4.*t5.*t7.*t9.*(3.0./4.0e1);
t112 = abs(t12+t14+t29-t30+t31+t123-t124+x2-x3);
t113 = abs(t27+t43+t44-t67+z2-z3);
t127 = t4.*t7.*t8.*(3.0./4.0e1);
t128 = t2.*t4.*t5.*t9.*(3.0./4.0e1);
t114 = abs(t17-t22+t34+t36-t39+t127+t128+y2-y3);
t130 = t4.*t21.*t23.*(3.0./4.0e1);
t131 = t4.*t15.*t18.*t24.*(3.0./4.0e1);
t115 = abs(t29+t31+t53-t54+t55+t130-t131+x3-x4);
t116 = abs(t44+t61+t62-t79+z3-z4);
t134 = t4.*t15.*t23.*(3.0./4.0e1);
t135 = t4.*t18.*t21.*t24.*(3.0./4.0e1);
t117 = abs(t34-t39+t57+t58-t59+t134+t135+y3-y4);
t119 = t109.^2;
t121 = t110.^2;
t122 = abs(-t17-t19+t22+t47+y2);
t125 = abs(t12+t14+t29-t30+t31-t123+t124+x2-x3);
t126 = abs(t27+t43+t44+t67+z2-z3);
t129 = abs(-t17+t22-t34-t36+t39+t127+t128-y2+y3);
t132 = abs(t29+t31+t53-t54+t55-t130+t131+x3-x4);
t133 = abs(t44+t61+t62+t79+z3-z4);
t136 = abs(-t34+t39-t57-t58+t59+t134+t135-y3+y4);
t146 = t12+t13+t14-x2;
t137 = abs(t146);
t148 = t26-t27+z2-3.0./4.0e1;
t138 = abs(t148);
t139 = abs(-t17+t19+t22-t47+y2);
t140 = abs(t12+t14+t29+t30+t31+t123-t124+x2-x3);
t141 = abs(t27-t43+t44-t67+z2-z3);
t142 = abs(t17-t22+t34-t36-t39+t127+t128+y2-y3);
t143 = abs(t29+t31+t53+t54+t55+t130-t131+x3-x4);
t144 = abs(t44-t61+t62-t79+z3-z4);
t145 = abs(t34-t39+t57-t58-t59+t134+t135+y3-y4);
t147 = t137.^2;
t149 = t138.^2;
t150 = abs(-t17+t19+t22+t47+y2);
t151 = abs(t12+t14+t29+t30+t31-t123+t124+x2-x3);
t152 = abs(t27-t43+t44+t67+z2-z3);
t153 = abs(-t17+t22-t34+t36+t39+t127+t128-y2+y3);
t154 = abs(t29+t31+t53+t54+t55-t130+t131+x3-x4);
t155 = abs(t44-t61+t62+t79+z3-z4);
t156 = abs(-t34+t39-t57+t58+t59+t134+t135-y3+y4);
lengths = reshape([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,sqrt(t3.^2+t10.^2+t11.^2),sqrt(t46.^2+t48.^2+t49.^2),sqrt(t64.^2+t65.^2+t66.^2),sqrt(t91.^2+t92.^2+t93.^2),sqrt(t119+t121+t111.^2),sqrt(t119+t121+t122.^2),sqrt(t147+t149+t139.^2),sqrt(t147+t149+t150.^2),sqrt(t16.^2+t25.^2+t28.^2),sqrt(t50.^2+t51.^2+t52.^2),sqrt(t68.^2+t73.^2+t78.^2),sqrt(t94.^2+t95.^2+t96.^2),sqrt(t112.^2+t113.^2+t114.^2),sqrt(t125.^2+t126.^2+t129.^2),sqrt(t140.^2+t141.^2+t142.^2),sqrt(t151.^2+t152.^2+t153.^2),sqrt(t33.^2+t42.^2+t45.^2),sqrt(t56.^2+t60.^2+t63.^2),sqrt(t80.^2+t85.^2+t90.^2),sqrt(t98.^2+t103.^2+t108.^2),sqrt(t115.^2+t116.^2+t117.^2),sqrt(t132.^2+t133.^2+t136.^2),sqrt(t143.^2+t144.^2+t145.^2),sqrt(t154.^2+t155.^2+t156.^2)],[8, 4]);

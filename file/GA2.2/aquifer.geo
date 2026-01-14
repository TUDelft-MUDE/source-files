dens = 4;

Point(1) = {480., 020., 0, dens};
Point(2) = {-040., 050., 0, dens};
Point(3) = {-040., -030., 0, dens};
Point(6) = {080., -030., 0, dens};
Point(9) = {260., -070., 0, dens};
Point(7) = {480., -080., 0, dens};

Line(1) = {7, 1};
Line(2) = {1, 2};
Line(3) = {2, 3};
BSpline(17) = {3, 6, 9, 7};
Curve Loop(1) = {1, 2, 3, 17};

Point(11) = {80.5, 2.6, 0, dens};
Point(12) = {238.3, -17.3, 0, dens};
Point(13) = {124.5, 2.2, 0, dens};
Point(14) = {212, -14.9, 0, dens};
Point(15) = {102.2, 1.2, 0, dens};
Point(16) = {202, -20.1, 0, dens};

BSpline(18) = {11, 13, 14, 12};
BSpline(19) = {11, 15, 16, 12};
Curve Loop(2) = {19, -18};

Plane Surface(1) = {1,2};

Physical Curve(8) = {2};
Physical Surface(9) = {1};

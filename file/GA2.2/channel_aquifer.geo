// =====================================================================
//  channel_aquifer.geo  --  buried sinuous sand channel (plan view)
//
//  Features (all dimensions in m):
//    * meandering channel, 600 m long, width varying along its length
//    * elongated clay island in the second bend -> flow splits in two branches
//    * dead-end side pocket (old oxbow) on the north bank. 
//
//  Boundary treatment expected by the FE code:
//    * inlet  = straight vertical edge at x = 0   (only nodes with x = min(x))
//    * outlet = straight vertical edge at x = 600 (only nodes with x = max(x))
//    * only the "source_bank" boundary is exported as line elements
//      (physical group 8); the triangles are physical group 9.
//
//  Generate mesh:  gmsh channel_aquifer.geo -2 -format msh2 -o channel_aquifer.msh
//  (view/edit in the GUI:  gmsh channel_aquifer.geo)
// =====================================================================

Mesh.MshFileVersion = 2.2;
Mesh.Algorithm = 6;                     // Frontal-Delaunay: well-shaped triangles
Mesh.MeshSizeFromPoints = 0;            // element size is controlled by the
Mesh.MeshSizeFromCurvature = 0;         // background field defined at the end
Mesh.MeshSizeExtendFromBoundary = 0;

// ---------------- geometry parameters --------------------------------
L    = 600;    // channel length (x-extent)
A    = 40;     // meander amplitude
lam  = 420;    // meander wavelength
w0   = 50;     // basic (vertical) channel width
wb   = 50;     // extra width in the island bend
xb   = 315;    // x-position of the island bend
sb   = 60;     // length scale of the widening
wm   = 8;      // small width modulation amplitude
lm   = 260;    // wavelength of the width modulation
nx   = 100;    // number of bank segments (dx = L/nx = 6 m)

// ---------------- channel banks: points on both banks ----------------
For i In {0:nx}
  x  = L*i/nx;
  yc = A*Sin(2*Pi*x/lam);
  w  = w0 + wb*Exp(-((x-xb)/sb)^2) + wm*Cos(2*Pi*x/lm);
  Point(1000+i) = {x, yc+w/2, 0};      // north bank
  Point(2000+i) = {x, yc-w/2, 0};      // south bank
EndFor

// ---------------- dead-end pocket (oxbow) on the north bank ----------
// The pocket outline starts on bank point i=30 (x=180), ends on bank point
// i=36 (x=216), and is described in a local frame (u,s):
//   u = horizontal offset from the neck axis xn,
//   s = height above the local bank line.
// The shear term m*u*exp(-s/10) makes the mouth follow the sloping bank
// and fades out higher up, so the neck and bulb stay upright.
xn = L*33/nx;                          // neck axis, x = 198

// bank height and bank slope at the neck axis
yv[] = {};
For j In {0:2}
  xs = xn + 3*(j-1);
  yv[] += {A*Sin(2*Pi*xs/lam) + 0.5*(w0 + wb*Exp(-((xs-xb)/sb)^2) + wm*Cos(2*Pi*xs/lm))};
EndFor
yb = yv[1];                            // bank height at xn
m  = (yv[2]-yv[0])/6;                  // bank slope at xn

// left half of the outline, from the bank up to the top of the bulb
// (mouth flare -> 12 m neck -> bulb);  the right half is its mirror image
uL = {-13.0, -9.5, -7.4, -6.3, -6.0, -6.5, -9.5, -16.0, -24.0, -29.5, -28.5, -20.0, -9.0};
sL = {  1.5,  4.5,  9.0, 15.0, 21.0, 27.0, 32.0,  36.5,  42.0,  51.0,  61.0,  68.0, 71.5};
np = 13;                               // entries per side

For k In {0:np-1}
  Point(4100+k) = {xn + uL[k],  yb + m*uL[k]*Exp(-sL[k]/10) + sL[k], 0};  // left
  Point(4200+k) = {xn - uL[k],  yb - m*uL[k]*Exp(-sL[k]/10) + sL[k], 0};  // right (mirror)
EndFor
Point(4300) = {xn, yb + 73, 0};        // top of the bulb

// ---------------- island (hole): elongated clay lens -----------------
xi  = xb;                              // centre of the island
yi  = A*Sin(2*Pi*xi/lam) + 6;          // slightly north of the centre line
For k In {0:11}
  th = 2*Pi*k/12;
  x = xi + 68*Cos(th);
  Point(3000+k) = { x, yi + 13*Sin(th)*(1+0.25*Cos(th)) + 0.1*(x-xi), 0};
EndFor

// ---------------- curves ---------------------------------------------
Spline(1) = {2000:2000+nx};            // south bank
Line(2)   = {2000+nx, 1000+nx};        // outlet  (x = L)
Spline(3) = {1036:1100};               // north bank downstream of pocket
// pocket outline: bank point 1030 -> left side -> top -> right side -> bank point 1036
Spline(5) = {1030, 4100:4100+np-1, 4300, 4200+np-1:4200:-1, 1036};
Spline(7) = {1018:1030};               // north bank, between source and pocket
Spline(8) = {1008:1018};               // north bank, source zone (x=48..108)
Spline(9) = {1000:1008};               // north bank, upstream part
Line(10)  = {1000, 2000};              // inlet   (x = 0)
Spline(20) = {3000:3011, 3000};        // island boundary (closed)

Curve Loop(1) = {1, 2, -3, -5, -7, -8, -9, 10};
Curve Loop(2) = {20};
Plane Surface(1) = {1, 2};

// ---------------- physical groups ------------------------------------
Physical Curve("source_bank", 8) = {7, 8, 9};   // possible spill boundary
Physical Surface("aquifer", 9)   = {1};

// ---------------- mesh size: local refinement ------------------------
// Fine near the source bank, around the island and at the pocket neck;
// gradual coarsening elsewhere.
fac   = 1.0;                 // global mesh scaling: 2 = coarser, 0.5 = finer
hmin  = 3*fac;   
hmax = 6*fac;
hisl  = 3.0*fac;             // around the island
hneck = 4.0*fac;             // at the pocket neck
hbulb = 4.0*fac;             // along the pocket outline

Field[1] = Distance;  Field[1].CurvesList = {7, 8};     Field[1].Sampling = 100;
Field[2] = Threshold; Field[2].InField = 1;
  Field[2].SizeMin = hmin; Field[2].SizeMax = hmax; Field[2].DistMin = 5;  Field[2].DistMax = 40;

Field[3] = Distance;  Field[3].CurvesList = {20};       Field[3].Sampling = 200;
Field[4] = Threshold; Field[4].InField = 3;
  Field[4].SizeMin = hisl;    Field[4].SizeMax = hmax; Field[4].DistMin = 4;  Field[4].DistMax = 35;

// pocket neck: fine mesh in a ball around the neck, coarser along the bulb
Field[5] = Ball;
  Field[5].XCenter = xn;  Field[5].YCenter = yb + 12;  Field[5].ZCenter = 0;
  Field[5].Radius = 16;   Field[5].Thickness = 18;
  Field[5].VIn = hneck;       Field[5].VOut = hmax;

Field[7] = Distance;  Field[7].CurvesList = {5};        Field[7].Sampling = 200;
Field[8] = Threshold; Field[8].InField = 7;
  Field[8].SizeMin = hbulb;    Field[8].SizeMax = hmax; Field[8].DistMin = 2;  Field[8].DistMax = 20;

Field[10] = Min; Field[10].FieldsList = {2, 4, 5, 8};
Background Field = 10;

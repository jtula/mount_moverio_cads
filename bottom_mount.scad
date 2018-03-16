use<shapes2.scad>;

X = 0;
Y = 1;
Z = 2;

//--common parameters
sloping_angle = 10;
angle = 30;
extra = 5;
fn = 30;

//--bottom square parameters
poly_width = 24;
poly_height = 4;
poly_depth = 26;

//--left and right side parameters
side_width = poly_width;
side_height = 24;
side_depth = 4;
side_rot = [90, 0, 0];

//--inner mold parameters
iw = 18.5;
ih = poly_width + extra;
id = 31;
ir = 2;
cs = 0.8;

//--Positions
pos_base = [-poly_width/4, 0, 0];
pos_square = [-15, -poly_depth/2, 3.5];
pos_left_side = [pos_square[X], pos_square[Y]+side_depth, pos_square[Z]+poly_height];
pos_right_side = [pos_square[X], -pos_square[Y], pos_square[Z]+poly_height];
pos_inner_mold = [pos_square[X]+poly_width/2, 0, pos_square[Z]+19];

difference() {
  union(){
  //-------------------LEFT SIDE----------------------------//
  translate(pos_left_side)
  rotate(side_rot)
    cube([side_width, side_height, side_depth], false);

  //-------------------RIGHT SIDE----------------------------//
  translate(pos_right_side)
  rotate(side_rot)
    cube([side_width, side_height, side_depth], false);

  //-------------------SQUARE BASE-------------------------//
  sa = sin(sloping_angle) * poly_width + 0.5;
  p0 = [0         ,          0,           0];
  p1 = [poly_width,          0,         -sa];
  p2 = [poly_width, poly_depth,         -sa];
  p3 = [0         , poly_depth,           0];
  p4 = [0         ,          0, poly_height];
  p5 = [poly_width,          0, poly_height];
  p6 = [poly_width, poly_depth, poly_height];
  p7 = [0         , poly_depth, poly_height];

  cubePoints = [
    p0, p1, p2, p3,
    p4, p5, p6, p7 
  ];
		
  cubeFaces = [
    [0,1,2,3],
    [4,5,1,0],
    [7,6,5,4],
    [5,6,2,1],
    [6,7,3,2], 
    [7,4,0,3]];

  translate(pos_square)
    polyhedron( cubePoints, cubeFaces );

  //-------------------CYLINDRICAL ARM--------------------//
  cyl_height = 20;
  cyl_radius = 1.3;
  cyl_rot = [0, sloping_angle + 90, angle];
 
  rect_bridge_width = cyl_height/3;
  rect_bridge_height = cyl_radius;
  rect_bridge_depth = cyl_radius;
  rect_bridge_size = [rect_bridge_width, rect_bridge_height, rect_bridge_depth];

  y0 = sin(angle) * cyl_height/4;
  z0 = sin(sloping_angle) * cyl_height/2;

  pos_cyl = [0, 0, 0];
  rect_bridge_pos = [pos_cyl[X]-cyl_height/2 + rect_bridge_width, 
                             pos_cyl[Y]-y0 + rect_bridge_depth/2, 
                             pos_cyl[Z]+z0 + 0.3];

  translate(pos_base)
    union() {
      //--cylinder base
      translate(pos_cyl)
      rotate(cyl_rot) {
        rcylinder(r = cyl_radius, h = cyl_height, both = true, center = true, $fn = fn);
      }

      //--rectangle bridge
      translate(rect_bridge_pos)
      rotate([0, sloping_angle, angle])
        cube(rect_bridge_size, center=true);	
    }
}

//------------------------INNER MOLD-----------------------------//
translate(pos_inner_mold)	
  difference() {
    innerMold([ih, iw, id], ir, ir, cs, fn);	
    translate([0, -ir*2, 14.5])
    cube([ih, 9, 2.5], true);
  }

}

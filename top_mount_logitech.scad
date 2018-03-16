use<shapes2.scad>;

module top_arm(width, height, screw_radius, screw_distance, nscrew, pos_arm=[0,0,0], fn=30) {

  arm_radius = 3;
  arm_point_ref = [width, 0, height];
  arm_points = [
      [0      , 0, 0],
      [width/2, 0, 0],
      arm_point_ref
    ];

  supp_base_width = 15;
  supp_base_height = 14;
  supp_base_depth = 3;
	
  translate(pos_arm)
  union() {
    pos_cyl = [arm_point_ref[0], arm_point_ref[1], arm_point_ref[2]+arm_radius];
    translate(pos_cyl)
      difference() {
        cube([supp_base_width, supp_base_height, supp_base_depth], true);
        union() {					
          for (i=[0:nscrew-1]) {
            translate([i*screw_distance - supp_base_width/4, -supp_base_height/2+screw_radius*8, -supp_base_depth/2+0.5])
              cylinder(r=screw_radius, h=supp_base_depth, $fn=20);
          }
          for (i=[0:nscrew-1]) {
            translate([i*screw_distance - supp_base_width/4, supp_base_height/2-screw_radius*8, -supp_base_depth/2+0.5])
              cylinder(r=screw_radius, h=supp_base_depth, $fn=fn);
          }
        }
      }

    hull(){
      for(pos = arm_points)
        translate(pos)
        rotate([90, 0, 0])
          cylinder(r = arm_radius, h = height, center = true, $fn = fn);
    }
  }	
}

module top_base(width, height, depth, pos_base=[0, 0, 0], fn=30) {

  angle = -2;
  extra = 5;

  //--inner mold parameters
  imoldWidth = 19;
  imoldHeight = width+extra;
  imoldDepth = 10;
  imoldRadius = 2;
  cs = 0.6;

  posInnerMold = [pos_base[0], pos_base[1], pos_base[2] - depth];

  difference() {
    translate(pos_base)
      cube([width, height, depth], true);

    rotate([0, 0, -angle])
    translate(posInnerMold)		
      difference() {
        innerMold([imoldHeight, imoldWidth, imoldDepth], imoldRadius, imoldRadius, cs, fn);	
        translate([0, -imoldRadius*2-2, imoldRadius+1])
          cube([imoldHeight, imoldDepth, 4], true);
      }
  }
}

module top(pos=[0,0,0]) {
  topArmWidth = 5;
  topArmHeight = 6;
  screw_radius = 0.8/2;
  screw_distance = 4;
  nscrew = 3;
  fn = 30;
  twidth = 24;
  theight = 26;
  tdepth = 6;

  pos_base = [0, 0, 0];
  pos_arm = [-(pos_base[0] + twidth/2 - topArmHeight/2), pos_base[1] + theight/2 - topArmHeight/2 , pos_base[2] + tdepth/2];

  translate(pos) {
    top_arm(topArmWidth, topArmHeight, screw_radius, screw_distance, nscrew, pos_arm, fn);
    top_base(twidth, theight, tdepth, pos_base, fn);	
  }
}

top();
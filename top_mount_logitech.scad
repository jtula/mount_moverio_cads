use<shapes2.scad>;

module top_arm(width, height, screw_radius, screw_distance, nscrew, pos_arm=[0,0,0], logitech=true, fn=100) {

  cyl_height = 10;
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
      if(logitech) {
        difference() {
          cube([supp_base_width, supp_base_height, supp_base_depth], true);
          union() {					
            for (i=[0:nscrew-1]) {
              translate([i*screw_distance - supp_base_width/4, 
                        -supp_base_height/2+screw_radius*8, 
                        -supp_base_depth/2+0.5])
                cylinder(r=screw_radius, h=supp_base_depth, $fn=20);
            }
            for (i=[0:nscrew-1]) {
              translate([i*screw_distance - supp_base_width/4, 
                        supp_base_height/2-screw_radius*8, 
                        -supp_base_depth/2+0.5])
                cylinder(r=screw_radius, h=supp_base_depth, $fn=fn);
            }
          }
        }
      } else {
        translate([arm_radius+1, 0, 0])
        rotate([90, 90, 0])
          cylinder(r=arm_radius, h=cyl_height, center=true, $fn=fn);
      }

    hull(){
      for(pos = arm_points)
        translate(pos)
        rotate([90, 0, 0])
          cylinder(r = arm_radius, h = height, center = true, $fn = fn);
    }
  }	
}

module top_base(width, height, depth, pos_base=[0, 0, 0], fn=100) {

  angle = -2;
  extra = 5;

  //--inner mold parameters
  imoldWidth = 19;
  imoldHeight = width+extra;
  imoldDepth = 10;
  imoldRadius = 2;
  cs = 0.6;

  posInnerMold = [pos_base[0], pos_base[1], pos_base[2] - (depth/2 + imoldDepth/2 - 2)];

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

module top(pos=[0,0,0], both) {
  topArmWidth = 5;
  topArmHeight = 6;
  screw_radius = 0.8/2;
  screw_distance = 4;
  screw_side_hdistance = screw_radius*2 + 5;
  screw_side_vdistance = screw_radius*2 + 2;
  nscrew = 3;
  fn = 100;
  twidth = 24;
  theight = 26;
  tdepth = 6;

  //--left and right side parameters
  side_width = twidth;
  side_height = 15;
  side_depth = 4/2;
  side_rot = [90, 0, 0];

  pos_base = [0, 0, 0];
  pos_arm = [-(pos_base[0] + twidth/2 - topArmHeight/2), 
             pos_base[1] + theight/2 - topArmHeight/2, 
             pos_base[2] + tdepth/2];

  pos_right_side = [pos[0] - side_width/2, 
                   pos[1] + theight/2, 
                   pos[2] - side_height-tdepth/2];

  pos_left_side = [pos[0] - side_width/2, 
                    pos[1] - theight/2+side_depth, 
                    pos[2] - side_height-tdepth/2];

  //-------------------LEFT SIDE----------------------------//
  translate(pos_left_side)
    rotate(side_rot)
    cube([side_width, side_height, side_depth]);
    for (i=[0:nscrew-1]) {
      for (j=[0:nscrew-1]) {
        translate([pos_left_side[0]+side_width/4 + j*screw_side_hdistance, 
                 pos_left_side[1], 
                 pos_left_side[2]/1.2 + i*screw_side_vdistance])
        rotate(side_rot)
          rcylinder(r=screw_radius, h=side_depth, false, false, fn);
      }
    }


  //-------------------RIGHT SIDE----------------------------//
  translate(pos_right_side)
    rotate(side_rot)
    cube([side_width, side_height, side_depth]);
    for (i=[0:nscrew-1]) {
      for (j=[0:nscrew-1]) {
        translate([pos_left_side[0]+side_width/4 + j*screw_side_hdistance, 
                 pos_right_side[1]-side_depth, 
                 pos_right_side[2]/1.2 + i*screw_side_vdistance])
        rotate(-side_rot)
          rcylinder(r=screw_radius, h=side_depth, false, false, fn);
      }
    }

  translate(pos) {
    if (both) {
      top_arm(topArmWidth, topArmHeight, screw_radius, screw_distance, nscrew, pos_arm, fn);
      top_base(twidth, theight, tdepth, pos_base, fn);	 
    } else {      
      difference() {    
        top_base(twidth, theight, tdepth, pos_base, fn);	
        translate([pos_arm[0], pos_arm[1], pos_arm[2]-topArmHeight/1.5])
        rcylinder(screw_radius*3, topArmHeight, false, true, fn);
      }
    }
  }
}

module arm(pos=[0,0,0], logitech=true) {

  topArmWidth = 5;
  topArmHeight = 6;
  screw_radius = 0.8/2;
  screw_distance = 4;
  nscrew = 4;
  fn = 100;

  pos_arm = pos;
  top_arm(topArmWidth, topArmHeight, screw_radius, screw_distance, nscrew, pos_arm, logitech, fn);
  translate([pos_arm[0], pos_arm[1], pos_arm[2]-topArmHeight*1.2])
    rcylinder(screw_radius*3, topArmHeight, false, true, fn);
}
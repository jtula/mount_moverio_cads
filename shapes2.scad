module innerMold(size, r, s, cs, fn=20) {
  borderRadius = r;
  moldSize = [size[0], size[1], size[2]];

  coords = (moldSize - [2*borderRadius, 2*borderRadius, 2*borderRadius])/2;

  x = coords[0];
  y = coords[1];
  z = coords[2];

  positions = [
    [ x,     y,   z],
	  [ x,     0,   z],
    [-x,     0,   z],
    [-x,     y,   z],
    [-x,    -y, z-s],
    [ 0, -y-cs, z-s],
    [ x,    -y, z-s],
    [ x,     y,  -z],
    [-x,     y,  -z],
    [-x,    -y,  -z],
    [ 0, -y-cs,  -z],
    [ x,    -y,  -z]
  ];

  hull() {
    for(pos = positions)
      translate(pos)
        sphere(r = borderRadius, $fn = fn); 
  }
}


//-- from http://www.iearobotics.com/wiki/index.php
module rcylinder(r, h, center, both, $fn = 100) { 
  hc = (both == true) ? h - 2 * r : h - r;
  posc = (center == true) ? 0 : h/2;
  translate([0, 0, posc])
    if (both == true) {
      cylinder(r = r, h = hc, center = true, $fn = $fn);
      for (i = [-1, 1])
        translate([0, 0, i * hc / 2])
          sphere(r = r);          
    } else {
      translate([0, 0, -h/2]) {
        cylinder(r = r, h = hc, $fn = $fn);
          translate([0, 0, hc]) 
						sphere(r = r, $fn = $fn);
      }
		}       
}

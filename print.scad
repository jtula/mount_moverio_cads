use<top_mount.scad>;
use<bottom_mount.scad>;

top([0,22,0], false);
arm([-2,0,-7.5]);
bottom([0,-10,-12], [90,90,0]);
arm([-2,45,-9], false);


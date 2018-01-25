include <parameters.scad>
use <util.scad>
use <sweep.scad>

pl_w = Zip_w;
x_w = 30;
max_i = floor(x_w/pl_w)-1;
wedge_st = 0.6;
opening = 4;
connect_l = 0.5;
ang = atan((wedge_st*(max_i+1))/x_w);
shorten_beam = 5*x_w/6;

translate([(x_w-connect_l-max_i*pl_w)/2,0,0])
hook(0);

// Hooks for line
hook_h = 6;
wall_th = Wall_th;
w = 2*wedge_st*(max_i+1);
h = 10;
module hook(ang=2){
  translate([-2.5/2,w/2-1,h-1])
    rotate([-90,0,0])
    rounded_cube2([2.5, h-1, 2.5+2],0.8,$fn=4*4);
  translate([0,2+w/2+2.5/2,0])
    rotate([0,0,ang])
    translate([-hook_h/2,-2.5/2,0])
    rounded_cube([hook_h, 2.5, h],1,$fn=4*3);
}

// wedge steps
intersection(){
  for(i=[0:max_i])
    cube([x_w-connect_l-i*pl_w, wedge_st*(i+1), h]);
    left_rounded_cube2([x_w, wedge_st*(max_i+1), h],1,$fn=4*4);
}
//beam
translate([0,(wedge_st*(max_i+1)) + opening - 0.05, 0])
  rotate([0,0,-ang])
    translate([shorten_beam,0,0])
      cube([x_w-shorten_beam, wedge_st, h]);
// swing
translate([x_w-connect_l,(opening+wedge_st)/2,0])
  rotate([0,0,-90])
    sweep(circle_sector(180-ang, (opening-wedge_st)/2,
                                 (opening+wedge_st)/2),
      [translation([0,0,0]),translation([0,0, h])]);

// Bends arms outwards, so pressure is distributed over beam flat-sides
//beam_slider();
module beam_slider(){
  extra_length = 6;

  module arm(){
    difference(){
      union(){
        clamp_wall(10,extra_length=Clamp_wall_extra_length+1.45);
        translate([Beam_width/2+3.5/2+2.4, -Beam_width/2-3.2, h/2])
          rotate([90,0,0])
          cylinder(d=5.6/cos(30)+2, h=1.5, $fn=6);
      }
      translate([Beam_width/2+3.5/2+2.4, 0, h/2])
        rotate([90,0,0])
        cylinder(d=3.5, h=w+10, center=true, $fs=1);
      translate([Beam_width/2+3.5/2+2.4, -Beam_width/2-3.2, h/2])
        rotate([90,0,0])
        cylinder(d=5.6/cos(30), h=3, $fn=6);
    }
  }
  arm();
  mirror([0,1,0])
    arm();
  translate([-wall_th-Fat_beam_width/2,-w/2,0])
    rounded_cube2([wall_th, w, h],1,$fn=4*4);
  rotate([0,0,90])
    hook(0);

  for(k=[0,1])
    mirror([0,k,0]){
      hook();
    }
}


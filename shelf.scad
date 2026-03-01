$fn = 100;

module shelf(length, width, thickness, fingerSlotSize){
  difference(){
    cube([length, width, thickness], true);
    translate([0,width/2,-thickness]) cylinder(r=fingerSlotSize, h=thickness*2);
  } 
}

shelf(50, 50, 1, 10);
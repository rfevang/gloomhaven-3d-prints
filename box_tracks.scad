module boxTracks(outerL, outerW, depth, radiusCorner, trackSize, thickness, innerFill){
  difference(){
    union(){
      difference(){
        minkowski(){
          cube([outerL-radiusCorner*2,outerW-radiusCorner*2,depth], true);
          translate([0,0,-1/2])cylinder(r=radiusCorner,h=1,$fn=100);
        }

        translate([0,0,0])
        minkowski(){
          cube([outerL-radiusCorner*2-thickness*2,outerW-radiusCorner*2-thickness*2,depth+1], true);
          translate([0,0,-1/2])cylinder(r=radiusCorner,h=1,$fn=100);
        }
      }

      difference(){
        union(){
          minkowski(){
            cube([outerL-radiusCorner*2-thickness*2-trackSize*2,outerW-radiusCorner*2-thickness*2-trackSize*2,depth], true);
            translate([0,0,-1/2])cylinder(r=radiusCorner,h=1,$fn=100);
          }
        }

        if(innerFill){
          translate([0,0,0])
            minkowski(){
              cube([outerL-radiusCorner*2-thickness*4-trackSize*2,outerW-radiusCorner*2-thickness*4-trackSize*2,depth+1], true);
              translate([0,0,-1/2])cylinder(r=radiusCorner,h=1,$fn=100);
            }
          }
      }
    }
    translate([(outerL-radiusCorner)/2,(outerW-radiusCorner)/2,0])
      cube([radiusCorner+thickness,radiusCorner+thickness,depth*2],true);
  }
  //color([1,1,1]){
    translate([(outerL-radiusCorner-thickness*2-trackSize*2)/2,(outerW-radiusCorner-thickness*2-trackSize*2)/2,0])
      cube([radiusCorner,radiusCorner,depth+1],true);
    translate([(outerL-thickness)/2-4.5,(outerW-thickness)/2,0])
      cube([radiusCorner-1,1,depth+1],true);
    translate([(outerL-thickness)/2,(outerW)/2-5,0])
      cube([1,radiusCorner-1,depth+1],true);
  //}
}

boxTracks(50, 30, 15, 5, 1, 2, true);
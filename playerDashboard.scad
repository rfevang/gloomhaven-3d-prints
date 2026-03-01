c = 1;
m = 2;
thickness = 1;
// all meassures of cards include sleeves
cardHeight = 0.6;

charAbilityLength = 92.2;
charAbilityWidth = 66.8;
// stack of 30 cards
charAbilityHeight = 17.3;

attackModifierLength = 46.2;
attackModifierWidth = 71.2;
// stack of 40 cards
attackModifierHeight = 24;

charInfoLength = 95.25;
charInfoWidth = 145.8;
charInfoHeight = 2.25;

// diameter
charToken = 11;

// Minaturebox
charMinLength = 60;
charMinWidth = 35;
charMinHeight = 31;

sheetLength = 141;
sheetWidth = 115;
sheetThickness = 1.2;

// fingerSlot
fingerSlotSize = 10;


// indicator
indicatorWidth = 14.2;
indicatorHeight = 2.1;

tolerence = 0.3;
radius_cutout = 4.6;

play = 0; // [0,1]
lidPos = (play == 1) ? 180 : 0;

module myrotate(a, orig) {
    translate(orig)
    rotate(a)
    translate(-orig)
      children();
}


module chainLink(length, width, thickness){
  difference(){
    cube([length, width, thickness], true);
    cube([length-thickness*2, width-thickness*2, thickness+c], true);
  }
}

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

module MakeSide(length2, width2, gridSize2, gridThickness2, gridHeight, thickness2) {
  gridActualNumLength = length2 / gridSize2;
  gridNumLength = round(gridActualNumLength);
  gridActualNumWidth = width2 / gridSize2;
  gridNumWidth = round(gridActualNumWidth); 
  difference() {
    translate([((gridSize2 * gridNumLength) * -0.5), ((gridSize2 * gridNumWidth) * -0.5), 0]){
      for (j = [0 : abs(1) : gridNumWidth]) {
        for (i = [0 : abs(1) : gridNumLength]) {
          translate([(i * gridSize2), (j * gridSize2), 0]){
            rotate_extrude($fn=4){
              translate([(gridSize2 / 2), 0, 0]){
                square([gridThickness2, gridHeight], center=true);
              }
            }
          }
        }

      }

    }

    difference() {
        cube([(length2 + gridSize2*2), (width2 + gridSize2*2), gridThickness2+c], center=true);
        cube([(length2 - thickness2 * 2), (width2 - thickness2 * 2), gridThickness2 + c], center=true);
    }
  }
}



module snap(length, width, height, thickness, lockDepth, tolerance, female){
  module hook(){
      polyhedron(points=[[0,0,0],[1.5*lockDepth,0,0],[0, lockDepth,0],
                      [0,0,height],[1.5*lockDepth,0,height],[0, lockDepth,height]],
              faces=[[0,1,2],[0,2,5,3],[0,3,4,1],[1,4,5,2],[3,5,4]]);
  }
  
  if(female){
    translate([-length/2+1/2,0,0]) cube([1, width, height], true);
    translate([0,width/2-thickness/2-thickness*2,0]) cube([length, thickness, height], true);
    translate([length/2-1.5*lockDepth,width/2-thickness*2,-height/2]) hook();
    
    translate([-length/2+1/2,0,0]) cube([1, width, height], true);
    translate([0,-(width/2-thickness/2-thickness*2),0]) cube([length, thickness, height], true);
    translate([length/2-1.5*lockDepth,-(width/2-thickness*2),height/2]) rotate([180,0,0])hook();
    
  }else{
    translate([length/2-(1-tolerence)/2,0,0]) cube([1-tolerence, width, height], true);
    translate([0,width/2-thickness/2+tolerence/2,0]) cube([length, thickness-tolerence, height], true);
    translate([-(length/2-1.5*lockDepth-1-tolerence),width/2-thickness*3/2+tolerence,0]) cube([length-2*1.5*lockDepth-1-tolerance, thickness, height], true);
    translate([-(length-1.5*lockDepth-1+tolerance)/2+1,(width/2-thickness+tolerence),height/2-height]) rotate([180,180,0]) hook();
    
    translate([length/2-(1-tolerence)/2,0,0]) cube([1-tolerence, width, height], true);
    translate([0,-(width/2-thickness/2+tolerence/2),0]) cube([length, thickness-tolerence, height], true);
    translate([-(length/2-1.5*lockDepth-1-tolerence),-(width/2-thickness*3/2+tolerence),0]) cube([length-2*1.5*lockDepth-1-tolerance, thickness, height], true);
    translate([-(length-1.5*lockDepth-1+tolerance)/2+1,-(width/2-thickness+tolerence),height/2]) rotate([0,180,0]) hook();
  }
}


radiusCorner = 7;

//
// Sidepanel
/*
union(){
  difference(){
    union(){
      translate([charAbilityLength/2+thickness*5/2+1,0,0]) 
        rotate([270,0,90])
          boxTracks(attackModifierWidth+m*2+thickness*6+2, attackModifierHeight+thickness*4+2, 2, radiusCorner, 1, thickness, false);
    }
    
    translate([charAbilityLength/2+thickness*4/2,50,14])
      rotate([90,90,0]) {
      difference(){
        cylinder(r=2,h=100,$fn=4);
        translate([1,0,50]) cube([2,5,100],true);
      }
      translate([0.5,0,50]) cube([1,4,100],true);
    }
    
    
    translate([0,6.1,0])
      cube([charAbilityLength+thickness*7,attackModifierWidth+8,thickness+0.5], true);
    translate([charAbilityLength/2+thickness*3/2,67,0.75]) rotate([90,90,0])
       cylinder(r=2,h=100,$fn=4);
    
    translate([0,6.1,-8.5])
      cube([charAbilityLength+thickness*7,attackModifierWidth+8,thickness+0.5], true);
    translate([charAbilityLength/2+thickness*3/2,67,0.75-8.5]) rotate([90,90,0]) 
      cylinder(r=2,h=100,$fn=4);
    
    translate([0,-33,attackModifierHeight/2-3.5])
      cube([charAbilityLength+thickness*7,thickness+0.5,attackModifierHeight+11.5], true);
    
  translate([charAbilityLength/2+thickness*4/2,50,-13])
      rotate([90,90,0]) {
      difference(){
        cylinder(r=3,h=100,$fn=4);
        translate([1.5,0,50]) cube([2.9,7,100],true);
      }
      //translate([0.25,0,50]) cube([0.5,4,100],true);
    }
  }
  //translate([charAbilityLength/2+thickness*4/2,-attackModifierWidth/2-thickness*2,-attackModifierHeight/2-thickness*0]) cube([2,7,7],true);
  
  
  translate([charAbilityLength/2+thickness*5.5,0,0]) rotate([90,0,90])
  union(){
    difference(){
        minkowski(){
          cube([attackModifierWidth+m*2+thickness*8-radiusCorner*2,attackModifierHeight+thickness*4+2-radiusCorner*2,0.001], true);
          translate([0,0,-3/2]) cylinder(r=radiusCorner,h=2,$fn=100);
        }
      }
    translate([-(attackModifierWidth+m*2+thickness*8-radiusCorner)/2,(attackModifierHeight+thickness*4+2-radiusCorner)/2,-0.5]) 
      cube([radiusCorner, radiusCorner ,2], true);
    translate([(attackModifierWidth+m*2+thickness*8-radiusCorner)/2,-(attackModifierHeight+thickness*4+2-radiusCorner)/2,-0.5]) 
      cube([radiusCorner, radiusCorner ,2], true);
    translate([-(attackModifierWidth-radiusCorner+thickness*3)/2,-(attackModifierHeight-radiusCorner-thickness*3)/2,-3.5]) 
      difference(){
        translate([-radiusCorner-1,-radiusCorner-1,0])cube([radiusCorner+1, radiusCorner+1 ,4]);
        translate([0,0,-0.5])cylinder(r=radiusCorner,h=5,$fn=100);
      }
  }
}

//
// back curve
/*
translate([-charAbilityLength/2-thickness*5.5,-attackModifierWidth/2+thickness*2,attackModifierHeight/2-radiusCorner+thickness*2])rotate([0,90,0])
  difference(){

  

    translate([-radiusCorner-1,-radiusCorner-1,0])cube([radiusCorner+1, radiusCorner-2.5 ,103]);
    translate([0,0,-0.5])cylinder(r=radiusCorner,h=104,$fn=100);
  }


//
// Sidepanel  
/*
rotate([0,0,180])mirror([0,1,0]){
    difference(){
    union(){
      translate([charAbilityLength/2+thickness*5/2+1,0,0]) 
        rotate([270,0,90])
          boxTracks(attackModifierWidth+m*2+thickness*6+2, attackModifierHeight+thickness*4+2, 2, radiusCorner, 1, thickness, false);
    }
    
    translate([charAbilityLength/2+thickness*6/2,50,14])
      rotate([90,90,0]) {
      difference(){
        cylinder(r=2,h=100,$fn=4);
        translate([1,0,50]) cube([2,5,100],true);
      }
      translate([0.5,0,50]) cube([1,4,100],true);
    }
    
    
    translate([0,6.1,0])
      cube([charAbilityLength+thickness*7,attackModifierWidth+8,thickness+0.5], true);
    translate([charAbilityLength/2+thickness*3/2,67,0.75]) rotate([90,90,0])
       cylinder(r=2,h=100,$fn=4);
    
    translate([0,6.1,-8.5])
      cube([charAbilityLength+thickness*7,attackModifierWidth+8,thickness+0.5], true);
    translate([charAbilityLength/2+thickness*3/2,67,0.75-8.5]) rotate([90,90,0]) 
      cylinder(r=2,h=100,$fn=4);
    
    translate([0,-33,attackModifierHeight/2-3.5])
      cube([charAbilityLength+thickness*7,thickness+0.5,attackModifierHeight+11.5], true);
    
  translate([charAbilityLength/2+thickness*4/2,50,-13])
      rotate([90,90,0]) {
      difference(){
        cylinder(r=3,h=100,$fn=4);
        translate([1.5,0,50]) cube([2.9,7,100],true);
      }
      //translate([0.25,0,50]) cube([0.5,4,100],true);
    }
  }
  //translate([charAbilityLength/2+thickness*4/2,-attackModifierWidth/2-thickness*2,-attackModifierHeight/2-thickness*0]) cube([2,7,7],true);
  
  
  translate([charAbilityLength/2+thickness*5.5,0,0]) rotate([90,0,90])
  union(){
    difference(){
        minkowski(){
          cube([attackModifierWidth+m*2+thickness*8-radiusCorner*2,attackModifierHeight+thickness*4+2-radiusCorner*2,0.001], true);
          translate([0,0,-1/2]) cylinder(r=radiusCorner,h=1,$fn=100);
        }
      }
    translate([-(attackModifierWidth+m*2+thickness*8-radiusCorner)/2,(attackModifierHeight+thickness*4+2-radiusCorner)/2,0]) cube([radiusCorner, radiusCorner ,1], true);
    translate([(attackModifierWidth+m*2+thickness*8-radiusCorner)/2,-(attackModifierHeight+thickness*4+2-radiusCorner)/2,0]) cube([radiusCorner, radiusCorner ,1], true);
    translate([-(attackModifierWidth-radiusCorner+thickness*3)/2,-(attackModifierHeight-radiusCorner-thickness*3)/2,-3.5]) 
      difference(){
        translate([-radiusCorner-1,-radiusCorner-1,0])cube([radiusCorner+1, radiusCorner+1 ,4]);
        translate([0,0,-0.5])cylinder(r=radiusCorner,h=5,$fn=100);
      }
  }
}
*/


module shelf(length, width, thickness, fingerSlot){
  difference(){
    translate([0,0,0])
      cube([length, width, thickness], true);
    if(fingerSlot){
      translate([0,width/2,-thickness]) cylinder(r=fingerSlotSize, h=thickness*2, $fn=100);
    }
  } 
}

module side(length, height, thickness, radiusCorner){
  difference(){
    minkowski(){
      cube([length-radiusCorner*2,height-radiusCorner*2,0.001], true);
      translate([0,0,-thickness/2+1]) cylinder(r=radiusCorner,h=thickness,$fn=100);
    }
  }
  translate([-(length-radiusCorner)/2,(height-radiusCorner)/2,1]) 
    cube([radiusCorner, radiusCorner ,thickness], true);
  translate([(length-radiusCorner)/2,-(height-radiusCorner)/2,1]) 
    cube([radiusCorner, radiusCorner ,thickness], true);
  translate([-(length-radiusCorner)/2,-(height-radiusCorner)/2,1]) 
    cube([radiusCorner, radiusCorner ,thickness], true);
}

module right_triangle(side1,side2,corner_radius,triangle_height){
  translate([corner_radius,corner_radius,0]){  
    hull(){  
    cylinder(r=corner_radius,h=triangle_height);
      translate([side1 - corner_radius * 2,0,0])cylinder(r=corner_radius,h=triangle_height);
          translate([0,side2 - corner_radius * 2,0])cylinder(r=corner_radius,h=triangle_height);  
    }
  }
    
}

module hook(length,width,height){
    polyhedron(points=[[0,0,0],[length,0,0],[0, width,0],
                    [0,0,height],[length,0,height],[0, width,height]],
            faces=[[0,1,2],[0,2,5,3],[0,3,4,1],[1,4,5,2],[3,5,4]]);
}


module indicator(count, modul=""){
  chars = "0123456789";
  
  ant = len(chars);
  fontsize = 5;
  radiusInd = 2+ant;
  widthInd = 7;
  radiusInner = radiusInd*0.70;
  notches = 0.8+radiusInd/10;
  m = 0.3;
  ang = 360/ ant;
  
  if(modul == 1 || modul == ""){
    difference(){
      translate([2,0,0]){
        
        translate([1.5,0,-0.5])cube([26,widthInd+2,1], true);
        translate([12,-(widthInd+2)/2,-0.5*0]) rotate([90,0,180]) hook(2,1.2,(widthInd+2));
        
        translate([14,0,((widthInd+m)*count+1)/2])cube([1,widthInd+2,(widthInd+m)*count+1], true);
        
        translate([1.5,0,(widthInd+m)*count+1])cube([26,widthInd+2,1], true);
        translate([12,(widthInd+2)/2,(widthInd+m)*count+0.5]) rotate([90,180,0]) hook(2,1.2,(widthInd+2));
      }
      translate([-1,0,(widthInd+m)*count/2+0.25]) cube([3.4,5.4,(widthInd+0.5)*count+2.5], true);  
    }
  }
  
  if(modul == 2 || modul == ""){
    translate([2,0,0]){
      rotate([0,0,0]) translate([-(radiusInner-2),0,((widthInd+m)*count+1)/2-0.275]) cube([notches*ant/10-0.3,notches*ant/10-0.3,(widthInd+m)*count-m/2], true); 
      difference(){
          translate([-3,0,0.3]) cylinder(r=radiusInner-notches*2-1-0.2, h=(widthInd+m)*count-m/2, $fn=100);
          translate([0,0,((widthInd+m)*count+1)/2-0.5]) cube([3,10,(widthInd+m)*count+2], true);
        }  
    }
    
    translate([-1.15,0,((widthInd+m)*count+1)/2-0.25]) cube([3.3,5.25,(widthInd+m)*count+6], true);
  }
  
  if(modul == 3 || modul == ""){
    for(i=[1:count]){
      translate([-1,0,(widthInd+m)*(i-1)]) rotate([0,0,0]) dail(chars);
    }
  }
  
  /*
  // test 
  difference(){
    translate([14.75,0,25/4]) cube([1.3,15,25], true);
    translate([14.75,0,-0.5]) cube([1.5,10,2], true);
    translate([14.75,0,15]) cube([1.5,10,2], true);
  }
  */
}
  
module dail(chars){
  //chars = "0123456789";
  ant = len(chars);
  fontsize = 5;
  radiusInd = 2+ant;
  widthInd = 7;
  radiusInner = radiusInd*0.70;
  notches = 0.8+radiusInd/10;
  m = 0.3;
  ang = 360/ ant;
  
  
  difference(){
    rotate([0,0,ang/2])cylinder(r=radiusInd, h=widthInd, $fn=ant);
    for (i= [0 : ant-1]){
      rotate([0,0,ang*i]){
        rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,0]) rotate([45,0,0]) cube([radiusInd,1,1],true);
        rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,widthInd]) rotate([45,0,0]) cube([radiusInd,1,1],true);
        translate([radiusInner-1,0,widthInd/2]) rotate([0,0,45]) cube([notches,notches,widthInd+2],true);
        
        rotate([0,0,ang/2])
        translate([2,radiusInd-2,fontsize/2+widthInd/2-0.5]) rotate([90,90,180]) 
          linear_extrude(2){
            text(
              chars[i],
              size = fontsize,
              font = "Liberation Sans"
            );
          }
        
      }   
    }
    translate([0,0,-0.5]) cylinder(r=radiusInner+m-1-0.1, h=widthInd+1, $fn=100);
  }
 
    
    //translate([0,0,-0.5]) cylinder(r=(radiusInd+radiusInner)/2+0.2, h=widthInd+1, $fn=10);
  
  /*
  difference(){
    cylinder(r=(radiusInd+radiusInner)/2, h=widthInd, $fn=10);
    translate([0,0,-0.5]) cylinder(r=radiusInner+ma, h=widthInd+1, $fn=100);
    for (i= [0 : len(chars)-1]){
      rotate([0,0,ang*i]){
        translate([radiusInner,0,widthInd/2]) rotate([0,0,45]) cube([notches,notches,widthInd+2],true);
      }
    }
  }
  */
  
  // flexing arms
  difference(){
    union(){
      rotate([0,0,-ang*2]) translate([radiusInner-1,0,0]) cylinder(r=notches/2-0.1, h=3, $fn=100);
      rotate([0,0,ang*2]) translate([radiusInner-1,0,0]) cylinder(r=notches/2-0.1, h=3, $fn=100);
      difference(){
          cylinder(r=radiusInner-1, h=3, $fn=100);
          translate([0,0,-0.5])cylinder(r=radiusInner-2, h=4, $fn=100);
      }
    }
    translate([0,0,-0.5])
    intersection(){
      union(){
        rotate([0,0,-25])cube([14,14,6]);
        rotate([0,0,-65])cube([14,14,6]);
      }
      cylinder(r=radiusInd-2, h=6, $fn=100);
    }
  }
  
  // center holder
  difference(){
    union(){
      cylinder(r=radiusInner-notches*2, h=widthInd, $fn=100);
      intersection(){
        rotate([0,0,135])cube([14,14,widthInd]);
        cylinder(r=radiusInner-1, h=widthInd, $fn=100);
      }
      intersection(){
        union(){
          rotate([0,0,-33])cube([14,14,widthInd]);
          rotate([0,0,-57])cube([14,14,widthInd]);
        }
        cylinder(r=radiusInner-1, h=widthInd, $fn=100);
      }
    }
    translate([0,0,-0.5])cylinder(r=radiusInner-notches*2-1, h=widthInd+1, $fn=100);
    translate([-(radiusInner-notches*2-notches/2),0,(widthInd+1)/2-0.1]) cube([notches*ant/10,notches*ant/10,widthInd+1], true);
  }
  
}


module dail2(chars, modul = "", length = 0){
  //chars = "0123456789";
  ant = len(chars);
  fontsize = 5;
  radiusInd = 2+ant;
  widthInd = 7;
  radiusInner = radiusInd*0.70;
  notches = 0.8+radiusInd/10;
  m = 0.3;
  ang = 360/ ant;
  
  
  if(modul == "" || modul == 1){
    difference(){
      union(){
        rotate([0,0,ang/2])cylinder(r=radiusInd, h=widthInd, $fn=ant);
        for(i=[0:ant-1]){
          rotate([0,0,ang/2+ang*i])translate([radiusInner+3.2,0,widthInd/2]) rotate([0,0,0]) cylinder(r=0.7, h=widthInd, center=true, $fn=24);
        }
      }
      for (i= [0 : ant-1]){
        rotate([0,0,ang*i]){
          rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,0]) rotate([45,0,0]) cube([radiusInd,5,1],true);
          rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,widthInd]) rotate([45,0,0]) cube([radiusInd,1,5],true);
          
          
          rotate([0,0,ang/2])
          translate([2,radiusInd-2,fontsize/2+widthInd/2-0.5]) rotate([90,90,180]) 
            linear_extrude(2){
              text(
                chars[i],
                size = fontsize,
                font = "Liberation Sans"
              );
            }
          
        }   
      }
      translate([0,0,-0.5]) cylinder(r=9, h=widthInd+1, $fn=100);
    }
  }
  //translate([radiusInner+5,0,widthInd/2]) rotate([0,0,0]) cylinder(r=0.5, h=widthInd, center=true, $fn=24);
  
  
  // flexing arms
  if(modul == "" || modul == 1){
    difference(){
      union(){
        rotate([0,0,-ang*2]) translate([radiusInner-0.5,0,0]) rotate([0,0,0]) cylinder(r=notches-0.3, h=widthInd, $fn=6);
          /*{
            translate([0.947-1.80,1.39,widthInd/2]) rotate([0,0,-10]) translate([0,-0.5,0]) cube([1,2,widthInd], true);
            translate([0.947-1.80,-1.39,widthInd/2]) rotate([0,0,10]) cube([1,3,widthInd], true);
          }*/
        rotate([0,0,-ang*2]) translate([-radiusInner+0.5,0,0]) rotate([0,0,180]) cylinder(r=notches-0.3, h=widthInd, $fn=6);
          /*{
            translate([0.947-1.80,1.39,widthInd/2]) rotate([0,0,-10]) translate([0,-0.5,0]) cube([1,2,widthInd], true);
            translate([0.947-1.80,-1.39,widthInd/2]) rotate([0,0,10]) cube([1,3,widthInd], true);
          }*/
        
        difference(){
          cylinder(r=7.75, h=widthInd, $fn=100);
          translate([0,0,-0.5]) cylinder(r=7, h=widthInd+1, $fn=100);
        }
      }
      translate([0,0,-0.5])
        intersection(){
          rotate([0,0,-60])cube([14,14,widthInd+1]);
          rotate([0,0,-145])cube([14,14,widthInd+1]);
          cylinder(r=radiusInd-2, h=widthInd+1, $fn=100);
        }
      translate([0,0,-0.5])
        intersection(){
          rotate([0,0,120])cube([14,14,widthInd+1]);
          rotate([0,0,35])cube([14,14,widthInd+1]);
          cylinder(r=radiusInd-2, h=widthInd+1, $fn=100);
        }
      difference(){
        translate([0,0,-0.5])cylinder(r=9,h=widthInd+1, $fn=100);
        translate([0,0,-1])cylinder(r=7.75,h=widthInd+2, $fn=100);
      }
    }
  }
  
  
  //center
  
  if(modul == "" || modul == 2){
    rotate([0,0,ang/2])
      difference(){
        cylinder(r=7-0.1,h=widthInd+length);
        for(i=[0:ant-1]){
          rotate([0,0,ang/2+ang*i])translate([radiusInner-0.5-0.1,0,(widthInd+length)/2]) rotate([0,0,180]) 
            union(){
              //translate([0.947,1.39,0]) rotate([0,0,10])cube([1,3,widthInd+1], true);
              //translate([0.947,-1.39,0]) rotate([0,0,-10])cube([1,3,widthInd+1], true);
              cylinder(r=notches-0.3, h=widthInd+length+1, center=true, $fn=6);
            }
        }
        difference(){
          translate([0,0,-0.5])cylinder(r=7.75,h=widthInd+length+1, $fn=100);
          translate([0,0,-1])cylinder(r=6.4,h=widthInd+length+2, $fn=100);
        }
      }
    for(i=[0:ant-1]){
      rotate([0,0,ang/2+ang*i])translate([4.9,0,0]) rotate([0,0,180]) 
        union(){
          //translate([0.947,1.39,0]) rotate([0,0,10])cube([1,3,widthInd+1], true);
          //translate([0.947,-1.39,0]) rotate([0,0,-10])cube([1,3,widthInd+1], true);
          cylinder(r=notches-0.5+0.5, h=widthInd+length, $fn=100);
        }
    }
  }
  
  
  //translate([0,5.1,0])cylinder(r=notches-0.3, h=widthInd, $fn=100);
  //cylinder(r=notches-0.3, h=widthInd+1, center=true, $fn=100);
  
  /*
  cylinder(r=notches-0.3, h=widthInd+1, center=true, $fn=6);
  translate([0.947,1.39,0]) rotate([0,0,15])cube([1,3,widthInd+1], true);
  translate([0.947,-1.39,0]) rotate([0,0,-15])cube([1,3,widthInd+1], true);
  */
  
  // outer buffer
  if(modul == "" || modul == 1){
    difference(){
      union(){
        //cylinder(r=radiusInner-notches*2, h=widthInd, $fn=100);
        intersection(){
          union(){
            rotate([0,0,127])cube([14,14,widthInd]);
            rotate([0,0,123])cube([14,14,widthInd]);
          }
          cylinder(r=radiusInner+1, h=widthInd, $fn=100);
        }
        intersection(){
          union(){
            rotate([0,0,-53])cube([14,14,widthInd]);
            rotate([0,0,-57])cube([14,14,widthInd]);
          }
          cylinder(r=radiusInner+1, h=widthInd, $fn=100);
        }
      }
      translate([0,0,-0.5])cylinder(r=7, h=widthInd+1, $fn=100);
      //translate([-(radiusInner-notches*2-notches/2),0,(widthInd+1)/2-0.1]) cube([notches*ant/10,notches*ant/10,widthInd+1], true);
    }
  }
}


module dailStandee(){
  chars = "0123456789";
  ant = len(chars);
  fontsize = 3.2;
  radiusInd = 2+ant;
  widthInd = 5;
  radiusInner = radiusInd*0.70;
  notches = 0.8+radiusInd/10;
  m = 0.3;
  ang = 360/ ant;
  count = 2;
  
  
  translate([3,0,0]){
      rotate([0,0,0]) translate([-(radiusInner-2),0,((widthInd+m*5/3)*count+1)/2-0.575]) cube([notches*ant/10-0.3,notches*ant/10-0.3,(widthInd+m*5/3)*count-m/2], true); 
      difference(){
          translate([-3,0,0]) cylinder(r=radiusInner-notches*2-1-0.2, h=(widthInd+m*5/3)*count-m/2, $fn=100);
          //translate([0,0,((widthInd+m)*count+1)/2-0.5]) cube([2.8,10,(widthInd+m)*count+2], true);
        }
      }
      translate([0,0,10.5]){
        difference(){
          union(){
            cylinder(r=2.5, h=2, $fn=50); 
            translate([0,0,1.7])
              rotate_extrude(convexity = 100, $fn=50){
                translate([2.2,0,0])circle(r=0.8,$fn=4);
              }
          }
          translate([1.25,-5,0])cube([5,10,5]);
        }
      }

    
    //translate([0,0,((widthInd+m)*count+1)/2-0.25]) cube([3.2,5.2,(widthInd+m)*count+6], true);
  
  for(j = [1:count]){
    translate([0,0,(j-1)*(widthInd+m)]){
      difference(){
        rotate([0,0,ang/2])cylinder(r1=radiusInd, r2=radiusInd, h=widthInd, $fn=ant);
        for (i= [0 : ant-1]){
          rotate([0,0,ang*i]){
            rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,0]) rotate([45,0,0]) cube([radiusInd,1,1],true);
            rotate([0,0,ang/2]) translate([0,cos(ang/2)*radiusInd,widthInd]) rotate([45,0,0]) cube([radiusInd,1,1],true);
            //translate([radiusInner-1,0,widthInd/2]) rotate([0,0,45]) cube([notches,notches,widthInd+2],true);
            translate([radiusInner-1,0,widthInd/2]) rotate([0,0,0]) cylinder(r=notches/2, h=widthInd+2 ,center=true, $fn=50);
            
            rotate([0,0,ang/2])
            translate([1.5,radiusInd-2,fontsize/2-0.6]) rotate([90,0,180]) 
              linear_extrude(2){
                text(
                  chars[i],
                  size = fontsize,
                  font = "Liberation Sans"
                );
              }
            
          }   
        }
        translate([0,0,-0.5]) cylinder(r=radiusInner+m-1, h=widthInd+1, $fn=100);
      }
    
        
        //translate([0,0,-0.5]) cylinder(r=(radiusInd+radiusInner)/2+0.2, h=widthInd+1, $fn=10);
      
      
//      difference(){
//        cylinder(r=(radiusInd+radiusInner)/2, h=widthInd, $fn=10);
//        translate([0,0,-0.5]) cylinder(r=radiusInner+ma, h=widthInd+1, $fn=100);
//        for (i= [0 : len(chars)-1]){
//          rotate([0,0,ang*i]){
//            translate([radiusInner,0,widthInd/2]) rotate([0,0,45]) cube([notches,notches,widthInd+2],true);
//          }
//        }
//      }
      
      
      // flexing arms
      difference(){
        union(){
          rotate([0,0,-ang]) translate([radiusInner-1,0,0]) cylinder(r=notches/2-0.1, h=3, $fn=100);
          rotate([0,0,ang]) translate([radiusInner-1,0,0]) cylinder(r=notches/2-0.1, h=3, $fn=100);
          difference(){
              cylinder(r=radiusInner-0.9, h=3, $fn=100);
              translate([0,0,-0.5])cylinder(r=radiusInner-2, h=4, $fn=100);
          }
        }
        translate([0,0,-0.5])
          intersection(){
            rotate([0,0,-61])cube([14,14,6]);
            rotate([0,0,-29])cube([14,14,6]);
            cylinder(r=radiusInd-2, h=6, $fn=100);
          }
      }
      
      // center holder
      difference(){
        union(){
          cylinder(r=radiusInner-notches*2, h=widthInd, $fn=100);
          intersection(){
            rotate([0,0,135])cube([14,14,widthInd]);
            cylinder(r=radiusInner-0.9, h=widthInd, $fn=100);
          }
          intersection(){
            rotate([0,0,-72])cube([14,14,widthInd]);
            rotate([0,0,-18])cube([14,14,widthInd]);
            cylinder(r=radiusInner-0.9, h=widthInd, $fn=100);
          }
        }
        translate([0,0,-0.5])cylinder(r=radiusInner-notches*2-1, h=widthInd+1, $fn=100);
        translate([-(radiusInner-notches*2-notches/2),0,(widthInd+1)/2-0.1]) cube([notches*ant/10,notches*ant/10,widthInd+1], true);
      }
    }
  }
  
}


module lid(length, width, height, lock = false, lockDepth = 15, fingerSlot = true){
  
  lockThickness = 2;
  knobSize = 1;
  edgeThickness = 3;
  translate([0,-4.8,0]){
    difference(){
      union(){
        difference(){
          cube([length,width,height], true);
          cube([length-edgeThickness*2,width-edgeThickness*2,height+0.1], true);
        }
        MakeSide(length, width, 15, 2, height, height);
        
        if(lock){
          translate([(length-lockThickness)/2-lockThickness*1,-(width-lockDepth)/2+lockThickness/2,0]) cube([lockThickness+lockThickness*2,lockDepth+lockThickness,height], true);
          translate([-((length-lockThickness)/2-lockThickness*1),-(width-lockDepth)/2+lockThickness/2,0]) cube([lockThickness+lockThickness*2,lockDepth+lockThickness,height], true);
        }
        
        if(fingerSlot){
          translate([0,(width)/2-fingerSlotSize,-height/2]) cylinder(r=fingerSlotSize+edgeThickness, h=height, $fn=100);
          translate([0,(width-fingerSlotSize)/2,0]) cube([fingerSlotSize*2+edgeThickness*2,fingerSlotSize,height],true);
        }
      }
      if(lock){
        translate([(length-lockThickness)/2-lockThickness,-(width-lockDepth)/2,0]) cube([lockThickness,lockDepth,height+0.1], true);
        translate([-(length-lockThickness)/2+lockThickness,-(width-lockDepth)/2,0]) cube([lockThickness,lockDepth,height+0.1], true);
      }
      
      if(fingerSlot){
        translate([0,(width)/2-fingerSlotSize,-height/2-0.5]) cylinder(r=fingerSlotSize, h=height+1, $fn=100);
        translate([0,(width)/2,-0.5]) cube([fingerSlotSize*2,fingerSlotSize*2,height+2],true);
      }
    }
    if(lock){
      translate([-length/2,-width/2+3,0]) cylinder(r=knobSize, h=height, $fn=24, center=true);
      translate([length/2,-width/2+3,0]) cylinder(r=knobSize, h=height, $fn=24, center=true);
    }
  }
}

module hinge(type){
    difference(){
      union(){
        cylinder(r=4, h=10, $fn=100);
        difference(){
          translate([sqrt(32)/2,-sqrt(32)/2,0]) rotate([0,0,45]) cube([6,6,10]);
          translate([-2,3.75,0]) cube([10,6,10]);
        }
      }
      if(type == "screw"){ 
        translate([0,0,2]) cylinder(r=1.4, h=8, $fn=100);
      }else{
        translate([0,0,-1]) cylinder(r=2, h=12, $fn=100);
        translate([-sqrt(8)/2,0,5]) rotate([0,0,45]) cube([2,2,12],true);
            
        translate([0,0,-0.01]) rotate([0,0,0])
          cylinder(r=3, h=3, $fn=100);
      }
    }
}
module deckStorage(side){
  holeWidth = 6.9;
  angleDial = 45;
  
  difference(){
    // Deck box
    union(){
      /*translate([-11.5,0,-attackModifierHeight/2-3/2]) 
        cube([charAbilityLength+2*m+thickness*9+23, attackModifierWidth+2*m+thickness*6, 1],true);*/
      /*translate([0,-attackModifierWidth/2-m-thickness*4.5,-1]) 
        cube([charAbilityLength+2*m+thickness*9,3,attackModifierHeight+2],true);*/
       
     
      if(side=="discard"){
        
        translate([11.75,0,-attackModifierHeight/2-3/2]) 
          cube([charAbilityLength+2*m+thickness*9+23, attackModifierWidth+2*m+thickness*6, 1],true);
        translate([11.75,-attackModifierWidth/2-m-thickness*4.5,-1]) 
          cube([charAbilityLength+2*m+thickness*9+23,3,attackModifierHeight+2],true);
        
        translate([charAbilityLength/2+4+11.675,0,thickness/2-1]) rotate([90,0,90])
          side(attackModifierWidth+m*2+thickness*6,attackModifierHeight-thickness+2,26.15,5);
        
        difference(){
          union(){
            rotate([0,0,180]) mirror([0,1,0]){
              translate([charAbilityLength/2+4,-1.5,thickness/2-1]) rotate([90,0,90])
                side(attackModifierWidth+m*2+thickness*6+3,attackModifierHeight-thickness+2,3,5);
            }
            difference(){
              translate([-3,0,0])
                rotate([0,0,180]) mirror([0,1,0]){
                  translate([charAbilityLength/2+4,-1.5,thickness/2-1]) rotate([90,0,90])
                    side(attackModifierWidth+m*2+thickness*6+3,attackModifierHeight-thickness+2,3,5);
                }
              translate([-(attackModifierLength+17),0,-0])rotate([0,75,0])cube([40,attackModifierWidth+2*m+13,20], true);
            }
            
            // lock
            /*translate([-(attackModifierLength+8),0,-9.0])
              cube([5,attackModifierWidth+m*2+thickness*6,10], true);*/
            
            rotate([0,0,180]) translate([(attackModifierLength+8),1.5,-9.0]){
              cube([5,attackModifierWidth+m*2+thickness*6+3,10], true);
              difference(){
                translate([-1.39,0,5.35]) rotate([0,45,0]) cube([6,attackModifierWidth+m*2+thickness*6+3,5], true);
                translate([-5,0,3]) cube([5,attackModifierWidth+m*2+thickness*6+4,10], true);
                translate([-2.39,-1,5.35]) rotate([0,45,0]) cube([6,attackModifierWidth+m*2+thickness*6+1,5], true);
              }
            }
          }
          
          // cutout for lock
          rotate([0,0,180]){
          translate([(attackModifierLength+8),-1,-8.5])
            cube([3,attackModifierWidth+m*2+thickness*6,9], true);
          /*translate([(attackModifierLength+8+2)-1.975,1,-2])
            cube([2.8,attackModifierWidth+m*2+thickness*6-20,3.8], true);*/
          }
          //cutout for active card
          translate([-(attackModifierLength+7.5),0,10])
            rotate([0,-20,0]) cube([0.60,attackModifierWidth+2*m+6,7], true);
        }
      }else{
        translate([-11.75,0,-attackModifierHeight/2-3/2]) 
          cube([charAbilityLength+2*m+thickness*9+23, attackModifierWidth+2*m+thickness*6, 1],true);
        translate([-11.75,-attackModifierWidth/2-m-thickness*4.5,-1]) 
          cube([charAbilityLength+2*m+thickness*9+23,3,attackModifierHeight+2],true);
        
        difference(){
          union(){
            translate([charAbilityLength/2+4,-1.5,thickness/2-1]) rotate([90,0,90])
              side(attackModifierWidth+m*2+thickness*6+3,attackModifierHeight-thickness+2,3,5);
            //color([0.5,0.5,0.1,100])
            difference(){
              translate([3,0,0])
                translate([charAbilityLength/2+4,-1.5,thickness/2-1.5]) rotate([90,0,90])
                  side(attackModifierWidth+m*2+thickness*6+3,attackModifierHeight-thickness+2+1,3,5);
              
              translate([(attackModifierLength+17),0,-0])rotate([0,-75,0])cube([40,attackModifierWidth+2*m+20,20], true);
            }
            
            // lock
            translate([(attackModifierLength+8),-1.5,-9.0]){
              cube([5,attackModifierWidth+m*2+thickness*6+3,10], true);
              difference(){
                translate([-1.39,0,5.35]) rotate([0,45,0]) cube([6,attackModifierWidth+m*2+thickness*6+3,5], true);
                translate([-5,-1.5,3]) cube([5,attackModifierWidth+m*2+thickness*6+4,10], true);
                translate([-2.39,1,5.35]) rotate([0,45,0]) cube([6,attackModifierWidth+m*2+thickness*6+1,5], true);
              }
            }
            /*translate([(attackModifierLength+8),0,-9.0])
              cube([5,attackModifierWidth+m*2+thickness*6,10], true);*/
          }
          // cutout for lock
          translate([(attackModifierLength+8),1,-8.5])
            cube([3,attackModifierWidth+m*2+thickness*6,9], true);
          translate([(attackModifierLength+8+2)-1.975,-5,-2])
            cube([2.8,attackModifierWidth+m*2+thickness*6-35,3.8], true);
          /*translate([(attackModifierLength+8),0,-7.0])
            cube([3,attackModifierWidth+m*2+thickness*6-30,8], true);*/
          
          // cutout for active card
          translate([(attackModifierLength+7.5),3,10])
            rotate([0,20,0]) cube([0.60,attackModifierWidth+2*m+7,7], true);
        }
        
        /*
        //lock test
        translate([0,40,0]){
          translate([(attackModifierLength+8),0,-8.5]){
            cube([3-0.4,attackModifierWidth+m*2+thickness*6-4,9-0.2], true);
            translate([-1.7,0,4.4]) 
              difference(){
                rotate([0,45,0]) cube([4.2426,attackModifierWidth+m*2+thickness*6-4,4.2426], true);
                translate([-2.1,0,0]) cube([5,attackModifierWidth+m*2+thickness*6-3,10], true);
              }
          }
        */  
          /*translate([(attackModifierLength+8),-20,-5.0]) rotate([0,10,0])
            cube([3-0.4,10,8], true);*/
        //}

        rotate([0,0,180]) mirror([0,1,0]){
          translate([charAbilityLength/2+4+11.675,0,thickness/2-1]) rotate([90,0,90])
            side(attackModifierWidth+m*2+thickness*6,attackModifierHeight-thickness+2,26.15,5);
        }
      }
      
      
      if(side == "discard"){
        translate([0,-attackModifierWidth/2+1-0.5,-7-7/4-thickness*1.5/2-1.])
          cube([charAbilityLength+thickness*7,thickness*2,5], true); 
        translate([0,1,-7-7/4-thickness*1.5/2-1.])
          cube([thickness,attackModifierWidth,5], true);
      }else{
        translate([0,-attackModifierWidth/2+1-0.5,-7-7/4-thickness*1.5/2+2.5])
          cube([charAbilityLength+thickness*7,thickness*2,12], true); 
      }
    }
    
    // dial open box 
    if(side == "discard"){
      translate([63.5,-1.5,-0.75]){
        translate([0,-32,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1),0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)+15,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*2+15,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*3+15,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*3+15*2,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*4+15*2,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*5+15*2,0])cube([22,holeWidth,24.5], true);
      }
      /*translate([85,-1.5,18.5]){
        translate([0,-32,0])cube([22,6.6,24.5], true);
        translate([0,-32+8,0])cube([22,7.3,24.5], true);
        translate([0,-32+20,0])cube([22,7.3,24.5], true);
        translate([0,-32+28,0])cube([22,7.3,24.5], true);
        translate([0,-32+36,0])cube([22,7.3,24.5], true);
        translate([0,-32+48,0])cube([22,7.3,24.5], true);
        translate([0,-32+56,0])cube([22,7.3,24.5], true);
        translate([0,-32+64,0])cube([22,7.3,24.5], true);
        
      }*/
      translate([73.5,0,14.5]) 
        rotate([0,20,0])cube([42,90,20], true);
      translate([74.5,0,13.5]) 
        rotate([0,45,0])cube([42,90,20], true);
      translate([63.5,42,-0.75]) 
        rotate([90,angleDial,0]) scale(0.88) dail2("0123456789",2,95);
      translate([73.5,0,18]) 
        rotate([0,0,0])cube([42,90,10], true);
      
      
      // text HP
      translate([75.2,-34,-10]) rotate([90,0,90])
        linear_extrude(1){
          text("HP",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,-9.5,-10]) rotate([90,0,90])
        linear_extrude(1){
          text("GP",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,19.5,-10]) rotate([90,0,90])
        linear_extrude(1){
          text("XP",size = 5,font = "Liberation Sans: style=Bold");
        }
      
    }else{
      mirror([1,0,0]){
      translate([63.5,-1.5,-0.75]){
        translate([0,-32,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*0+16,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*0+16*2,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*0+16*3,0])cube([22,holeWidth,24.5], true);
        translate([0,-32+(holeWidth-0.1)*0+16*4,0])cube([22,holeWidth,24.5], true);
      }

      translate([73.5,0,14.5]) 
        rotate([0,20,0])cube([42,90,20], true);
      translate([74.5,0,13.5]) 
        rotate([0,45,0])cube([42,90,20], true);
      translate([63.5,42,-0.75]) 
        rotate([90,angleDial,0]) scale(0.88) dail2("0123456789",2,95);
      translate([73.5,0,18]) 
        rotate([0,0,0])cube([42,90,10], true);
      
      // text HP
      start = 32;
      translate([75.2,start,-10]) rotate([90,0,90])
        linear_extrude(1){
          mirror([1,0,0]) text("1",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,start-16,-10]) rotate([90,0,90])
        linear_extrude(1){
          mirror([1,0,0]) text("2",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,start-16*2,-10]) rotate([90,0,90])
        linear_extrude(1){
          mirror([1,0,0]) text("3",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,start-16*3,-10]) rotate([90,0,90])
        linear_extrude(1){
          mirror([1,0,0]) text("4",size = 5,font = "Liberation Sans: style=Bold");
        }
      translate([75.2,start-16*4,-10]) rotate([90,0,90])
        linear_extrude(1){
          mirror([1,0,0]) text("x",size = 5,font = "Liberation Sans: style=Bold");
        }
    }
  }
    
    
    depthFingerSlot = 10;
    
    if(side=="hand"){
    // long fingerslot?
      translate([0,30+fingerSlotSize-depthFingerSlot,-20]) 
        cylinder(r=fingerSlotSize, h=40, $fn=100);
      translate([0,30+attackModifierWidth/4+fingerSlotSize-depthFingerSlot,-attackModifierHeight/2]) 
        cube([fingerSlotSize*2, attackModifierWidth/2,5], true);
    }else if(side=="discard"){
      translate([-25,30,-20]) 
        cylinder(r=fingerSlotSize, h=40, $fn=100);
      translate([-25,20+attackModifierWidth/4+fingerSlotSize,-attackModifierHeight/2]) 
        cube([fingerSlotSize*2, attackModifierWidth/2,5], true);
      translate([25,30,-20]) 
        cylinder(r=fingerSlotSize, h=40, $fn=100);
      translate([25,20+attackModifierWidth/4+fingerSlotSize,-attackModifierHeight/2]) 
        cube([fingerSlotSize*2, attackModifierWidth/2,5], true);
    }
    
    
    // shelf groves
    // Lid grove
    translate([0,-5.99+attackModifierWidth/2,attackModifierHeight/2-thickness*2.5])
      shelf(charAbilityLength+m*2+thickness*6,attackModifierWidth*2-2,thickness*1.5, true);
    translate([charAbilityLength/2+2.89,0.01+0*attackModifierWidth/2,attackModifierHeight/2-thickness*2.5+0.75])
      rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
    translate([-(charAbilityLength/2+2.89),0.01+0*attackModifierWidth/2,attackModifierHeight/2-thickness*2.5+0.75])
      rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
    translate([(charAbilityLength/2+4.75),-(attackModifierWidth/2+2),attackModifierHeight/2-thickness*2.25-0.25])
      rotate([0,0,45]) cube([2,2,1.5], true);
    translate([-(charAbilityLength/2+4.75),-(attackModifierWidth/2+2),attackModifierHeight/2-thickness*2.25-0.25])
      rotate([0,0,45]) cube([2,2,1.5], true);
    
    // top shelf grove
    translate([0,-5.99+attackModifierWidth/2,0])
      shelf(charAbilityLength+m*2+thickness*6,attackModifierWidth*2-2,thickness*1.5, true); 
    translate([charAbilityLength/2+2.89,0.01+0*attackModifierWidth/2,0.75])
      rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
    translate([-(charAbilityLength/2+2.89),0.01+0*attackModifierWidth/2,0.75])
      rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
    translate([(charAbilityLength/2+4.75),-(attackModifierWidth/2+2),0])
      rotate([0,0,45]) cube([2,2,1.5], true);
    translate([-(charAbilityLength/2+4.75),-(attackModifierWidth/2+2),0])
      rotate([0,0,45]) cube([2,2,1.5], true);
      
    
    if(side == "discard"){
    // bottom shelf grove
      translate([0,attackModifierWidth/2,-7])
        shelf(charAbilityLength+m*2+thickness*6,attackModifierWidth*2-1,thickness*1.5, true);
      translate([charAbilityLength/2+2.89,5.5,-7+0.75])
        rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
      translate([-(charAbilityLength/2+2.89),5.5,-7+0.75])
        rotate([0,45,0])cube([3,attackModifierWidth+10,3], true);
      translate([(charAbilityLength/2+4.75),-(attackModifierWidth/2)+4,-7])
        rotate([0,0,45]) cube([2,2,1.5], true);
      translate([-(charAbilityLength/2+4.75),-(attackModifierWidth/2)+4,-7])
        rotate([0,0,45]) cube([2,2,1.5], true);
    }
    
    // hinge cutouts
    translate([-5-charAbilityLength/2+8.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
      cylinder(r=radius_cutout, h=11, $fn=100);
    translate([charAbilityLength/2-4.0,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
      cylinder(r=radius_cutout, h=12, $fn=100);
    //translate([charAbilityLength/2-19.0,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.1]) rotate([0,90,0])
    //  cylinder(r=4.1, h=5, $fn=100);
    
    translate([-5-charAbilityLength/2-1.501-4,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4+0.8]) rotate([0,90,0])
      cylinder(r=3, h=7, $fn=100);
    translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
      cylinder(r=3, h=3, $fn=100);

    translate([-5-charAbilityLength/2-3.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
      cylinder(r=2, h=14, $fn=100);
    translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
      cylinder(r=2, h=10, $fn=100);
      
    translate([charAbilityLength/2+8.0,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180])
      translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,-12]) rotate([0,0,45]) cube([8,8,24]);
    translate([-5-charAbilityLength/2+20.5,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180]) 
      translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,0]) rotate([0,0,45]) cube([8,8,12]); 
      
  }
  
  // dials
  if(side == "discard"){
    //translate([63.5,-30.5,-0.75]) rotate([90,angleDial,0]) scale(0.85) dail2("0123456789");
    //translate([67,-23.5,5.75]) rotate([90,angleDial-10,0]) scale(0.85) dail2("0123456789");
    /*
    translate([65,-22,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,-9,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,-1,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,7,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,19,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,27,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    translate([65,35,-0.75]) rotate([90,18,0]) scale (0.99) dail2("0123456789",2);
    */
    //translate([63.5,40.6,-0.75]) rotate([90,angleDial,0]) scale ([0.85,0.85,1]) dail2("0123456789",2,77.2);
    
    // holder for text
    difference(){
      translate([73.5-19,-1,11.74]) 
        difference(){
          rotate([0,45,0])cube([5,75,15], true);
          translate([-8,0,0])cube([10,76,20], true);
        }
      translate([73.5,0,14.5]) 
        rotate([0,20,0])cube([42,90,20], true);
    }
    
    
    /*
    //text
    translate([56.5,-34,9.4]) rotate([20,0,90])
      linear_extrude(1){
        text("HP",size = 5,font = "Liberation Sans: style=Bold");
      }
    translate([56.5,-8.5,9.4]) rotate([20,0,90])
      linear_extrude(1){
        text("GP",size = 5,font = "Liberation Sans: style=Bold");
      }
    translate([56.5,19.5,9.4]) rotate([20,0,90])
      linear_extrude(1){
        text("XP",size = 5,font = "Liberation Sans: style=Bold");
      }
    */
  }else{
    // holder for text
    mirror([1,0,0])
    difference(){
      translate([73.5-19,-1,11.74]) 
        difference(){
          rotate([0,45,0])cube([5,75,15], true);
          translate([-8,0,0])cube([10,76,20], true);
        }
      translate([73.5,0,14.5]) 
        rotate([0,20,0])cube([42,90,20], true);
    }
  }
  
  //translate([-5-charAbilityLength/2-1.501,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.1]) rotate([0,90,0])
  //  cylinder(r=3, h=3, $fn=100);
  /*
  // Lid stopper bumps
    translate([charAbilityLength/2+3.5,-12,8.2])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
    translate([-(charAbilityLength/2+3.5)-3,-12,8.2])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
      
    translate([charAbilityLength/2+3.5,-12,-1.3])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
    translate([-(charAbilityLength/2+3.5)-3,-12,-1.3])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
      
    translate([charAbilityLength/2+3.5,-12,-8.3])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
    translate([-(charAbilityLength/2+3.5)-3,-12,-8.3])rotate([0,90,0])
      cylinder(r=1,h=3, $fn=100);
  */
  
  // Hinge
  translate([-5-charAbilityLength/2-1.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+1.2]) rotate([0,90,0])   
    hinge();
  
  translate([charAbilityLength/2-14.0,-attackModifierWidth/2-m-7,attackModifierHeight/2+1.2]) rotate([0,90,0])
    hinge("screw");
    
}

module edgeBoxTop(length3, width3, slope, thickness3, lockTap) {
  difference() {
    cube([length3, width3, thickness3], center=true);

    translate([0, ((width3 + thickness3) / -2), 0]){
      rotate([slope, 0, 0]){
        cube([length3+c, (thickness3 * 4), (thickness3 * 2)], center=true);
      }
    }
    translate([0, ((width3 + thickness3) / 2), 0]){
      rotate([(-1 * slope), 0, 0]){
        cube([length3+c, (thickness3 * 4), (thickness3 * 2)], center=true);
      }
    }
    translate([((length3 + thickness3) / -2), 0, 0]){
      rotate([0, (-1 * slope), 0]){
        cube([(thickness3 * 4), width3+c, (thickness3 * 2)], center=true);
      }
    }
  }
  
  if(lockTap){
    if(slope < 90){
      translate([length3/2-thickness3*1.25-12.5,width3/2-thickness3*0.8-0.8,0])
        difference(){
          rotate([slope,0,0])cylinder(r=thickness3/2*0.8, h=thickness3*2.2, $fn=24, center=true);
          translate([0,0,thickness3]) cube([thickness3*3,thickness3*3,thickness3], center=true);
          translate([0,0,-thickness3]) cube([thickness3*3,thickness3*3,thickness3], center=true);
      }
      translate([length3/2-thickness3*1.25-12.5,-width3/2+thickness3*0.8+0.8,0])
        difference(){
          rotate([-slope,0,0])cylinder(r=thickness3/2*0.8, h=thickness3*2.2, $fn=24, center=true);
          translate([0,0,thickness3]) cube([thickness3*3,thickness3*3,thickness3], center=true);
          translate([0,0,-thickness3]) cube([thickness3*3,thickness3*3,thickness3], center=true);
      }
    }
  }
}


module mainUnit(modul = ""){
   boxCorr = 3.25;
  
  if(modul == "" || modul == 1){
    //Bottom
    difference(){
      //translate([12.5-1.75/2,0,-attackModifierHeight/2-1.5]) cube([charAbilityLength+36.25, attackModifierWidth*2+28, 1], true);
      //MakeSide(length2, width2, gridSize2, gridThickness2, gridHeight, thickness2)
      
      union(){
        //translate([12.5-1.75/2,0,-attackModifierHeight/2-1.5]) MakeSide(charAbilityLength+36.25,attackModifierWidth*2+28,10,2,1,1);
        translate([12.5-1.75/2,0,-attackModifierHeight/2-1.5+0.25])
          cube([charAbilityLength+36.25,attackModifierWidth*2+28,1.5], true);
        /*
        translate([53.5-1.75-2,(attackModifierWidth+2*m+2*thickness+12)/2,-4.5]) 
          translate([(attackModifierLength+2*m)/2,0,-(attackModifierHeight-6)/2]){
            translate([0,fingerSlotSize,0]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
            translate([0,0,0]) cube([fingerSlotSize*2+4, fingerSlotSize*2+4,1], true);
            translate([0,-fingerSlotSize,0]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
          }
        
        translate([53.5-1.75-2,-(attackModifierWidth+2*m+2*thickness+12)/2,-4.5])
          translate([(attackModifierLength+2*m)/2,0,-(attackModifierHeight-6)/2]){
            translate([0,fingerSlotSize,0]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
            translate([0,0,0]) cube([fingerSlotSize*2+4, fingerSlotSize*2+4,1], true);
            translate([0,-fingerSlotSize,0]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
          }
        */
        /*
        translate([8,-2,-(attackModifierHeight-6)/2-5]){
          translate([-22,-(attackModifierWidth+2*m+2*thickness+8)/2-12.5,0]) rotate([0,0,90])
            translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.5]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
          translate([-22,-(attackModifierWidth+2*m+2*thickness+15)/2+42.5,0]) rotate([0,0,90])
            translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.5]) cylinder(r=fingerSlotSize+2, h=1,center=true,$fn=100);
        } */
      }
      
      translate([53.5-1.75-2,(attackModifierWidth+2*m+2*thickness+12)/2,-4.5]) 
        translate([(attackModifierLength+2*m)/2,0,0]){
          translate([0,fingerSlotSize,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-5+1,center=true,$fn=100);
          translate([0,attackModifierLength/2-fingerSlotSize+1,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
          translate([0,0,-0.1]) cube([fingerSlotSize*2, attackModifierLength-fingerSlotSize*2,attackModifierHeight-boxCorr+1], true);
          translate([0,-(attackModifierLength/2-fingerSlotSize+1),-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
        }
      
      translate([53.5-1.75-2,-(attackModifierWidth+2*m+2*thickness+12)/2,-4.5])
        translate([(attackModifierLength+2*m)/2,0,0]){
          translate([0,fingerSlotSize,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-5+1,center=true,$fn=100);
          translate([0,attackModifierLength/2-fingerSlotSize+1,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
          translate([0,0,-0.1]) cube([fingerSlotSize*2, attackModifierLength-fingerSlotSize*2,attackModifierHeight-boxCorr+1], true);
          translate([0,-(attackModifierLength/2-fingerSlotSize+1),-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
        }
      translate([8,-2,0]){
        translate([-22,-(attackModifierWidth+2*m+2*thickness+8)/2-12.5,-3.375]) rotate([0,0,90])
          translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.4]){
            cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+3,center=true,$fn=100);
            translate([0,fingerSlotSize,-2.1]) cube([fingerSlotSize*3, fingerSlotSize*2,attackModifierHeight-5+1], true);
          }
        translate([-22,-(attackModifierWidth+2*m+2*thickness+15)/2+42.5,-3.375]) rotate([0,0,90])
          translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.4]){ 
            cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+3,center=true,$fn=100);
            translate([0,fingerSlotSize,-2.1]) cube([fingerSlotSize*3, fingerSlotSize*2,attackModifierHeight-5+1], true);
          }
      }
      
    }
  }
  
  
  flexingDepth = 10;
  translate([0*-51.5,0,0]){
  if(modul == "" || modul == 2){
    // top
      difference(){
        union(){
          translate([12.5-1.75/2,0,attackModifierHeight/2-4-0.25]) cube([charAbilityLength+36.25, attackModifierWidth*2+23.5, 1.5], true);
          
          // holder for sheet
          translate([11.625,0,attackModifierHeight/2-3+0.35]) 
            difference(){
              cube([charAbilityLength+36.25, attackModifierWidth*2+19.5, sheetThickness+0.5], true);
              translate([-5.81*-1,0,0])cube([sheetWidth+m+10, sheetLength+m, sheetThickness*2], true);
            }
        }
        translate([11.625,0,attackModifierHeight/2-3+0.35-1]) 
          translate([-5.81*-1,0,0])cube([sheetWidth+m+10, sheetLength+m, sheetThickness*4], true);
        translate([-49.1-3,36,8]) cube([8,30,5],true);
        translate([-59.6,36,8]) cube([14,38,5],true);
        //module lid(length, width, height, lock = false, lockDepth = 15, fingerSlot = true)
        
        // groves in lid for flexing
        translate([76-flexingDepth,79,7.4-0.5]) cube([flexingDepth,2,10]);
        translate([74.85,81,7.4-0.5]) cube([1,2,10]);
        
        translate([76-flexingDepth,-81,7.4-0.5]) cube([flexingDepth,2,10]);
        translate([74.85,-83,7.4-0.5]) cube([1,2,10]);
      }
      
      difference(){
        union(){
          translate([8.4,4.8*0,attackModifierHeight/2-3+0.35-1.35]) 
            translate([6.45,0,-0.25])
              //lid(sheetWidth+m+5, sheetLength+m, 1, fingerSlot=false);
              cube([sheetWidth+m+5, sheetLength+m, 1.5], true);
          translate([-49.1,36,8]) cube([14,36,1],true);
          
        }
        translate([-49.1-3,36,8]) cube([8,30,5],true);
        translate([-59.6,36,8]) cube([14,38,5],true);
        translate([-33,-5.5,0.5]){
          cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
          translate([-fingerSlotSize,0,0]) cube([fingerSlotSize*2,fingerSlotSize*2,attackModifierHeight-boxCorr+1],true);
        }
      }
      // taps for catching holes
      translate([73.85,-83,7.5-0.5]) cylinder(r=1, h=1.5, $fn=100);
      translate([73.85,83,7.5-0.5]) cylinder(r=1, h=1.5, $fn=100); 
      
      difference(){
        translate([11.625,0,11.33]) rotate([0,0,180]) 
          difference(){
            cube([charAbilityLength+36.25,charInfoWidth+2*m+12, charInfoHeight], true);
            //translate([-15,0,0]) 
              rotate([0,0,180])
                edgeBoxTop(charAbilityLength+36.3,charInfoWidth+2*m+10,45,charInfoHeight+0.1, false);
            translate([-64.3,79,-5]) cube([flexingDepth,2,10]);
            translate([-64.3,-81,-5]) cube([flexingDepth,2,10]);
          }
         
        translate([-49.1,36,8]) cube([8,30,10],true);
        translate([-59.6,36,8]) cube([14,38,5],true);  
        translate([11.625,0,11.33]) rotate([0,0,180]) translate([-64.3,-81,-5]) cube([flexingDepth,10,10]);    
        translate([11.625,0,11.33]) rotate([0,0,180]) translate([-64.3,70,-5]) cube([flexingDepth,10,10]);
      }
      //translate([11.625,0,11.33]) rotate([0,0,180]) translate([-64.3,-81,-5]) cube([flexingDepth,10,10]);
    }
  
  if(modul == "" || modul == 3){  
      // holder for char plate
      difference(){
        union(){
          translate([0,0,attackModifierHeight/2-0.67]) 
            difference(){
              translate([11.55,0,0]) rotate([0,0,0]) edgeBoxTop(charAbilityLength+35.65,charInfoWidth+2*m+8.3,45,charInfoHeight+0.1, true);
              translate([5,0,0]) cube([charInfoLength+m,charInfoWidth+m, charInfoHeight*2], true);
          }
          translate([9.875+3.375,0,12.875]) rotate([0,0,180]) 
            difference(){
              cube([charAbilityLength+32.25,charInfoWidth+2*m+1.55, 0.75], true);
              
              //text
              /*
              translate([-59,67.25,-1])rotate([0,0,-90])
                linear_extrude(2){
                  text("HP",size = 6,font = "Liberation Sans: style=Bold");
                }
              translate([-59,27.25,-1])rotate([0,0,-90])
                linear_extrude(2){
                  text("GP",size = 6,font = "Liberation Sans: style=Bold");
                }
              translate([-59,-18.25,-1])rotate([0,0,-90])
                linear_extrude(2){
                  text("XP",size = 6,font = "Liberation Sans: style=Bold");
                }
              */
              translate([8,0,0]) cube([charInfoLength-2*m,charInfoWidth-2*m,2+0.1], true);
            }
          translate([-49.5*0+60,76.5,10.25])rotate([90,0,0])cylinder(r=0.75, h=4, $fn=24);
          translate([-49.5*0+60,-72.5,10.25])rotate([90,0,0])cylinder(r=0.75, h=4, $fn=24);
          
          // extra height for active cards grove  
          /*translate([-46.5,0,12.875+0.75])
            cube([3,charInfoWidth+2*m+1.55, 0.75], true);
          */
        }
        
        // groves for active cards
        translate([9.875+3.375,0,12.875+0.5])
          translate([-(attackModifierLength+7.5)-6,-37,1])
            rotate([0,-20,0]) cube([0.60,(attackModifierWidth+2*m+6)*0+charAbilityWidth+2*m,7], true);
        translate([9.875+3.375,0,12.875+0.5])
          translate([-(attackModifierLength+7.5)-6,37,1])
            rotate([0,-20,0]) cube([0.60,(attackModifierWidth+2*m+6)*0+charAbilityWidth+2*m,7], true);
        
        
        // holes for mini
        translate([-50.1-3,36,12]) cube([8,30,5],true);
        
        /*
        //holes for health indicator
        translate([66,-51.5,24.2]) rotate([0,90,90])
          translate([14.75,0,25/4+0.75]) cube([5,12,20], true); 
        translate([66,-51.25,27]) rotate([0,90,90]){
          translate([14.75,0,-1.5]) cube([2.5,10,2], true);
          translate([14.75,0,15]) cube([2.5,10,2], true);
        }
        
        //holes for gold indicator
        translate([66,-7.25,24.2]) rotate([0,90,90])
          translate([14.75,0,25/4+0.5]) cube([5,12,27.5], true);
        translate([66,-7.25,27]) rotate([0,90,90]){
          translate([14.75,0,-5.25]) cube([2.5,10,2], true);
          translate([14.75,0,18.5]) cube([2.5,10,2], true);
        }
        
        //holes for experience indicator
        translate([66,37,24.2]) rotate([0,90,90])
          translate([14.75,0,25/4+0.5]) cube([5,12,27.5], true);
        translate([66,37,27]) rotate([0,90,90]){
          translate([14.75,0,-5.25]) cube([2.5,10,2], true);
          translate([14.75,0,18.5]) cube([2.5,10,2], true);
        }
        */
        // test 
  //      difference(){
  //        translate([14.75,0,25/4]) cube([1.3,15,25], true);
  //        translate([14.75,0,-0.5]) cube([1.5,10,2], true);
  //        translate([14.75,0,15]) cube([1.5,10,2], true);
  //      } 
      }
    }
  }
  /*
  if(modul == "" || modul == 4){
    translate([66,-37,27.5]) rotate([90,90,0]) indicator(2);
    translate([66,55,27.5]) rotate([90,90,0]) indicator(3);
    translate([66,10.5,27.5]) rotate([90,90,0]) indicator(3);
  }
  */
  
  //translate([51.1,0,11]) cube([3,30,5],true);
  //translate([-51.1,0,11]) cube([3,30,5],true);
  
  if(modul == "" || modul == 1){
    // wall segment
    translate([75.35,0,-3.375-0.25]) cube([1,12,attackModifierHeight-boxCorr],true);
    
    difference(){
      union(){
        // Hinges
        translate([32,-(attackModifierWidth*2+30)/2,attackModifierHeight/2+1.2]) rotate([0,90,0]) hinge("screw");
        translate([-52.6,-(attackModifierWidth*2+30)/2,attackModifierHeight/2+1.2]) rotate([0,90,0]) hinge();
        translate([52.6,(attackModifierWidth*2+30)/2,attackModifierHeight/2+1.2]) rotate([0,90,180]) hinge();
        translate([-32,(attackModifierWidth*2+30)/2,attackModifierHeight/2+1.2]) rotate([0,90,180]) hinge("screw");
      
        difference(){
          // Sides
          union(){
            translate([12.5-1.75/2,(attackModifierWidth*2+25)/2,-1]) cube([charAbilityLength+36.25,3,attackModifierHeight+2], true);
            translate([12.5-1.75/2,-(attackModifierWidth*2+25)/2,-1]) cube([charAbilityLength+36.25,3,attackModifierHeight+2], true);
          }
          
          // top mounting hole 
          // center
          translate([22.4,-83,8.25]) rotate([0,0,45]) cube([2,2,2.5], true);
          translate([22.4,83,8.25]) rotate([0,0,45]) cube([2,2,2.5], true);
          
          //edge
          translate([73.85,-83,8.25]) rotate([0,0,45]) cube([2,2,2.5], true);
          translate([73.85,83,8.25]) rotate([0,0,45]) cube([2,2,2.5], true);
          
          // hinge cutouts
          translate([0,-41.6,0.3]){
            translate([-5-charAbilityLength/2+8.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=radius_cutout, h=11, $fn=100);
            translate([charAbilityLength/2-4.0,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=radius_cutout, h=15, $fn=100);
            
            translate([-5-charAbilityLength/2-1.501,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=3, h=3, $fn=100);
            translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=3, h=3, $fn=100);

            translate([-5-charAbilityLength/2-1.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=2, h=12, $fn=100);
            translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=2, h=10, $fn=100);
              
            translate([charAbilityLength/2+7.0,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180])
              translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,0]) rotate([0,0,45]) cube([8,8,12]);
            translate([-5-charAbilityLength/2+19.5,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180]) 
              translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,0]) rotate([0,0,45]) cube([8,8,12]); 
          }
          rotate([0,0,180])translate([0,-41.6,0.3]){
            translate([-5-charAbilityLength/2+8.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=radius_cutout, h=11, $fn=100);
            translate([charAbilityLength/2-4.0,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=radius_cutout, h=12, $fn=100);
            
            translate([-5-charAbilityLength/2-1.501-4,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=3, h=7, $fn=100);
            translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=3, h=3, $fn=100);

            translate([-5-charAbilityLength/2-1.5,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=2, h=12, $fn=100);
            translate([charAbilityLength/2-14,-attackModifierWidth/2-m-7,attackModifierHeight/2+0.4]) rotate([0,90,0])
              cylinder(r=2, h=10, $fn=100);
              
            translate([charAbilityLength/2+7.0,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180])
              translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,0]) rotate([0,0,45]) cube([8,8,12]);
            translate([-5-charAbilityLength/2+19.5,-attackModifierWidth/2-m-4,attackModifierHeight/2+0.4+3]) rotate([0,90,180]) 
              translate([sqrt(radius_cutout*radius_cutout*2)/2,-sqrt(radius_cutout*radius_cutout*2)/2,0]) rotate([0,0,45]) cube([8,8,12]); 
          }
        }
      }
      // top track
      translate([12.5,0,attackModifierHeight/2-4.25]) cube([charAbilityLength+38, attackModifierWidth*2+24, 1.5], true);
      translate([12.5,(attackModifierWidth*2+24)/2-1.4,attackModifierHeight/2-3.5]) rotate([45,0,0]) cube([charAbilityLength+38, 2, 2], true);
      translate([12.5,-(attackModifierWidth*2+24)/2+1.4,attackModifierHeight/2-3.5]) rotate([45,0,0]) cube([charAbilityLength+38, 2, 2], true);
    }
  }
  
  
  // inner wall
  if(modul == "" || modul == 1){
    translate([12,0,0]){
      translate([-5.75,0,0]){
        translate([43.5,(attackModifierWidth+2*m+2*thickness+12)/2,-3.375-0.25]) 
          difference(){
            cube([attackModifierLength+2*m+2*thickness,attackModifierWidth+2*m+2*thickness, attackModifierHeight-boxCorr],true);
            translate([0,0,-0.1]) cube([attackModifierLength+2*m,attackModifierWidth+2*m, attackModifierHeight-boxCorr+3],true);
            translate([(attackModifierLength+2*m)/2,0,0]){
              translate([0,attackModifierLength/2-fingerSlotSize+1,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
              translate([0,0,-0.1]) cube([fingerSlotSize*2, attackModifierLength-fingerSlotSize*2,attackModifierHeight-boxCorr+1], true);
              translate([0,-(attackModifierLength/2-fingerSlotSize+1),-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
            }
          }
        translate([43.5,-(attackModifierWidth+2*m+2*thickness+12)/2,-3.375-0.25]) 
          difference(){
            cube([attackModifierLength+2*m+2*thickness,attackModifierWidth+2*m+2*thickness, attackModifierHeight-boxCorr],true);
            translate([0,0,1]) cube([attackModifierLength+2*m,attackModifierWidth+2*m, attackModifierHeight-boxCorr+3],true);
            translate([(attackModifierLength+2*m)/2,0,0]){
              translate([0,attackModifierLength/2-fingerSlotSize+1,-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
              translate([0,0,-0.1]) cube([fingerSlotSize*2, attackModifierLength-fingerSlotSize*2,attackModifierHeight-boxCorr+1], true);
              translate([0,-(attackModifierLength/2-fingerSlotSize+1),-0.1]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
            }
          }
        }
    translate([-4,-2,0]){
      translate([-22,-(attackModifierWidth+2*m+2*thickness+8)/2-12.5,-3.375-0.25]) rotate([0,0,90])
        difference(){
          cube([attackModifierLength+2*m+2*thickness,attackModifierWidth+2*m+2*thickness, attackModifierHeight-boxCorr],true);
          translate([0,0,1]) cube([attackModifierLength+2*m,attackModifierWidth+2*m, attackModifierHeight-boxCorr+3],true);
          translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.5]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
        }
        
      translate([-22,-(attackModifierWidth+2*m+2*thickness+15)/2+42.5,-3.375-0.25]) rotate([0,0,90])
        difference(){
          cube([attackModifierLength+2*m+2*thickness,attackModifierWidth+2*m+2*thickness, attackModifierHeight-boxCorr],true);
          translate([0,0,1]) cube([attackModifierLength+2*m,attackModifierWidth+2*m, attackModifierHeight-boxCorr+3],true);
          translate([0,(attackModifierWidth+m*2+thickness*2)/2,0.5]) cylinder(r=fingerSlotSize, h=attackModifierHeight-boxCorr+1,center=true,$fn=100);
        }
        
      translate([-22,-(attackModifierWidth+2*m+2*thickness+15)/2+99.5,-3.375-0.25]) rotate([0,0,90])
        difference(){
          cube([attackModifierLength+2*m+2*thickness+11.5,attackModifierWidth+2*m+2*thickness, attackModifierHeight-boxCorr],true);
          translate([0,0,1]) cube([attackModifierLength+2*m+11.5,attackModifierWidth+2*m, attackModifierHeight-boxCorr+3],true);
        }
      }
    } 
  }
}



// -------------------------
//
// Discard and lost side
//
// -------------------------

    difference(){
        myrotate([lidPos,0,0],[0,-attackModifierWidth/2-9+attackModifierWidth*3/2+24,attackModifierHeight/2+0.7]){
          translate([0,attackModifierWidth*3/2+24,0]){ 
            deckStorage("discard");
            
            // lid
            translate([0,4.75,9.5]){
              lid(attackModifierLength*2+2*m+5,attackModifierWidth+2*m+2*3, 1.3, true, 10, fingerSlot = false);
              translate([0,attackModifierWidth/2-0.45,-attackModifierHeight/2+6.05]) rotate([90,0,0]) 
                lid(attackModifierLength*2+2*m*0+5,attackModifierHeight-1.2,1.3, fingerSlot=false);
            } 
            
            // shelf
            //translate([0,6,-7]){
            union(){
              lid(attackModifierLength*2+2*m+5,attackModifierWidth, 1.3, true,10,true);
              translate([0,-attackModifierWidth/2-4.15,3]) rotate([90,0,0]) 
                cube([attackModifierLength*2+1,5.5,1.3], true);
            }
            
            // shelf with text
            union(){
              difference(){
                union(){
                  lid(attackModifierLength*2+2*m+5,attackModifierWidth, 1.3, true,10,true);
                  translate([0,-attackModifierWidth/2-4.15,3]) rotate([90,0,0]) 
                    cube([attackModifierLength*2+1,5.5,1.3], true);
                  
                }
                
                //=== Discard / Lost ===
                translate([-attackModifierLength+16,25,0]) rotate([90,0,0]) 
                  cube([38,1.4,10], true);
                
                //=== Hand ===
                translate([attackModifierLength-16,25,0]) rotate([90,0,0]) 
                  cube([38,1.4,10], true);
                
                
              }
              
              
              //=== Discard / Lost ===
              difference(){
                translate([-attackModifierLength+16,25,0])
                difference(){
                  rotate([90,0,0]) cube([38,1.3,10], true);
                  translate([0,1,0]) rotate([0,0,180]) linear_extrude(2){
                    text(
                      "DISCARD",
                      size = 6,
                      font = "Liberation Sans",
                      halign = "center",
                      valign = "center"
                    );
                  }
                }
              }
              
              
              //=== Hand ===
              difference(){
                translate([attackModifierLength-16,25,0])
                difference(){
                  rotate([90,0,0]) cube([38,1.3,10], true);
                  translate([0,1,0]) rotate([0,0,180]) linear_extrude(2){
                    text(
                      "HAND",
                      size = 6,
                      font = "Liberation Sans",
                      halign = "center",
                      valign = "center"
                    );
                  }
                }
              }
             
            }
            //}
          }
        }
    }  


// -------------------------
//
// Hand and supply side
//
// -------------------------
    myrotate([lidPos,0,0],[0,attackModifierWidth/2+9-(attackModifierWidth*3/2+24),attackModifierHeight/2+0.7]){
      translate([0,-(attackModifierWidth*3/2+24),0]) rotate([0,0,180])
       deckStorage("hand");
    }

// -------------------------
//
// Lock for sideboxes
//
// -------------------------
    rotate([0,0,180]) translate([(attackModifierLength+8)+10*0,132.5,-8.5]){
      difference(){
        union(){
          difference(){
            union(){
              translate([0,0,-0.05]) cube([3-0.4,attackModifierWidth+m*2+thickness*6-4,9-0.3], true);
              translate([-1.7,0,4.3]) 
                difference(){
                  rotate([0,45,0]) cube([4.2426,attackModifierWidth+m*2+thickness*6-4,4.2426], true);
                  translate([-2.1,0,0]) cube([5,attackModifierWidth+m*2+thickness*6-3,10], true);
                }
            }
            translate([-1.5,-25.5,0])cube([3,8,20], true);
            translate([-1.0,-25.5,-3.4])cube([3,8,5], true);
          }
          
          translate([-0.7,-25.5,2.2])cube([1.1,7.8,12.4], true);
          translate([-0.4,-25.5,-2.4])rotate([0,10,0])cube([1.1,7.8,3], true);
          translate([1.58,-25.5,7.7])rotate([0,-45,0])cube([3,7.8,5], true);
        }
        //translate([-0.5,-35.5,-2.5])cube([10,20,20], true);
      }
    }


// -------------------------
//
// Dial center rod
//
// -------------------------

    translate([63.5,-87.2,-1]) rotate([90,0,0]) scale(0.87) dail2("0123456789",2,89.7);




// -------------------------
//
// Main unit
//
// -------------------------
    mainUnit();


// -------------------------
//
// Card Holder
//
// -------------------------
 
    translate([2.88,0,13.9]){
      difference(){
        cube([charInfoLength-4.5, 30,3], true);
        translate([-30,0,0])
        for(i=[0:5]){
          translate([-10+15*i,0,2.25])
            rotate([0,-20,0]) cube([0.60,32,7], true);
        }
        translate([42,-25,-0.25]) cube([10,50,10]);
        translate([42,-25,-0.25]) rotate([0,-45,0]) cube([10,50,10]);
        translate([-45.5,-25,-0.25]) rotate([0,-45,0]) cube([10,50,10]);
      }
      translate([0,0,-1.6])
        cube([charInfoLength, 30,0.3], true);
    }


// -------------------------
//
// Codes for measurements
//
// -------------------------


// Minis
/*
    translate([-23,50,0]){
      translate([-25,0,0]) cube([2,36,27], true);
      translate([0,0,0]) cube([50,36,15], true);
    }
*/


// char plate
/*
    color("gray")
      translate([3,0,attackModifierHeight/2-0.6-0]) cube([charInfoLength,charInfoWidth, charInfoHeight], true);
/*

// char sheet
/*
    color("gray")
      translate([11,0,attackModifierHeight/2-2.75]) cube([sheetWidth, sheetLength, sheetThickness], true);
*/


// Cards

// Ability Card
/*
    translate([0,0,-6])
      cube([charAbilityLength, charAbilityWidth, cardHeight*15], true);
    translate([0,-6,5])
      cube([charAbilityLength, charAbilityWidth, cardHeight*13], true);
*/


// Attack modifier card
/*
    //translate([43,39,-7])
    k=15;
    a=6;
    for(i=[1:a]){
      myrotate([-45,0,0],[0,(attackModifierWidth/2+k*(i-1)-2),((2*a+1)*cardHeight+(a-1)*0.1)/2]){
      //translate([0,-(attackModifierWidth/2+k*(i-1)-2),0]){
        //translate([0,k*(i-1),(cardHeight*2)*i-cardHeight/2])
        //  cube([attackModifierLength, attackModifierWidth, cardHeight*1], true); 
        translate([(attackModifierLength+4)/2+1,attackModifierWidth/2+k*(i-1)-2,((2*a+1)*cardHeight+(a-1)*0.1)/2]) cube([4,(2*a+1)*cardHeight+(a-1)*0.1,(2*a+1)*cardHeight+(a-1)*0.1], true);
        translate([-(attackModifierLength+4)/2-1,attackModifierWidth/2+k*(i-1)-2,((2*a+1)*cardHeight+(a-1)*0.1)/2]) cube([4,(2*a+1)*cardHeight+(a-1)*0.1,(2*a+1)*cardHeight+(a-1)*0.1], true);
        
        translate([0,attackModifierWidth/2+k*(i-1)-2,cardHeight/2+(cardHeight*2+0.1)*(i-1)]) cube([attackModifierLength+2, (2*a+1)*cardHeight+(a-1)*0.1, cardHeight*1], true); 
        translate([0,attackModifierWidth/2+k*(i-1)-2,cardHeight*2.5+(cardHeight*2+0.1)*(i-1)]) cube([attackModifierLength+2, (2*a+1)*cardHeight+(a-1)*0.1, cardHeight*1], true); 
      }
      
    }

    translate([(attackModifierLength+12)/2,38,((2*a+1)*cardHeight+(a-1)*0.1)/2]) 
      cube([1.5, attackModifierWidth*2+10, sqrt(2*((2*a+1)*cardHeight+(a-1)*0.1)^2)], true);
    translate([-(attackModifierLength+12)/2,38,((2*a+1)*cardHeight+(a-1)*0.1)/2]) 
      cube([1.5, attackModifierWidth*2+10, sqrt(2*((2*a+1)*cardHeight+(a-1)*0.1)^2)], true);

    translate([0,38,-1.22]) 
      cube([attackModifierLength+12, attackModifierWidth*2+10, 1], true);
*/




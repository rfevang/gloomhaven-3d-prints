
// TODO: Remove this and replace with function parameter if needed
c = 1;

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

MakeSide(100, 30, 10, 1, 10, 5);
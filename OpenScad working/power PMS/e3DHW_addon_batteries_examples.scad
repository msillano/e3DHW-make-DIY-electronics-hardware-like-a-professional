/*
   e3DHW project ©2018 Marco Sillano  (marco.sillano@gmail.com)
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This project is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
   
   Designed with: OpenScad 2019.05 http://www.openscad.org/
   Tested with: 3DRAG 1.2 https://www.futurashop.it/3drag-stampante-3d-versione-1.2-in-kit-7350-3dragk
   Documentation extracted by Doxygen 1.8.15 http://www.doxygen.nl/
*/


 include <e3DHW_base_lib.1.3.scad>
 include <e3DHW_array_utils.1.3.scad> 
 include <e3DHW_addon_base.1.3.scad> 
 include <e3DHW_addon_batteries.1.3.scad> 
 
// test for all battery holders
module test_batteries(){
   for (k =["AAx3","AAAx3","18650x1","18650Px1"])
      translate([0, get_position(k,_BATTHOLDER)*80,0]) 
      union(){
         difference() {
            rectangleBase(120, 86, fill=100);
            carve1_batteryHolder(k, x= 20, y=10);   // carve battery holder before
            }
      add2_batteryHolder(k, x= 20, y=10);   // then add battery holder
     }
   }

module test_LM3914(){
   difference() {
      union(){
         rectangleBase(80, 100, fill=100);
         add1_LM3914_10LED( x=10, y=10);
         add1_LM3914_XLED(n=3, x=10, y=50);
         }
        carve2_LM3914_10LED( x=10, y=10);
        carve2_LM3914_XLED(n=3, pos="rigth", x=10, y=50);
      }
   }

// required by do_arduino_pms()
  include <e3DHW_hardware_data.1.3.scad>;
  include <e3DHW_pcb_board_data.1.3.scad>;    // arduino board data
  include <e3DHW_addon_terminal.1.3.scad>;    // terminals
  include <e3DHW_addon_box.1.3.scad>;         // for carve_roundPolyBorder

// Arduino Yun board with PMS
// Arduino Yun max 300 mA (https://forum.arduino.cc/index.php?topic=188821.0)
module do_arduino_pms(){
   module arduino_yun_box(x=0, y=0, rot=norot){
   // the box border is carved 
       xb =get_maxX(arduinoYunVertex);
       translate([x,y,0]) rotate(rot) difference(){
            add_polyBox(arduinoYunVertex);
 //     carve_roundPolyBorder(get_squareArray2 (16, 17.5),  r=0, x= 3,y=31);   // lan, 17.5 @31
 //     carve_roundPolyBorder(get_squareArray2 (16, 8.0),   r=0, x= 3,y=16);   // USB, 8 @15
 //     carve_roundPolyBorder(get_squareArray2 (16, 7.18),  r=0, x= 3,y=6.0);  // USB, 7.18 @6
      carve_roundPolyBorder(get_squareArray2 (16, 13.50), r=0, x= xb+4,y=11);//SM 13.50, @11
           }
      }
  // dimensions 
   xs = 106; //from container size
   ys = 145;
   xd = 83;  // center hole distance
   dv = 24;  // diam. vertex cut

   bx = 16.4;   // size box for 5V step-up module
   by = 35.5;
   
   lx = 45.53;  // size box led batt-status
   ly = 13.80;

  // placements
   xb = 82;   //batteries holder position
   yb = 68;
 
   xa =24 ;   // Arduino position
   ya = ys/2+8;
//
   baseV= get_squareArray2(xs,ys);                  // the main board vetex array
//  here all base holes:
   baseH= [[(xs-xd)/2,ys/2,3],[(xs+xd)/2,ys/2,3]];  // 2 fixing holes
   baseC= get_array3(baseV, d = dv);                // 4 corner holes to meet the box shape
   baseA= translateArray3(arduinoUnoR3Holes, xa+BOXTOLERANCE+BOXTHICKNESS, ya+BOXTOLERANCE+BOXTHICKNESS); // Arduino fixing holes

// first buil the base, then carve it, after the adds and the final carves
difference(){
   union(){
      difference() {
         polyBase(baseV, concat(baseH, baseC, baseA), fill=66);
         carve1_batteryHolder("AAx3", xb, yb, rot=[0,0,180]);  //  3xAA NiMH batteries
         }
      add2_batteryHolder("AAx3",x= xb, y=yb, rot=[0,0,180]);   //  3xAA NiMH batteries
      // placing Arduino
      arduino_yun_box(x = xa, y = ya);
      add_rectangleBox(bx, by, x= xs-22, y=30);             // box for 5V step-up
      add_rectangleBox(ly, lx, x= EXTRA, y=20);             // box for status LEDs
      add_cableFix(4, false, x=66 , y=3, rot= [0,0,90]);    // power cable fix
      add_cableFix(4, false, x=66+8 , y=3, rot= [0,0,90]);  // power cable fix
      add1_terminalM3Block(n= 2, x=18, y = 3);              // input VCC
      add1_terminalM3Block(n= 2, x=xs-10 , y=7, rot=[0,0,90]);     // output VCC
      add1_milsBox(4,1, x=3, y = 13);
      }
   carve2_terminalM3Block(n= 2, x=18, y = 3);  // input VCC
   carve2_terminalM3Block(n= 2, x=xs-10 , y=7, rot=[0,0,90]);  // output VCC
   carve2_milsBox(4,1, x=3, y = 13);
   carve_rectangleBox(ly, lx, x= EXTRA, y=20);  // box for status LEDs
   }
}
 
  // =================== UNCOMMENT TO RUN

 // test_batteries();
 // do_arduino_pms();
 
  test_LM3914();

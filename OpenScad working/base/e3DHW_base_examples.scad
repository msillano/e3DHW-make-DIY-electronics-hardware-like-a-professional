/*
   e3DHW project © 2018 Marco Sillano(marco.sillano<at>gmail.com)
   This library is free software: you can redistribute it and/or modify
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
/**
 @file e3DHW_base_examples.scad
 Examples for library e3DHW_base_lib.1.3.scad
 */

include <e3DHW_base_lib.1.3.scad>
include <e3DHW_array_utils.1.3.scad>
include <e3DHW_hardware_data.1.3.scad>

// Shows the use of rectangleBase(), rectangle4Holes(), do_perimetral(), polyBase().
module test_base_lib() {
   testBoard = [[0,0],[30,0],[30,50],[40,50],[40,100],[0,100]];
   testHoles = [[10,20,8],[20,20,-6],[10,80, -57]];
   angle= [0,0,0];
   //
   rectangleBase(rx = 40, ry=80,  fill=100, rot=angle);          
   rectangle4Holes(20, 60, x = 50, rot=angle);   // uses defaults
   translate([100,0,0])rotate(angle)do_perimetral(vertex=testBoard, width = 10);
   polyBase(vertex = testBoard, holes = testHoles, fill=80, thickness=8, x = 150, rot=angle);
   polyBase(vertex = testBoard, holes = testHoles, fill=100, x=200, rot=angle);
}

// Shows all special holes that do_nuthole() can make.
// Print this example to fine tune the hardware data (in e3DHW_hardware_data.1.3.scad) for your 3D printer and filament.
 
 
module test_do_nuthole(){
   BOARDTHICKNESS = 6;  // overwrite global default in local scope 
   difference(){
      rectangleBase(20, 90, fill = 100, thickness =6);
      for(i =[0:8]) {
         translate([5,-5+i*10,0])do_nuthole(-i, s =6);     
         }
      translate([5,85,0])do_nuthole(-1180, s =6);     
         
      for(i =[51:58]) {
         translate([15,-5 + (i-50)*10,0])do_nuthole(-i, s =6);     
         }
      translate([15,85,0])do_nuthole(-2000, s =6);     
      }
   }

/**
@fn test_get_boltz_get_nutz()
*/
// A development test for 2 private functions used by do_nuthole():
//   _get_boltz() returns the bolt carving deep in nut insert (doubled).
//   _get_nutz() returns the deep for the nut.
// This test shows the carving shapes makes by do_nuthole() for codes -1090 and -2090, for diffent support thicknesses.
// You can get the STL and make exact measures (the cube replaces the support) using netfabb, to fine tune _get_boltz() and _get_nutz() on hardware data.
// General rules: 
//   1. The thickness under the nut must be more than _minz but with a limit to mm 3.
//   2  If possible the nut and the bolt must be hidden on the opposite side.

module test_get_boltz_get_nutz(){
   for(i =[4:0.5:15]){   // thickness from 4 to 15
   translate([80*(i-8),0,0]){
      do_nuthole(-1090, s = i); // botton case, left
      cube(i);   // the cube replaces the support, 
      translate([i,0,0]) do_nuthole(-2090, s = i);  // top case, right
      translate([0,-20,0])linear_extrude(1)text(str (i));
     }
   }
}

// =================== UNCOMMENT TO RUN

// test_base_lib();
// test_do_nuthole();
// test_get_boltz_get_nutz();


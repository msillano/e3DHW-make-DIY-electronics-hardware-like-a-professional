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
include <e3DHW_hardware_data.1.3.scad>

// 
module all_base_addon(){
difference(){
   union(){
      rectangleBase(80, 210, fill=100, x=10); // a solid base
      // here  add_xxxx addons
      add_rectangleBox(50, 20, closed=true, x=35, y= 2);
      add1_polySupport([[20,10,-11]], 15, 6, 8, angle= 45, horiz = false); 
      add_polyBox(arduinoUnoR3Vertex, x=12, y = 40);
      add1_polyTower(15, arduinoUnoR3Holes, cbase=true, x=12, y=150);
      add_text("addons", size=6, h=80,x=10, y=110);
      add1_tower(10, x=23, y=110);
      add1_polySupport([[30,130,3]], 15, 6, 8, horiz = true); //one support by array
      add_cableFix(2, x=50, y=130);
      add_cableFix(4, x=60, y=125);
      add_cableFix(6, x=70, y=120);
    }
 // here  carve_xxxx addons
    carve_rectangleBox(50, 20, closed=true, x=35, y= 2);
 //   carve_polyBox(arduinoUnoR3Vertex, x=12, y = 40);
    carve2_tower(10, x=23, y=110);
    carve2_polySupport([[20,10,-5]], 15, 6, 8, angle= 45, horiz = false); 
    carve2_polySupport([[30,130,3]], 15, 6, 8, horiz = true);
    carve2_polyTower(15, arduinoUnoR3Holes, cbase=true, x=12, y=150);
   }
 // one more board  
 difference(){
   rectangleBase(60, 160, fill=100, x= -70); // a new solid base
      // here  carve_xxxx addons
   carve_roundHole(12, x=-50, y=20);
   carve_elongatedHole(6, 25, x=-50, y=35);
   carve_roundRectangle(30,20,4, x=-50, y=50);
   carve_roundRectangle(xr=10,yr=4,rr=0, x=-50, y=80);
   star =[[12.5,0],[10,10],[0,12.5],[10,15],[12.5,25],[15,15],[25,12.5],[15,10]];
   carve_roundPoly(star, x=-30, y=80);
   carve_dymoD1_9(20, x=-60, y=100);
   carve_colander (d=4, s=6, rows=3, cols = 6, x=-60, y=120);
   carve_text(txt = "carved", size=6,h = -60, x=-10, y=150);  // note h < 0
   }
}   


// base support for scheduled irrigation system with sonoff-basic + humidity meter to fit in Itead box.
// see photos there https://github.com/msillano/sonoff_watering/blob/master/watering-sonoff-en01.pdf 
module watering_Sonoff04(){
   difference(){
      union() {
         rectangle4Holes(43,44,12.3,12.3,6,6, -57); // base: size from Itead box
 //here addons add_xxxx
         add_polyBox(sonoffBasicVertex, x = -EXTRA); // added EXTRA to fix design
         add_rectangleBox(30.50,15.08, x=17, y =38.3); // humidity meter pcb
         add_text(txt="MSWS04", size=3, x=66, y =38.3, rot=[0,0,90]);
         }
 //here carve_xxxx
      carve_rectangleBox(30.50,15.08, x=17, y =38.3); // humidity meter pcb is carved
      }
  }

// =================== UNCOMMENT TO RUN

// all_base_addon();
// watering_Sonoff04();



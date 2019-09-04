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
include <e3DHW_hardware_data.1.3.scad>
include <e3DHW_addon_base.1.3.scad>
include <e3DHW_DIN_rail_lib.1.3.scad>
include <e3DHW_DIN_boxes_lib.1.3.scad>
include <e3DHW_addon_box.1.3.scad>

// Shows all vertical box addons
module vertical_test() {
star =[[12.5,0],[10,10],[0,12.5],[10,15],[12.5,25],[15,15],[25,12.5],[15,10]];
difference() {
   union(){
      translate([50-BOARDTHICKNESS,0,0])cube([BOARDTHICKNESS,150,70]);
      translate([50,10,0])add_PcbGuide(70);
      }
   // low-level: using here carve_text() from addon_base, because don't exist a 'border' version:
   translate([50, 90, 10])carve_text("carved border", size=7, rot=[90,0,-90]); 
   carve_holeBorder(12, h=70, x=50, y = 30);
   carve_elongatedHoleBorder(2, 8, h=70, x=50, y = 50);
   carve_roundPolyBorder(star, h=70, x=50, y = 60);
   carve_colanderBorder (d=4, s=6,rows=3, cols = 3, h=70,  x=50, y = 100);
   }
}

// This is the DIN container for the project:
// https://www.hackster.io/msillano/adding-a-remote-switch-to-sonoff-one-pin-for-switch-led-901cd3
module din_DSP4(){
 include <e3DHW_addon_terminal.1.3.scad> //required for this project
// local re-definitions for this project
  _TEXTFONT   ="DejaVu Sans Mono: style=Bold";  // test 
  DEFAULTFILL = 60;
// constats
_hm=3; // 3 half modules = 26.5 mm
   //
    length = get_H(_hm);
    difference(){
        union(){
           simpleDINBox(_hm, width= DINWIDTHS, top = DINHTOP, boxThick = TOPTHICKNESS, lidStyle = LSNONE, bottomFill=DEFAULTFILL, leftless=-8);
           // here addons
           // box for Sonoff
           add_polyBox(sonoffBasicVertex,3, x=-6.5, y=2.5);
           // 2 x 3 mammuts for 110/220 V AC (IN/OUT)
           add_cubeMammut(3, 2, length, type =HT, x=84, y=30);
           add_cubeMammut(3, 2, length, type =HT, x=93, y=2);
           // decoration
           add_text("MSDSP4", 5,  x=29, y=56);
           }
     // here carving things
     // front switch
       translate([85/2-5,65,length/2])carve_elongatedHoleBorder(12, 2, rot=[90,0,90]);
     // aeration
       carve_elongatedHoleBorder(2,length-12, h=length, x= -5 , y= 30 ,rot=[0,0,45]);
       carve_elongatedHoleBorder(2,length-12, h=length, x= 62 , y= 53,rot=[0,0,135]);
      // 2 mammuts re-carving:
       carve_cubeMammut(3, 2, length, type =HT, x=84, y=30);
       carve_cubeMammut(3, 2, length, type =HT, x=93, y=2);
      // dymo  labels
       translate([87.2,16,-10])carve_dymoD1_9(45, rot = [0,-90,0]);
       translate([76,45.1,-10])carve_dymoD1_9(45, rot = [0,-90,90]);
      }
}

// =================== UNCOMMENT TO RUN

// vertical_test();
// din_DSP4();

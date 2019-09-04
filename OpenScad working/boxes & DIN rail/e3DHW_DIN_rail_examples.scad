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
include <e3DHW_hardware_data.1.3.scad>
include <e3DHW_DIN_rail_lib.1.3.scad>
include <e3DHW_array_lib.1.3.scad>
// test: all DIN clips on a rail

module show_all(){
   OPTION_RAIL = 80;  // to test
  // low-level: all clips, with the smallest size.
  // All clips are translated and rotated to have the top center of the DIN rail aligned on the x axis.
  // The main parameter is clipD: the distance of the clip holes or the clip top dimension (see do_DINClip())
   for (clip = ["SCB","SPC","SCC","SPF","SCF","NSS","MSX"], inc=[0, 20])
      let( clipD = get_min_d(clip)+inc,   // clipD: clip holes distance or clip top size, 2 values, min and min+20
         xoffset =  -(clipD *get_xm(clip) + get_xq(clip)) - get_exd(clip)/2 )  // x required to center the DIN rail
         translate([60*get_position(clip, _DINCLIPS),inc*6,0]) rotate([90,0,90])  // to sets clips aligned
//
            translate([xoffset, get_rail2top(clip),0])    //  to center rail
               do_DINClip(clip, get_min_h(clip), clipD);  //  makes the DIN clip

// Same, but now high-level, for custom applications: All clips are centered and interchangeable (*)
// Here you can use the get_ClipWidth() and get_ClipTrnsX() utilities.
// The main parameter is now 'width', the top usable width (in this example it is a cube())
   for (clip = ["SCB","SPC","SCC","SPF","SCF","NSS","MSX"], width=[70, 90])  // 70, 90: big enough for all clips(*)
      let( clipD = get_ClipWidth(clip, width) ,   // clipD: the clip holes distance or clip top size
         xoffset = get_ClipTrnsX(clip, width) ){   // x requred by translate() to center the DIN rail
         translate([60*get_position(clip, _DINCLIPS),(width-30)*6,0]) rotate([90,0,90])  // to sets clips aligned
//
          translate([0, get_rail2top(clip),0]) union() {  //   to set rail on axis
               translate([xoffset, 0,0])do_DINClip(clip, get_min_h(clip), clipD); // makes the DIN clip centered
               cube([width, 8, get_min_h(clip)]);  // your custom project, starting (0,0)
               }
            } 
//(*) note: the clips have different minimum sizes, so they are not "always" interchangeables!
  }

// =================== UNCOMMENT TO RUN

  show_all();

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
include <e3DHW_array_lib.1.3.scad>
include <e3DHW_hardware_data.1.3.scad>
include <e3DHW_addon_base.1.3.scad>
include <e3DHW_DIN_rail_lib.1.3.scad>
include <e3DHW_DIN_boxes_lib.1.3.scad>

// tests rectangleBox() and custom box
module test_boxes(){
// standard rectangleBox: smallest
   rectangleBox( 15, 15, 10, lidThick = NOTOPTHICKNESS, bottomThick = NOTOPTHICKNESS, lidHole = 0,  towerHole =0, lidStyle = LSIN, y = 220 );
// standard rectangle box: example
   rectangleBox( 40, 80, 35, lidHole = -5, lidThick = TOPTHICKNESS, towerHole = -2000, bottomFill = 86, lidStyle = LSOUT, y = 100 );
}

// custom box: box with lateral panel
module custom_box(){
 lidStyle = LSIN;   // lid style: lid is lateral.
 towerHole =-58;    // lid fixing holes, see do_nuthole()
 boxLidHole = -7;   // lid fixing holes, see do_nuthole()
// towers size and position:
 towRadius = get_towerRadius(towerHole, lidStyle);
 dt = get_towerDistance(towerHole, lidStyle);
 // now shape definition:
 boxvertex=[[0,0],[120,0],[120,75],[90,75],[30,40],[0,40]];
 boxHeight = 120;
// Automatic tower positionning is implemented for rectangles and DIN box shapes only.
// For generic polygonal shapes the positionning must be done by hand.
// As an aid,in the design phase, use the do_verifyArrays(vertex, towers) module to test the arrays. You must use it alone: you comment all the code after do_verifyArrays().
 boxtowers=[[+dt,+dt,towerHole],
           [120-dt,0+dt,towerHole],
           [120-dt,75-dt,towerHole],
           [90+dt/2,75-dt,towerHole],
  //         [30-dt,40-dt,undef],             // no tower
           [0+dt,40-dt,towerHole]];
 
// do_verifyArrays(boxvertex, boxtowers );

// In standard cases, it is easy to get the hole array for the lid from the tower array: 
lidHoles =get_tower2holes(boxtowers, boxLidHole); 
// now ready to do the box: because the panel is a lateral box side, the default thicknesses are changed.
do_standalone_polyBox(boxvertex, height = boxHeight, lidAHoles = lidHoles, lidStyle = LSIN, lidThick = NOTOPTHICKNESS, lidFill = 80, bottomThick=NOTOPTHICKNESS, bottomFill = 80, sideThick = TOPTHICKNESS, towerAHoles = boxtowers, towerRadius=towRadius, round_box=_slabcorner);
  if (OPTION_BOXPRINT)   // close and print style
   do_standalone_polyLid(boxvertex, height = boxHeight, lidAHoles = lidHoles, lidStyle = LSIN, lidThick = NOTOPTHICKNESS, lidFill = 80, bottomThick=NOTOPTHICKNESS, bottomFill = 80, sideThick = TOPTHICKNESS, towerAHoles = boxtowers, towerRadius=3.2, round_box=_slabcorner);
  else 
    translate([-10,0,boxHeight+0.1])rotate([0,180,0])
       do_standalone_polyLid(boxvertex, height = boxHeight, lidAHoles = lidHoles, lidStyle = LSIN, lidThick = NOTOPTHICKNESS, lidFill = 80, bottomThick=NOTOPTHICKNESS, bottomFill = 80, sideThick = TOPTHICKNESS, towerAHoles = boxtowers, towerRadius=3.2, round_box=_slabcorner);
}

// custom DIN separator, trapezoidal
module my_separator (clip, length, large, height, w, x=0, y=0, rot = norot) {
   lateral = 28;  // used in vertex
// parameters test
   assert(w >= 0 && w <=100, "out range: w is percent: (0..100)");
   _useCLIP =  get_Clip(clip, length, ["NSS","SPF"]);  // so length min 1 (as separator)
   assert ((height >= get_rail2top(_useCLIP)) && (height>=lateral),str(" parameter height too small, min ",max([get_rail2top(_useCLIP),lateral])) );  
   if (height > DINPOT) echo(str(" WARNING: height (",height,")too big for standard DIN containers, max (",DINPOT,")"));
// building my shape, from parameters: height, w, lateral, large:
myVertex =[[0,0],[large,0],[large,lateral], [large*(0.5+w*0.005),height], [large*(0.5-w*0.005),height], [0,lateral]];
// doing separator:
polyDINSeparator(vertex = myVertex, length = (length), width=xauto, uclip = _useCLIP, fill = 100, x=(x), y=(y), rot = (rot));
}

//  shows a selection of strong terminals from my_separator()
module test_terminals(){
for(m=[28,33,38,43], n = [0, 20, 40, 60, 80, 100]){
   // I wanna strong terminals, not separators, so I use "SCF" clip and length = 12:
       my_separator ("SCF", length = 12, large = DINWIDTHS, height = m, w=n, x=n*5, y=(m-28)*20, rot = norot);
        translate([n*5,(m-28)*20,0])linear_extrude(height = 1) text(str(m,"-",n,"%"));
      }
   }

// test boxDINSeparator with all DIN clips (min length).
module test_boxDINSeparator1() {
for(i=[0:get_clipCount()-1]){
  let(clip =get_Key0(i)){
     boxDINSeparator(length=get_min_h(clip), uclip = clip, width= DINWIDTHS, top = DINHTOP, fill = 0, y= i*100, rot=[90,0,0]);
      #translate([-40,i*100,0])linear_extrude(height = 1)text(clip);
     }
   }
}

// test boxDINSeparator standard 1 to 19 mm, fill decrescent
module test_boxDINSeparator2() {
for(i=[0:6]){
boxDINSeparator(length=3*i + 1, width= DINWIDTHS, top = DINTOP, fill = max(0, 100-i*20), x = 150, y= i*100, rot=[90,0,0]);
   #translate([250,i*100,0])linear_extrude(height = 1)text(str("L= ", 3*i + 1," fill= ",max(0,(100-i*20))));
   }
}

// many simpleDINBox
module test_DINboxes() {
   widths=[DINWIDTHS, DINWIDTHM, DINWIDTHL ];
   tops = [DINPOT, DINTOP, DINHTOP];
   for(size = [1, 3]){
      for(w = [0:8]){
         simpleDINBox(size, tops[w%3], widths[w/3], x=w*120, y=(size-1) *50);
         }
      }
   }

// test  3 bigDINBox()
module test_bigDINBox() {
bigDINBox(size_hm = 14, top=DINPOT, topFill= 79.1, base_width=100); // wide (mm 100) without TOP
translate([150,0,0]) bigDINBox(size_hm = 14, top=DINTOP, base_width=DIN_BOX_TOP_WIDTH);  // smallest (mm 45) with TOP
translate([300,0,0]) bigDINBox(size_hm = 14, top=DINHTOP, base_width=100);  // wide (mm 100) with top
}

// test of all LidStile on a small box
module test_lidStyle() {
                     rectangleBox( 40, 40, 30, lidStyle = LSNONE);
 translate([50,0,0]) rectangleBox( 40, 40, 30, lidStyle = LSTOW);
 translate([100,0,0])rectangleBox( 40, 40, 30, lidStyle = LSOUT);
 translate([150,0,0])rectangleBox( 40, 40, 30, lidStyle = LSIN);
}

// =================== UNCOMMENT TO RUN

// test_boxes();
// custom_box();
// test_terminals();
// test_boxDINSeparator1();
// test_boxDINSeparator2();
// test_DINboxes();
// test_bigDINBox();
// test_lidStyle();


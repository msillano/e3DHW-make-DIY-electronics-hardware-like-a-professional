/*
   Parametric DIN modules, OpenSCAD library
   © 2018 Marco Sillano  (marco.sillano@gmail.com)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
   Designed with http://www.openscad.org/
*/
/**
 @file e3DHW_DIN_modules_A.1.3.scad
 Collection of ready to print and use DIN modules.
 Here you can found:
  \li dinBasicTerminalBlock() serie. It uses simple double mammuts, size variabile, wire variable, as defined in e3DHW_addon_terminal.1.3.scad. \n
  \image html dinterminalbasic.jpg
   The family is completed by end plates, dinBasicEndPlate() and strong end brackets with screw, dinBasicEndBrackets().
  
   \li dinTowerTerminalBlock() serie. It offerts 2, 4 or 6 connections, in couples or wired togheter. 
   \image html dinterminaltower.jpg
   Very flat (less than half module) and easy to print, it is a real space saver.\n
   The family is completed by parametric end plates dinTowerEndPlate() and end brackets with screw dinTowerEndBrackets().
   
    \li dinQuickConnector() is a support for compact splicing connector with operating levers.
   (WAGO 222-415 PCT-215 PCT215).
   
    \li dinStrainRelief() to fix cables (diameter 3-22 mm) to DIN rail. Requires nylon tie straps.
   \image  html moremodules.jpg
@note: Terminal are designed to require as parameter only the cable section. The correct mammut core is chose from e3DHW_mammut_data.1.3.scad.

@par dependences
  This library requires:
      \li \c e3DHW_base_lib.1.3.scad
      \li \c e3DHW_hardware_data.1.3.scad
      \li \c e3DHW_addon_base.1.3.scad
      \li \c e3DHW_DIN_rail_lib.1.3.scad
      \li \c e3DHW_DIN_boxes_lib.1.3.scad
      \li \c e3DHW_addon_terminal.1.3.scad
     \li \c e3DHW_mammut_data.1.3.scad
      
  To use this collection you must add the following lines to your code:
      \li <tt> include <e3DHW_base_lib.1.3.scad> </tt>
      \li <tt> include <e3DHW_hardware_data.1.3.scad> </tt>
      \li <tt> include <e3DHW_addon_base.1.3.scad> </tt>
      \li <tt> include <e3DHW_DIN_rail_lib.1.3.scad> </tt>
      \li <tt> include <e3DHW_DIN_boxes_lib.1.3.scad> </tt>
      \li <tt> include <e3DHW_addon_terminal.1.3.scad> </tt>
      \li <tt> include <e3DHW_DIN_modules_A.1.3.scad> </tt>\n
          <i>but don't allow duplicate include.</i>

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2   29/07/2019 bugs corrections,
                    better use: parameters check and standization, 
                    Doxygen comments
 @copyright GNU Lesser General Public License.
 @example e3DHW_DIN_modules_A_examples.scad
*/ 

//! @privatesection
// for Basic Terminals serie
function _get_basicPhat(d) =([[3,0.5],[0,0],[d,0],[d,0.5],[d-3,0.5],[d-3,35],[d-12,43],[12,43],[4,35]]);

// for Tower Terminals serie
_clip_TwBrackets = "SCB";   // the smallest screw clip, used for dinTowerEndBrackets()

// return parametric vertex  array: uses some getter protected functions in e3DHW_addon_terminal.1.3.scad
function _getPolyTower(p, mmq)=(let(idx=_get_MIdx(mmq))[[0,0],[p.y,0],[p.y,1],[p.y+3,1],[p.y+3,_getMyTot(idx)+6],[(p.y+p.z)/2,p.x],[(p.y-p.z)/2,p.x,],[-3, _getMyTot(idx)+6],[-3,1],[ 0,1]]);

// returns in a vector with all parameters for Tower profile (_getPolyTower)
//  uses some getter protected functions in e3DHW_addon_terminal.1.3.scad
function _gethbd0dhVect(n, mmq)=(let(idx=_get_MIdx(mmq))[ 
 max(((_getMyTot(idx)+0.8)*n+6),(get_rail2top(_clip_TwBrackets)+6)), // hb: profile height, on x axis
 max(46,_getMxT(idx)*n+16),  // d0: profile bottom large, y axis
 _getMxT(idx)+4 ]);          // dh: profile top large, y axis

//! @publicsection
/**
@fn  dinBasicTerminalBlock(n, mmq=2)
Strong terminal, it uses double mammuts.
Full parametric, auto-select the correct mammut as defined in e3DHW_mammut_data.1.3.scad.\n
All elements of the \c Basic \c Serie : dinBasicTerminalBlock(), dinBasicEndPlate(), dinBasicEndBrackets() have same parametric shape.
@param n number of mammuts
@param mmq: wire section (mmq)
*/
module dinBasicTerminalBlock(n, mmq=2){
   mh = get_simpleMammutStep(mmq) *n;
   lD = get_simpleMammutSize( mmq, DT);
   clip = "SPF";  // the best for basicTerminals, but you can change it
   h = max(get_min_h(clip), mh);
   d = max(get_min_d(clip)+get_xq(clip)+get_exd(clip),lD);
   translate([0, get_rail2top(clip),0]) union(){
      translate([get_ClipTrnsX(clip,d), 0, 0]) do_DINClip(clip, h, get_ClipWidth(clip, d));
      translate([(d -lD)/2,0,0]) add_simpleMammut (n, mmq, h, type = DT);
   }
}
  
 /**
@fn dinBasicEndPlate(s=2)
Slim end plate for basic blocks.
Because this uses polyDINSeparator() if s >= 4 it makes a box.
@param s plate thickness, s >= 1
*/
module dinBasicEndPlate(s=2){
   clip = "NSS";  // uses NSS clip to allow small thicknesses
   h = max(get_min_h(clip),s, 1);
   d = max(get_min_d(clip)+get_xq(clip)+get_exd(clip),55);
   polyDINSeparator(vertex = _get_basicPhat(d), length = h, uclip = clip, fill = 100);
}

/**
@fn dinBasicEndBrackets(s=10)
Strong end bracket with screw for basic blocks.
It can be used also as logical/functional separator car it accepts a Dymo 9 label.
@param s thickness, s >= 10
*/
module dinBasicEndBrackets(s=10){
   clip = "SCF";  // the best for basic Brackets, you can change it  
   h = max(get_min_h(clip), s, 10);
   d = max(get_min_d(clip)+get_xq(clip)+get_exd(clip),55);
   difference(){
      polyDINSeparator(vertex = _get_basicPhat(d), length = h, uclip = clip, fill = 100);
      translate([0,43+2.1,(h-9)/2])carve_dymoD1_9(55, 0, rot = [90, 0,0], z=1);
      }
}

/**
@fn dinTowerTerminalBlock(n, mmq=1)
Space and filament saving DIN terminal, structured as an Hanoi tower.
This block is with a side open: it will be closed by next terminal or by an EndPlate.\n 
Changing internal connections, the bigger terminal (n = 3) can be used as 1x6, or 1x2+1x4, or 3x2. \n
Full parametric, selects the correct mammut as defined in e3DHW_mammut_data.1.3.scad\n
All elements of the \c Tower \c Serie : dinTowerTerminalBlock(), dinTowerEndPlate(), dinTowerEndBrackets() have same parametric shape.
@note Requires some wire to internal connect mammuts. Fix it with hot wax.
@param n number of floors, [1,2,3]
       \li n=1, mammut 1 : 1x2
       \li n=2, mammut 3 : 1x4, 2x2
       \li n=3, mammut 5 : 1x6, 1x2+1x4, 3x2
@param mmq: wire section (mmq)
*/
module dinTowerTerminalBlock(n, mmq=1){
  assert (n >=1 && n<=3,str(" n (",n,") must be in [1,2,3] range."));
  HT = NOTOPTHICKNESS;                  //  thickness
  s = HT+ _getMbD(_get_MIdx(mmq)) + 0.4; // total thickness (0.4 clearance)
//
  params = _gethbd0dhVect(n, mmq);
  assert((params.x +0.5) <= 43, str("block height ( ",(params.x +0.5),") is greater than standard DIN_BOX_HEIGHT"));
  translate([ get_rail2top("NSS"),-params.y/2,0]) union(){  // uses NSS clip to have a very flat clip
     difference(){
        union(){
            translate([0,params.y,0])rotate([0,0,-90])
                 dinRailSmallNoSpring(s, params.y);
            translate([-2,params.y,0])rotate([0,0,-90])
                 polyBase(_getPolyTower(params, mmq), undef, 100, HT );
            translate([0,0,HT-EXTRA]) cube([3,params.y,3]);  // round
          }  // union ends
          translate([3,params.y+2,3+HT]) rotate([90,0,0])cylinder(r=3, h =params.y+4, $fn=32); // round
        }  // difference ends
       translate([2.9,params.y/2,0])linear_extrude(height =s)_towerSection(n, mmq);  // maze
     }  // union ends
 }

 /**
@fn dinTowerEndPlate(n, mmq=1, s=2)
 Parametric end plate, lid for tower blocks.
 Because uses polyDINSeparator() if s >= 4 makes a box.
@param n number of floors, [1,2,3]
@param mmq wire section (mmq)
@param s plate thickness, s >= 1
*/
module dinTowerEndPlate(n, mmq=1, s=2){
  assert (n >=1 && n<=3,str(" n (",n,") must be in [1,2,3] range."));
  clip = "NSS"; // uses NSS clip to allow small thicknesses
  HT = max(get_min_h(clip),s, 1);       //  thickness
//
  params = _gethbd0dhVect(n, mmq);
  assert((params.x +0.5) <= 43, str("block height ( ",(params.x +0.5),") is greater than standard DIN_BOX_HEIGHT"));
  translate([0,params.y/2,0])rotate([0,0,-90])
         polyDINSeparator(vertex = _getPolyTower(params, mmq), length = HT, uclip = clip, fill = 100);
 }
 
 /**
@fn dinTowerEndBrackets(n, mmq=1, s = 10)
Strong end bracket with screw for tower blocks.
It can be used also as logical/functional separator car it accepts a Dymo 9 label.
Required because tower blocks and end tower plates uses waeck NSS clips.
@param n number of floors, [1,2,3]
@param mmq wire section (mmq)
@param s plate thickness, s >= 10
*/
module dinTowerEndBrackets(n, mmq=1, s = 10){
  assert (n >=1 && n<=3,str(" n (",n,") must be in [1,2,3] range."));
  HT = max(get_min_h(_clip_TwBrackets), s, 10);
//
  params = _gethbd0dhVect(n, mmq);
  assert((params.x +0.5) <= 43, str("block height ( ",(params.x +0.5),") is greater than standard DIN_BOX_HEIGHT"));
  translate([0,params.y/2,0])rotate([0,0,-90])difference(){
      polyDINSeparator(vertex = _getPolyTower(params, mmq), length = HT, uclip = _clip_TwBrackets, fill = 100);
      translate([0,params.x+2.1,(HT-9)/2])
             carve_dymoD1_9(55, 0, rot = [90, 0,0], z=1);
      }
  }


 /**
  @fn dinQuickConnector()
  Support for quickConnectors (wago compact connectors).
  Very simple, requires 2 self-tapping screws.
  */
  module dinQuickConnector(){ 
   union(){
      translate([0,-10,0])dinRailBasicScrew(17, 40);
      translate([13,-1,0])cube([3, 4.1,50]);
      difference(){
          linear_extrude(height = 50, convexity = 20, twist = 0)_quickProfile();
          translate([7.5,-5,5])rotate([-90,0,0])polyhole(25,2);
          translate([7.5,-5,45])rotate([-90,0,0])polyhole(25,2);
        }
   }
}

/**
  @fn dinStrainRelief(dia)
  To fix big cables to DIN rail.
  Use nylon tie straps for the cable.
  */
module dinStrainRelief(dia){
   module toro(d){
      rotate([90,0,-90])rotate_extrude(convexity = 10, $fn = 32)
           translate([d/2+1, 0, 0])resize([3,6,0])circle(r = 2, $fn = 32);
      }
  assert(dia >= 3 && dia <= 22, "cable size out of bounds [3..22]");
  hd = dia+ 3;
  difference(){
     dinRailFlatSpring(hd, 80);  
     translate([-EXTRA,dia/2 - ((dia > 9)? dia/4:dia/3),hd/2])
       rotate([-90,0,-90])cylinder(d = dia, h = 80+1, $fn = 16);
   translate([8, -2,hd/2])toro(hd);
   translate([72,-2,hd/2])toro(hd);
   translate([40,-2,hd/2])toro(hd);
  }    
}

//! @privatesection
//================================== locals

module _towerSection(n, mmq){
  mh = _getMzStep(_get_MIdx(mmq));
  difference(){
      projection(cut = true)translate([0,0,-mh/2]) _towerBlock(n,mmq);
      offset(delta = -1, chamfer=true)projection(cut = true)translate([0,0,-mh/2]) _towerBlock(n, mmq);
     }
  }

module _towerBlock(n, mmq){
   _idx =_get_MIdx(mmq);
   mhz = _getMzStep(_idx);
   dx=   _getMyTot(_idx)+0.8;
   dy=   _getMxT(_idx)/2+3;
   alpha = 0;
   dz0 = n >2?0:n >1? -dx: -dx-dx;
   xoff = get_cubeMammutSize( mmq, type = FT)/2;
   union(){
   if(n >2)    translate([0,+dy+dy,0])    add_cubeMammut (mhz, 1, mmq, type = FT, y= -xoff, rot =[0,0,-90+alpha]);
   if(n >2)    translate([0,-dy-dy,mhz])  add_cubeMammut (mhz, 1, mmq, type = FT, y= +xoff, rot =[180,0,90-alpha]);
   if(n >1)    translate([dz0+dx,+dy,0])  add_cubeMammut (mhz, 1, mmq, type = FT, y= -xoff, rot =[0,0,-90+alpha]);
   if(n >1)    translate([dz0+dx,-dy,mhz])add_cubeMammut (mhz, 1, mmq, type = FT, y= +xoff, rot =[180,0,90-alpha]);
               translate([dz0+dx+dx,0,0]) add_cubeMammut (mhz, 1, mmq, type = FT, y= -xoff, rot =[0,0,-90]);
    }
 }
 
 module _allProfile(){ 
    wpoly =[[0,21],[0,8],[4,0],[15,0],[15,5],[14,15],[11,21]];
    difference(){
       offset(r = 1, $fn=32)  polygon(wpoly);
       polygon(wpoly);
       translate([-2,20.9,0])  square([20,1.1]);
    }
 }
 
 module _halfProfile(){
   difference(){
       _allProfile();
       translate([10,0,0])  square([20,40]);
    }
}

module _quickProfile(){ 
   union(){
      _allProfile();
      translate([-0.8,-0.7,0])resize([17.88,22.6,50])_halfProfile();
    }
}


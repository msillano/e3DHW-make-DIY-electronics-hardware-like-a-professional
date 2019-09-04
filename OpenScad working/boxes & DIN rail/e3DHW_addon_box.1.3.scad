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
/*
The e3DHW project is a set of libraries and things in OpenSCAD to make actual DIY electronics hardware in a simple and modular way (see e3DHW_HOWTO.pdf).
 
 This ADDON library contains useful complements that you can add to a box, like boxes from e3DHW_DIN_boxes_lib.scad
 
MAIN MODULES
ADDON: union() with box.
  add_PcbGuide: for pcb. note: print it only vertically.

CARVE: difference() with box.

- carve_holeBorder(): to make a circular hole centered on vertical top/border: for a led, a switch... or for ventilation.

- carve_elongatedHoleBorder: carves an oval hole centered on vertical border. For connectors, flat cables, aeration.

- carve_roundPolyBorder: carves any polygonal shape with optional rounded corners on vertical top/border. 

- carve_colanderBorder: carves a centered area with sataggered holes, on vertical top/border. For aeration.

*/
use <MCAD/polyholes.scad>
/**
@file e3DHW_addon_box.1.3.scad
 Contains general pourpose modules that you can add to a box. 
 This is the vertical version of e3DHW_addon_base.1.3.scad, for box sides.
 It is not difficult to transform an horizontal ADDOH into a vertical one. For your convenience 
 here some common ADDONS useful for vertical panels.
@par dependences
    This library requires
      \li \c e3DHW_base_lib.1.3.scad
      \li \c e3DHW_addon_base.1.3.scad
       
 To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_addon_base.1.3.scad> </tt>
      \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt>\n
      <i> but don't allow duplicate includes.</i>

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2   29/07/2019 Bugs correction. 
                   Better use: parameters check and standization. 
                   Doxygen comments.
 @copyright GNU Lesser General Public License.
 @example  e3DHW_addon_box_examples.scad
*/
///! @privatesection
_pcb_space = 1.2 ;

///! @publicsection
/**
@fn add_PcbGuide(height, s=_pcb_space, x=0, y=0, rot=[0,0,0])
Adds guides for PCB. 
So you can place PCB under the top, or trasvrsal inside a box...
This is better printed vertical, but it is designed to be printed horizontal without supports.
@param height the guide long
@param s the pcb thickness, default _pcb_space
*/
module add_PcbGuide(height, s=_pcb_space, x=0, y=0, rot=[0,0,0]){
   translate([x,y,0])rotate(rot)translate([-EXTRA,0,0])union(){
   linear_extrude(height)polygon([[0,0],[3+EXTRA,0],[3+EXTRA,-1],[0,-3]]);
   translate([0,_pcb_space,0])linear_extrude(height)polygon([[0,0],[0,2],[2+EXTRA,1.4],[2+EXTRA,1]]);
   }
}

/**
@fn carve_holeBorder(dia, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ)
Vertical version of carve_roundHole().
@copydoc carve_roundHole()
*/
module carve_holeBorder(dia, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ){
   translate([x,y,0])rotate(rot) carve_roundHole(dia = (dia), h=(h), rot=[0,-90,0], z= (z));
}

/**
@fn carve_elongatedHoleBorder(dia, cd, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ)
Vertical version of carve_elongatedHole().
@copydoc carve_elongatedHole()
*/
module carve_elongatedHoleBorder(dia, cd, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ){
   translate([x,y,0])rotate(rot) carve_elongatedHole(dia = (dia), cd=(cd), h=(h), rot=[0,-90,0],  z= (z));
}

/**
@fn carve_roundPolyBorder(vertex, r=ROUNDRADIUS, h=0,  x=0, y=0, rot=[0,0,0], z= CARVEZ)
Vertical version of carve_roundPoly().
@copydoc carve_roundPoly()
*/
module carve_roundPolyBorder(vertex, r=ROUNDRADIUS, h=0,  x=0, y=0, rot=[0,0,0], z= CARVEZ){
   translate([x,y,0])rotate(rot) carve_roundPoly(vertex=(vertex),h = (h), r=(r), rot=[0,-90,0], z=(z));
}

/**
@fn carve_colanderBorder (d=4, s=6,rows=3, cols = 3, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ)
Vertical version of carve_colander().
@copydoc carve_colander()

*/
module carve_colanderBorder (d=4, s=6,rows=3, cols = 3, h=0, x=0, y=0, rot=[0,0,0], z= CARVEZ){
   translate([x,y,0])rotate(rot)carve_colander( d=(d), s=(s), rows = (rows), cols=(cols), h=(h), rot=[0,-90,0],  z= (z));
}




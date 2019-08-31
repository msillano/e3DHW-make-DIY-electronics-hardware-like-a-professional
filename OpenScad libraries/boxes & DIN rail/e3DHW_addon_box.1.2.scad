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
/**
@file e3DHW_addon_box.1.2.scad
 Contains general-purpose modules that you can add to a box. 
 This is the vertical version of e3DHW_addon_base.1.2.scad, for box sides.\n
 \image html boxddon.png
 It is not difficult to transform an horizontal ADDOH into a vertical one. For your convenience here some common ADDONS useful for vertical panels.
@par dependences
    This library requires
      \li \c e3DHW_base_lib.1.2.scad
      \li \c e3DHW_addon_base.1.2.scad
       
 To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_base_lib.1.2.scad> </tt>
      \li  <tt> include <e3DHW_addon_base.1.2.scad> </tt>
      \li  <tt> include <e3DHW_hardware_data.1.2.scad> </tt>\n
      <i> but don't allow duplicate includes.</i>

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2    29/07/2019 Bugs correction. 
                   Better use: parameters check and standardization. 
                   Doxygen comments.
 @copyright GNU Lesser General Public License.
 @example  e3DHW_addon_box_examples.scad
*/
///! @privatesection
use <MCAD/polyholes.scad>
_pcb_space = 1.2 ;  // pcb thicness, used a default by add_PcbGuide().

///! @publicsection
/**
@fn add_PcbGuide(height, s=_pcb_space, x=0, y=0, rot=[0,0,0])
Adds guides for PCB. 
So you can place PCB under the top, or transversal inside a box...
This is better printed vertical, but it is designed to be printed horizontally without supports.
@param height the guide long
@param s the PCB thickness, default _pcb_space
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




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
@file e3DHW_addon_batteries.1.3.scad
 ADDON modules for batteries. 
 
 The PMS Power Management System, for DIY electronics (see e3dhw-pms-intro_en.pdf) make use of rechargeable batteries (NiMH, LiIon) and some pcb board.\n
 The ADDONs here allow to make simple, flexible and cheap power suppliers for your circuits.
 (see examples).
 
@par dependences
    This library requires
      \li \c contrib/flexbatter.repaired.scad or \c contrib/flex<xxx>.stl files
      \li \c e3DHW_base_lib.1.3.scad
      \li \c e3DHW_array_utils.1.3.scad
      \li \c e3DHW_addon_base.1.3.scad
      
 To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_array_utils.1.3.scad> </tt>
      \li  <tt> include <e3DHW_addon_base.1.3.scad> </tt>
      \li  <tt> include <e3DHW_addon_batteries.1.3.scad> </tt>\n
     <i> but don't allow duplicate includes.</i>
     
@par Acknowledgment
  The excellent design of battery holders used here is by Heinz Spiess (see https://www.thingiverse.com/thing:456900).\n
  The file in <tt>contrib/flexbatter.repaired.scad</tt> is not the original flile by H.S., but a repaired version to avoid numerous problems encountered with the original.
 @author    Marco Sillano
 @version 0.1.3   03/09/2019 base version
 @copyright GNU Lesser General Public License.
 @example  e3DHW_addon_batteries_examples.scad
*/

//! @privatesection
// table for sizes, measures from stl files
// here only the battery holders used with PMS (you can easily extend it).
_BATTHOLDER =[
//  code   | total x| body x|      y|
["AAx3",       64.07,  51.61,  54.00],
["AAAx3",      57.52,  48.34,  42.15],
["18650x1",    79.32,  67.74,  22.88],
["18650Px1",   81.32,  69.66,  22.88]
];

//! @publicsection
/**
@fn get_battX(code)
getter function for batteries holder data.
We have following getter functions: \n
\li get_battX(code) returns the full X size of battery holder.
\li get_battBody(code) returns the X size of body.
\li get_battY(code) returns the Y size of battery holder.

@param code the code of a battery holder in _BATTHOLDER array: "AAx3", "AAAx3", "18650x1", "18650Px1".
*/
function  get_battX(code)     = (valueGetter(code, 1, _BATTHOLDER));
function  get_battBody(code)  = (valueGetter(code, 2, _BATTHOLDER)); ///< returns the X size of body, with exclusion of springs.
function  get_battY(code)     = (valueGetter(code, 3, _BATTHOLDER));///< returns the Y size of a battery holder.

/**
@fn do_flexBatteryA(code)
Generates a battery holder.
This module uses <tt>contrib/flexbatter.repaired.scad</tt>
@param code the code of a battery holder in _BATTHOLDER array: "AAx3", "AAAx3", "18650x1", "18650Px1".
@see do_flexBatteryB().
*/
module do_flexBatteryA(code){
   include <contrib/flexbatter.repaired.scad>;
   if (code=="AAx3") flexbatterAA(n=3);
   else if (code=="AAAx3") flexbatterAAA(n=3);
   else if (code=="18650x1") flexbatter18650(n=1);
   else if (code=="18650Px1") flexbatter18650P(n=1);
   else assert(false, "Battery code not found");
}

/**
@fn do_flexBatteryB(code)
Generates a battery holder.
This module imports a STL file with the required battery holder.
Equivalent but faster than  do_flexBatteryA().
@param code the code of a battery holder in _BATTHOLDER array: "AAx3", "AAAx3", "18650x1", "18650Px1".
@note the files <tt> "contrib/flex"+code+".stl"</tt> must exist.
*/
module do_flexBatteryB(code){
    name= str("contrib/flex",code,".stl");
    import(name);  
 }

/**
@fn  carve1_batteryHolder(batt, x =0, y=0, rot= norot)
 Carves for a battery holder on a board.
This carve must be done before the add2_holder().
@param batt the code of a battery holder in _BATTHOLDER array: "AAx3", "AAAx3", "18650x1", "18650Px1".
*/
module carve1_batteryHolder(batt, x =0, y=0, rot= norot){
   assert(!is_undef(batt), " The batt prameter is mandatory");
   clearance = 2;
   translate([x , y, 0])rotate(rot)translate([get_battX(batt)/2-clearance,clearance, 0])
   union(){
      carve_roundRectangle(get_battX(batt), get_battY(batt) -2*clearance, rr=0 );
      translate([-get_battBody(batt)/2+clearance/2,-2*clearance,0])carve_roundRectangle(get_battX(batt)-get_battBody(batt)+clearance, get_battY(batt)+2*clearance, rr=clearance );
    }
 }
 
/**
@fn  add2_batteryHolder(batt, x =0,y=0, rot= norot)
Adds a battery holder to a board.
@param batt the code of a battery holder in _BATTHOLDER array: "AAx3", "AAAx3", "18650x1", "18650Px1".
*/
module add2_batteryHolder(batt, x =0,y=0, rot= norot){
   assert(!is_undef(batt), " The batt prameter is mandatory");
   translate([x,y,0])rotate(rot){
      do_flexBatteryA(batt);  // choose module you like
//    do_flexBatteryB(batt);
   }
 }


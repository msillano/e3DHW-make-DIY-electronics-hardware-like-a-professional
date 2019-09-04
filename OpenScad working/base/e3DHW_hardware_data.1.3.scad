/*
   e3DHW project © 2018 Marco Sillano  (marco.sillano@gmail.com)
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
 @file e3DHW_hardware_data.1.3.scad
 Collection of hardware data, used by many e3DHW libraries.
 These data are function of the commercial hardware found, but also of the printer tolerances.
 Keeping this data here, it is possible to optimize them on the 3D printer and on the filament.\n
 All e3DHW libraries will share this optimized values.
 
@par Hardware
    \li M3 screws are the most used
    \li Parker self tapping screws requires a pilot hole
    \li Engraved text parameters fit well here
 */
//! @publicsection
//  general constants
MILs = 2.54;  ///< mil to mm

//! @privatesection
// ------------------ 3drag printer, PLA filament
// ---------- bolts and nuts data
// -------  - M3 see https://www.engineersedge.com/hardware/metric_hex_nuts_14056.htm
_M3_dia     = 3;
_M3_adj     = 0.1;    // added to all diameters (printer clearance)
_M3_nut_Wc  = 6.36;   // M3 nut max large measured, nominal 6.36
_M3_nut_Ws  = 5.39;   // M3 nut min large measured, nominal 5.50
_M3_nut_h   = 2.35;   // M3 nut height measured. nominal 3.2;
_M3_Washer  = 7;      // M3 measured washer 3.2x7, nominal 7
_M3_LWasher = 9;      // M3 measured washer 3.2x9, nominal 9
_M3_HWasher = 0.75;   // M3 less than the measured washer height (0.82), nominal 1
_M3_headd   = 5.5;    // M3 measured head diameter: nominal 5.8
_M3_headh   = 3;      // M3 measured head height, nominal 3

 //-------- Parker (self-tapping screws)
 // see http://staticassets-hrd.appspot.com/hct614a8s/file.pdf%3Ffilename%3Dtrue
_park_dia   = 1.2;    // Parker (self-tapping): 1.2x5 pilot hole. 
_park_len   = 5;      // Parker (self-tapping): 1.2x5 pilot hole
_park_hole  = 3;      // Parker (self-tapping) 2.9x6: hole

//--------- Text parameters
_TEXTFONT   ="Courier New: style=Bold";  ///< best looking monospace font
_XY_FFACTOR = 0.93;       ///< for better looking. It change with the font (0.93 for Courier New), test using 'o" character
_text_add_relief  = 0.8;  // height of relief text





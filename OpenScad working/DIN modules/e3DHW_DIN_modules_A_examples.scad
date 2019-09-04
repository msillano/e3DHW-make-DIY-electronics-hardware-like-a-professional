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
include <e3DHW_addon_base.1.3.scad>
include <e3DHW_hardware_data.1.3.scad> 
include <e3DHW_DIN_rail_lib.1.3.scad>
include <e3DHW_DIN_boxes_lib.1.3.scad>
include <e3DHW_addon_terminal.1.3.scad>
include <e3DHW_DIN_modules_A.1.3.scad>

// all basic family terminals
module show_basic_family() {
   translate([0,0,0])dinBasicEndBrackets();
   translate([0,0,15])dinBasicTerminalBlock(1);
   translate([0,0,30])dinBasicTerminalBlock(3);
   translate([0,0,55])dinBasicEndPlate();
   translate([0,0,70])dinBasicTerminalBlock(2, 6);
   translate([0,0,100])dinBasicEndBrackets();
}
// all tower family terminals
module show_tower_family() {
   translate([0,0,10])dinTowerEndBrackets(3);
   translate([0,0,30])dinTowerTerminalBlock(3);
   translate([0,0,45])dinTowerEndPlate(3);
   translate([0,0,60])dinTowerTerminalBlock(2,mmq=8);
   translate([0,0,75])dinTowerTerminalBlock(2,mmq=8);
   translate([0,0,90])dinTowerEndPlate(2, mmq=8);
   translate([0,0,105])dinTowerTerminalBlock(1,mmq=8);
   translate([0,0,120])dinTowerTerminalBlock(1,mmq=8);
   translate([0,0,135])dinTowerEndBrackets(1, mmq=8);
}

// QuickConnector and StrainRelief
module show_more(){
   translate([0,0,0])dinQuickConnector();
   translate([0,60,0]) dinStrainRelief(6);
   translate([0,60,30])dinStrainRelief(10);
   translate([0,60,60])dinStrainRelief(14);
}

// =================== UNCOMMENT TO RUN
 show_basic_family();
// show_tower_family();
// show_more();
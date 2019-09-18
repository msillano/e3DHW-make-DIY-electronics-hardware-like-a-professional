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

include <e3DHW_base_lib.1.3.scad>;
include <e3DHW_addon_base.1.3.scad>
include <e3DHW_hardware_data.1.3.scad> 
include <e3DHW_addon_terminal.1.3.scad>

// -------  terminalM3Block test
module test_terminalM3Block() {
   difference(){
      union(){
         rectangleBase(50, 55, fill = 100);
         for(i=[1:7]){
            add1_terminalM3Block( n= i, y = (i-1)*20);
            }
         }
      for(i=[1:7])
         carve2_terminalM3Block( n= i, y = (i-1)*20);
      }
   }

//--------  simpleMammut test
module test_simpleMammut() {
for (usetype = [HT, FT, DT])
   union(){
      for(i=[1:3]){
         add_simpleMammut( n=i, mmq=2, len=1, type = usetype, x= usetype*50, y=(i-1)*30, rot =[90,0,10]);
         add_simpleMammut( n=i, mmq=5, len=1, type = usetype, x= usetype*50, y=90+ (i-1)*40, rot =[90,0,10]);
         }
    // to show the mammut position we add carve_cubeMammut(FT)
     for(i=[1:3]){
         #carve_simpleMammut( n=i, mmq=2, len=1, type = FT, x= usetype*50, y=(i-1)*30, rot =[90,0,10]);  
         #carve_simpleMammut( n=i, mmq=5, len=1, type = FT, x= usetype*50, y=90+ (i-1)*40, rot =[90,0,10]);
         }
      }
   }

//------------- cubeMammut test 
module test_cubeMammut(){
for (usetype = [HT, FT ])
   union() {
      for(i=[1:3]){
         add_cubeMammut( n=i, mmq=2, len=1, type = usetype, x=  usetype*50, y=(i-1)*30, rot =[90,0,80]);
         add_cubeMammut( n=i, mmq=5, len=1, type = usetype, x=  usetype*50, y=90+ (i-1)*40, rot =[90,0,80]);
         }
      for(i=[1:3]){
   // to show the mammut position we add carve_cubeMammut(FT)
         # carve_cubeMammut( n=i, mmq=2, len=1, type = FT, exScr=2, x=  usetype*50, y=(i-1)*30, rot =[90,0,80]);
         # carve_cubeMammut( n=i, mmq=5, len=1, type = FT, exScr=2, x=  usetype*50, y=90+ (i-1)*40, rot =[90,0,80]);
         }
      }
   }

// =================== UNCOMMENT TO RUN

// test_terminalM3Block();
// test_simpleMammut();
// test_cubeMammut();


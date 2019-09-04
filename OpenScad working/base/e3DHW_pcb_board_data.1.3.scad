/*
   e3DHW project © 2018 Marco Sillano  (marco.sillano<at>gmail.com)
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
 @file e3DHW_pcb_board_data.1.3.scad
 
 Collection of data of commercial PCB geometries,used by e3DHW_addon_base.1.3.scad
 
 You can contribute sending me new data: I will add it in next release.

 @author  Marco Sillano
 @version 0.1.1    14/03/2018 base version
 @version 0.1.1.1  21/04/2018 added Sonoff TH10
 @version 0.1.2   29/07/2019 Doxygen comments
 @copyright GNU Lesser General Public License.
*/

//! Arduino UNO REV3 (and compatibles)
// description: microcontroller board based on the ATmega328P
// home: https://store.arduino.cc/arduino-uno-rev3
// see also:
//   https://i0.wp.com/blog.protoneer.co.nz/wp-content/uploads/2012/10/Arduino-Uno-Mega-Dimensions.png
//   https://forum.arduino.cc/index.php?action=dlattach;topic=381671.0;attach=156228
// contribution by m.s. (14/03/2018, marco.sillano<at>gmail.com)
arduinoUnoR3Vertex = [[0,0],[66,0],[66,3.5],[68.6,5.5],[68.6,38],[66,40],[66,53.3],[0,53.3]];
arduinoUnoR3Holes  = [[14,2.5,3],[15.3,50.7,3],[66.4,7.5,3],[66.4,35,3]];   ///< map 4xM3

//! Arduino Yûn
// description: microcontroller board based on the ATmega328P + Linux
// home: https://store.arduino.cc/arduino-yun, https://store.arduino.cc/arduino-yun-rev-2
// contribution by m.s. (14/03/2018, marco.sillano<at>gmail.com)
arduinoYunVertex = [[0,0],[66,0],[66,3.5],[68.6,5.5],[68.6,53.4],[0,53.4]];
arduinoYunHoles  = [[14,2.5,3],[15.3,50.7,3],[66.4,7.5,3],[66.4,35,3]];  ///< map 4xM3


//! Sonoff Basic
// description: cost effective WiFi smart switch (EPS8266)
// home: http://sonoff.itead.cc/en/products/sonoff/sonoff-basic
// see also:  https://www.itead.cc/wiki/Sonoff
// pcb: 2017-5-5, Sonoff TH_V1.1 (1744)
// contribution by m.s. (14/03/2018, marco.sillano<at>gmail.com)
sonoffBasicVertex =[[0,0],[65,0],[65,34.1],[0,34.1]];       
sonoffBasicHoles =undef;   ///< none

//! Sonoff TH10
// description: Wi-Fi switch with Temp. and Hum. monitoring
// home:  http://sonoff.itead.cc/en/products/sonoff/sonoff-th
// see also:  https://www.itead.cc/wiki/Sonoff_TH_10/16
// pcb: 2017-6-8 ver 2.1 Sonoff TH10/16 (1737)
// contribution by m.s. (21/04/2018, marco.sillano<at>gmail.com)
sonoffTH10Vertex =[[0,0],[72.4,0],[72.4,2.5],[89.2,2.5],[89.2,42.5],[72.4,42.5],[72.4,45],[4.5,45],[4.5,37.7],[0,37.7]];
sonoffTH10Holes =[[20,3.5,3.2],[66.5,3.5,3.2],[66.5,41.5,3.2],[20,41.5,3.2]];   ///< map 4xM3

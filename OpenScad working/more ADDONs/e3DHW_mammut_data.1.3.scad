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
 @file e3DHW_mammut_data.1.3.scad
 Collection of commercial mammut data, used by e3DHW_addon_terminal.1.3.scad.
 \image html mammutstrip.jpg
 \li \b Mammut  connectors uses the metallic core of industrial cheap mammut strips. 
@note You must update the MAMMUT array with the sizes of naked mammut you use.

 \image html mammut.jpg
 
@note \b IMPORTANT keep the array ordered by cable size ( \c MAMMUT[0], ascendent)
*/
// Naked MAMMUT
// Array of measures of mammut metallic cores (see photo). 
// To be update: it must fit available mammuts.
// IMPORTANT! keep the array ordered by cable size (MAMMUT[0], ascendent)
MAMMUT = [[ 4,  3.1,   6,   11,   14,   4,   10,   7,  "BM 9201"],  // [0]
          [16,  5.6, 8.5,   15,   17, 5.5,   11,  10,  "BM 9203"]]; // [1]
//         0     1     2    3     4     5     6    7    8
//       0=  nominal cable (mmq)
//       1=  d-intern (mm)
//       2=  d-extern (mm) barrel diameter max: it is oval, round it to bit size
//       3=  h-total, screws full open (mm)
//       4=  l-barrel length (mm)
//       5=  d-screws (head - mm) round it to bit size
//       6=  screws distance (axes, mm)
//       7=  step, mammut distance (at least [2]+1 mm) 
//       8=  model reference
//
// note: if len(MAMMUT) > 5 you must update the function _get_MIdx() in e3DHW_addon_terminal.1.3.scad !!
//
// warning: the clearence (7) influences also the max working tension.
//   see https://www.semikron.com/dl/service-support/downloads/download/semikron-application-note-insulation-coordination-en-2017-12-07-rev-03/
//   see http://www.smpspowersupply.com/ipc2221pcbclearance.html


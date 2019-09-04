/*
   e3DHW project © 2018 Marco Sillano  (marco.sillano@gmail.com)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
   Designed with http://www.openscad.org/
   Tested with: 3DRAG 1.2 https://www.futurashop.it/3drag-stampante-3d-versione-1.2-in-kit-7350-3dragk
*/
/**
@file e3DHW_array_utils.1.3.scad
Grouping general purpose array utilities.

\li First group is general purpose functions: col2array(), is_arrayOK().
\li Second group is about the management of arr2 (points) and arr3(holes, towers): get_squareArray2() get_squareArray3(), get_array3(), get_minX(), get_maxX(), get_minY(), get_maxY(), translateArray2(), translateArray3().
\li Third group defines functions to handle small DataBases implemented as an array of records. \n
Condition: the field[0] of each record is a string and is the primary key. \n
Usually the array is private and RO: it works like an associative array, with public getter functions. \n
This structure was used for the first time in e3DHW_DIN_rail_lib.1.3.scad. Found it useful, the
basic functions are collected here, so DataBases can be used by more libraries: is_in(), get_position(), 
get_Key0(), valueGetter().

@par dependences
  This library requires:
         \li nothing

  To use this library you must add the following lines to your code:
       \li  <tt> include <e3DHW_array_utils.1.3.scad> </tt> \n
      <i> but don't allow duplicate include.</i>

 @author    Marco Sillano
 @version 0.1.3    18/03/2018 base version
 @copyright GNU Lesser General Public License.
*/


//! @publicsection
// ------------------- general purpose array management

/**
@fn col2array(table, col)
utility: returns table[col] as an array.
*/

function col2array(table, col)=([for(i=[0:len(table)-1]) table[i][col] ]);  ///< returns an array from a table

  /**
  @fn is_arrayOK(v, s =1, n=1)
  Test function for mandatory 'arrays of arrays' parameters.
  General pourpose function to verify array2 of points 2D [x,y] or array3 of holes [x,y,d].
  @param v  an array
  @param d  elements size required (points = 2, holes = 3)
  @param n  minimum number of elements in array (polygons: at least 3 points).
  @returns true if array is as required, else message and abort.
  */
  function is_arrayOK(v, s =1, n=1) = ( 
      is_undef(v) ? assert(false, "this parameter is mandatory"):
        (!is_list(v))?  assert(false, "this parameter is not an array"):
          (!(len(v) >= n)) ?  assert(false, str("this array must have at least ", n ," elements")):
            (!(is_list(v[0]) && (len(v[0]) >= s))) ?  assert(false, str("any element must have at least ", s ," values")): true );

// ---------------- array2 and array3 functions

/**
@fn get_squareArray2 (b, h, offx=0, offy=0)
utility: makes an array2 (points) for rectangular shapes, with offsets from borders.
*/
 function get_squareArray2 (b, h, offx=0, offy=0)=(
 [[0 +offx,0+offy],[0+offx,h-offy],[b-offx,h-offy],[b-offx,0+offy]]
);

/**
#@fn get_squareArray3 (b, h, d=0, offx=0, offy=0)
utility: makes an array3 (holes, towers) for rectangular shapes, with offsets from borders.
*/
function get_squareArray3 (b, h, d=0, offx=0, offy=0)=(
 [[0 +offx,0+offy,d],[b-offx,0+offy,d],[b-offx,h-offy,d],[0+offx,h-offy,d]]
);

/**
@fn translateArray2 (arr2, x=0, y=0)
utility: makes a new array2 (points) traslating arr2 points.
*/
 function translateArray2 (arr2, x=0, y=0)=(
  [for(i=[0:len(arr2)-1])[arr2[i].x+x,arr2[i].y+y]]
);

/**
@fn translateArray3 (arr3, x=0, y=0)
utility: makes a new array3 (holes) traslating arr3 points.
*/
 function translateArray3 (arr3, x=0, y=0)=(
  [for(i=[0:len(arr3)-1])[arr3[i].x+x,arr3[i].y+y, arr3[i].z]]
);


/**
#@fn get_array3 (arr2, d)
utility: makes an array3 (holes, towers) from an arr2 (vertex).
*/
function get_array3 (arr2, d)=(
 [for(i=[0:len(arr2)-1])[arr2[i].x,arr2[i].y,d]]);

/**
@fn get_maxX(table)
utility: returns max X value from an arr2 (or arr3).
The complete set:
\li get_maxX(table)
\li get_minX(table)
\li get_maxY(table)
\li get_minY(table)
*/
function get_maxX(table) = max(col2array(table, 0));
function get_minX(table) = min(col2array(table, 0)); ///< utility: returns min X value from an arr2 (or arr3)
function get_maxY(table) = max(col2array(table, 1)); ///< utility: returns max Y value from an arr2 (or arr3)
function get_minY(table) = min(col2array(table, 1)); ///< utility: returns min Y value from an arr2 (or arr3)

// ------------------- general purpose database management

function is_in(key0,table) = (is_num(search(key0,table)[0])); ///< utility: test the presence of \c key0 element on col[0]: returns \c true/false

// generic access functions, 'key0' is string, used as index.
function get_position(key0, table) = (assert(is_in([key0],table), "key code not valid") search([key0],table)[0]);               ///< given the key0 returns a row number (0..len()-1), inverse of get_Key0(). 

function get_Key0(i, table) = table[i][0];    ///< given row number, returns the key0[i], inverse of get_position().

function valueGetter(key0, col, table) =(table[get_position(key0,table)][col]);  ///< lookup function: given the key0 returns the value in col 




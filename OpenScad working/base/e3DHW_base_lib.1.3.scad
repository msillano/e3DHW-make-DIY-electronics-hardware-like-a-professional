/*
   e3DHW project © 2018 Marco Sillano(marco.sillano<at>gmail.com)
   This library is free software: you can redistribute it and/or modify
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
@mainpage e3DHW project
<i>The \b e3DHW is a project to make DIY electronics hardware like a professional, but in a simple and modular way.</i>

For a general overview of \b e3DHW \b project see <a target="_blank" href='https://cdn.thingiverse.com/assets/05/17/2c/73/19/e3DHW_HOWTO_en.pdf'> https://cdn.thingiverse.com/assets/05/17/2c/73/19/e3DHW_HOWTO_en.pdf </a>.
  (originale in italiano: <a target="_blank" href=https://cdn.thingiverse.com/assets/f5/37/2d/68/ec/e3DHW_HOWTO_it.pdf> https://cdn.thingiverse.com/assets/f5/37/2d/68/ec/e3DHW_HOWTO_it.pdf </a>). \n

The OpenScad implementation uses a growing set of full parametric libraries, all named \c e3DHW_xxxxx.scad.  \n
The \ref e3DHW_base_lib.1.3.scad "base library" generates a hollow or solid <b>main board</b> of any shape, to be used as structural support for electronics modules and devices.\n
Also \ref e3DHW_DIN_boxes_lib.1.3.scad "DIN boxes library" contains <b>box</b> modules, to be used alone or inside a DIN rail enclosure: on boxes ADDONs can be placed on any plane: top, bottom, lateral.

 A hollow <i>main board</i> with a square grid pattern:
     \li uses less material 
     \li allows air circulation
     \li facilitates the passage of the wires
     
The use of the 3D printer allows us to obtain tailor-made hardware structures without the need for mechanical
workshop machines for cutting, bending or drilling.Many accessories (ADDON) such as box for PCB modules,
terminals, connectors, etc. can be inserted into the 3D project by simplifying assembly and wiring.\n

\b e3DHW design is flexible: one solid main board can be the front panel of your project, other boards can be stacked using spacers and everything can be placed on a container to get a robust and usable DIY project. Otherwise, the \i main \i board  can be used with DIN rail clips, as custom module in bigger projects, or... the limit is the designer's imagination.

@section intro OpenScad libraries
@subsection libintro parametric libraries 
<i>All OpenScad libraries are designed to be very easy to use in your projects:</i> 
   \li any library is composed of modules to make containers and boards or ADDON to add things to a \b main \b board. 
   \li all modules are fully parameterized, but for the user convenience, many parameters have "reasonable" default values which can be ok almost everywhere.
   \li all parameter values are checked, with specific error messages
   \li the use of Doxigen gives us the complete <b>e3DHW library reference</b>, a help indispensable for the e3DHW users.

How to use "e3DHW_xxxxxx.scad" libraries? \n
   \li In your OpenSCAD file add on top <tt>"include <e3DHW_xxxxxxxxx.x.x.scad>;"</tt> for all files you need for your project (see documentation).
   \li put all required libraries in the same directory as your project.
   \li create also the dir  \c ./contrib, and copy there all the required files.
   \li Then you can use all <b>public modules</b> as you like.\n
  
 
@note  Public variables capitalized are \c CONSTANTS, they are used as default values in many e3DHW modules. You can overwrite them everywhere in your file (global change) or you can overwrite them inside your module (local scope change) or you can use the module parameters (defaults overwrite), as you need.
@note The names of private variables, functions and modules begin with an underscore (\c"_name").

  <i><tt>Public/private</tt> here is a conventional classification: it only means that 'public' things are designed to be used in your projects and are therefore well documented. The main modules are public but also some useful modules/functions to carry out customized projects: see examples. </i>

@see The \b e3DHW \b reference file for all libraries is  \c e3DHWref.1.3.chm. \n About  ADDON standardization see @htmlonly <a href='e3_d_h_w__addon__base_81_82_8scad.html#addonuse'>here</a> @endhtmlonly.


All e3DHW designs are experimental and may change. The last version can be found here:  <a href = "https://github.com/msillano/e3DHW-make-DIY-electronics-hardware-like-a-professional" target= _blank>
https://github.com/msillano/e3DHW-make-DIY-electronics-hardware-like-a-professional</a>

@subsection stlintro STL check and repair
 The e3DHW libraries are manifold safe. But that don't minds you will get everytime a perfect STL file. \n
 Exporting to STL tends to cause degenerate triangles due to the truncation to floating point values, if there are vertices very close together.\n
 To check a STL file I fallow the workflow:
  <OL> <li>Check the STL using \b KISSlicer: so you can see where the problems are (if present, color-coded).
       <li>If KISSlicer finds any problem:
      <UL> <li>  Try to change a little the design in \b OpenScad (changing parameters ? fill ? small rotation ?), then create a new STL
           <li>  or try to fix it (if there are degenerate triangles only) using \b netfabb (<i>steps: apply automatic repair, remove old part, Export part as STL</i>)
           <li>  back to step 1)</UL>
       <li>In any case, use \b 3D \b Builder to reduce triangles before print. (<i>steps: modify, simplify level 2, save as STL</i>)
 </OL> 

@subsection printintro STL print
 Tested using 3DRAG, PLA, layer 0.2, perimeter 4 layers, infill 40%-60%.\n
 For more professional results, choose a high temperature and approved Flame Retardant filament.

@subsection thank Thank you in advance.
I always appreciate any comment and collaboration. \n
I would like to apologize for my bad english, it is not my nativ language. 
*/

/**
 @file e3DHW_base_lib.1.3.scad

Generates a solid or perforated plate, the structural support for electronics modules and devices.
  \image html base_lib01.jpg
   
   The base board can be any shape, solid or hollow, with or without fixing holes.
@par library use
Above the base can be placed several ADDONs (see libraries e3DHW_xxxxx.x.x.scad) as spacers, terminals, batteries, etc.
 \image html  watering_board.jpg
The same base board can be used in a container or with DIN rail clips, or... 

@par useful functions
  In this library are also some general purpose array functions, here for developper convenience.
  
@note: The base grid has a long rendering time in OpenScad. For fastest tests, you can use \c fill=100 (or 0). \n


@par dependences
    This library requires:
            \li \c MCAD/polyholes.scad
            \li \c e3DHW_array_utils.1.3.scad
            \li \c e3DHW_hardware_data.1.3.scad
            
    To use this library you must add the following line to your code:
            \li  <tt> include <e3DHW_array_utils.1.3.scad> </tt>
            \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt>\n
            \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
            <i> but don't allow duplicate includes. </i>

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version.
 @version 0.1.2   29/07/2019 Bugs correction. 
                   Added: \c do_nuthole(), is_arrayOK
                   Better use: parameters check and standization. 
                   Doxygen comments.
 @copyright GNU Lesser General Public License.
 @example e3DHW_base_examples.scad
*/

//! @publicsection
// -------------- global parameters 
EXTRA = 0.05;               ///< quantum anti non-manifold error. (0.05)
BOARDTHICKNESS = 2.7;       ///< default base board thickness (2.7 mm) 
DEFAULTFILL = 40;           ///< default hollow factor (40%)
// ------- don't change
norot = [0,0,0];          ///<  null vector, used as default value (don't change it)
xauto = 8888;             ///< used as special parameter value by some modules

//! @privatesection
include <MCAD/polyholes.scad>
// ------------- main board parameters
_gridSolid = 4;    // square grid solid width (mm)
_gridAngle = 45;
_slabborder = 7;   // board perimetral border width(mm)
_slabcorner = 2;   // board round corners radius (mm)
_slabHoleClearance = 5;   // solid border around mounting holes (radius, mm)
_printer_max_x = 200;     // limits for 3D printer, max size 
_printer_max_y = 200; 

//! @publicsection
// ========================== PUBLIC MODULES

/** 
    @fn polyBase(vertex, holes = undef, fill= DEFAULTFILL, thickness =BOARDTHICKNESS, x=0, y=0, rot = norot, roundc = _slabcorner)
    Makes a hollow base of any shape, using 2 arrays to define vertex and holes.\n
    Flexible generic module, used by many other modules.
    @param vertex is an array of 3 or more points: <tt>[[p0.x, p0.y],[p1.x,p1,y],...]</tt> \n 
    @param holes is an array of mounting holes: <tt>[[h0.x,h0.y,h0.d],...]</tt>.\n 
    For the diameter of the holes ( \c hn.d) and the codes of the special holes, see do_nuthole(). \n 
    Each hole will have around a solid circular border (_slabHoleClearance). \n Default: <tt> holes = undef</tt>: no holes at all.\n
   If <tt> hn.d = undef</tt>: no 'n' hole, no circular border \n
   If <tt> hn.d = 0</tt>: no 'n' hole, yes circular border

    @param fill: a value in percent: 0 (empty)... 100 (solid), usual range 20..80 (default DEFAULTFILL)
    @param thickness: board thickness [mm] (default BOARDTHICKNESS) 
    @param roundc board round corners radius, default \c _slabcorner.
    @note  the square holes in a hollow grid are calculated from the \c fill parameter and the \c _gridSolid  constant: smaller \c _gridSolid value produces smaller holes.
 */
module polyBase(vertex, holes = undef, fill= DEFAULTFILL, thickness =BOARDTHICKNESS, x=0, y=0, rot = norot, roundc = _slabcorner){
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");  // mandatory
   if(! is_undef(holes))  // optional
       assert(is_arrayOK(holes, 3, 1), "test on array failed");
    assert ((fill >=0) && (fill <= 100),"fill out of bounds: 0..100 (percentage)");
    assert ((thickness > 0) && (thickness <200), "board thickness out of bounds");
    translate([x,y,0])rotate(rot)intersection(){
      _do_baseh(vertex, holes, fill, thickness, roundc);
      translate([0,0,-EXTRA])_cut_base(vertex,thickness+2*EXTRA, roundc);
      }
}

/** 
    @fn  rectangleBase(rx, ry, fill=DEFAULTFILL, thickness=BOARDTHICKNESS, x=0, y=0, rot=norot)
    Makes a rectangular board.
    The easy way, without arrays.
    @param rx the x size of the rectangular board [mm]
    @param ry the y size of the rectangular board [mm]
    @param fill a value in percent: 0 (empty)... 100 (solid), usual range 20..80. (default DEFAULTFILL)
    @param thickness the board thickness usually 2, 3 mm (default BOARDTHICKNESS)
*/
module rectangleBase(rx, ry, fill= DEFAULTFILL, thickness =BOARDTHICKNESS, x=0, y=0, rot = norot) { 
   rectangle4Holes(rx, ry, 0, 0, 0, 0,0, fill, thickness, x, y, rot );
   }
   
/**   
   @fn rectangle4Holes(holex, holey, dxl=10, dxr=10, dyu=10, dyl=10, dhole = 3, fill= DEFAULTFILL, thickness =BOARDTHICKNESS, x=0, y=0, rot = norot)
   @brief  makes a rectangular board with 4 mounting holes. \n
   Easy module, without arrays. See picture for parameters definitions.
   @param holex x holes distance 
   @param holey y holes distance
   @param dxl x border left
   @param dxr x border right (board x size = holex+dxl+dxr)
   @param dyu y border up
   @param dyl y border low (board y size = holey+dyu+dyl)
   @image html rectangle4holes.jpg 
   @param dhole: holes diameter. If 0: no holes, if < 0: coded special holes. See do_nuthole(). 
   @param fill value in percent: 0 (empty)... 100 (solid), default DEFAULTFILL.
   @param thickness the board thickness usually 2, 3 mm (default BOARDTHICKNESS)
*/

module rectangle4Holes(holex, holey, dxl=10, dxr=10, dyu=10, dyl=10, dhole = 3, fill= DEFAULTFILL, thickness =BOARDTHICKNESS, x=0, y=0, rot = norot) { 
   assert ((fill >=0) && (fill <= 100)," fill out of bounds: [0..100] (percentage)");
   assert ((thickness > 0) && (thickness <200), "board thickness out of bounds");
   assert ((holex >= 0) &&(holey >= 0) &&(dxl >= 0) &&(dxr >= 0) &&(dyu >= 0) &&(dyl >= 0), "distances (holex, holey, dxl, dxr, dyu, dyl) must be 0 or positive values");
   _rectPoints = [[0,0],[holex+dxl+dxr,0],[holex+dxl+dxr,holey+dyu+dyl],[0,holey+dyu+dyl]];
   if (dhole == 0)
     polyBase(_rectPoints, undef, fill, thickness, x, y, rot);
  else { 
     _rectHoles = [[dxl,dyl,dhole],[dxl,holey+dyl,dhole],[dxl+holex,dyl,dhole],[dxl+holex,holey+dyl,dhole]];
     polyBase(_rectPoints, _rectHoles, fill, thickness, x, y, rot); 
     }
  }
  
// ========================== PUBLIC FUNCTIONS
/**
  @fn do_perimetral(vertex=undef, height=BOARDTHICKNESS, width = _slabborder, roundc = _slabcorner)
  General pourpose module to do poly borders and lateral faces.
  Generates a lateral border from the vertex array (rounds corners).
  @param  vertex an array of points: [[p1.x, p1.y],[p2.x,p2,y],...]
  @param  height border height (vertical, default BOARDTHICKNESS)
  @param  width border width (default _slabborder)
  @param roundc board round corners radius, default _slabcorner.
*/
 
module do_perimetral(vertex=undef, height=BOARDTHICKNESS, width = _slabborder, roundc = _slabcorner){
  assert(is_arrayOK(vertex, 2, 3), "test on array failed");
  assert ((height > 0) && (height <200), " board border height out of bounds");
  assert ((width > 0) && (width <200), " board width out of bounds");
  difference(){
    _cut_base(vertex, height, roundc);
    translate([0,0,-EXTRA])linear_extrude(height = height+2*EXTRA, convexity = 20, twist = 0)  offset(delta=-width) polygon(vertex); 
    }
 }
    
/**
  @fn do_nuthole (d, s = BOARDTHICKNESS)
  General purpose  module to make one hole in a board or support.
  Generate simple holes, any diameter, or special holes for 3M bolts and self-tapping screw.\n
  @note To be used inside a \c difference() section.
  @note When fixing M3 parts (nut, washer ...) it is useful to heat them using a welder.
  @param  d if positive is the hole diameter
  if 0 or negative is a coded special hole:
  \image html do_nuthole.jpg
  \li \b  0  no hole
  \li \b -1 M3 nut at the bottom
  \li \b -2 M3 washer 7x1, at the bottom
  \li \b -3 M3 washer 7x1, max deep, at the bottom
  \li \b -4 M3 washer 9x1, at the bottom
  \li \b -5 M3 head at the bottom
  \li \b -6 M3 head + washer 7x1 at the bottom
  \li \b -7 M3 conical head at the bottom
  \li \b -8 Parker screws (self-tapping) pilot hole, at the bottom
  \li \b -1xxx  M3 nut receptacle. \c xxx is the angle, at the bottom  (for M3 needs \c s > 3.5 mm).
  \li \b -51 M3 nut at the top
  \li \b -52 M3 washer 7x1, at the top
  \li \b -53 M3 washer 7x1, max deep, at the top
  \li \b -54 M3 washer 9x1, at the top
  \li \b -55 M3 head at the top
  \li \b -56 M3 head + washer 7x1 at the top
  \li \b -57 M3 conical head at the top
  \li \b -58 Parker screws (self tapping) pilot hole, at the top
  \li \b -2xxx  M3 nut receptacle. \c xxx is the angle, at the top (for M3 needs \c s > 3.5 mm).
 @param s board or support thickness (default BOARDTHICKNESS)  
*/
module do_nuthole(d, s = BOARDTHICKNESS){
 assert ((s > 0) && (s <200), "s (thickness) out of bounds");
 // assert ((d <= 10), str("d too big (",d ,") instead use carve_roundHole()"));
 
   // z strategies
  _nutz  = (s > _M3_nut_h+ _minz ? _M3_nut_h+EXTRA:s-_minz+EXTRA); // deep for nuts: limit _M3_nut_h
  _deep  = (s > _minz ? s-_minz:s/2);  // deep, no limit, _minz
  _head  = (s > _minz +_M3_headh ? _M3_headh:s- _minz); // for head. limit (_M3_headh)
  _headw = (s > _minz +(_M3_headh +_M3_HWasher) ? _M3_headh +_M3_HWasher:s- _minz); // for head+washer. limit (_M3_headh +_washer_hadj)
  _park = _park_len; // in any case
   
 if (d > 0) polyhole(2*s,d);
 else if (d == 0) ;  // no hole
// at the bottom:
 else if (d == -1) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj);
           translate([0,0,-2*EXTRA])cylinder(d=_M3_nut_Wc+_M3_adj, h= _nutz, $fn=6);}  // M3_nut_Wc, bottom
 else if (d == -2) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
           translate([0,0,-2*EXTRA])polyhole(_M3_HWasher+EXTRA, _M3_Washer+_M3_adj);}  // _M3_Washer deep, bottom 
 else if (d == -3) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
           translate([0,0,-2*EXTRA])polyhole(_deep+EXTRA, _M3_Washer+_M3_adj);}  // _M3_Washer deep, bottom 
 else if (d == -4) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
           translate([0,0,-2*EXTRA])polyhole(_M3_HWasher + EXTRA, _M3_LWasher+_M3_adj);}  // _M3_LWasher, bottom
 else if (d == -5) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
           translate([0,0,-2*EXTRA])polyhole(_head+EXTRA, _M3_headd+_M3_adj);}  // _M3_head, bottom
 else if (d == -6) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
           translate([0,0,-2*EXTRA])polyhole(_headw+EXTRA, _M3_Washer+_M3_adj);}  // _M3_head + washer, bottom
 else if (d == -7) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia);
           translate([0,0,-2*EXTRA])cylinder(d2= _M3_adj, d1=_M3_nut_Wc, h=_M3_nut_Wc/2+2*EXTRA,$fn=6);}  // conical 45°,
 else if (d == -8) translate([0,0,-2*EXTRA])cylinder(d = _park_dia, h=_park_len+2*EXTRA);  // parker 5x2, bottom
 else if ((d > -2000) && (d <= -1000)){
             _lz = _get_boltz(s, _minz);  // bolt hole deep
             translate([0,0,-EXTRA])rotate([0,0,-d - 1000])translate([0,0,_M3_nut_h/2+_get_nutz(s, _minz)+EXTRA-_lz/2])union(){
               polyhole(_lz,_M3_dia+_M3_adj);
               translate([-3* _M3_adj,0,_lz/2- _M3_nut_h/2])cylinder(d=_M3_nut_Wc, h=_M3_nut_h, $fn=6);
               translate([8,0,_lz/2])cube(size=[16, _M3_nut_Ws+_M3_adj,_M3_nut_h+2*_M3_adj], center = true); }}  // 
// same, at the top
 else if (d == -51) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
         translate([0,0,s- _nutz+EXTRA])cylinder(d=_M3_nut_Wc+_M3_adj, h=_nutz+EXTRA, $fn=6);}  // M3_nut_Wc, top
 else if (d == -52) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
         translate([0,0,s-3*_M3_HWasher/4])polyhole(_M3_HWasher+EXTRA, _M3_Washer+_M3_adj);}  // _M3_Washer, top 
 else if (d == -53) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj);
         translate([0,0,s-_deep+EXTRA])polyhole(_deep+EXTRA, _M3_Washer+_M3_adj);}  // _M3_Washer deep, top 
 else if (d == -54) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
         translate([0,0,s-3*_M3_HWasher/4+EXTRA])polyhole(_M3_HWasher+EXTRA , _M3_LWasher+_M3_adj);}  // _M3_LWasher, top
 else if (d == -55) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
         translate([0,0,s-_head+EXTRA])polyhole(_head+EXTRA, _M3_headd+_M3_adj);}  // _M3_head, top
 else if (d == -56) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia+_M3_adj); 
         translate([0,0,s-_headw+EXTRA])polyhole(_headw+EXTRA, _M3_Washer+_M3_adj);}  // _M3_head+washer, top
 else if (d == -57) union(){translate([0,0,-s/2])polyhole(2*s,_M3_dia); 
          translate([0,0,s-_M3_dia+EXTRA])cylinder(d1=  _M3_adj, d2=_M3_nut_Wc, h=_M3_nut_Wc/2+2*EXTRA,$fn=6);}  // conical, top
else if (d == -58) translate([0,0,s-_park_len])cylinder(d = _park_dia, h=_park_len+2*EXTRA);  // parker 5x2, top
else if ((d > -3000) && (d <= -2000)){
             _lz = _get_boltz(s, _minz);  // bolt hole deep
             translate([0,0,-EXTRA])rotate([0,0,-d - 2000])
                 translate([0,0,s -_M3_nut_h/2 -_get_nutz(s, _minz) +EXTRA - _lz/2])union(){
                 polyhole(_lz,_M3_dia+_M3_adj);
                 translate([-3* _M3_adj,0,_lz/2- _M3_nut_h/2])cylinder(d=_M3_nut_Wc, h=_M3_nut_h, $fn=6);
                 translate([8,0,_lz/2])cube(size=[16, _M3_nut_Ws+_M3_adj,_M3_nut_h+ 2*_M3_adj], center = true); }
                }
  else assert(false, str("diameter (d) is ", d,": this value is not allowed"));
}


// ================= private local modules and functions
//! @privatesection
_minz = 1.2;          // required min board thickness

// _do_grill creates a square very big grill, f: fill factor, h: tickness, solid width fixed:_gridSolid,
// angle = _gridAngle. Square holes size is calculated from fill and _gridSolid
module _do_grill(f,h){
    if (f > 98){
        cube([_printer_max_x+50,_printer_max_y+50,h],false);
    }  else {
        _t = sqrt(100/(100-f-1));
        _y = _gridSolid/(_t-1);
        _prtL = max(_printer_max_x, _printer_max_y );  
       translate([_prtL/2,_prtL/2,0])rotate([0,0,_gridAngle]) translate([-_prtL*3/4,-_prtL*3/4,0])union(){
          for (k = [0 : _gridSolid+_y : _prtL*3/2])  
             translate([k,0,0]) cube([_gridSolid, _prtL*3/2,h],false); 
          for (j = [0 : _gridSolid+_y : _prtL*3/2])  
             translate([0,j,0]) cube([_prtL*3/2,_gridSolid,h],false); 
       }
    }
 }
 
// _cut_base generates a rounded (r = roundc) polygon from vertex, hb is thickness.
module _cut_base(vertex, hb, roundc =_slabcorner){
     linear_extrude(height = hb, convexity = 20, twist = 0,$fn=64) offset(roundc) offset(-roundc) polygon(vertex); 
}

// _do_baseh makes a base, solid or hollow, with border and holes
// needs an intersection() with _cut_base for final cut.
module _do_baseh(vertex, holes, fill, s, roundc =_slabcorner) {
difference(){
   union(){
       _do_grill(fill, s);
       do_perimetral(vertex, s, _slabborder, roundc);
       if(!is_undef(holes))
          for (n =[0:1:len(holes)-1]) if(!is_undef(holes[n].z))translate([holes[n].x,holes[n].y,0])
             // cylinder(r=_slabHoleClearance, h=s); // modified 3.9.19 m.s.  to add _slabHoleClearance to big holes
             cylinder(r=_slabHoleClearance+(holes[n].z >3?holes[n].z/2:1.5), h=s);
       } // union ends
   if(!is_undef(holes))
      for (n =[0:1:len(holes)-1]) translate([holes[n].x,holes[n].y,-EXTRA]) if(!is_undef(holes[n].z))do_nuthole(holes[n].z,s); 
    }
}

// _get_boltz()  implements strategy for bolt carving deep in nut insert. Returns double of real value. Rules:
//            (thickness <  _M3_nut_h+minz)  =>>  not allowed (3.55)
//      (tickness < (_M3_nut_h + minz + 9))  =>>  11   // fix value: back closed for thickness > 10 mm
//                                     else  =>>  15
// see example test_get_boltz_get_nutz()
function _get_boltz(thickness, minz) = ((thickness < _M3_nut_h+minz)? 
              assert(false, str("Not enough thikness (",thickness,") for the nut, min 3.55 mm")):
          (thickness < _M3_nut_h+minz+9)? 
               11: // numerical values tuned by hand
               15);

//_get_nutz()  implement strategy to maximize the space nut<->surface to make it stronger. 
    // strategy:  <top/bottom border>|<get_nutz>|<nut>|<0-...>|::     total = support thickness
    //                       (thickness <  _M3_nut_h+minz)  =>>  not allowed (3.55)
    //  (_M3_nut_h+_minz  < thickness < _M3_nut_h+minz +3)  =>>  _minz < get_nutz() < _minz +delta
    //                     (thickness >=  _M3_nut_h+minz+3)  =>>  get_nutz() = 3  (conventional max)
// see example test_get_boltz_get_nutz()
function _get_nutz(thickness, minz) = ((thickness < _M3_nut_h+minz)? 
              assert(false, str("Not enough thikness (",thickness,") for the nut, min 3.55 mm")):
          ((thickness < _M3_nut_h+minz + 3)?   // 
              minz + (thickness- _M3_nut_h-minz)/2:
              3));

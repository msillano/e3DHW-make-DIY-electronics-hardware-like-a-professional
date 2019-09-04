/*
   Parametric DIN boxes, OpenSCAD library
   © 2018 Marco Sillano  (marco.sillano@gmail.com)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
   Designed with http://www.openscad.org/
*/
/**
@file e3DHW_DIN_boxes_lib.1.3.scad
Contains parametric general purpose boxes and separators and boxes for DIN rail. 
@par General purpose boxes
   In this library are 2 modules buiding boxes: a cuboid box rectangleBox() and a genaral purpose do_standalone_polyBox(). This one has the base polygonal, defined by an array of points.\n
   Both boxes have a lid fixabe in different ways. The cover and the bottom can becomes lateral faces turning the box, so the panel can be oblique.\n
   The cover and/or the bottom can be perfored.\n
  These boxes are designed to be used as container for electronic devices, when a custom printed box is preferable to a commercial container.
   The bottom, the lid and also a lateral face can be used as panel. Using ADDONs the DIY maker can get custom panels with holes for LDs and switchs, rectangular openings for displays, etc... with hi precision without a mechanical workshop.

@par DIN separators
   Din separators have many functions:
         \li be a lid for open box and devices placed on DIN rail: same shape than box.
         \li logical/functional connector modules separator, sometime with labels: a little bigger than the near modules
         \li to adjust the space used by commercial or custom blocks, so TOPs fits exactly the available space: DIN separators with TOP.
         \li terminal screw block, to keep in place a full range of modules on a DIN rail: small but strong DIN separators.

   So separators can be very thin or very thick. All separators with thickess over 3 mm are implemented as box with a lid.\n
   In the library is a generic polyDINSeparator() and a specialized boxDINSeparator() that meets standard DIN boxes.

@par DIN boxes
  Some PCB or device can be used as they are, after tied to a DIN clip. But if they have an user interface the better solution is to use a DIN box with TOP. The TOP panel is accessible in any DIN standard container or cabinet.\n
@image html DINboxsonoff.jpg
   In this library we have two DIN boxes: simpleDINBox(), 2 pieces: baseboard and box, and bigDINBox(), a four pieces box.

@par utilities
 In this library there are also some useful functions for new custom designs.


@htmlonly <a name='vertexbox' ></a> @endhtmlonly
@par Polygonal DIN shapes: rules
    For great freedom, som DIN modules requires an array of points for shape definition. 
   \image html dinarray.png
   The 2D shape MUST be placed as in picture:
   \li  all \c y measurements references to the top of DIN rail.\n
   \li  the clip top left point is on y axis, position [0, get_rail2top(clip)].
   \li  the botton line of shape MUST be on x axis: blue line ([0,0], [0,D])(D= width + get_exd())
   \li  the shape will be cut on the bottom (blue rectangle) to make room for the DIN clip: this allows you to change the DIN clip used at runtime without changing the final size of the box. See get_cut2_shape().

@htmlonly <a name='dinbox' ></a> @endhtmlonly
@par DIN boxes shape: rules.
    In case of standard DIN separator or boxes, the shape array is built by the utility function get_DINvertex(), starting from 4 parameters \c width, \c top, \c lefless, \c rigthless:
\image html dinbox.png
The basic shape, rectangule, is defined by the \c width: <i>small, medium or large</i>: \ref DINWIDTHS: 85 mm, \ref DINWIDTHM: 90 mm, \ref DINWIDTHL: 100 mm.\n
The \c top can have 3 values predefined: 43 mm (none:\ref DINPOT), 58 e 63 mm (\ref DINTOP and \ref DINHTOP). \n
For a total control, the user can use also numeric values. \n
The left and rigth sides can be modified using \c leftless and \c rigthless. ( ± 20 mm)\n
Shoulder height (\ref DINPOT) and TOP width (\ref DIN_BOX_TOP_WIDTH) are fixed by standard.\n
The length is in mm for separtors, and in <i>half-modules</i> for boxes (1 module = 18 mm) see get_H().
In any module the DIN clip for the rail is usually choose between 2 alternatives, based on DIN element length, see get_Clip() \n
By default, Din separators don't have towers, boxes have.
See 

@htmlonly <a name='lidstyle' ></a> @endhtmlonly
@par Lid styles
  The lid can match the box in different styles, defined by a set of costants:\n
1 - \ref LSNONE  no lid, no towers, only the box. \n
2 - \ref LSTOW   no lid, only the box and towers.\n
3 - \ref LSOUT   the lid coverts the box sides.\n
4 - \ref LSIN    lid is inside the box sides.\n
\image html toplid.jpg
The Lid stile LSOUT is used when the lid is panel, car it covers the box lateral walls (e.g. standalone boxes).\n 
   The stile LSIN is preferable when the panel is the bottom or a lateral side, car the box now hides the lid (e.g. rotated standalone box, DIN boxes).\n
   The style LSTOW is used in bigDINBox() where the box must fit a larger board.

@note:
   A box with many addons can be difficult to print: it contains many holes and many small surfaces.
   The main issue on my printer is the ooze in not-printing moves. \n
   I try to reduce ooze using lower temperature and accordingly slow speed (I use 80%-60% of usual 70 mm/s in Repetier).
   
@par dependences
    This library requires:
            \li \c MCAD/polyholes.scad
            \li \c e3DHW_base_lib.1.3.scad
            \li \c e3DHW_array_utils.1.3.scad
            \li \c e3DHW_hardware_data.1.3.scad
            \li \c e3DHW_addon_base.1.3.scad
            \li \c e3DHW_DIN_rail_lib.1.3.scad

    To use this library you must add the following line to your code:
            \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
            \li  <tt> include <e3DHW_array_utils.1.3.scad></tt>
            \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt>
            \li  <tt> include <e3DHW_addon_base.1.3.scad></tt>
            \li  <tt> include <e3DHW_DIN_rail_lib.1.3.scad></tt>
            \li  <tt> include <e3DHW_DIN_boxes_lib.1.3.scad></tt>\n
            <i> but don't allow duplicate includes.</i>

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version.
 @version 0.1.2   29/07/2019 Bugs correction. 
                   Better use: parameters check and standization. 
                   Doxygen comments.
 @copyright GNU Lesser General Public License.
 @example  e3DHW_DIN_boxes_examples.scad
 */

//! @publicsection

OPTION_BOXPRINT = false; ///< true: all pieces at z=0, otherwhise the lid is in place.
/**
A decreasing set of box thicknesses (printer and filament dependent).
1 - \ref BOARDTHICKNESS (mm 2-3) for big main boards and lids with many ADDONs (in  e3DHW_base_lib.1.3.scad )\n
2 - \ref TOPTHICKNESS (mm 1.8-2.5) for panels: the bottom of DIN boxes, the top if used as panel.\n
3 - \ref NOTOPTHICKNESS (mm 1.4-2) for lateral sides of boxes, for the botton (no panel)\n
4 - \ref SEPARATORTHICKNESS = (mm 1-1.6) minimal thickness for separators.
*/
TOPTHICKNESS = 2.2;        ///< eavy TOP thickness
NOTOPTHICKNESS = 1.7;      ///< slim TOP and sides thickness
SEPARATORTHICKNESS = 1.2;  ///< separators thickness

// note all consecutive values between LSNONE and LSIN.
LSNONE =100;  ///< @htmlonly <a href='#lidstyle'>lidStyle</a> @endhtmlonly. costant: no lid, no towers, only box
LSTOW  =101;  ///< @htmlonly <a href='#lidstyle'>lidStyle</a> @endhtmlonly. costant: no lid, only box + towers
LSOUT = 102;  ///< @htmlonly <a href='#lidstyle'>lidStyle</a> @endhtmlonly. costant: the lid is on top.
LSIN  = 103;  ///< @htmlonly <a href='#lidstyle'>lidStyle</a> @endhtmlonly. costant: the lid goes inside the walls of the box.

// DIN standard boxes constants
DINHTOP  = 63;  ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN top height max.
DINTOP   = 58;  ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN top height standard.
DINPOT   = 43;  ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN box height at shoulders, no top (fix).
DINWIDTHS = 85;           ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN box width small.
DINWIDTHM = 90;           ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN box width medium.
DINWIDTHL = 100;          ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN box width +large.
DIN_BOX_TOP_WIDTH = 45;   ///< @htmlonly <a href='#dinbox'>DIN boxes</a> @endhtmlonly constant: DIN top large (fix).

//! @privatesection

_biground = 10;   // internal use, for DIN boxes with TOP
_lidclearance =0.3;
_stop_width   =  7;   // stop step for box with lid  width: better to keep it =  _slabborder in e3DHW_base_lib (defaut 7)
_stop_height  = 1.2;   // stop step for box with lid: height
 // gets the length of the base segment ([0,0]...[D.0]) from the shape array
 // return valkue or 0
function _getD(parray, m =0, i=0) = ( i == len(parray)? m: _getD( parray,(parray[i][1] == 0)&&( m < parray[i][0])? parray[i][0]:m, (i+1))) ;

//! @publicsection 
 // -------------------------------  box standalone
  /**
  @fn do_standalone_polyBox(vertex, height = 20, lidAHoles = undef, lidStyle = LSOUT, lidThick = BOARDTHICKNESS, lidFill = 100, bottomThick=TOPTHICKNESS, bottomFill = 100, sideThick = NOTOPTHICKNESS, towerAHoles = undef, towerRadius=3, x=0, y=0, rot = norot, round_box=_slabcorner)
   builds a generic standalone prismatic box.
  With many parametrs, this is a generic module used by all other specilized modules.\n
  The shape is defined from a \c vertex array and an height. Indipendent ticknesses can be defined for cover, sides and bottom. A \c towerAHoles array defines the towers used to fix the lid with screws, \c lidAHoles array defines the lid holes (for towers, and maybe more). The final look is set by the \c lidStyle, top and botton filling factors and the round corners radius.
@image html custombox.png
  @param vertex  is an array2 of points: <tt>[[p0.x, p0.y],[p1.x, p1,y],...]</tt> see @htmlonly <a href='#vertexbox'>shape rules</a> @endhtmlonly and get_DINvertex().
  @param height box height [mm], external measurement.
  @param lidAHoles  is an array3 of holes definitions for the lid: <tt>[[h0.x, h0. y,h0.d],..]</tt>. Must contains also all towerAHoles. See get_tower2holes(); see do_nuthole() for codes.\n
   Default - 'undef': no holes. <tt>hn.d = 0 </tt>: makes the base, but not the hole.
  @param lidStyle one of \ref LSNONE, \ref LSTOW, \ref LSOUT, \ref LSIN, default LSOUT: it defines the @htmlonly <a href='#lidstyle'>lid styles</a> @endhtmlonly.
  @param lidThick the lid thickness. Default BOARDTHICKNESS
  @param lidFill lid filling control: a value in percent: <tt>0 (empty)..100 (solid)</tt>.Default DEFAULTFILL.
  @param bottomThick box bottom thickness. Default TOPTHICKNESS. 
  @param bottomfill  box bottom perforation control: a value in percent: </tt>0 (empty)..100 (solid)</tt>. Default DEFAULTFILL.
  @param sideThick  box lateral sides thickness. Default NOTOPTHICKNESS.
  @param towerAHoles is an array3 of towers for lid fixing. Defines the holes on tower top: <tt>[[t0.x, t0.y, t0.d],..]</tt>. See do_nuthole() for codes.\n
   Default - \c 'undef': no towers at all. <tt>tn.d = undef </tt>: no 'n' tower;  <tt>tn.d = 0 </tt>: no carving on 'n' tower top\n
  @param towerRadius default = 3 mm. minimun, can be overwrited: see get_towerRadius(), add1_tower().
  @param round_box radius round box corners. Default _slabcorner (in  e3DHW_base_lib.1.3.scad ); max 3;
  */
  module do_standalone_polyBox(vertex, height = 20, lidAHoles = undef, lidStyle = LSOUT, lidThick = BOARDTHICKNESS, lidFill = 100, bottomThick=TOPTHICKNESS, bottomFill = 100, sideThick = NOTOPTHICKNESS, towerAHoles = undef, towerRadius=3, x=0, y=0, rot = norot, round_box=_slabcorner){
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");
   // min lid 4x4
   assert((get_maxX(vertex) - get_minX(vertex)) >= 2*sideThick + 4, "box length too small");  
   assert((get_maxY(vertex) - get_minY(vertex)) >= 2*sideThick + 4, "box width too small"); 
   if(! is_undef(lidAHoles))  // optional
      assert(is_arrayOK(lidAHoles, 3, 1), "test on array failed");
   assert ((lidStyle >= LSNONE) && (lidStyle <= LSIN),"lidStyle value not allowed");
   if(! is_undef(towerAHoles))  // optional
       assert(is_arrayOK(towerAHoles, 3, 1), "test on array failed");
   assert ((lidFill >=0) && (lidFill <= 100),"lidFill out of bounds: 0..100 (percentage)");
   assert ((bottomFill >=0) && (bottomFill <= 100),"bottomfill out of bounds: 0..100 (percentage)");
   assert (round_box < 3 * sideThick, str("round_box value too big: max ", 3*sideThick)); // the exact value is sqr(2)/(sqr(2)-1) = 3.414 
   _boxUseH = (lidStyle == LSOUT ? height - lidThick : height );
   _towerH = (lidStyle  == LSOUT ? _boxUseH-BOARDTHICKNESS -_stop_height- _lidclearance 
               :(lidStyle  == LSTOW?_boxUseH -BOARDTHICKNESS-_lidclearance
                 :_boxUseH-BOARDTHICKNESS -lidThick - 2*_lidclearance)); 
   _towerUseH = max (0, _towerH);
   // n.b. BOARDTHICKNESS is added by add1_polyTower to height
 //  assert ((_towerUseH >= 2.65), "box height too small"); // magic 2.65: with defaults assert ok for h >= 10 mm
   translate([x,y,0])rotate(rot)difference(){
      union() {
         polyBase(vertex,get_tower2holes(towerAHoles, 0), bottomFill, bottomThick, 0,0, norot, round_box);  // bottom, noy holes, but get_tower2holes() give an array of 'holes' dia=0: this force tower bases construction
         do_perimetral(vertex, _boxUseH, sideThick, round_box);             // sides
         _hborder = min(_stop_width /2, _boxUseH-lidThick-_lidclearance -EXTRA);
         if (lidStyle == LSIN) translate([0,0,max(EXTRA,_boxUseH - lidThick - _lidclearance-_hborder)]){  // stop ring if lidStyle == LSIN
            difference(){
               linear_extrude(height = _hborder) offset(delta=-(sideThick-EXTRA)) polygon(vertex); 
               translate([0,0,-EXTRA])linear_extrude(height =_stop_width+2*EXTRA)
                   offset(delta=-(sideThick +_stop_height)) polygon(vertex);
               } // difference ends
            }
        if ((lidStyle != LSNONE)&&(!is_undef(towerAHoles))) add1_polyTower(height = _towerUseH, holes = towerAHoles, towerd=2*towerRadius, cbase=false);
           // to late to do tower bases: they can go out from board profile.
         }  // union ends
    if ((lidStyle  != LSNONE)&&(! is_undef(towerAHoles)))  carve2_polyTower(height = _towerUseH, holes = towerAHoles, towerd=2*towerRadius);
      }// difference ends
   }
  
/**
  @fn do_standalone_polyLid(vertex, height = 20, lidAHoles = undef, lidStyle = LSOUT, lidThick = BOARDTHICKNESS, lidFill = 100, bottomThick=TOPTHICKNESS, bottomFill = 100, sideThick = NOTOPTHICKNESS, towerAHoles = undef, towerRadius=3, x=0, y=0, rot = norot, round_box=_slabcorner)
  companion lid module for do_standalone_polyBox(). Use it with same parameters.
  */
module do_standalone_polyLid(vertex, height = 20, lidAHoles = undef, lidStyle = LSOUT, lidThick = BOARDTHICKNESS, lidFill = 100, bottomThick=TOPTHICKNESS, bottomFill = 100, sideThick = NOTOPTHICKNESS, towerAHoles = undef, towerRadius=3, x=0, y=0, rot = norot, round_box=_slabcorner){
   assert ((lidStyle >= LSNONE) && (lidStyle <= LSIN),"lidStyle value not allowed");
   assert((lidStyle != LSNONE) || (lidStyle != LSTOW), "it is an ERROR to use do_standalone_polyLid() when lidStyle == LSNONE|LSTOW");
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");
   assert ((height > 0) && (height <200), "box height out of bounds");
   if(! is_undef(lidAHoles))  // optional
       assert(is_arrayOK(lidAHoles, 3, 1), "test on array failed");
   if(! is_undef(towerAHoles))  // optional
       assert(is_arrayOK(towerAHoles, 3, 1), "test on array failed");
   assert ((lidFill >=0) && (lidFill <= 100),"lidFill out of bounds: 0..100 (percentage)");
   assert ((bottomFill >=0) && (bottomFill <= 100),"bottomfill out of bounds: 0..100 (percentage)");
   translate([x,y,0])rotate(rot)translate([-10,0,0])mirror([1,0,0]) 
   difference(){
      union(){
         intersection(){
            polyBase(vertex,get_tower2holes(lidAHoles, 0), lidFill, lidThick);  // top standard get_tower2holes() give an array of 'holes' dia=0: this force bases construction.
            if (lidStyle == LSIN)
                translate([0,0,-EXTRA])linear_extrude(height = lidThick+2*EXTRA) 
                    offset(delta=-(sideThick+_lidclearance)) polygon(vertex);   // reduces lid for LSIN
            }
         if (lidStyle == LSOUT)difference(){                                   // add stop border for LSOUT
               translate([0,0,EXTRA])linear_extrude(height = lidThick+_stop_height-EXTRA) 
                    offset(delta=-(sideThick+_lidclearance)) polygon(vertex); 
               translate([0,0,0])linear_extrude(height = lidThick+_stop_height+2*EXTRA)
                    offset(delta=- _stop_width) polygon(vertex); 
         }
      } // ends union
    if(!is_undef(lidAHoles)) for (n =[0:1:len(lidAHoles)-1])                  // now holes
         translate([lidAHoles[n].x,lidAHoles[n].y,0]) 
         do_nuthole(lidAHoles[n].z, ((lidStyle==LSOUT)? lidThick+_stop_height-EXTRA:lidThick));
    } // ends difference
} 

/**
  @fn rectangleBox( length, width, height, lidHole = -7, lidThick = BOARDTHICKNESS, lidFill = 100, towerHole = -58, bottomThick = TOPTHICKNESS, bottomFill = 100, lidStyle = LSOUT, x=0, y=0, rot = norot)
  Standalone box, an enclosures for DIY electronic projects.
  This is a general pourpose rectangular box, in two pices: a base box and a lid board.
  As default the cover is tied to base using 4 self-tapping screws, placed at the 4 corners. \n
  The front panel can be the cover or the base: ADDONs can be added on the floor of the box and/or on the lid. Also lateral sides can have ADDONS: see e3DHW_addon_box.1.3.scad.\n
  @image html rectbox.png
  If required the lid and/or the bottom can be perforated ( \c lidFill, \c bottomFill) for ventilation.
  @param length  the total box length, mandatry. Min variable (with defaults: 15).
  @param width  the total box width, mandatory.  Min variable (with defaults: 15).
  @param height  the total box height, mandatory.  Min variable (with defaults: 10).
  @param lidHole,towerHole @parblock the diameter/code used for the holes on lid and on tower top. (see do_nuthole()).\n
       The default is for self-tapping screws (\c lidHole: -7 = \c conic \c head and \c towerHole: -58 = \c pilot \c hole).\n
       It is also possible to use bolts: set -5 (or -6) as \c lidHole and -2000 as \c towerHole: the code will handle that correctly. \n
	    <tt>lidHole == 0</tt> minds no holes on the lid.\n
       <tt>towerHole == 0</tt> minds no towers: you must use custom ways to tie the cover.</i>
       @endparblock
  @param lidThick  the lid thickness. Default \ref BOARDTHICKNESS
  @param lidFill  the fill factor for the lid (default 100).
  @param bottomThick  the box bottom thickness. Default \ref TOPTHICKNESS.
  @param bottomFill  the fill factor for the box bottom (default 100).
  @param lidStyle  default LSOUT (lid is panel).
*/
module rectangleBox( length, width, height, lidHole = -7, lidThick = BOARDTHICKNESS, lidFill = 100, towerHole = -58, bottomThick = TOPTHICKNESS, bottomFill = 100, lidStyle = LSOUT, x=0, y=0, rot = norot){
   assert(length >= 15, "box length too small, min 15"); 
   assert(width >= 15, "box width too small, min 15"); 
   assert(height >= 10, "box height too small, min 10"); 
   // tower size tune based on towerHole style
   _towRad = get_towerRadius(towerHole, lidStyle);
   // towers borders distance
   _dt = get_towerDistance(towerHole, lidStyle);
   _vertex = get_squareArray2(length,width);
   _baseHoles = get_squareArray3(length,width,_dt,_dt,lidHole);
     // special for -2xxx holes, rectangular shape   
   _towerHoles = [ for(i= [0:1:3])[_baseHoles[i].x, _baseHoles[i].y, (towerHole > -3000) &&(towerHole <= -2000)? (-2045 -i*90):towerHole ]];
    // boardHole == 0 : no holes on board, towerHole == 0: no towers at all.
   do_standalone_polyBox(_vertex, height,(lidHole == 0? undef:_baseHoles), lidStyle, lidThick, lidFill, bottomThick, bottomFill, NOTOPTHICKNESS,(towerHole == 0? undef:_towerHoles), _towRad, x=(x),y=(y), rot =(rot));
    if ((lidStyle != LSNONE) && (lidStyle != LSTOW)){
  if (OPTION_BOXPRINT)
       do_standalone_polyLid(_vertex, height, (lidHole == 0? undef:_baseHoles),  lidStyle, lidThick, lidFill, bottomThick, bottomFill, NOTOPTHICKNESS,(towerHole == 0? undef:_towerHoles), _towRad, x=(x),y=(y), rot =(rot)); 
  else 
     translate([-10,0,height+1])rotate([0,180,0]) 
      do_standalone_polyLid(_vertex, height, (lidHole == 0? undef:_baseHoles),  lidStyle, lidThick, lidFill, bottomThick, bottomFill, NOTOPTHICKNESS,(towerHole == 0? undef:_towerHoles), _towRad, x=(x), y=(y), rot =(rot));
 
      }
  }

/**
  @fn polyDINSeparator(vertex = undef, length = 2, width=xauto, uclip = xauto, lidThick = SEPARATORTHICKNESS, boxThick = SEPARATORTHICKNESS, fill = DEFAULTFILL, x=0, y=0, rot = norot)
   makes a simple separator for DIN rail.
   This kind of separator is used logical and funtional separator between DIN moduke (e.g. terminals) or as strong terminal (with screw). For that the length is in mm. \n
  @image html DINcustom.jpg
   If length is 4 mm or more, it becomes a box with lid, but whitout towers and holes: the lid can be fixed with glue or hot wax (lidStyle = LSIN).
  @param vertex  2D polygon definition.
  @param length the separator length [mm], acceps any value. 
  @param width this value is used to build the DIN clip. Default \c xauto: the width is calculated automatically from the vertex points on x axis: [0,0]... [width,0]
  @param uclip acceps different options: @parblock
       \li:\c xauto: this module choses between "NSS" or "SPF", based on length (default).
       \li: <tt>["XXX","YYY"]</tt>: this module uses one of the two clips, based on length: the first clip MUST have a value min_h() less than "YYY".
       \li "ZZZ": this module uses the clip "ZZZ".
  Any clip can be used, so take care to different clips sizes limits.
	   @endparblock
  @param lidThick is the the lid and box bottom thickness. Default \ref SEPARATORTHICKNESS
  @param boxThick  is the box sides thickness. Default \ref SEPARATORTHICKNESS.
  @param fill is the fill factor for lid and box bottom. Default \ref DEFAULTFILL.
 */
module polyDINSeparator(vertex = undef, length = 2, width=xauto, uclip = xauto, lidThick = SEPARATORTHICKNESS, boxThick = SEPARATORTHICKNESS, fill = DEFAULTFILL, x=0, y=0, rot = norot){
     assert(is_arrayOK(vertex, 2, 3), "test on array failed");

    _useCLIP =  get_Clip(uclip,length,["NSS","SPF"]);
  //   assert((get_xq(_useCLIP)==0), str("The DIN clip ",_useCLIP," not allowed for separators"));
    _cutX = get_rail2top(_useCLIP) - SEPARATORTHICKNESS;
    _useD = (width==xauto?_getD(vertex):width);
    _useArray = get_cut2_shape(vertex,_cutX-EXTRA); 
   translate([x,y,0])rotate(rot)union(){
   translate([get_ClipTrnsX(_useCLIP, _useD),get_rail2top(_useCLIP)+EXTRA,0])do_DINClip(_useCLIP, length, get_ClipWidth(_useCLIP, _useD));
     if (length <4){
          polyBase(vertex=_useArray, holes = undef,  fill=(fill), thickness =length, x=0, y=0, rot = norot);
      }
      else {
        do_standalone_polyBox(_useArray, height = length, lidAHoles = undef, lidStyle = LSIN, lidThick = (lidThick), lidFill = fill, bottomThick=lidThick, bottomFill = fill, sideThick = boxThick, towerAHoles = undef, towerRadius=3);
   if (OPTION_BOXPRINT)
       do_standalone_polyLid(_useArray, height = length, lidAHoles = undef, lidStyle = LSIN, lidThick = (lidThick), lidFill = fill, bottomThick=lidThick, bottomFill = fill, sideThick = boxThick, towerAHoles = undef, towerRadius=3);
  else
      translate([-10,0,length+0.1])rotate([0,180,0]) 
      do_standalone_polyLid(_useArray, height = length, lidAHoles = undef, lidStyle = LSIN, lidThick = (lidThick), lidFill = fill, bottomThick=lidThick, bottomFill = fill, sideThick = boxThick, towerAHoles = undef, towerRadius=3);
     }
    }
  }
  

/**
  @fn boxDINSeparator(length, top = DINTOP, width= DINWIDTHM, leftless=0, rigthless=0, uclip = xauto, lidThick = SEPARATORTHICKNESS, boxThick = SEPARATORTHICKNESS, fill = DEFAULTFILL, x=0, y=0, rot = norot)
   This kind of separator is used as lid for open DIN boxes, and as filler to meet container dimensions. For that the length is in mm. 
  @image html DINboxsep.png
  Uses polyDINSeparator(), with vertex builts by get_DINvertex(), using standard DIN profiles parameters.
  @param length [mm] of the separator, if \c length > 4 mm the separator bocomes a box with cover.
  @param  width,top,lefless,rigthless  the DIN profile definition. see @htmlonly <a href='#dinbox'>DIN boxes rules</a> @endhtmlonly.
  @param uclip acceps different options: xauto, "XXX", ["XXX","YYY"] see get_Clip(). Default xauto: (<tt>["NSS","SPF"]</tt>).\n
  @param fill  the fill factor for the separator (default \c DEFAULTFILL).
*/
module boxDINSeparator(length, top = DINTOP, width= DINWIDTHM, leftless=0, rigthless=0, uclip = xauto, lidThick = SEPARATORTHICKNESS, boxThick = SEPARATORTHICKNESS, fill = DEFAULTFILL, x=0, y=0, rot = norot){
      _useCLIP =  get_Clip(uclip, length, ["NSS","SPF"]);
       polyDINSeparator(get_DINvertex(top, width, leftless, rigthless), length , width,_useCLIP, lidThick , boxThick , fill, x=(x), y=(y), rot=(rot));
}


/**
@fn  simpleDINBox(size_hm, top = DINTOP, width= DINWIDTHM, leftless=0, rigthless=0, uclip = xauto, lidHole = -7, lidThick = TOPTHICKNESS, lidFill = 100, towerHole = -58, bottomThick = TOPTHICKNESS, bottomFill = 100, boxThick = NOTOPTHICKNESS, lidStyle = LSIN, x=0, y=0, rot = norot)
  Containers (boxes) for DIN rail, defined by standard parameters.
  The box can contains one or more horizontal or vertical PCBs (addon PCB rails in e3DHW_addon_boxes.scad) and any ADDON on the lid or TOP.
  @param size_h box length, in half-modules (1 module = mm 18). 
  @param  width,top,lefless,rigthless  the DIN profile definition. see @htmlonly <a href='#dinbox'>DIN boxes rules</a> @endhtmlonly.

  @param uclip acceps different options: xauto, "XXX", ["XXX","YYY"]. See polyDINSeparator(). Default <tt> ["SPF","MSX"] </tt> to maximize interior space.\n
     Acceps only symmetrical DIN clips.
  @param lidHole,towerHole @parblock the diameter/code used for the holes on lid and on tower top. (see do_nuthole()).\n
       The default is for self-tapping screws (\c lidHole: -7 = \c conic \c head and \c towerHole: -58 = \c pilot \c hole).\n
 	    <tt>lidHole == 0</tt> minds no holes on the lid.\n
       <tt>towerHole == 0</tt> minds no towers: you must use custom ways to tie the cover.</i>
       @endparblock
  @param lidThick  the lid thickness. Default BOARDTHICKNESS
  @param lidFill  the fill factor for the lid (default 100).
*/
module simpleDINBox(size_hm, top = DINTOP, width= DINWIDTHM, leftless=0, rigthless=0, uclip = xauto, lidHole = -7, lidThick = TOPTHICKNESS, lidFill = 100, towerHole = -58, bottomThick = TOPTHICKNESS, bottomFill = 100, boxThick = NOTOPTHICKNESS, lidStyle = LSIN, x=0, y=0, rot = norot){
    _length = get_H(size_hm);
    _useCLIP =  get_Clip(uclip, _length, ["SPF","MSX"]); 
      // tower size tune based on towerHole style
   _towRad = get_towerRadius(towerHole, lidStyle);
   // towers borders distance
   _dt = get_towerDistance(towerHole, lidStyle);
   _vertex = get_DINvertex(top, width, leftless, rigthless); // get basic vertex array
   _cutX = get_rail2top(_useCLIP) - SEPARATORTHICKNESS;      // cutting y for  DIN clip
   _useArray = get_cut2_shape(_vertex,_cutX-EXTRA);           // get cut array
   _towList = get_DINvertex2tower(_useArray, towerHole, _dt);      // get tower positions
   translate([x,y,0])rotate(rot)union(){
        translate([get_ClipTrnsX(_useCLIP, width),get_rail2top(_useCLIP)+EXTRA,0])do_DINClip(_useCLIP, _length, get_ClipWidth(_useCLIP, width));

      do_standalone_polyBox(_useArray, _length,lidAHoles =(lidHole == 0? undef:get_tower2holes(_towList, lidHole)), lidStyle = (lidStyle), lidThick = (lidThick), lidFill = (lidFill), bottomThick=(bottomThick), bottomFill = (bottomFill), sideThick = boxThick,towerAHoles = (towerHole == 0? undef: _towList),towerRadius= _towRad);
   } 
 if (lidStyle != LSNONE)translate([x,y,0])rotate(rot){
  if (OPTION_BOXPRINT)
    do_standalone_polyLid(_useArray, _length,lidAHoles =(lidHole == 0? undef:get_tower2holes(_towList, lidHole)), lidStyle = (lidStyle), lidThick = (lidThick), lidFill = (lidFill), bottomThick=(bottomThick), bottomFill = (bottomFill), sideThick = boxThick,towerAHoles = (towerHole == 0? undef: _towList),towerRadius= _towRad);
  else
     translate([-10,0,_length+0.1])rotate([0,180,0]) 
     do_standalone_polyLid(_useArray, _length,lidAHoles =(lidHole == 0? undef:get_tower2holes(_towList, lidHole)), lidStyle = (lidStyle), lidThick = (lidThick), lidFill = (lidFill), bottomThick=(bottomThick), bottomFill = (bottomFill), sideThick = boxThick,towerAHoles = (towerHole == 0? undef: _towList),towerRadius= _towRad);
   }
 }

/**
@fn bigDINBox(size_hm, base_width=50, top = DINPOT, uclip = xauto, boardThick = BOARDTHICKNESS, boardFill = DEFAULTFILL,  topFill = 100,  topThick = TOPTHICKNESS, boxThick = NOTOPTHICKNESS)
   This big board consist in four pieces assembled by screws.
   2 DIN clips are tied to main board ("SCB","SPC","SCC"); also the box is tied with screws.\n 
   Without top (DINPOT) the box is rectangular over the board, else the box is limited to the TOP zone.
 \image html bigDINbox.png
   @param size_hm box length, in half-modules, min 5 (2.5 modules = mm 44.5).
   @param base_width: values [50..100], usually less than DINWIDTHL.
   @param top one of \ref DINPOT, \ref DINTOP, \ref DINHTOP, or a numeric value >= 43 mm. this parameter controls the resulting box style.
   @param uclip here you can use standalone strong clips: "SCB" the smallest, "SPC" whith spring or "SCC".
   @param boardThick is the the main board thickness. Default \ref BOARDTHICKNESS
   @param topThick  is the top box thickness. Default \ref TOPTHICKNESS.
   @param boxThick  is the box walls thickness. Default \ref NOTOPTHICKNESS.
   @param boardFill is the fill factor for the main board. Default \ref DEFAULTFILL.
   @param topFill is the fill factor for the TOP. Default 100, because it is the panel. If the box is without TOP. can be perfored for areation.
*/
module bigDINBox(size_hm, base_width=50, top = DINPOT, uclip = xauto, boardThick = BOARDTHICKNESS, boardFill = DEFAULTFILL,  topFill = 100,  topThick = TOPTHICKNESS, boxThick = NOTOPTHICKNESS){
     assert ((size_hm >= 5), "bigDINBox size too small: min.5");
     assert ((base_width >= DIN_BOX_TOP_WIDTH), str("bigDINBox width too small: min = ", DIN_BOX_TOP_WIDTH));
  // constants
   _clip_length = 11;
//   _hole_border =4;
   //
   _board_clipHole = -7;
   _board_boxHole =-57;
   _towerHole = -58;
   // 
   _length = get_H(size_hm);
   _height = top -boardThick;
   _useCLIP =  get_Clip(uclip, _length, ["SCB","SCB"]); 
    assert(get_exd(_useCLIP)>0,"Clips must have fixing holes"); 
    // accepts also not symmetrical clips("SCB")
   _useDHoleClip = get_ClipWidth(_useCLIP, base_width);
   _xoffset = get_ClipTrnsX(_useCLIP, base_width);
 // --------- 2 * clips 
  if (OPTION_BOXPRINT){
   translate([(_length + 20)*2, 30,0])do_DINClip(_useCLIP, _clip_length,_useDHoleClip);
   translate([(_length + 20)*2, 60,0])do_DINClip(_useCLIP, _clip_length,_useDHoleClip);
  }
  else {
    translate([-_xoffset+base_width+(top == DINPOT?0:-(base_width -DIN_BOX_TOP_WIDTH)/2), _length/4 + _clip_length/2 ,_height+boardThick+1])rotate([-90, 0,180])do_DINClip(_useCLIP, _clip_length,_useDHoleClip);
     
    translate([-_xoffset+base_width+(top == DINPOT?0:-(base_width -DIN_BOX_TOP_WIDTH)/2), 3*_length/4 + _clip_length/2 ,_height+boardThick+1])rotate([-90, 0,180])do_DINClip(_useCLIP, _clip_length,_useDHoleClip);
 }
 // -------- top
    // general constants
   // tower size tune based on towerHole style
   _towRad = get_towerRadius(_towerHole, LSTOW);
   // towers borders distance
   _dt = get_towerDistance(_towerHole, LSTOW);
   _topcarve=[[0,3],[DINPOT-3,20],[DINPOT-3,_length-20],[0,_length-3]];
   _boardpoints = get_squareArray2(base_width,_length);
   // top box
   _toppoints =( top == DINPOT)?
       _boardpoints:
       get_squareArray2(DIN_BOX_TOP_WIDTH,_length);
    // tower in boxes
   _boxtowers =( top == DINPOT)?
        get_squareArray3(base_width,_length,_dt,_dt,_towerHole ):
        get_squareArray3(DIN_BOX_TOP_WIDTH,_length,_dt,_dt,_towerHole );
    // standard box
  
   difference(){
      do_standalone_polyBox(_toppoints, _height, undef, LSTOW, boardThick, boardFill, boxThick, topFill, boxThick, _boxtowers, _towRad, round_box= top != DINPOT?0: _slabcorner );
    if ( top != DINPOT){
        translate([-5,0,top+8])rotate([0,90,0]) linear_extrude(height = DIN_BOX_TOP_WIDTH+10, $fn=64) offset(r=_biground) offset(delta=-_biground) polygon(_topcarve);
      }
   }
  
 //========= base 
     // clips mountimg holes
   _baseh1 = 
    [[get_exd(_useCLIP)/2,_length/4,_board_clipHole],[get_exd(_useCLIP)/2,3*_length/4,_board_clipHole],[get_exd(_useCLIP)/2+_useDHoleClip,3*_length/4,_board_clipHole],[get_exd(_useCLIP)/2+_useDHoleClip,_length/4,_board_clipHole]];
     // box mounting holes
   _baseh2 =( top == DINPOT)?
        get_squareArray3(base_width,_length,_dt,_dt,_board_boxHole ): 
        get_squareArray3(base_width,_length,(base_width-DIN_BOX_TOP_WIDTH)/2+_dt,_dt,_board_boxHole );
   _baseholes = concat(_baseh1,_baseh2);
//   
 if (OPTION_BOXPRINT)
       translate([_length + 20,0,0])
         polyBase(_boardpoints,_baseholes, fill= boardFill );
  else translate([ top == DINPOT?0:-(base_width -DIN_BOX_TOP_WIDTH)/2,0,_height+0.3])
         polyBase(_boardpoints,_baseholes, fill= boardFill );
 } 
 
 // =====================================   PUBLIC FUNCTIONS

/**
@fn get_DINvertex(top , width, leftless, rigthless) 
utility: makes a \b vertex array2 from DIN box parameters <tt>top , width, leftless, rigthless </tt>. See @htmlonly <a href='#dinbox'>DIN rules</a> @endhtmlonly.
*/
// To keep the top centered on the rail uses negative coordinates ( \c leftless).
// It creates a small step (0.5mm), using only width: <tt>(0,0),(width,0)</tt>, compatible with the option <tt> width = xauto </tt>.
  function get_DINvertex(top, width, leftless, rigthless)=[
       [0,0],
       [0,0.5],
       [leftless,0.5],
       [leftless,DINPOT],
       [(width -DIN_BOX_TOP_WIDTH)/2,DINPOT],
       [(width -DIN_BOX_TOP_WIDTH)/2,top ],
       [(width +DIN_BOX_TOP_WIDTH)/2,top ],
       [(width +DIN_BOX_TOP_WIDTH)/2,DINPOT],
       [width-rigthless,DINPOT],
       [width-rigthless,0.5],
       [width,0.5],
       [width,0] ];

/**
@fn get_DINvertex2tower(v, diam, delta)
utility: makes the towers array3 from vertex array. Only if vertex is created by get_DINvertex().
*/
//  Accepts also diam = -2000.
  function get_DINvertex2tower(v, diam, delta)=[
    [v[2].x+delta,v[2].y+delta,(diam > -3000)&&(diam <= -2000)? -2045:diam ],
    [v[3].x+delta,v[3].y-delta,(diam > -3000)&&(diam <= -2000)? -2315:diam ],
    [v[5].x+delta,v[5].y-delta, v[5].y == v[4].y ?0:(diam > -3000)&&(diam <= -2000)? -2315:diam ],
    [v[6].x-delta,v[6].y-delta, v[6].y == v[7].y ?0:(diam > -3000)&&(diam <= -2000)? -2225:diam ],
    [v[8].x-delta,v[8].y-delta,(diam > -3000)&&(diam <= -2000)? -2225:diam ],
    [v[9].x-delta,v[9].y+delta,(diam > -3000)&&(diam <= -2000)? -2135:diam ] ];

/**
@fn get_tower2holes(v, diam)
utility: builds the lid holes array3, from any towers array. 
*/
  function get_tower2holes(v, diam)=(is_undef(v)? undef:[ 
     for(i= [0:len(v) -1])[v[i].x,v[i].y, (is_undef(v[i].z)? undef:(v[i].z == 0)? 0: diam)]]);
 
/**
@fn get_towerRadius(towerHole, lidStyle = LSIN)
utility: implements the strategy for box tower radius for special tower holes.
*/
// <i> For standard holes (towerHole >0) the strategy is implemented in add1_tower().</i>
// goals: smallest tower, and enough place for screw heart on the lid (magic numbers tuned by tests).
  function get_towerRadius(towerHole, lidStyle = LSIN)=
   (towerHole > 0 ? xauto:
      (lidStyle == LSIN? (towerHole <=- 2000? 4.2:3.5 ):
         (towerHole <=- 2000? 4.2:3.2 )));

 /**
@fn get_towerDistance(towerHole, lidStyle = LSIN)
utility: implements the strategy for the distance between the tower and the sides of the box (90° angle).
*/
// goals: best tower/border fit, and enough place for screw heart on lid (magic numbers tuned by tests).
function get_towerDistance(towerHole, lidStyle = LSIN)=
   (towerHole > 0 ? towerHole/2+3.5:
      (lidStyle == LSIN? (towerHole <=- 2000? 6:6 ):
         (towerHole <=- 2000? 4.8:4.8 )));
  
  /**
  @fn  do_verifyArrays(vertex, towers = undef)
  utility: development test for polygon array and towers positions. Use with only array definitions.
  */
module do_verifyArrays(vertex, towers = undef){
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");
   if(!is_undef(towers))
         assert(is_arrayOK(towers, 3, 3), "test on array failed");
   difference(){
      union(){
         if(!is_undef(towers))for(i=[0:len(towers)-1]){
            if(!is_undef(towers[i].z ))translate([towers[i].x,towers[i].y+5,1])text(str(i));
            polygon(vertex);
            }
         }
      if(!is_undef(towers)) for(i=[0:len(towers)-1]){
            translate([towers[i].x,towers[i].y,0]){
               if(!is_undef(towers[i].z))circle(r= towers[i].z > 0? towers[i].z:_tower_min_radius);
            } 
      }
   }
}

/**
@fn get_cut2_shape(arr2, cut)
utility: cuts the bottom of an array2 shape, see @htmlonly <a href='#vertexbox'>polygonal rules</a> @endhtmlonly.
*/
  function get_cut2_shape(arr2, cut)=([for(i=[0:len(arr2)-1])[arr2[i].x, arr2[i].y>cut?arr2[i].y:cut]]); 
 

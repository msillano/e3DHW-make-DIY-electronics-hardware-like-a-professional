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
  @file e3DHW_DIN_rail_lib.1.3.scad
   Here some supports that clips onto standard DIN rail (EN 50022, BS 5584, DIN 46277-3, TS35).
   We have here <i>four basic clip designs:</i>
   \li <i> No spring</i> (NS): Very simple, for no load, use it only for small separators.
   \li <i> Spring</i> (SP): The plastic spring is equipped with a guard, to reduce the risk of breakage, and is prolonged, allowing the use of a screwdriver to open it.\n
   <i>note to avoid damaging the plastic springs the fixed side must be positioned up and the spring down.</i>
   \li <i> Screw</i> (SC): Strong fix, it is better to use bolts with hex socket, becouse in small spaces it is easier to use an allen key than a screwdriver. A 3x9 washer distributes the pression.
   \li <i> Metallic spring</i> (MS): Used only in dinRailExtraMSpring(), this design allows very flat (only 2 mm) but large (min 26 mm) DIN clips.

<hr>
   In total <b>7 parametric DIN clips</b> are defined in this library. They can meet different needs:\n
     <i>thee are standalone things</i> ready to use, fixing a loan like PCBs with screws. The size \c d is the holes distance. \n
   @image html dinPCB.jpg
     <i>four are bulding blocks</i> with a flat top, to be used in larger projects. For that clips  \c d is the total clip size.\n
  
    From the weakest to the strongest:
    \li \c dinRailSmallNoSpring(): \b NSS - min 1x45, very low profile, a block for custom designs.
    \li \c dinRailBasicScrew(): \b SCB - min: 9x30, asymmetrical, smallest generical support for PCB: fix it with thread-forming screws.
     \li \c dinRailCenterSpring(): \b SPC - min 8x48, symmetrical, ready for PCB: fix it with M3 bolts.
     \li \c dinRailCenterScrew(): \b SCC - min: 9x48, symmetrical, ready for PCB: fix it with M3 bolts.
     \li \c dinRailFlatSpring(): \b SPF - min 4x55, flat surface for custom designs.
     \li \c dinRailFlatScrew(): \b SCF - min 9x50, flat surface for custom designs.
     \li \c dinRailExtraMSpring(): \b MSX - min 26x70, big with a very low profile, for boxes and custom designs. Requires a metallic spring.
 \image html DINclips.jpg
     
@note  The Screw clips are sturdier than Spring clips. But the Screw clips are less easy to fix when a cable duct is 5 cm from the rail. For that sometimes rails are popoled off the cabinet, or you can not tighten the screw after clicking. A god use of screw clips is as fixing terminals.

@htmlonly <a name='clipuse' ></a> @endhtmlonly
@par library use
      Really all clips are totally compatibles, so in your project you can change the clip without to cange te code.
     \li The main module is do_DINClip(clip, h,d), that build any clip. Parameters are the clip code (\c clip) like "SPF" or "MSX", the clip height (\c h) and the clip size (\c d).
    \li All mechanical data about clips are in the table _DINCLIPS (private ) with public getter functions. The clip code is required as parameter. See get_clipCount() and following functions.\n
   \li This code aligns all clips so you can try at runtime any clip:
 @code
 my_DINthing(use_clip = xauto, length, width, <more params>..) {
    clip = get_Clip(use_clip, length, ["SPF","MSX"]);  // defauts: SPF (4<= length < 26) and MSX( length >= 26)
    translate([get_ClipTrnsX(clip, width), 0, 0]) do_DINClip(clip, length, get_ClipWidth(clip, width));
   // the clip top is the line (0,0) to (width, 0).
 ..<here more code>... 
 }
 @endcode

   \li The DIN clips are created in the fourth quadrant, the clip top is on the x axis.
   \li To place the DIN rail top on x axis you can do: <tt> translate([0,get_rail2top(clip),0]) </tt>.
   \li To center the DIN rail on y axis you can do: <tt> translate( [-width/2,0,0]) </tt>.
   \li The structure of this library allows clips interchangeability and the addition of news clips to collection.
 @htmlonly <a name='clipusenote' ></a> @endhtmlonly
@note Of course the 7 clips are different, about clip force and minimal dimensions: every application will have the best clip. Beacuse the clips are full compatible, you can try more clips then chose without changing the desing ( see examples). \n For small separators it is best \c NSS (\c h min = 1), for strong terminal it is required a screw clip (\c h min = 9), while for DIN boxes it is better a very flat clip like \c MSX (\c h min 26). \n
   If i need a small box, I can't use \c MSX. The best alternative is to use a \c SPF clip from 4 mm to 26 mm, but with loss of vertical space (from 2 mm to 19.5 mm: I miss 17.5 mm in vertical).\n
   In this library, the function get_Clip() will implement this strategy: having as default a couple like ["SPF","MSX"] the function returns MSX if h >= 26, otherwise returns SPF. So the code for boxes will works from small boxes to bigger ones, giving whenever the best solution.
 
@par extra
  \li Screw-clips requires: a screw M3x12 (better hex socket head)+ nut + washer mm 3.2x9 (large)
  \li Basic-clips requires: 2 thread-forming screws to fix PCB.
  \li Center-clips requires: 2 x M3x15 + nuts +nylon washers to fix PCB. 
  \li XStrong-clip requires: a spring in steel wire

@note For user convenice avery clip has a signature with model and size.

@par dependences
  This library requires:
      \li \c MCAD/polyholes.scad
      \li \c e3DHW_hardware_data.1.3.scad
      \li \c e3DHW_array_lib.1.3.scad
      \li \c contrib\dinprofile.dxf
      
  To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_DIN_rail_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_array_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt> \n
      <i> but don't allow duplicate include.</i>
 
@see  Thanks to maker dseelbach80 for inspiration: 
        https://www.thingiverse.com/thing:2162938 
@see Thanks to maker cgapeart for dinprofile.dxf file:
        https://www.thingiverse.com/thing:293558 

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2   29/07/2019 bugs corrections,
                    big rewrite, access modules do_xx(), get_xx()
                    better use: parameters check and standization.
                    Doxygen comments
 @copyright GNU Lesser General Public License.
 
 @example  e3DHW_DIN_rail_examples.scad
*/

//! @privatesection
include <MCAD/polyholes.scad>

// All mechanical infos about DIN clips are stored here.
// All are implementation dependents, and may vary in future.
// note  center of the DIN rail top (xc, yc):
//  xc =(d* get_xm("xxx") + get_xq("xxx") + get_exd("xxx")/2)
//  yc = - get_rail2top("xxx")
//  note  in SCB, SPC, SCC 'd' is holes distance. Real top misure is (d + get_exd("xxx"))
_DINCLIPS =[
// code |           human| min h| min d| rail2top|   xm|    xq| extra_d
  ["SCB",    "BasicScrew",     9,    30,     13.5,    0,  10.0,    6.0],
  ["SPC",  "CenterSpring",     8,    48,     24.5,  0.5,     0,    8.0],
  ["SCC",   "CenterScrew",     9,    50,     24.5,  0.5,     0,    8.0],
  ["SPF",    "FlatSpring",     4,    55,     19.5,  0.5,     0,      0],
  ["SCF",     "FlatScrew",     9,    50,     19.5,  0.5,     0,      0],
  ["NSS", "SmallNoSpring",     1,    45,      2.0,  0.5,     0,      0],
  ["MSX",  "ExtraMSpring",    26,    70,      2.0,  0.5,     0,      0]
  ];

//! @publicsection

OPTION_RAIL = 80;  ///< if OPTION_RAIL > 0, the DIN rail trace is added.

/**
@fn do_DINClip(clip, h, d, x=0, y=0, rot = [0,0,0])
 main module, does a DIN rail clip given code and sizes.
 As default the top left point of the clip is in (0,0).
 @param clip the clip code, one of <tt>["SCB","SPC","SCC","SPF","SCF","NSS","MSX"]</tt>
 @param h vertical size
 @param d for "SCB","SPC","SCC" it is the PCB mount holes distance, else is total size. See get_ClipWidth().
*/
module do_DINClip(clip, h, d, x=0, y=0, rot = [0,0,0]){
 translate([x,y,0])rotate(rot)union(){
 if (clip == "SCB") dinRailBasicScrew(h,d); else 
 if (clip == "SPC") dinRailCenterSpring(h,d); else
 if (clip == "SCC") dinRailCenterScrew(h,d); else
 if (clip == "SPF") dinRailFlatSpring(h,d); else
 if (clip == "SCF") dinRailFlatScrew(h,d); else
 if (clip == "NSS") dinRailSmallNoSpring(h,d); else
 if (clip == "MSX") dinRailExtraMSpring(h,d); else
    assert(false, str("the DIN clip code '", clip, "' is not valid")); 
 if (OPTION_RAIL > 0) %translate([ d* get_xm(clip) + get_xq(clip) +get_exd(clip)/2 + DINSL/2, -get_rail2top(clip),0])rotate([0,0,180])linear_extrude(OPTION_RAIL)import("contrib/dinprofile.dxf");
  }
}
 
 
/**
 @fn get_ClipWidth(clip, width)
utility: gets the parameted \c d to be used in get_Clip() to have the required \c width top.
@note: the use of this function and get_ClipTrnsX() makes all clips interchangeables.
@param clip the actual clip key
@param width total external large
@returns the correct value required by get_Clip() for any clip.\n
 */
function get_ClipWidth(clip, width) =  (get_xq(clip) == 0?width - get_exd(clip):
       (get_xq(clip)+ width/2 - get_exd(clip)/2));   // works with all clips

/**
 @fn  get_ClipTrnsX(clip, width)
 utility: returns the x value for a \c translate() required to position the clip top. Works with get_ClipWidth() also for asymmetrical clips.
 @note: the use of this function and get_ClipWidth() makes all clips interchangeables.
 @param clip the actual clip key
 @param width total external.
 */
function get_ClipTrnsX(clip, width) =  (get_xq(clip) == 0?0:width/2 - get_xq(clip) - get_exd(clip)/2);    // work with all clips

/**
 @fn get_Clip(uclip, length, default)
 utility: implements the strategy for DIN clip selection.
 Any clip as a minimal length required, and a distance from DIN rail.\n
 This functions choses based on \c length, with preference to second clip. The goal is to maximize the vertical space. See @htmlonly <a html='#clipusenote' >note on clips use</a>. @endhtmlonly \n 
   For the clips in a couple MUST be true: <tt>get_min_h(clip[1])>=get_min_h(clip[0])</tt>, so \c clip[0] is used when it is not possible to use \c clip[1]\n
 @param uclip @parblock the required clip:\n
    1 - a single code like <tt>"SCB"</tt>: forces the clip used.\n
    2 - a couple of codes like <tt>["SCF","MSX"]</tt>.\n
    3 - \c xauto: it uses the \c default couple. @endparblock 
 @param length vertical size of required clip, used to choose the clip in a couple.
 @param default a couple like: <tt>["SPF","SCF"]</tt> or <tt>["NSS","NSS"]</tt>
*/
function get_Clip(uclip, length, default) = (is_list(uclip)? (assert(get_min_h(uclip[1])>=get_min_h(uclip[0]), str("bad clips selection on parameter: check minimum h")) length < get_min_h(uclip[1])?uclip[0]:uclip[1]):is_string(uclip)? uclip:(length <get_min_h(default[1])?default[0]:default[1])); 

/**
@fn get_H(hm)
Utility: returns the H value [mm] for normalized DIN modules.
@note:all industrial DIN modules have some clearance: from that the exigence of filling separators.
@param hm  half-modules count: getH(2) = 1 module = 17.5 mm  (+ 0.5 clearance).
*/
function get_H(hm)= (hm*9)-0.5;

/**
 @fn dinRailBasicScrew(h, d)
 code \b SCB: a stong asymmetrical clip, using screw M3 fixing design.
 The smallest screw DIN clip, only 36 mm top, only 13,5 mm rail to top. You can use it with a PCB, or other flat things, e.g. a box, tied with self-tapping screws./n
   Used as symmetrical and interchangeable clip, min width is 45 mm.
   
 @param h = size (min 9 mm for washer size)
 @param d = PCB mount holes distance (min 30 mm)
 */
module dinRailBasicScrew(h, d) {
   assert ( d >= get_min_d("SCB"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("SCB"),".")); 
   assert ( h >= get_min_h("SCB"), str("parameter (h) too small (",h,") Required min. ",get_min_h("SCB"),".")); 
   translate([d+get_exd("SCB")/2,0,0])rotate([0,0,-90])translate([2,-d+33.5,0])
   difference(){
      _din_screw(h, d,"B",d);
      translate([-3,d-33.5, + h/2])rotate([0,90,0])cylinder(d = _park_dia, h=15);
      translate([-3,-33.5, + h/2])rotate([0,90,0])cylinder(d = _park_dia, h=15);
      }
   }

/**
 @fn dinRailCenterSpring(h, d)
 code \b SPC: clip symmetrical with printed spring.
 It uses M3 bolts to fix PCB or other flat things, e.g. a box.
 @param h = size (min 8 mm)
 @param d = PCB mount holes distance (min 48 mm)
 */
module dinRailCenterSpring(h, d){
   assert ( d >= get_min_d("SPC"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("SPC"),".")); 
   assert ( h >= get_min_h("SPC"), str("parameter (h) too small (",h,") Required min. ",get_min_h("SPC"),".")); 
   _y = (d-40)/2;  // d+get_exd("SPC")
   translate([d+get_exd("SPC"),0,0])rotate([0,0,-90])translate([13,-d/2+20,0]) union(){
            _din_spring(h, 30, _y,"C",d);
            translate([0,-1.5,0])_top_center(h,d, nose=2);
            }
 }

/**
 @fn dinRailCenterScrew(h, d)
 code \b SCC: like dinRailCenterSpring(), eavy version with screw.
 @param h = size (min 9 mm for washer size)
 @param d = PCB mount holes distance (min 50 mm)
 */
module dinRailCenterScrew(h, d) {
    assert ( d >= get_min_d("SCC"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("SCC"),".")); 
   assert ( h >= get_min_h("SCC"), str("parameter (h) too small (",h,") Required min. ",get_min_h("SCC"),".")); 
   translate([d+get_exd("SCC"),0,0])rotate([0,0,-90])translate([13,-d/2+19.5,0])union(){
          _din_screw(h, 30,"C",d); 
          translate([0,-1,0])_top_center(h,d);
      }
}

/**
 @fn dinRailFlatSpring(h, d)
 code \b SPF: clip with printed spring, flat top, symmetrical.
 Without holes, it is a building block for custom designs. Good top to rail distance: 19.5
 @param h = size (min 4 mm)
 @param d = TOP size (min 55 mm)
 */
module dinRailFlatSpring(h, d){
   assert ( d >= get_min_d("SPF"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("SPF"),".")); 
   assert ( h >= get_min_h("SPF"), str("parameter (h) too small (",h,") Required min. ",get_min_h("SPF"),".")); 
   _y = (d-48)/2;
    translate([d+get_exd("SPF"),0,0])rotate([0,0,-90])translate([8,-(d-11-37)/2,0]) union(){
              _din_spring(h, 30, _y,"F",d);
              translate([0,-1.5,0])_top_center(h,d-8,0, 1);
              }
 }

/**
 @fn dinRailFlatScrew(h, d)
 code \b SCF: clip like dinRailFlatSpring(), but eavy version with screw.
 @param h = size (min 9 mm)
 @param d = TOP size (min 50 mm, no holes)
 */
module dinRailFlatScrew(h, d) {
   assert ( d >= get_min_d("SCF"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("SCF"),".")); 
   assert ( h >= get_min_h("SCF"), str("parameter (h) too small (",h,") Required min. ",get_min_h("SCF"),".")); 
   translate([d+get_exd("SCF"),0,0])rotate([0,0,-90])translate([8,-(d-10-37)/2,0])union(){
              _din_screw(h, 30,"F",d);
              translate([0,-1,0])_top_center(h,d-8,0);
             } 
}

/**
 @fn dinRailSmallNoSpring(h, d)
 code \b NSS: minimal clip, without spring.
 Building block for custom separators, not for loan.
 @param h = size (any)
 @param d = long (min 45 mm, no holes)
 */
module dinRailSmallNoSpring(h,d){
   assert ( d >= get_min_d("NSS"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("NSS"),".")); 
   assert ( h >= get_min_h("NSS"), str("parameter (h) too small (",h,") Required min. ",get_min_h("NSS"),".")); 
  _l1 = (d-45)/2; // left space
  _l2 = _l1+40.5;   // start rigth hook, , 40.5: default, 40.0: stronger grip
  _h1= 5;  // hook 
  _l3 = (_l1 > 3)? 3:_l1;
 _DinSmall = [[0,0],[0,2],[_l1-_l3,2],
    [_l1+3.5-_l3,_h1],[_l1+3.5+3.3,_h1],[_l1++3.5+3.4,_h1-0.5],[_l1+3,2],
    [_l2,2],[_l2,2+1],[_l2-0.8,2+1+0.8],[_l2-0.8,2+1+1.4],[_l2-0.8+0.5,_h1],[_l2+3+_l3,_h1],[_l2+4.5+_l3,2],
    [d,2],[d,0]];
  translate([d+get_exd("NSS"),0,0])rotate([0,0,180])linear_extrude(h)polygon(_DinSmall); 
}

/**
 @fn dinRailExtraMSpring(h, d)
 code: \b MSX: big and strong clip with metallic spring.
 Minimal size 36x70. Very low top to rail value: only 2 mm.
 Without holes, building block for custom designs: because the flat profile useful for boxes.
 @param h = size (min 26 mm)
 @param d = TOP size (min 70 mm, no holes)
  <i>note The required metallic springs can be built using harmonic steel wire (0.6-1 mm). I use paper clips in soft steel wire (mm 0.9), easy to bend with pliers. The simplest form is circular: one or two turns of the indicated measures (mm 20x22), but you can indulge yourself using imaginative forms.</i>
  \image html spring.jpg
 */
module dinRailExtraMSpring(h,d){
   assert ( d >= get_min_d("MSX"), str("parameter (d) too small (",d,"). Required min. ",get_min_d("MSX"),".")); 
   assert ( h >= get_min_h("MSX"), str("parameter (h) too small (",h,") Required min. ",get_min_h("MSX"),".")); 
   _splarge= 22;  // metal spring, z limit: splarge + 4 (26 mm)
   _splong=18;    // metal spring: + mm 2-4 (22x20 - 22x22)
   //
   _ycenter = d/2;
   _l1 = _ycenter - 17.5-6; // start fix block
   _l2 = _l1+44;            // start spring block
   _l3 = _l2+14.5;          // end spring block
   
   _DinStong = [[0,0],[0,3],[_l1,3], [_l1+3.5,6],[_l1+3.5+4.3,6],[_l1+3.5+4.3,5.5],[_l1+3.5+4.5,5.2],[_l1+5,2],[_l2,2],[_l2,6],[_l3-2,6],[_l3,3],[d,3],[d,0]];
    translate([d+get_exd("MSX"),0,0])rotate([0,0,180])difference(){
       linear_extrude(h) polygon(_DinStong);
       translate([_l2+3,7,h/2]) rotate([90,0,0])polyhole(4,3);
       translate([_l2-1,2.5,h/2-_splarge/2]) cube([13,2,_splarge]);
       }
}


//! @privatesection
// =============== private modules

// writes the signature
module _do_signc(tx){
   translate([0,-18,-0.05])rotate([0,0,90])    
   resize(newsize=[32,4.5,_text_add_relief+0.05])   linear_extrude(height=2) text(, font = _TEXTFONT, text= str(tx), halign ="center");
} 

// nut receptacle
module _din_screw(h,d,t,y) {
    _DinRailMountScrew = [
[-2,-(d-30)],[-2,6-(d-30)], [5,9-(d-30)],[5,27],[-2,30],[-2,36],[0.5,36],[0.5,41],[1.5,42], [11.5,44],[15.5,44],
[15.25,41], [13.5,40], [13,40], [12.75,42],
[2,40], [1.75,39.75], [1.75,35.5], [2,35.25],[2.25,35.25],[2.50,35.50],[3.50,39.25], [11.5,39.25],
[11.5,33], [10,32], [10,9], [11.5,8], [11.5,4.75],
[12.75,4.75], [13.25,6.5], [13.75,6.5], [15.5,5.5],
[15.5,2], [15,1], [13,0],[8,-(d-30)]];

difference(){
    union(){
      translate([0,-0.5,h-_text_add_relief]) rotate([180,0,0]) linear_extrude(height=h-_text_add_relief) polygon(_DinRailMountScrew);
      translate([9.9,0,h-_text_add_relief-0.1])_do_signc(str("SC",t,h,"x",y));
    }
    translate([7,-10,h/2]) rotate([90,0,0])polyhole(36,_M3_dia);  // 3MA 
    translate([7,-39,h/2]) rotate([90,0,-5])polyhole(16,_M3_dia);  
    translate([7+3,-37.5,h/2-3.4]) rotate([0,0,90])cube(size=[_M3_nut_h+0.8, _M3_headd+0.4,h+2]);
    }
}

// spring definition
module _din_spring(h, d, dist,t,y){
_DinRailMountSpring = [
[0,-(d-30)],[0,6-(d-30)], [5,9-(d-30)],[5,27],[0,30],[0,36],[0.1,36],[0.1,41.5],     
// alternative: the action hook
[12,41.5],[13,42],[13,dist+43+4], [10,dist+43+4], [10,dist+45+4], [15.5,dist+46+4],
// alternative: no action hook
 // [10,41.5],[13,42],[15.5,42],   
[15.25,39], [13.5,38], [13,38], [12.75,40],
[2,40], [2,39.75], [2,36.75],[2.25,36.25], [11.5,39.25],
[11.5,35], [10,34], [10,9], [11.5,8], [11.5,4.75],
[12.75,4.75], [13.25,6.5], [13.75,6.5], [15.5,5.5],
[15.5,2], [15,1], [13,0],[8,-(d-30)]];

     union(){
        translate([0,-1,h-_text_add_relief]) rotate([180,0,0]) linear_extrude(height=h-_text_add_relief){
        polygon(_DinRailMountSpring); };
     translate([9.9,0,h-_text_add_relief-0.1])_do_signc(str("SP",t,h,"x",y));
    }
}

// upper clip part
module _top_center(h, d, z=5, nose = 0){
 _L= d + 8;
 _DinRailTop = [[-4,_L/2 -36/2-4.5],[0.01,0],[0.01, - 39.5],[-1, - 39.5],[-4,-_L/2- 36/2-4.5 ],[-8-z, -_L/2- 36/2 -4.5],[-8-z, -_L/2- 36/2+8-4.5],[-8, -_L/2- 36/2+11 -4.5],[-8, _L/2- 36/2 -11-4.5],[-8-z, _L/2- 36/2 -8-4.5],[-8-z, _L/2- 36/2-4.5]];
  _Safe =[[-7.6,-43],[-7.6,-50.5],[28, -46]];
  $fn=32;
difference(){
   union(){
      linear_extrude(height=h){ polygon(_DinRailTop); };
      if (nose >0) linear_extrude(height = h-1)offset(r=2) offset(delta=-2) polygon(_Safe);    
   }
      if (z>0) {
          translate([-14,_L/2-4-36/2-4.5,h/2]) rotate([90,0,90])polyhole(14,_M3_dia);
          translate([-5.5,_L/2-4-36/2-4.5,h/2]) rotate([90,0,90])cylinder(h=15,r=(_M3_nut_Wc+0.2)/2,$fn=6);
          }
          
      if (z>0) {
         if (nose==2 && d< 60){
           translate([-14,4-_L/2-36/2-4.5,h/2]) rotate([90,0,90])polyhole(20,_M3_dia);
           translate([-5.5,4-_L/2-36/2-4.5,h/2])cube(size=[_M3_nut_h+0.8,10, _M3_headd+0.4], center=true);
         } else {
           translate([-14,4-_L/2-36/2-4.5,h/2]) rotate([90,0,90])polyhole(14,_M3_dia);
           translate([-5.5,4-_L/2-36/2-4.5,h/2]) rotate([90,0,90])cylinder(h=15,r=(_M3_nut_Wc+0.2)/2,$fn=6);
	      }
       }
    }
 }
 

//! @publicsection
 // DIN  rail std
DINSL = 35;   ///< constant standard DIN rail size.

//public getter functions for _DINCLIPS DBase, uses e3DHW_array_lib.1.3
function get_clipCount() = ( len(_DINCLIPS)); ///< For clips: returns the number of clips availables

function get_name(clip) =     (valueGetter(clip, 1,_DINCLIPS));  ///< returns the name of the DIN clip

function get_min_h(clip) =    (valueGetter(clip, 2,_DINCLIPS));  ///< returns the min. height

function get_min_d(clip) =    (valueGetter(clip, 3,_DINCLIPS));  ///< returns the min. width

function get_rail2top(clip) = (valueGetter(clip, 4,_DINCLIPS));  ///< returns distance rail/top, y axis

function get_xm(clip) =       (valueGetter(clip, 5,_DINCLIPS));  ///< returns m in equation xc = m*d + q

function get_xq(clip) =       (valueGetter(clip, 6,_DINCLIPS));  ///< returns q in equation xc = m*d + q, used by get_ClipTrnsX().

function get_exd(clip) =      (valueGetter(clip, 7,_DINCLIPS));  ///< returns extra value (when d is screws distance), used by get_ClipWidth().


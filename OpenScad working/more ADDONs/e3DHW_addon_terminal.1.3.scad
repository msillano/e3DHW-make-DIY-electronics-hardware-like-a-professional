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
 @file e3DHW_addon_terminal.1.3.scad
 Custom connectors strip, using mammut or screw.
 
This terminals are well situed for AC applications. They are classified in parametric series:
@par MAMMUT series
  All mammut series uses the metallic core from cheap commercial mammut terminal strips, from 3A to 60A and more. This connector can be used with pin wire terminals.\n
  The unique required design paramaters are N (number) and the current. The correct core mammut is selected on MAMMUT array and the connector is ready.
\li <b>serie cubeMammut-HT(\c add1_cubeMammut(type = HT)) </b> \n
\image html cubemammutHT.jpg
 This is a very thinny terminal strip, to be used where you have space constraints or as build block in more complex connectors, because is also very flexible. Half connector is protected and half mammut is naked.
\li <b>serie cubeMammut-FT(\c add1_cubeMammut(type = FT)) </b> \n
\image html cubemammutFT.jpg
 Like cubeMammut-HT, now the connector is full protected. 
\li <b>serie simpleMammut-HT (<tt>add1_simpleMammut(type = HT)</tt>) </b> \n
\image html simpleHT.jpg
This serie (Half Type) is for box connections: the front, with plaqce for Dymo label, is out of the box and half mammut is naked inside the box.
\li <b>serie simpleMammut-FT (<tt>add1_simpleMammut(type = FT)</tt>) </b> \n
\image html simpleFT.jpg
This serie (Full Type) is for boards: the front is for external wires, and the connector is protected. 
\li <b>serie simpleMammut-DT (<tt>add1_simpleMammut(type = DT)</tt>) </b> \n
\image html simpleDT.jpg
This serie (Double Type) is more like the original mammut strip: the front is in both side of the connector. \n To be use standalone, on DIN rails, etc.
@par Screw Terminals serie
      simple connetor strip with screws, can be used with ring and spade wire terminals.
\li <b>serie terminal-M3 (<tt>add1_terminalM3Block()</tt>) </b> \n
\image html terminal3M.jpg
   Well situed for internal small terminal strip on boards. Dimension of a strip with N elements x: 10 *N + 3, y: 12 [mm].

@note  The mammut data are in file e3DHW_mammut_data.1.3.scad. Keep it updated with correct measurements of mammuts you use.

@par dependences
  This library requires:
      \li \c e3DHW_base_lib.1.3.scad
      \li \c e3DHW_hardware_data.1.3.scad
      \li \c e3DHW_addon_base.1.3.scad
      \li \c e3DHW_array_utils.1.3.scad
      \li \c e3DHW_mammut_data.1.3.scad
      
  To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_addon_base.1.3.scad> </tt>
      \li  <tt> include <e3DHW_array_utils.1.3.scad> </tt>
      \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt>
      \li  <tt> include <e3DHW_addon_terminal.1.3.scad> </tt>
      \li <i>but don't allow duplicate include.</i>
 
 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2   29/07/2019 bugs corrections,
                    better use: parameters check and standization, 
                    Doxygen comments
 @version 0.1.3      
 @copyright GNU Lesser General Public License.
 @example e3DHW_addon_terminal_examples.scad
*/
//! @privatesection
include <e3DHW_mammut_data.1.3.scad>

//! @publicsection
// constants used for type - don't change it
HT =  0;   ///< half size type: puts 1/2 naked mammut inside a box.
FT =  1;   ///< full size type: one front, for board
DT =  2;   ///< double front: standalone, for DIN rail...

/**
   @fn add_simpleMammut( n=undef, mmq=1, len=1, type = FT, x= 0, y=0, rot =norot)
   Mammut strip for external connections.
   Connector with 3 flawors: 
      \li HT - half type serie
      \li FT - full type serie
      \li DT - double type serie.

   Accepts Dymo tape (mm 9) as labels.
   @note requires interior of commercial mammut strips.
   @param n: number of connectors in strip, required
   @param mmq: max cable section in mmq.
   @param len: total height (on z axis, the connector is built in vertical)/n
   If len is less than the minimum, len is adjusted to minimum (without warning). If larger, connector is centered.
   @param type:  \c FT (default) or \c HT or \c DT
*/
module add_simpleMammut( n=undef, mmq=1, len=1, type = FT, x= 0, y=0, rot =norot){
   assert (!is_undef(n), " the parameter n is required");
   assert (n > 0, " number of elements (n) must be positive");
   assert (mmq> 0, " required wire section (mmq) must be a positive number");
   _idx = _get_MIdx(mmq);
   _min = _getMzStep(_idx)*n;
   _uselen = max(len,_min);
   assert ((type == FT) ||(type == HT)||(type == DT), " type must be HT or FT or DT.");
//     builds required parametric profiles:
   _HTpoly=[[0,_getMxT(_idx)-5],[_getMyTot(_idx)+3,_getMxT(_idx)-5],
      [_getMyTot(_idx)+3,_getMxT(_idx)+_getDScr(_idx)+0.5],[_getMbD(_idx)+3.8,_getMxT(_idx)+_getDScr(_idx)+10],
      [0,_getMxT(_idx)+_getDScr(_idx)+10]];
 
   _FTpoly=[[0,0],[_getMyTot(_idx)+3,0],
      [_getMyTot(_idx)+3,_getMxT(_idx)+_getDScr(_idx)+0.5],[_getMbD(_idx)+3.8,_getMxT(_idx)+_getDScr(_idx)+10],
      [0,_getMxT(_idx)+_getDScr(_idx)+10]];

   _xoffset= ((type == HT)? _getMxT(_idx)/2+_getDScr(_idx)-1.99:
         (type == FT)? 0 : _getMxT(_idx)/2-17) + get_simpleMammutSize( mmq, type) ;  // to align on y axis
// now builds connectors
   translate([x, y, 0])rotate(rot)translate([_xoffset,0,0])rotate([0,0,90]){
      if (type == DT){
         union(){
            _do_simpleMammut(_uselen, n, _idx, _FTpoly);
            translate([0,2*_getMxT(_idx)-10,_uselen])rotate([180,0,0])_do_simpleMammut(_uselen, n, _idx,_FTpoly);
            }        
         }
      else
         _do_simpleMammut(_uselen, n, _idx, mpoly=(type == FT)? _FTpoly:_HTpoly);
   }
}

/**
@fn get_simpleMammutSize( mmq=1, type = FT)
gets the real x dimension of a simpleMammut.
   @param mmq: max cable section in mmq.
   @param type:  FT (default) or HT or DT
**/
function get_simpleMammutSize( mmq=1, type = FT)=
( let(_idx = _get_MIdx(mmq)) (type == HT)? _getMxT(_idx)+_getDScr(_idx)+10 -(_getMxT(_idx)-5) :
      (type == FT)? _getMxT(_idx)+_getDScr(_idx)+10 :(_getMxT(_idx)+_getDScr(_idx)+10) *2 - (2*_getMxT(_idx)-10));  // formulas directly from poly def

/**
@fn get_simpleMammutStep( mmq=1)
gets the standard z step for simpleMammut.
   @param mmq: max cable section in mmq.
 **/
function get_simpleMammutStep( mmq=1)=
(_getMzStep(_get_MIdx(mmq)));

/** 
   @fn carve_simpleMammut (n, mmq=1, len=1, type = FT, x= 0, y=0, rot =norot)
   companion carve module for add1_simpleMammut(). Optional, use it to re-carve
  */
module carve_simpleMammut (n, mmq=1, len=1, type = FT, x= 0, y=0, rot =norot){
   _min = _getMzStep(_get_MIdx(mmq))*n; 
   _idx = _get_MIdx(mmq);
   translate([x, y, 0])rotate(rot)rotate([0,0,90])translate([0,- _getMxT(_idx)-_getDScr(_idx)-10, 0]) _do_carving(max(len,_min), n, _idx, type);
   }

/**
  @fn add_cubeMammut(n=undef, mmq=1, len=0, type = FT, step= undef, space = undef, exBar = 1, exScr=0,rot =norot )
   Thinny mammut strip for internal connections.
   Connector with 2 flawors: 
      \li HT - half type serie
      \li FT - full type serie

  This connector is simple and very adaptable. That make it a good start point for custom more complex connectors.
  @param  n: number of connectors required on strip.
  @param  mmq: cable section in mmq.
  @param  len: total height (z). If too small, it is adjusted to minimum. If larger, connectors are centered.
  @param  type:  FT (default) or HT
  @param  step: required distance between connectors.
  @param  space: minimum space between connectors, clerance. If defined, step is updated.
        note: step and space can conflict. Rules
           \li _getMzStep(idx) is the default interaxis distance.
           \li if \c space is defined, interaxis distance becomes <tt>space + _getMbD(idx)</tt> (barrel diameter).
           \li if \c step is defined, and \c space is \c undef, \c step becomes interaxis distance ( it must be greater than <tt>_getMbD(idx)</tt> (barrel diameter).

  @param  exBar: extra space on x axis (barrel), 
  @param  exScr: extra space on y axis (screws).
*/
module add_cubeMammut(n=undef, mmq=1, len=0, type = FT, step= undef, space = undef, exBar = 2, exScr=0, x= 0, y=0, rot =norot ){
   assert (!is_undef(n), "the parameter n is required");
   assert (n > 0, " number of elements (n) must be positive");
   assert (mmq> 0, "required wire section (mmq) must be a positive number");
   _idx = _get_MIdx(mmq);
   assert ((_idx >= 0) && (_idx < len(MAMMUT)), str(" required mammut not found in MAMMUT list.</font>"));
   assert ((type == FT) ||(type == HT), " parameter type must be FT or HT");
   assert (is_undef(step) ||(step > 0), " parameter step must be positive");
   assert (is_undef(space) ||(space > 0), " parameter space must be positive");
   if (!is_undef(step))assert(step >_getMbD(_idx),str(" parameter step (", step, ") less than mammut diameter ",_getMbD(_idx) ," mm</font>") );
 //
 // apply rules to get the vector of the current parameters:[0] used 'space', [1] used 'step', [2] used 'len'  
   p = _get_cubeParams(n, _idx, len, step, space);
 // now builds connectors
   _x_Fcube = _getMyTot(_idx)+p[0]+exScr;
   _y_Fcube = _getMxT(_idx)+2*exBar;
   _z_Fcube = p[2];
   difference(){
      translate([x,y,0])rotate(rot)rotate([0,0,90]){
         if (type == FT)cube([_x_Fcube,_y_Fcube,_z_Fcube]);
         if (type == HT)cube([_x_Fcube,_y_Fcube/2+1,_z_Fcube]);
         }   
      carve_cubeMammut(n=(n), mmq=(mmq), len=(len), type = (type), step=(step), space = (space), exBar = (exBar), exScr= (exScr), x= (x), y=(y), rot =(rot));
      } 
   }
 
/**
@fn get_cubeMammutSize( mmq=1, type = FT,  exBar = 1)
gets the real x dimension of a cubeMammut.
  @param  mmq: cable section in mmq.
  @param  type:  FT (default) or HT
  @param  exBar: extra space on x axis (barrel), 
*/
function get_cubeMammutSize( mmq=1, type = FT, exBar = 2)=(
let(_idx = _get_MIdx(mmq), _y_Fcube = _getMxT(_idx)+2*exBar) 
(type == FT)?_y_Fcube:_y_Fcube/2+1);

/**
@fn get_cubeMammutStep(n=undef, mmq=1, len=0, step= undef, space = undef)
gets the actual z step for cubeMammut.
   @param  n: number of connectors required on strip.
   @param  mmq: cable section in mmq.
   @param  len: total height (z). If too small, it is adjusted to minimum. If larger, connectors are centered.
   @param  step: required distance between connectors.
   @param  space: minimum space between connectors, clerance. If defined, step is updated.
**/
function get_cubeMammutStep(n=undef, mmq=1, len=0, step= undef, space = undef)=
( _get_cubeParams(n, _get_MIdx(mmq), len, step, space)[1]);

/** 
   @fn carve_cubeMammut(n=undef, mmq=1, len=0, type = FT, step= undef, space = undef, exBar = 1, exScr=0, x= 0, y=0, rot =norot )
   companion carve module for add1_cubeMammut(). Optional, for re-carving.
  */
module carve_cubeMammut(n=undef, mmq=1, len=0, type = FT, step= undef, space = undef, exBar = 2, exScr=0, x= 0, y=0, rot =norot ){
   // like add_cubeMammut(), tests not required.
   _idx = _get_MIdx(mmq);
 // apply rules to get the vector of the current parameters:[0] used 'space', [1] used 'step', [2] used 'len'  
   p = _get_cubeParams(n, _idx, len, step, space);
  // now builds carve
   _h0 = (p[2]- p[1]*n)/2;
   _y_Fcube = _getMxT(_idx)+2*exBar;
   translate([x,y,0])rotate(rot)rotate([0,0,90]){
         {for (i=[0:(n-1)]){
           translate([p[0] +_getMbD(_idx)/2,_y_Fcube/2, _h0+i*p[1]+p[1]/2]) rotate([0,0,-90])do_nakedModel(_idx,p[0]/2+exBar+1,p[0]/2+exScr+1, half = (type == HT ));
         }
      }
   }
}

//! @privatesection
// base sizes for terminals 3MA
_termX = 10;          ///<  terminals 3MA: single block length
_termY = 12;          ///<  terminals 3MA: large
_termZ = 5;           ///<  terminals 3MA: vertical
_term_extraX = 4;     ///<  terminals 3MA: min_X_total = _termX * n + _term_extraX 

//! @publicsection
/**
@fn add1_terminalM3Block(  n= 2, len= 0, x=0, y=0, rot = norot)
Block terminal with M3 screws.
@note requires 5mm M3 screw and 7x1 washer
@param n number of elements
@param h total length. Adjusted, rules: 
    \li <tt>min_X_total = n*_termX + _term_extraX</tt>
    \li if \c len < \c min_X_total, len is adjusted to \n min_X_total (without warning)
    \li if \c len >= \c min_X_total, connectors are centered.
*/
module add1_terminalM3Block(n= undef, len= 0, x=0, y=0, rot = norot){
   assert (!is_undef(n), " the parameter n is required");
   assert (n > 0, " number of elements (n) must be positive");
   _h1 = max(len, _termX*n+_term_extraX);
   _h0 = (_h1 -_termX*n)/2;
   translate([x,y,0])rotate(rot)difference(){
      union(){
         cube([_h1,_termY,_termZ]);
         for (i=[0:1:n])
            translate([_h0 +i*_termX,_termY/2,_termZ]) _terminalBlockA(_termY);
         }
      }
   }

/**
@fn carve2_terminalM3Block(  n= 2, len= 0, x=0, y=0, rot = norot)
  companion carve module for add1_terminalBlock(), mandatory.
*/
module carve2_terminalM3Block(n= undef, len= 0, x=0, y=0, rot = norot){
_h1 = (len < _termX*n+_term_extraX)? _termX*n+_term_extraX:len;
_h0 = (_h1 -_termX*n)/2;
translate([x,y,0])rotate(rot)for (i=[0:1:n-1])
translate([_h0+_termX/2 +i*_termX,_termY/2, 0]) _terminalBlockB();
} 
// ==================== UTILITIES: to design custom connectors
/**
@fn do_nakedModel(idx, exBar=0,exScr=0)
Utility, produces a Mammut model.
This centered model is used to carve connectors. The barrel and screws can be extended.
@param idx  MAMMUT index
@param exBar Berrel extension [mm]
@param exScr Scews extension [mm]
*/
module do_nakedModel(idx, exBar=0,exScr=0, half=false){
    rotate([-90,0,0])union(){
    translate([ _getSdist(idx),0,0])polyhole(_getMyTot(idx)-_getMbD(idx)/2+exScr,_getDScr(idx));   
    if (! half)translate([-_getSdist(idx),0,0])polyhole(_getMyTot(idx)-_getMbD(idx)/2+exScr,_getDScr(idx)); 
    translate([-_getMxT(idx)/2-exBar,0,0]) rotate([90,0,90])resize([_getMbD(idx)-0.5,_getMbD(idx),_getMxT(idx)+2*exBar])polyhole(_getMxT(idx)+2*exBar, _getMbD(idx));   // resaize 0.5: barrel is oval
   }
}

/**
@fn do_filmMammut(idx, s = 1, exBar = 1,exScr=0)
   BuildsSimple a minimal schape
   This utility shape can be used in more complex designs:  the nakedModel is recouvert by a film.
@param idx  MAMMUT index
@param s film thickness
@param exBar Berrel extension [mm]
@param exScr Scews extension [mm]
*/
module do_filmMammut(idx, s = 1, exBar = 1,exScr=0){
difference(){
   minkowski() {
      do_nakedModel(idx,exBar,exScr);
      sphere(r = s, $fn=32);
      }
    do_nakedModel(idx,exBar+2,exScr+2);
   }
}


//! @privatesection
// ======================================= private local
/**
@fn _get_MIdx(mmq)
Utility: it founds the MAMMUT index from cable section (mmq).
Limited to first 5 MAMMUTS in the array, ordered by cable size, ascendent.
@param mmq  cable size.
@returns index, if not found message and abort
*/
function _get_MIdx(mmq)= (MAMMUT[0][0] >= mmq ?0:
     (len(MAMMUT) > 1 && MAMMUT[1][0] >= mmq ?1:
     (len(MAMMUT) > 2 && MAMMUT[2][0] >= mmq ?2:
     (len(MAMMUT) > 3 && MAMMUT[3][0] >= mmq ?3:
     (len(MAMMUT) > 4 && MAMMUT[4][0] >= mmq ?4:
     assert(false,str("Not found mammut for ",mmq," mmq")))))));
//--------------------------- MAMMUT getters: array access
function _getMbD(idx)   = MAMMUT[idx][2];      // barrel diameter
function _getMyTot(idx) = MAMMUT[idx][3];      // y total, with screws all off
function _getMxT(idx)   = MAMMUT[idx][4];      // x total, barrel long
function _getDScr(idx)  = MAMMUT[idx][5]+0.0;  // screws diameter + tolerance
function _getSdist(idx) = MAMMUT[idx][6]/2;    // center screws distance (half)
function _getMzStep(idx)= MAMMUT[idx][7];      // step, barrel distance

// local function used by add_simpleMammut
module _do_simpleMammut(h, n, idx, mpoly){
    difference(){
     linear_extrude(height=h)polygon(mpoly);
       _do_carving(h,n,idx);
       translate([_getMyTot(idx)+3-2.4,_getMxT(idx)+_getDScr(idx)+0.5-1,h+0.1])carve_dymoD1_9(h+0.2, 0, rot = [0, 90,-atan2(_getMbD(idx)+3.8-_getMyTot(idx)-3,+10-0.5)], z=1);
   }
}

// local function used by carve_simpleMammut
module _do_carving(h,n,idx, type=FT, exBar=14,exScr=7 ){
    h0 = (h-(n*_getMzStep(idx)))/2 + _getMzStep(idx)/2;
    translate([0,0,h0])
      union(){
      for( i =[0:1:n-1]){
          translate([_getMbD(idx)/2+2,_getMxT(idx)-5,_getMzStep(idx)*i])rotate([0,0,-90])
                do_nakedModel(idx, exBar,exScr, half=(type == HT));
        }
    }
}

      // apply rules to get actual value of cube parameters
function _get_cubeParams ( n, _idx, len, step, space) = let( _min = is_undef(space)? 
              (is_undef(step)?
                   _getMzStep(_idx)*(n+1) -_getMbD(_idx):
                   step *(n+1) -_getMbD(_idx)):
              _getMbD(_idx)*n +space*(n+1))[
    // used values, back from _min:
            (_min - _getMbD(_idx)*n)/(n+1),                 // [0] used space value
            (_min - ((_min - _getMbD(_idx)*n)/(n+1)))/n,    // [1] used step value
            max(len, _min)];                                // [2] used len value

// local function used by add_terminal
module _terminalBlockA(l){
   rotate([90,0,90])resize([l,l/2+1,2.4])union(){
   translate([0,0,-2+EXTRA])cylinder(d1=4, d2=10, h=2);
   cylinder(d1=10, d2=4, h=2);
   }
}

// terminalBlock uses screws M3 sizes in e3DHW_base_lib, see do_nuthole() code.
module _terminalBlockB(){
union(){
   do_nuthole(-1, s = _termZ);   // bottom nut
   do_nuthole(-52, s = _termZ);  // top washer 7 mm
  }
}

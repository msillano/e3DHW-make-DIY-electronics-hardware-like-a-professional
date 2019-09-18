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
@file e3DHW_addon_base.1.3.scad
 Contains genaral pourpose modules that you can add to a board. 
  \image html base_addon.jpg
 <i>see e3DHW_addon_base_examples.scad</i>\n
 @htmlonly <a name='addonuse' ></a> @endhtmlonly
 @par parametric libraries use 
  In general there are two types of ADDONs: \b add_ and \b carve_. Using OpenScad you can add some thing (e.g. spacers) inside an \c union() command or carve a thing (e.g. holes) inside a \c difference() command.\n\n
   <b>ADDONs standardization</b>
                 \li If an ADDON has both the \c add_ and the \c carve_ modules, and their use is mandatory, then the modules are numbered, to indicate the correct use sequence: usually the \c carve_ must follow the \c add_ module, but not always. Use exactly same parameters in both modules.
                 \li Any ADDON is created with upper left vertex in [0,0]. Exception: some shapes are created centered to facilitate positioning.
                 \li Any ADDON accepts  3 common positionning parameters: \c x, \c y, \c rot. This reduces the code request to use ADDONs.
                 \li Centered ADDONs can have an extra parameter, \c h, as help to center the addon, \c h must be set to the free space in x axis (or z axis, if vertical): addon will be cetered (and x is now the offset).
       
 Typical use example:
@code
module my_board(){
   difference(){
      union(){
         //<main structure>: put here the main board like:
         rectangleBase(80, 210, fill=100, x=10); // a solid base 
 // ADD ZONE
 // here addons like add_xxxx, fine tuning the position with x,y. 
 // Center it with 'h' and rotate it with [a,b,c] if required:
           add_polyBox(arduinoUnoR3Vertex, x=12, y = 40);
           add1_tower(10, x=23, y=110);
        } // union ends
 // CARVE ZONE
 // here addons like carve_xxxxx, fine tuning the position with x,y. 
 // Center it with 'h' and rotate it with [a,b,c] if required:
        carve2_tower(10, x=23, y=110);   // required by  add1_tower()
        carve_elongatedHole(6, 25, x=50, y=120);
    } // difference ends
 }
@endcode
@see all \c xxxx_examples.scad files.

@par hint 
Temporarily move a new \c carve_xxx ADDON to the ADD ZONE: so you can see it and it's easier to place the addon exactly. Once good positioned move it back in the CARVE ZONE. Or use the debug modifier (#).
 
@par dependences
    This library requires
      \li \c e3DHW_base_lib.1.3.scad
      \li \c e3DHW_array_utils.1.3.scad
      \li \c e3DHW_hardware_data.1.3.scad
      \li \c e3DHW_pcb_board_data.1.3.scad
      
 To use this library you must add the following lines to your code:
      \li  <tt> include <e3DHW_base_lib.1.3.scad> </tt>
      \li  <tt> include <e3DHW_array_utils.1.3.scad> </tt>
      \li  <tt> include <e3DHW_hardware_data.1.3.scad> </tt>\n
      \li  <tt> include <e3DHW_addon_base.1.3.scad> </tt>
     <i> but don't allow duplicate includes.</i>

@see  Thanks to  Egor Chugay for 6x6 button models:
        https://grabcad.com/library/button-6x6-hole-mount-collection-1

 @author    Marco Sillano
 @version 0.1.1    18/03/2018 base version
 @version 0.1.2   29/07/2019 Bugs correction. 
                   Added: carve_polyBox(), carve_rectangularBox().
                   Better use: parameters check and standization. 
                   Doxygen comments.
 @copyright GNU Lesser General Public License.
 @example  e3DHW_addon_base_examples.scad
*/


//! @publicsection
// -------------- public parameters 
ROUNDRADIUS = 1.5;       ///< default round corners (for ADDON, for the base board is _slabcorner)
CARVEZ = 6;              ///< height of carving shapes 
//------------   BOX
BOXTOLERANCE = 0.2;      ///< extra size for boxes (printer clearence)
BOXTHICKNESS = 1;        ///<  box vertical wall size
BOXHEIGHT    = 5;        ///<  box vertical wall height
BOXSTEPL     = 1.1;      ///<  box internal step large (to fix PCB)
BOXSTEPH     = 1;        ///<  box internal step height 

//! @privatesection
include <e3DHW_pcb_board_data.1.3.scad>

_tower_min_radius = 3;    // tower min limit (thower 6, hole 3: tower thickness = 1.5 mm)

//======================= PUBLIC MODULES: ADD COLLECTION
//! @publicsection

/** 
  @fn add_polyBox(vertex=undef, height=BOXHEIGHT, closed=false, lstep= BOXSTEPL, hstep=BOXSTEPH, x=0, y=0, rot = norot)
  Creates a box to place and fix a PCB module into a big board.
  @note  If <tt>height=BOXHEIGHT</tt> (small), the box keeps in place the PCB module (the PCB can be fixed with hot wax or screws).
  @note  If <tt>height >= 10</tt> [mm] and bottom <tt>closed = true</tt>, the box can be filled with silicon or rubber protection.
  @param vertex is an array of points: <tt>[[p1.x, p1.y],[p2.x,p2,y],...]</tt>: the PCB module definition (any form). See e3DHW_pcb_board_data.1.3.scad
  @note The shape is augmented by BOXTOLERANCE.
  @param height box border height [mm], default \c BOXHEIGHT
  @param closed if \c true the box has a closed bottom, default \c false
  @param lstep PCB blocking step large, default BOXSTEPL
  @param hstep PCB blocking step height, default BOXSTEPH
*/
module add_polyBox(vertex=undef, height=BOXHEIGHT, closed=false, lstep= BOXSTEPL, hstep=BOXSTEPH, x=0, y=0, rot = norot){
    assert(is_arrayOK(vertex, 2, 3), "test on array failed");
    assert ((height > 0) && (height <200), "box height out of bounds");
    translate([x,y,0])rotate(rot)translate([BOXTOLERANCE+BOXTHICKNESS,BOXTOLERANCE+BOXTHICKNESS,0])
    union(){
        difference(){
          linear_extrude(height = height+BOARDTHICKNESS, center = false)offset(delta=BOXTHICKNESS) _sizebox(vertex);
          translate([0,0,-EXTRA])linear_extrude(height = height+BOARDTHICKNESS+2*EXTRA, center = false)_sizebox(vertex);   
    }
    translate([0,0, 0]) difference(){
          linear_extrude(height =BOARDTHICKNESS+hstep, center = false)offset(delta= BOXTHICKNESS-EXTRA) _sizebox(vertex);
         translate([0,0,-EXTRA])linear_extrude(height = BOARDTHICKNESS+hstep+2*EXTRA, center = false)offset(delta= - lstep) _sizebox(vertex);   
    }
    if (closed != false)linear_extrude(height = 1, center = false)offset(delta=BOXTHICKNESS/2) _sizebox(vertex);
    }
}

/**
  @fn carve_polyBox(vertex=undef, height=BOXHEIGHT, closed=false, lstep= BOXSTEPL, hstep=BOXSTEPH, x=0, y=0, rot = norot)
  optional base board carving for add_polyBox().
  @note of course \c close must be \c false.
  */
module carve_polyBox(vertex=undef, height=BOXHEIGHT, closed=false, lstep= BOXSTEPL, hstep=BOXSTEPH, x=0, y=0, rot = norot){
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");
  if (closed==false) translate([x,y,0])rotate(rot)translate([BOXTOLERANCE+BOXTHICKNESS+EXTRA,BOXTOLERANCE+BOXTHICKNESS+EXTRA,-EXTRA])linear_extrude(height = CARVEZ, center = false)offset(delta= -lstep+EXTRA) _sizebox(vertex);   
}

/** 
    @fn add_rectangleBox(pcbx, pcby, height =BOXHEIGHT, closed=false, x=0, y=0, rot = norot)
    simple box for PCB rectangular modules.
    \par  Box Anatomy
    \image html box02.jpg
    <i>In the picture you can see the parameter roles.</i>
    @param pcbx the x size of the rectangular PCB [mm]
    @param pcby the y size of the rectangular PCB [mm]
    @param height box border height [mm], default \c BOXHEIGHT
    @param closed if \c true the box has a closed bottom, default \c false
*/
module add_rectangleBox(pcbx, pcby, height =BOXHEIGHT, closed=false, x=0, y=0, rot = norot){
    assert ((pcbx >= 0) &&(pcby >= 0), "sizes (pcbx, pcby) must be 0 or positive values");
    assert ((height > 0) && (height <200), "box height out of bounds");
    _boxP= [[0,0],[pcbx,0],[pcbx,pcby],[0,pcby]];
    add_polyBox(_boxP, height, closed, x=(x), y=(y), rot=(rot));
}

/**
  @fn carve_rectangleBox(pcbx, pcby, height =BOXHEIGHT, closed=false, x=0, y=0, rot = norot)
  optional base board carving for add_rectangleBox()
  */
module carve_rectangleBox(pcbx, pcby, height =BOXHEIGHT, closed=false, x=0, y=0, rot = norot){
     carve_polyBox([[0,0],[pcbx,0],[pcbx,pcby],[0,pcby]], 0, false, x=(x), y=(y), rot=(rot));
}

/**
  @fn add1_milsBox(mx, my, h=4, x =0,y=0, rot= norot)
  Small support for MIL connectors (male and female).
  For board, for connections or also for TP, jumpers etc. 
  @param mx the x size in MILs 
  @param my the y size in MILs.
  @param h box border height [mm], default 4 [mm]
  @since 1.3
  */
module add1_milsBox(mx, my, h=4, x =0,y=0, rot= norot){
   assert ((mx > 0) &&(my > 0), "sizes (mx, my) must be positive values");
   boxv = get_squareArray2(mx*MILs+BOXTOLERANCE,my*MILs+BOXTOLERANCE); 
   add_polyBox( boxv, height = h, closed = false, lstep = MILs/4,  
      hstep = 1, x = (x), y = (y), rot = (rot) ); }

/**
  @fn carve2_milsBox(mx, my, h=4, x =0,y=0, rot= norot)
  companion carve module for add1_milsBox().
  */
module carve2_milsBox(mx, my,h=4, x =0,y=0, rot= norot){
   boxv = get_squareArray2(mx*MILs+BOXTOLERANCE,my*MILs+BOXTOLERANCE); 
   carve_polyBox( boxv, height = h, closed = false, lstep = MILs/4,  
     hstep = 1, x = (x), y = (y), rot = (rot) ); }   

/**
  @fn add1_milsVBox(mx, my, h=4, x =0,y=0, rot= norot)
  Like add1_milsBox() but over the board.
  For panels and boards, for internal connections.
  @param mx the horizontal size in MILs 
  @param my the vertical size in MILs.
  @param h box border height [mm], default 4 [mm]
  @since 1.3
  */
module add1_milsVBox(mx, my, h=4, x =0,y=0, rot= norot){
   assert ((mx > 0) &&(my > 0), "sizes (mx, my) must be positive values");
  translate([x,y,0])rotate(rot)translate([0,0,BOARDTHICKNESS-BOXTHICKNESS+EXTRA])difference(){rotate([90,0,0])add1_milsBox(mx, my, h);
   translate([BOXTHICKNESS+BOXTOLERANCE+MILs/4,-h-4, my*MILs+BOARDTHICKNESS-BOXTHICKNESS-MILs/4-EXTRA]) cube([mx*MILs-2*MILs/4 + 2*BOXTOLERANCE,h+5, 5]);
  }
 }

/**
  @fn carve2_milsVBox(mx, my, h=4, x =0,y=0, rot= norot)
  companion carve module for add1_milsHBox().
  */
module carve2_milsVBox(mx, my,h=4, x =0,y=0, rot= norot){
  translate([x,y,0])rotate(rot)translate([0,0,BOARDTHICKNESS-BOXTHICKNESS+EXTRA])rotate([90,0,0])carve2_milsBox(mx, my, h);
}
/**
  @fn add1_LED5holder(h= 6, x =0, y=0, rot= norot)
  Small support for 5 mm LEDs (for panels)
  @param mx the x size in MILs 
  @param my the y size in MILs.
  @param h box border height [mm], default 4 [mm]
  @since 1.3
  */
module add1_LED5holder(h= 6, x =0, y=0, rot= norot){
   translate([x,y,0])rotate(rot)translate([0,0,EXTRA])cylinder(r= 4.5, $fn=16,h = (h));
  }

/**
  @fn carve2_LED5holder(h= 6, x =0, y=0, rot= norot)
  companion carve module for add1_LED5holder().
  */
module carve2_LED5holder(h= 6, x =0, y=0, rot= norot){
    translate([x,y,0])rotate(rot)translate([0,0,-1])cylinder(r= 5/2, $fn=32,h = (h)+4);
}

//! @privatesection

// private values about 6x6 switch:
   _body=4;  // switch h.[mm]
   _lim = 2; // out button [mm]
   _bx = 6.2+ 2*BOXTHICKNESS; // box for 6x6 
   _by = 8+2*BOXTHICKNESS;    // box for 6x6

//! @publicsection

/**
  @fn add1_button6x6(h = 11, x =0,y=0, rot= norot)
   Receptacle for 6x6mm Tactile Push Button, long type.
   For panels, adds a button and it protrudes only 2 mm (_lim).
 \image html 6x6buttons.png.
   @param h total height. min 7-8 mm.
   for 4<h<8: out h -5 [mm]
   for h >=8: out 3 [mm]
  @since 1.3
  */
 module add1_button6x6(h = 11, x =0,y=0, rot= norot){
    // 6x6x 11
   assert(h >6, "h too small for this button holder");
   _out = (h-_body >=_lim+1?_lim:h-_body-1);
   translate([x,y,0])rotate(rot)translate([0,0, (h-_out)/2+EXTRA]) cube([_bx, _by,h-_out-EXTRA], center = true);
 }
 
/**
  @fn carve2_button6x6( h = 11, x =0, y=0, rot= norot)
  companion carve module for add1_button6x6().
  */
 module carve2_button6x6( h = 11, x =0, y=0, rot= norot){
    // 6x6x11 => 6.2x8, d = 3.4
    _out = (h-_body >=_lim+1?_lim:h-_body-1);
   translate([x,y,0])rotate(rot)translate([0,0,-EXTRA])union(){
       translate([0,0,20/2+h-_out-_body])cube([6.2,8, 20],center = true);
       cylinder(h= 20, d= 3.40, $fn=32);
    }
 }
 
 /**
  @fn add1_SButton6x6( h= 5, x =0,y=0, rot= norot)
   Receptacle for 6x6mm Tactile Push Button, short type.
   Adds a button that  protrudes 2 mm (_lim) from panel.
 \image html sbutton6x6.png.
   @param h total height. Min val: 4.3 
  @since 1.3
  */
 module add1_SButton6x6( h= 5, x =0,y=0, rot= norot){
    // 6.2x8
    assert(h >4, "h too small for this button holder");
    _bh = h +5;
    translate([x,y,0])rotate(rot)translate([0,0,_bh/2+EXTRA]) cube([_bx, _by,_bh], center = true);
 }
/**
  @fn carve2_SButton6x6(h= 5, x =0,y=0, rot= norot)
  companion carve module for add1_SButton6x6().
  */
module carve2_SButton6x6(h= 5, x =0,y=0, rot= norot){
    // 6.2x8
   _bh = h +5;
   translate([x,y,0])rotate(rot)translate([0,0,-EXTRA])union(){
      translate([0,0,_bh/2+h])cube([6.2,8, _bh],center = true);
      translate([0,0,2+EXTRA])cylinder(h= 10, d= 5.2, $fn=32);
      cylinder(h= 13, d= 3.40, $fn=32);
      }
 }
/**
  @fn  SButton_central( x =0,y=0, rot= norot)
   The button used by add1_SButton6x6().
  @since 1.3
  */
module SButton_central( x =0,y=0, rot= norot){
   translate([x,y,0])rotate(rot)union() {
     cylinder(h= 6, d= 3.30, $fn=32);
     cylinder(h= 2, d= 5, $fn=32);
     }
}

/** 
    @fn add1_tower(height, holediam=3, towerd= xauto, cbase=true, x=0, y=0, rot = norot)
    makes a vertical spacer to fix something like a PCB, a board etc.
    @note The tower must be drilled using carve2_tower().
   @param height tower height. If height <= 0: no tower
   @param holediam top tower hole definition: if positive it is the diameter, otherwise it is the code of a special hole. See do_nuthole().
    @param towerd tower external diameter. Accepts also the special value \c xauto. Default \c xauto.
   @param cbase: if true a round solid base (for hollow boards) is created, default true.
   @note
      It is an error if the tower diameter is less than the hole diameter plus <tt>(2 * min-wall-thickness)</tt>.\n
      The code try to correct the caller's tower diameter (\c towerd) when required and possible, so in many cases it is possible to use simply the default value. The correction is without warnings. Rules:
       \li if \c holediam = 0 (not hole)\n
          the largest  between <tt>(2*_tower_min_radius)</tt> and \c towerd is used. The value \c xauto is allowed (=0).
       \li if \c holediam < 0 (code for special holes)\n
         \c towerd is used as is without tests: the user must verify the compatibility (see get_towerRadius()). The value \c xauto is not allowed.
       \li if \c holediam > 0 (standard holes)\n
         the largest between <tt>(2*_tower_min_radius + holediam)</tt> and \c towerd is used. The value \c xauto  is allowed (=0).
  */
module add1_tower(height, holediam=3, towerd= xauto, cbase=true, x=0, y=0, rot = norot){
   if(height > 0) {
      _pointt =[[0,0,holediam]];
      add1_polyTower(height, _pointt, towerd, cbase, x, y, rot);
   }
}

/** 
    @fn carve2_tower(height, holediam=3, towerd= xauto, cbase=true, x=0, y=0, rot = norot)
  companion carve module for add1_tower().
  */
module carve2_tower(height, holediam=3, towerd= xauto, cbase=true, x=0, y=0, rot = norot){
  if(height > 0) {
   _pointt =[[0,0,holediam]];
    carve2_polyTower(height,_pointt, 0, cbase, x, y, rot);
   }
}

/**
   @fn add1_polyTower(height = 10, holes=undef, towerd=xauto, cbase=true, x=0, y=0, rot = norot)
   makes and places many spacers, definitions in an array.
   @param height tower height. If height <= 0: no towers
   @param holes is an array of spacers; <tt>[[s1.x,s1.y,s1.d],...]</tt> [mm], <tt>s1.d</tt> is the hole definition: if positive it is the diameter, otherwise it is the code of a special hole. See do_nuthole().\n
    \li If sn.d = 0: tower 'n' is built, but not top hole.
    \li If sn.d = undef: no tower 'n', no cbase
    \li If array holes undef: no towers at all.
   @param towerd common tower external diameter. Same rules as add1_tower().
   @param cbase: if true a round solid base (for hollow boards) is created, default true.
*/
module add1_polyTower(height = 10, holes=undef, towerd=xauto, cbase=true, x=0, y=0, rot = norot){
   assert (height > 0);
   if ((!is_undef(holes))&&(height > 0)){
      assert(is_arrayOK(holes, 3, 1), "test on array failed");
      translate([x,y,0])rotate(rot)union(){
         for (n =[0:1:len(holes)-1]) {
             if (!is_undef(holes[n].z)){
                if (cbase == true)_do_base(holes[n].x,holes[n].y);
                   translate([holes[n].x,holes[n].y,EXTRA]) 
                   cylinder(r= _get_tower_radius(towerd, holes[n].z), $fn=32,h = (BOARDTHICKNESS+height-EXTRA));
                }
             }
         }
     }
 }

/** 
    @fn carve2_polyTower(height = 10, holes=undef, towerd=xauto, cbase=true, x=0, y=0, rot = norot)
  companion carve module for add1_polyTower().
*/
module carve2_polyTower(height = 10, holes=undef, towerd=xauto, cbase=true, x=0, y=0, rot = norot){
   if ((!is_undef(holes))&&(height > 0)){
      assert(is_arrayOK(holes, 3, 1), "test on array failed");
      translate([x,y,0])rotate(rot)for (n =[0:1:(len(holes)-1)]) 
         if (!is_undef(holes[n].z))translate([holes[n].x,holes[n].y,-EXTRA]) do_nuthole(holes[n].z,height+BOARDTHICKNESS );
      }
   }

/**
   @fn add1_polySupport (vblock = undef, xs = 6, ys = 6, hs = 16, cbase=true, horiz = false, angle = 0, x=0, y=0, rot = norot)
   like polytower, but stronger cubic support.\n
   This ADDON can be used as a spacer (vertical hole) or as a support for vertical mounting (horizontal hole)
   @param vblock is an array of spacers; <tt>[[s1.x,s1.y,s1.d],...]</tt> [mm], 
        <tt>s1.d</tt> is the the hole definition: if positive it is the diameter, otherwise it is the code of a special hole. See do_nuthole(). If undef: skip.
   @param xs support size x >= 0 [mm] (default 6 mm).
   @param ys support size y >= 0 [mm] (default 6 mm).
   @param hs support height z >= 0 [mm] (default 16 mm).
   @param cbase if true a round solid base (for hollow boards) is created, default true.
   @param horiz 
       \li \c false the hole is vertical, on center[i] 
       \li else the hole is horizzontal (y axis) centered on xz face, and support is rounded.
   @param angle the rotation of any support on z axis.
*/
module add1_polySupport (vblock = undef, xs = 6, ys = 6, hs = 16, cbase=true, horiz = false, angle = 0, x=0, y=0, rot = norot){
   if (!is_undef(vblock)){
      assert ((xs > 0) && (ys >0), "support sizes (xs, ys) must be positive values");
      assert (hs > 0, "support height (hs) must be positive");
      assert(is_arrayOK(vblock, 3, 1), "test on array failed");
      translate([x,y,0])rotate(rot)for (n =[0:1:len(vblock)-1]){
             if (cbase == true)_do_base(vblock[n].x,vblock[n].y);
             if (horiz)
                 translate([vblock[n].x,vblock[n].y,EXTRA])rotate([0,0,angle])translate([-xs/2,+ys/2,0])rotate([90,0,0])linear_extrude(height = ys, $fn = 32)offset(r=ROUNDRADIUS) offset(delta=-ROUNDRADIUS) polygon([[0,0],[xs,0],[xs,hs+BOARDTHICKNESS-EXTRA],[0,hs+BOARDTHICKNESS-EXTRA]]); 
             else
                translate([vblock[n].x,vblock[n].y,EXTRA])rotate([0,0,angle])translate([-xs/2,-ys/2,0]) cube(size=[xs,ys,hs+BOARDTHICKNESS-EXTRA]);
       }
   }
}

/** 
    @fn carve2_polySupport (vblock, xs, ys, hs, cbase=true, horiz = false, angle = 0, x=0, y=0, rot = norot)
  companion carve module for add1_polySupport().
*/
module carve2_polySupport (vblock, xs, ys, hs, cbase=true, horiz = false, angle = 0, x=0, y=0, rot = norot){
   if (!is_undef(vblock)){
     assert(is_arrayOK(vblock, 3, 1), "test on array failed");
     translate([x,y,0])rotate(rot)for (n =[0:1:len(vblock)-1]){ 
        if (horiz)
         translate([vblock[n].x,vblock[n].y,0])rotate([0,0,angle])translate([0,++ys/2+EXTRA,BOARDTHICKNESS +hs/2])rotate([90,0,0])do_nuthole(vblock[n].z, ys);
        else
        translate([vblock[n].x,vblock[n].y,- EXTRA])rotate([0,0,angle])do_nuthole(vblock[n].z,hs+BOARDTHICKNESS );
        }
     }
  }
   
/**
  @fn add_text(txt = "text", size=10, z= _text_add_relief, h= 0, x=0, y=0, rot = norot)
   Adds a text in relief.  
   It uses TEXTFONT font (in e3DHW_hardware_data.1.3.scad ).
   @param txt the text string
   @param size height of  glyph [mm]
   @param z height of relief (default _text_add_relief).
   @param h space (x) were the text will be centered, default <tt>size*len(txt)*XY_FFACTOR</tt>
 */   
module add_text(txt = "text", size=10, z= _text_add_relief, h= 0, x=0, y=0, rot = norot){
   assert(len(txt)> 0, "some text (txt) is mandatory" );
   assert ((size > 0) && (size <200), "size out of bounds");
   assert ((z > 0) && (z <200), "relief text (z) out of bounds");
   _th =size*len(txt)*_XY_FFACTOR;
   _hx = max(h, _th);
//   echo(h=h, _th=_th);
   translate([x,y,0])rotate(rot)translate([_hx/2-_th/2-0.6,0.14,0])resize(newsize=[_th,size,z+BOARDTHICKNESS-EXTRA])linear_extrude(height=z+BOARDTHICKNESS-EXTRA) text(text= str(txt), font = _TEXTFONT, halign ="left");
} 

/**
   @fn add_cableFix(size, cbase=true, x=0, y=0, rot = norot)
   Adds 2  hook to fix a cable.
   @param size cable size  mm (1..10)
 */   
module add_cableFix(size, cbase=true, x=0, y=0, rot = norot){
      assert ((size > 0) && (size <=10), str("size (",size,") out of bounds (0..10]"));
      translate([x,y,0])rotate(rot)union(){
      translate([0,size*sqrt(2)/2,0]) union(){
          rotate([0,0,-45]) cube([size, size,2+size*2+BOARDTHICKNESS], center = false);
          translate([0,2*size,0])rotate([0,0,-45]) cube([size, size,2+size*2+BOARDTHICKNESS-EXTRA], center = false);
      }
    if (cbase == true){
      _do_base(size*sqrt(2)/2,size*sqrt(2)/2);
      _do_base(size*sqrt(2)/2,size*sqrt(2)/2 +2* size);
    }
  } 
}

//======================= PUBLIC MAIN MODULES: CARVE COLLECTION

/** 
    @fn  carve_base(holes = undef,  thickness =BOARDTHICKNESS)
    Carves in a base an array of holes. 
    Useful to re-carve base holes after some union.
    @param holes is an array of mounting holes: [[h1.x,h1.y,h1.d],...]. Mandatory.\n
       For holes diameter, and special holes codes, see do_nuthole(). 
    @param thickness: board thickness [mm] (default BOARDTHICKNESS) 
*/
module carve_base(holes = undef,  thickness =BOARDTHICKNESS){
    assert(is_arrayOK(holes, 3, 1), "test on array failed");
    for (n =[0:1:len(holes)-1]) translate([holes[n].x,holes[n].y,-EXTRA]) do_nuthole(holes[n].z, thickness);
    }

/**
   @fn carve_roundHole(dia, h=0, z= CARVEZ, x=0, y=0, rot = norot)
   Carves a centered hole. For front panel and borders, to fix components (switch, leds..) or for areation.
   @param dia hole diameter
   @param h space (x axis) where the hole will be centered, default 0
   @param z height (z axis) of carving shape, default CARVEZ
*/   
module carve_roundHole(dia, h=0, z= CARVEZ, x=0, y=0, rot = norot){
   assert ((dia > 0) && (dia <200), "hole diameter (dia) out of bounds");
   assert ((z > 0) && (z <200), "height of carving shape (z) out of bounds");
  translate([x,y,0])rotate(rot)translate([h/2,0,-EXTRA])polyhole(z,dia);
}

/**
   @fn carve_elongatedHole(dia, cd, h=0, z= CARVEZ, x=0, y=0, rot = norot)
   Carves a centered elongated hole. For front panel and borders.
   @param dia hole diameter (y)
   @param cd center distance (x) \n size: <tt>(cd+dia) x dia</tt>
   @param h space (x) were the hole will be centered, default 0.
   @param z height (z) of carving shape, default CARVEZ
*/   
module carve_elongatedHole(dia, cd = 0, h=0, z= CARVEZ, x=0, y=0, rot = norot){
   assert ((dia > 0) && (dia <200), "hole diameter (dia) out of bounds");
   assert ((cd > 0) && (cd <200), "center distance(cd)  out of bounds");
   assert ((z > 0) && (z <200), "height of carving shape (z) out of bounds");
   translate([x,y,0])rotate(rot)translate([h/2-cd/2,0,-EXTRA]);
}

/**
   @fn carve_roundRectangle(xr, yr, rr=ROUNDRADIUS, h=0, z= CARVEZ, x=0, y=0, rot = norot)
   Carve a rectangle with optional rounded corners, centered. 
   @param xr the x size of the rectangle [mm]
   @param yr the y size of the rectangle [mm]
   @param rr round radius 
   @param h space (x) were the hole will be centered, default 0
   @param z height (z) of carving shape, default CARVEZ
*/   
module carve_roundRectangle(xr, yr, rr=ROUNDRADIUS, h=0, z= CARVEZ, x=0, y=0, rot = norot){
   assert ((xr > 0) && (yr >0), "rectangle sizes (xr, yr) must be positive values");
   assert ((rr >= 0) && (rr <200), "round radius (rr) out of bounds");
   assert ((z > 0) && (z <200), "height of carving shape (z) out of bounds");
   _hx = (h < xr?0:(h/2-xr/2));
   translate([x,y,0])rotate(rot)carve_roundPoly([[_hx,0],[_hx+xr,0],[_hx+xr,yr],[_hx,yr]],r=rr, z=(z));
} 

/**
   @fn carve_roundPoly(vertex, r=ROUNDRADIUS, z= CARVEZ, x=0, y=0, rot = norot)
   carve any polygonal shape with optional rounded corners, centered.
   @param vertex is an array of points: [[p1.x, p1.y],[p2.x,p2,y],...] [mm]. Required.
   @param r radius that is used to generate rounded corners (defalt ROUNDRADIUS).
   @param z height (z) of carving shape, default CARVEZ
*/   
module carve_roundPoly(vertex=undef, r=ROUNDRADIUS, h = 0, z= CARVEZ, x=0, y=0, rot = norot){
   assert(is_arrayOK(vertex, 2, 3), "test on array failed");
   assert ((r >= 0) && (r <200), "corner radius (r) out of bounds");
   assert ((z > 0) && (z <200), "height of carving shape (z) out of bounds");
   _dx = get_maxX(vertex) - get_minX(vertex);
  translate([x,y,0])rotate(rot)translate([h/2-_dx/2,0,-EXTRA])linear_extrude(height = z, $fn = 32) 
      offset(r=(r)) offset(delta=-r) polygon(vertex); 
} 

/**
   @fn carve_colander (d=4, s=6, rows=3, cols = 3, h=0, z= CARVEZ, x=0, y=0, rot = norot)
   Carves sataggered holes, centered. For areation.  
   @param d holes diameter (default 4)
   @param s center distance ( > d, default 6)
   @param rows nuber of rows (default 3)
   @param cols nuber of colums (default 3)
   @param h space (x) were the holes will be centered, default 0
   @param z height (z) of carving shape, default CARVEZ
*/   
module carve_colander (d=4, s=6,rows=3, cols = 3, h=0, z= CARVEZ, x=0, y=0, rot = norot){
   assert ((d > 0) && (d <200), "holes diameter (d) out of bounds");
   assert ((s > 0) && (s <200), "center distance (s) out of bounds");
   assert ((rows > 0), "rows must be a positive number");
   assert ((cols > 0), "cols must be a positive number");
   assert ((z > 0) && (z <200), "height of carving shape out of bounds");
   a = s*sqrt(3)/2;
    zstart= (h - ((cols-1) *a))/2-d/2;
    bottom1 = (zstart >0) ? zstart:0;
    rigth1 = ((cols-1)*s+s/2+d/2);
    translate([x,y,0])rotate(rot)union(){
    for (i =[0:1:cols-1]){
         for (j =[0:1:rows-1]){
              translate([d/2+i*a+bottom1,d/2+j *s+((i%2)*s/2),-EXTRA]) cylinder(h=z, d=(d), $fn=32);
         }
      }
   }
}

/**
  @fn carve_text(txt = "text", size=8, h= 0, z= CARVEZ, x=0, y=0, rot = norot)
   Adds a text in relief.  Uses TEXTFONT font.
   @param txt the text string
   @param size height of  glyph [mm]
   @param h space (x) were the text will be centered, default <tt>size*len(txt)*XY_FFACTOR</tt>
   @param z height (z) of carving shape, default CARVEZ
 */   

module carve_text(txt = "text", size=8, h= 0, z= CARVEZ, x=0, y=0, rot = norot){
   assert(len(txt)> 0, "some text (txt) is mandatory" );
   assert ((size > 0) && (size <200), "size out of bounds");
   assert ((z > 0) && (z <200), "height of carving shape (z) out of bounds");
  translate([x,y,0])rotate(rot)translate([0,0,-EXTRA]) add_text(txt = (txt), size=(size), h=(h), z= (z));
} 

/**
  @fn module carve_dymoD1_9(l, h= 0, z= 0.7, x=0, y=0, rot = norot){
   Carves the seat for a Dymo label (mm 9)
   @param l  length
   @param h space (x) were the label will be centered
   @param z deep (z) of carving shape, default 0.7
 */   
module carve_dymoD1_9(l, h= 0, z= 0.7, x=0, y=0, rot = norot){
   assert ((l > 0) && (l <200), "length (l) out of bounds");
   assert ((z >= 0) && (z <= BOARDTHICKNESS), "height of carving (z) out of bounds: [0..BOARDTHICKNESS]");
   _h1 = h < 10?0:h/2-l/2;
   translate([x,y,0])rotate(rot)translate([_h1,0,-z+EXTRA+BOARDTHICKNESS]) cube([l,9+BOXTOLERANCE,z]);
} 

//---------------------------------- locals
//! @privatesection

module _sizebox(vertex){
  offset(delta=BOXTOLERANCE) polygon(vertex); 
}
module _do_base(x,y){
    translate([x,y,0])cylinder(r=_slabHoleClearance,h=BOARDTHICKNESS);
}

//  private test function: returns tower external radius (corrected if required) or abort.
function _get_tower_radius(diam, hole) =  
  (diam < 2*_tower_min_radius) && (hole==0)? _tower_min_radius:
    (diam >= 2*_tower_min_radius) && (hole==0)? diam/2:
      (diam == xauto) && (hole>0)? (_tower_min_radius+ hole/2):
        (diam >0) && (hole>0) && (diam >= (hole+2*_tower_min_radius))? diam/2:
          (diam >0) && (hole>0) ? (_tower_min_radius+ hole/2):
            (diam > 0) && (hole<0)? diam/2: assert(false,"bad values for hole and/or tower diameter (diam)"); 

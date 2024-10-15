/*
  CUSTOM.I
  custamization file modified for yorickvis by Hiroshi C. Ito. 2024
 */

/*
    CUSTOM.I
    Default version of user customization file --
    read after std.i and all package initalization files.

    $Id: custom.i,v 1.1 1993/08/27 18:50:06 munro Exp $
 */
/*    Copyright (c) 1994.  The Regents of the University of California.
                    All rights reserved.  */


viewport_center_x=0.398;
viewport_center_y=0.635;

my_legend_side="right";
my_legend_height=14.0;
my_legend_position=[0.0,0.0];
my_legend_outside=0;
my_legend_number=0;
my_legend_color=-5;

pldefault,color="blue",marks=0,height=12,font="helvetica";

label3=["X","Y","Z"];
label3_height=16;
label3off=[[0.0,0.0],[0.0,0.0],[0.0,0.0]];
label3_amp_dist=3.0;
z_vertical=0;
omit_ticks3=0;
omit_label3=0;
cage3_front=0;

cage3_backscreen=char(0.9*[250,250,250]);

white = char(252);
gray=char(245);
yellow=char(246);
purple=char(247);
cyan=char(248);
blue=char(249);
green=char(250);
red=char(251);
black=char(253);


flag_ms_windows=0;

if(flag_ms_windows==1){
  Y_DIR=Y_HOME+"Yorick/";
convert_bin=Y_HOME+"image_magick/convert.exe";
viewer_bin=Y_HOME+"image_magick/IMDisplay.exe";
 }else{
  convert_bin="convert";
  viewer_bin="display";
 }


Y_DIR="~/Yorick/";


include, Y_DIR+"graph2d.i";
include, Y_DIR+"graph3d.i";
include, Y_DIR+"idl.i";
include, Y_DIR+"tube3.i";
include, Y_DIR+"lcontour3.i";
include, Y_DIR+"pale.i";


/* This should be the final line in your custom.i file-- it implements
   the default command line processing (see help for process_argv).  */
command_line= process_argv();

/*
  IDL.I
  functions for event-driven programing, written by Hiroshi C. Ito. 2018
  
 */

/* functions in this file. (type "help, function_name" at yorick prompt for examples)

idl: idling function for event driven programing controlled by mouse click.
*/


require, Y_DIR+"graph2d.i";
require, Y_DIR+"graph3d.i";

idl_flag_animate_off=0;
idl_movie_eps=0;

idl_default_button="BOTH";
//idl_default_button="RIGHT";
//idl_default_button="LEFT";

idl_flag_end=0;
idl_flag_stop=0;

idl_init=1;
idl_init_pause=1;
idl_rotation=0;
idl_rotation_speed=array(0.0,3);
idl_ro_axis=0;
idl_zoom_factor=1.5;
idl_old_lim=[0,1,0,1,15];
idl_old_pos=0;
idl_count=0;
idl_count_movie=0;

idl_movie_size=720;
idl_movie=0;
//idl_movie_interval=10;
idl_movie_interval=2;




idl_curm_past=0;
idl_oldlim_past=0;
idl_flag_oldlim_stay=0;
idl_edge_drag=0.005;

idl_map=[["1_click","zoom_in"],
           ["1_drag","move"],
           ["1_Ctrl_click","scale"],
           ["1_Ctrl_drag","rotation_once"],
           ["2_Shift_click","zoom_out"],
           ["2_Shift_drag","switch_but_hide"],
           ["3_click","rotation_start"],
           ["3_drag","rotation_start"],
           ["3_Ctrl_click","rotation_stop"],
           ["3_Ctrl_drag","rotation_stop"],
           ["3_Shift_click","end"],
           ["3_Shift_drag","other"]];


idl_map_menu=[["pause","end"],//1
              ["change_pal-","change_pal+"],//3
              ["axis","rot_stop"],//5
              ["zoom_in","zoom_out"],//7
              ["reset","cage"],//8
              ["command","command"],//4
              ["fun1","fun2"],//6        
              ["switch_movie","make_movie"],//2
              ["switch_but_hide","switch_but_hide"]];//9

idl_but_labs_n=numberof(idl_map_menu(1,));
idl_but_labs_pvx=3.0;
idl_but_labs_pvy=array(0.0,idl_but_labs_n+1);
idl_but_labs=array("",idl_but_labs_n);
idl_button_hide=0;


idl_win_style="win2";

idl_offset_y_win2=[0.0538032,0.0807049,0.0538032+0.0672541];//400
//idl_offset_y_win2=[0.0415752,0.0623629,0.0935443];//500

//idl_offset_y_win2=[0.0338761,0.0508142,0.0762213];//600
//pp=[[0.0538032,0.0807049,0.0538032+0.0672541],[0.0415752,0.0623629,0.0935443],[0.0338761,0.0508142,0.0762213]];
//hh=[400,500,600];
//idl_offset_unit=[0.0538032,0.0807049,0.0538032+0.0672541]*0.357;

idl_offset_unit=[(1.0/idl_zoom_factor),1.0,idl_zoom_factor]*0.0807049*0.357;


idl_offset_y_win3=idl_offset_y_win2+[-0.0124161,-0.0186242,-0.0279363];

idl_offset_y=idl_offset_y_win2;


func idl_do_action_menu(LR,but_id){
  extern idl_flag_stop,idl_button_hide,idl_default_button,idl_map_menu;

  
  flag=0;
  aname=idl_map_menu(LR,but_id);
  
  
     if(aname=="pause")idl_flag_stop=(idl_flag_stop+1)%2;
      if(aname=="end"){write,"End";flag=1;}

      if(aname=="switch_movie")idl_switch_movie;
      if(aname=="make_movie")idl_make_movie;
         
    if(aname=="change_pal+")idl_change_pal,1;
     if(aname=="change_pal-")idl_change_pal,-1;
   
    if(aname=="command"){fun3,arg3;} 
    if(aname=="axis"){idl_switch_ro_axis;}
    if(aname=="rot_stop"){idl_stop_rotation;}
       
    if(aname=="fun1"){"fun1";if(!is_void(fun1))fun1,arg1;}
    if(aname=="fun2"){"fun2";if(!is_void(fun2))fun2,arg2;}
    if(aname=="zoom_in"){"zoom in";scale,1.1;}
    if(aname=="zoom_out"){"zoom out";scale,1.0/1.1;}
    if(aname=="reset"){limits;if(rot==1)scale,0.9;}
    if(aname=="cage"){cage3;}


    if(aname=="switch_but_hide"){idl_switch_but_hide;}

    return flag;
}
func idl_menu_id(menu_name){
  //menu_name;
  return (where2(idl_map_menu==menu_name))(2,1);
}

func idl_print_menu(void){

  if(idl_movie==0)idl_print_but," Movie:off\n /Encode","blue",idl_menu_id("switch_movie"),col0="black";
  if(idl_movie==1)idl_print_but," Movie:on\n /Encode","red",idl_menu_id("switch_movie"),col0="black";

    
    
    idl_print_but," Palette: "+swrite(format="%d\n \"%s\"",idl_pal_id,pals(idl_pal_id)),"blue",idl_menu_id("change_pal+"),col0="black";

    idl_print_but," Command","blue",idl_menu_id("command"),col0="black";
   
   axis_mode=["free","x,y,z"](idl_ro_axis+1);
   idl_print_but," RoAxis/Stop\n "+axis_mode,"blue",idl_menu_id("axis"),col0="black";
  
   idl_print_but," Fun1/2","blue",idl_menu_id("fun1"),col0="black";
   idl_print_but," Zoom","blue",idl_menu_id("zoom_in"),col0="black";
   idl_print_but," Reset/Cage","blue",idl_menu_id("reset"),col0="black";
   idl_print_but," Hide","blue",idl_menu_id("switch_but_hide"),col0="black";
   if(!idl_flag_stop)idl_print_but," Pause\n /End","blue",idl_menu_id("pause"),col0="black";
   if(idl_flag_stop){
     idl_print_but," Start\n /End","red",idl_menu_id("pause"),col0="red";
   }
  
}
  

func idl_do_action(act,x,li,rot=,rot_hist=){
  extern idl_zoom_factor, idl_rotation;
    ro_amp=0.1;
    if(is_void(rot_hist))rot_hist=1;
    flag=0;
    
  if(act=="switch_but_hide"){idl_switch_but_hide;}
  if(act=="limits")limits;
  if(act=="scale")scale,0.9;
  if(act=="zoom_out"){idl_zoom,idl_zoom_factor,x,li;}                   
  if(act=="zoom_in"){idl_zoom,(1.0/idl_zoom_factor),x,li;}
  if(act=="move")idl_move,x,li;
  if(act=="zoom_smooth")idl_zoom_smooth,x,li;
  if(act=="end"){write,"end";flag=1;}
    
 if(rot==1){
         if(act=="switch_rotation_mode")switch_rotation_mode;
         if(act=="rotation_stop"){if(rot_hist==0)idl_rotation=0;}
         if(act=="rotation_start"){idl_rotation=idl_set_rotation(x,li,ro_amp);}
         
         if(act=="rotation_once"){idl_rot3,x,li;draw3,1;}
     }

     if(act=="other"){
         "fun3";fun3;
       
      
       }


     return flag;
     
}

func idl_print_mouse_use(void){
    write,"Press menu on the right side of window with mouse bottuns.";
    write,"";
    write,"When mouse cursor is on graphics:";
    write,"";
    write,"Rotation: [Right-drag]";
    write,"Start/Pause: [Ctrl + Right-click]";
    write,"Zoom in/out: [Left-click] / [Shift + Left-click]";
    write,"Move: [Left-drag]";
    write,"Hide menu: [Shift + Left-drag]";
    write,"";
    write,"<During Pause>";
    write,"End: [Shift + Right-click]";
    write,"Enter command: [Shift + Right-drag]";
    if(rot==1){
       write,"Rotate once: [Ctrl + Left-drag]";
    }
        write,"";
    
    }



func idl_switch_movie(void){
  extern idl_movie,idl_count,idl_count_movie;
  idl_movie=(idl_movie+1)%2;

  if(idl_movie){
    write,"Movie on";
    system,"rm -f "+Y_DIR+"buf/frame*png";
    system,"rm -f "+Y_DIR+"buf/frame*ps";
    idl_count=0;
    idl_count_movie=0;

 
    if(idl_movie_eps)outps,t=idl_count_movie;
    if(!idl_movie_eps)outpng,,t=idl_count_movie;
   
 
  }
  if(!idl_movie)write,"Movie off";
  
}

func idl_make_movie(void){
   "encoding...";
   extern idl_movie_eps;
   if(idl_movie_eps==0)system,"ffmpeg -y -r 22 -i "+Y_DIR+"buf/frame%05d.png -b:v 1000000  -vcodec libx264 -qscale 0 "+"test.mp4";
   if(idl_movie_eps==1){
         cwd=get_cwd();
    cd,Y_DIR+"buf";
     
     system,swrite(format="../ps2mp4 %d %d %s",300,idl_movie_size,"test.mp4");
     cd,cwd;
     system,swrite(format="mv %sbuf/test.mp4 .",Y_DIR);
     
   }
    //ffmpeg  -i frame%05d.png  -vcodec libx264 -qscale 0  test.mp4
    //ffmpeg -r 10 -i GLVis_m%04d.png  -vcodec libx264 -qscale 0  test_large.mp4
    write,"movie created: test.mp4";
    write,"show movie?: Yes[Left] / No[Right]";
  
    if(mouse()(10)==1)system,"totem test.mp4";
    "totem test.mp4";
}

func idl_get_action(bu,idl_map){
 
  act=idl_map(2,where(idl_map(1,)==bu));
  if(numberof(act)>1)write,bu,"is mapped on",act;
  return act(1);
}



func idl_orig_pos(lim,olim,oldpos){
  extern idl_offset_y;

  
      xo=olim(1:2);
    yo=olim(3:4);
    nlim=lim;
    x=lim(1:2);
    y=lim(3:4);

   ax=(x(2)-x(1))/(xo(2)-xo(1));
    ay=(y(2)-y(1))/(yo(2)-yo(1));
    ddx=ax*(olim(2)-oldpos(1))-(lim(2)-oldpos(1));
    ddy=ay*(olim(4)-oldpos(2))-(lim(4)-oldpos(2));

  
  // if(abs(pos_dx,pos_dy)>0.0001){write,oldpos;write,pos;write,"";}
  
    lim(1:2)+=ddx;
    lim(3:4)+=ddy;
    
    xo=olim(1:2);
    yo=olim(3:4);
    x=lim(1:2);
    y=lim(3:4);

    
   
    
    xm=oldpos(1);
    ym=oldpos(2);

    if(abs(1.0-ay)>0.001)ym=(y(2)-ay*yo(2))/(1.0-ay);
    if(abs(1.0-ax)>0.001)xm=(x(2)-ax*xo(2))/(1.0-ax);
  
    ddx/=(xo(2)-xo(1));
    ddy/=(yo(2)-yo(1));

  if(ay<0.9)ddy+=idl_offset_y(1);
  if((ay<1.1)*(ay>0.9))ddy+=idl_offset_y(2);
  if(ay>1.1)ddy+=idl_offset_y(3);
    //write,"a",ay;

  button_type=0;
  modi=0;

  if((abs(1.0-ay)<0.1)*(abs(1.0-ax)<0.1)){
    //if(abs(ddx)>0.001){
    button_type=2;
    modi=1;
    //    write,ddx,ddy;
    
    //}
  }

  if((ax>1.3)+(ay>1.3))button_type=3;
  if((ax<1.0/1.3)+(ay<1.0/1.3))button_type=1;
  if((ax<0.1)+(ay<0.1)){
    button_type=3;
    modi=4;
  }
  sys=1;

  return [xm,ym,xm+ddx*(xo(2)-xo(1)),ym+ddy*(yo(2)-yo(1)),0,0,0,0,sys,button_type,modi];
}



func idl_axis_rot3_ho(ddx,ddy,&ro_axis,&dro){
  local xx,yy,z;
                xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
                get3_xy, xyz, xx, yy, z, 1;
                xbuf=xx;ybuf=yy;
                xx-=xx(1);yy-=yy(1);
                xx=xx(2:);yy=yy(2:);
                rr=abs(xx,yy);
                xx=xx/rr;yy=yy/rr;
                
               
                ro_axis=abs(xx*ddx +yy*ddy)(mnx);
                dro=-2*(xx*ddy -yy*ddx)(ro_axis);
            
}


func idl_fun3(rot3){
  while(1){
    keybd_focus,1;
    command=rdline(,1,prompt="Enter command: ")
      if(command(1)!=""){
        exec,command;
        //pause,1;
        
        if(rot3==1){
        draw3_trigger;
        draw3,1;
        }else{
          pause,1;
          // redraw;
        }
        
      }else{
        write,"Command mode ended";
        return;
      }
  }
}


func idl_check_menu_push(oldlim=){
  extern idl_but_labs_n;
  extern idl_curm_past, idl_oldlim_past,idl_flag_oldlim_stay;
  check2=0;
  curm=current_mouse();


  if(!is_void(oldlim)){
  ch_mou=1;
  if((numberof(idl_curm_past)>1)*(numberof(curm)>1)){
     ch_mou=(sum(abs(curm(1:2)-idl_curm_past(1:2)))>0);
  }

  ch_lim=(sum(abs(oldlim(1:4)-idl_oldlim_past(1:4)))>0);

  /////////////write,ch_mou,ch_lim,idl_flag_oldlim_stay;
  
  if(ch_mou==0){
    if(ch_lim==1){
      oldlim=idl_oldlim_past;
      idl_flag_oldlim_stay=1;

      //////////write,"stay on";
    }
    
  }
  
  if(idl_flag_oldlim_stay==1){
    if(ch_mou==1){
      idl_oldlim_past=oldlim;
      idl_flag_oldlim_stay=0;
    }else{
      oldlim=idl_oldlim_past;
    }

  }else{

  idl_curm_past=curm;
  idl_oldlim_past=oldlim;
  }
  

  }
  dlim=limits();
  if(is_void(oldlim))oldlim=dlim;

  if(numberof(curm)>0){
    mmx=curm(1)/(oldlim(2));
    mmy=(curm(2)-oldlim(3))/(oldlim(4)-oldlim(3));
    
    
  if(mmx>0.99){
    
     
      for(i=1;i<=idl_but_labs_n;i++){
        mmy_hi=1.0-1.0*(i-1)/(idl_but_labs_n);
        mmy_lo=1.0-1.0*i/(idl_but_labs_n);
        if((mmy>mmy_lo)*(mmy<mmy_hi)){
          //                  write,i,mmy_lo,mmy,mmy_hi;
          check2=i;
        }
      }
  }
  }

 
    return check2;
}

func idl_switch_but_hide(void){
  extern idl_button_hide;
  idl_button_hide=(idl_button_hide+1)%2;
  idl_but_hide,idl_button_hide;
}

func idl_but_hide(on){
  extern idl_button_hide;
  plsys,0;
  blist=plq();
  hlist=where(strgrep("idl_but",blist)(2,)>0);
  for(i=1;i<=numberof(hlist);i++)pledit,hlist(i),hide=on;
  plsys,1;
}


func idl_print_but_top(lab,col,id,col0=){
  extern idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy;
}

func idl_print_but(lab,col,id,col0=){
  extern idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy;

  pvx=idl_but_labs_pvx;
  pvy=idl_but_labs_pvy;
  
  if(is_void(col0))col0=black;
  if(col0!="")plt," --------",pvx,pvy(id),color=col0,justify="LH",legend="idl_but";
    
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color="bg",justify="LH",legend="idl_but";
  idl_but_labs(id)=lab;
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color=col,justify="LH",legend="idl_but";
  
  if(col0!="")plt," --------",pvx,pvy(id+1),color=col0,justify="LH",legend="idl_but";
}


func idl_zoom(amp,x,li,offset=){
  extern idl_old_lim;
  if(is_void(offset))offset=0;
  
  if((x(1)-li(1))<=0.99*(li(2)-li(1))){

    
    flag_sidex=((li(2)-x(1))>0.99*(li(2)-li(1)))+((x(1)-li(1))>0.99*(li(2)-li(1)));
  flag_sidey=((li(4)-x(2))>0.99*(li(4)-li(3)))+((x(2)-li(3))>0.99*(li(4)-li(3)));

  write,x(1),x(2),x(3),x(4);
  write,"zoom1!",flag_sidex,flag_sidey;
  ampx=amp;
  ampy=amp;
  if(flag_sidex)ampx=1;
  if(flag_sidey)ampy=1;
  
  limits, x(1)-ampx*(x(1)-li(1)),x(1)+ampx*(li(2)-x(1)),x(2)-ampy*(x(2)-li(3))+offset,x(2)+ampy*(li(4)-x(2))+offset;
  // idl_old_lim(1:4)=[x(1)-ampx*(x(1)-li(1)),x(1)+ampx*(li(2)-x(1)),x(2)-ampy*(x(2)-li(3)),x(2)+ampy*(li(4)-x(2))];
  }
}



 
pals=["mine","earth","heat","sunrise","cr","sun","bb","rr","gg","cool","gray","br","by","blue","koge","wine","te","yb","silver","earth2","gray2","cale","rg2","gr2","bg2","bb_rev","purple"];
idl_pal_id=0;
func idl_change_pal(add_id){
  extern idl_pal_id,pals;
  
  idl_pal_id= (idl_pal_id-1+sign(add_id))%(numberof(pals)) +1;
  if(idl_pal_id==0)idl_pal_id=numberof(pals);
  pal,pals(idl_pal_id);

  write,"Palette changed to:",pals((idl_pal_id));
}

func idl_init_pal(void){
 extern idl_pal_id,pals;
 local r,g,b;
 palette,r,g,b,query=1;
 make_palette,Y_DIR+"palette/mine.gp",r,g,b;
  idl_pal_id=1;
  pal,pals(1);

 
}


func idl_switch_ro_axis(void){
  extern idl_ro_axis;
  idl_ro_axis=(idl_ro_axis+1)%2;
  if(idl_ro_axis==0){write,"Rotation along axis: OFF";}
  if(idl_ro_axis==1){write,"Rotation along axis: ON";}
}


   
func  idl_get_push_name(x,ddr,edge_ddr){
     bu="";
     if(x(10)==1)bu="1_";
     if(x(10)==2)bu="2_";
     if(x(10)==3)bu="3_";
     if(x(11)==1)bu+="Shift_";
     if(x(11)==4)bu+="Ctrl_";
     if(ddr<edge_ddr)bu+="click";
     if(ddr>=edge_ddr)bu+="drag";
     return bu;
   }


func idl_stop_rotation(void){
  extern idl_rotation_speed, idl_rotation;
  idl_rotation=0;
  idl_rotation_speed*=0;
 
}
func idl_set_rotation(x,li,ro_amp){
  extern idl_ro_axis, idl_rotation_speed;
  
    ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);
  rotation=0;
  if(idl_ro_axis==0){
    rotation=1;
    idl_rotation_speed(1:2)=[-1*ddy,ddx]*ro_amp;
  }
  if(idl_ro_axis==1){
    rotation=2;            
    idl_axis_rot3_ho,ddx,ddy,ro_axis,dro;
    
    idl_rotation_speed*=0.0;
    idl_rotation_speed(ro_axis)=dro*ro_amp;
    
  }
  //  write,idl_ro_axis,idl_rotation;
  //idl_rotation_speed;
  return rotation;
}



func idl_rot3(x,li){
  extern idl_ro_axis;

    ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);

  /*
  xm=0.5*(li(2)+li(1));
  ym=0.5*(li(4)+li(3));
  ddx=(x(1)-xm)/(li(2)-li(1));
  ddy=(x(2)-ym)/(li(4)-li(3));
  write,ddx,ddy;
  */
  if(idl_ro_axis==0){
    rot3,-4*ddy,4*ddx;
  }else{
    
    
    idl_axis_rot3_ho,ddx,ddy,ro_axis,dro;
    
    if(ro_axis==3)rot3_ho,,,dro;
    if(ro_axis==1)rot3_ho,dro,,;
    if(ro_axis==2)rot3_ho,,dro,;         
    
  }
}



func idl_zoom_smooth(x,li){
  if(is_void(offset))offset=0;
  ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);
  
  amp = exp(-2.0*ddy);
  amp_pow=2*abs(ddy)/ddr;
  amp=amp^amp_pow;
       limits, x(1)-amp*(x(1)-li(1)),x(1)+amp*(li(2)-x(1)),x(2)-amp*(x(2)-li(3)),x(2)+amp*(li(4)-x(2));
       
}

func idl_move(x,li){
       limits,li(1)+(x(1)-x(3)),li(2)+(x(1)-x(3)),li(3)+(x(2)-x(4)),li(4)+(x(2)-x(4));
}



func idl(dp,count,rot=,stop=,fun1=,fun2=,fun3=,arg1=,arg2=,arg3=,rot_hist=)
/* DOCUMENT if(idl(dp))break;
   DEFINITION idl(dp,count,rot=,stop=,fun1=,fun3=)

 Idling function for event driven programing controlled by mouse click.
 This function uses "limits()" function to detect the state of mouse. In other words, idl hitchhikes the event loop of gist graphics system.

The menu on the right side of window can be pushed by Mouse-Right/Light-button.

 When mouse cursor is on graphics:
 
 Rotation: [Right-drag]
 Start/Pause: [Ctrl + Right-click]
 Zoom in/out: [Left-click] / [Shift + Left-click]
 Move: [Left-drag]
 Hide menu: [Shift + Left-drag]
 
 <During Pause>
 End: [Shift + Right-click]
 Enter command: [Shift + Right-drag]
 Rotate once: [Ctrl + Left-drag]
 
DP is waiting time at each execution of this function.
If COUNT is given, the value is printed at each "stop" event.
IF ROT is 1, 3D-rotation is enabled.

<Examples>
include,"idl_demo0.i";
include,"idl_demo1.i";
include,"idl_demo2.i";
include,"idl_demo3.i";


SEE ALSO: mouse, pause

*/
{
  extern idl_fun3,idl_init,idl_win_style,idl_flag_stop,idl_count,idl_count_movie;
  //extern idl_rotation, idl_rotation_speed,idl_ro_axis
    extern idl_old_lim,idl_old_pos;
  extern idl_init_pause, idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy,idl_default_button, idl_zoom_factor;
  extern idl_curm_past, idl_oldlim_past,idl_flag_oldlim_stay,idl_movie;
  extern idl_but_rotation_mode,idl_map;
  extern idl_offset_y_win3,idl_offset_y_win2,idl_offset_y,idl_offset_unit,idl_winh;
  extern idl_edge_drag;
  local xx,yy,z,ro_axis,dro;

  edge_ddr=idl_edge_drag;
  ro_amp=0.1;

  
  
  
  if(is_void(rot_hist))rot_hist=0;
  if(is_void(dp))dp=1;
  if(is_void(rot))rot=0;
  if(is_void(fun3)){
    fun3=idl_fun3;
    arg3=rot;
  }
  
  change_lim=0;
  idl_flag_stop=0;

   pv=viewport();
    //plsys,0;
   idl_but_labs_pvx=pv(2);
   idl_but_labs_pvy=span(pv(4),pv(3),(idl_but_labs_n+1));

   idl_print_menu;

     
     if(idl_button_hide)idl_but_hide,1;

     

     if(idl_init){
    
       idl_movie=0;
       idl_count=1;
       idl_init_pal;
       idl_old_lim=limits();

       idl_button_hide=0;
       idl_curm_past=current_mouse();
       idl_oldlim_past=idl_old_lim;
       idl_flag_oldlim_stay=0;

       idl_print_mouse_use;

    

      
     if(idl_init_pause==1)idl_flag_stop=1;   

     get_style,landscape, systems, legends, clegends;

     aaa=systems.viewport(,1);
     idl_offset_y=idl_offset_unit/(aaa(4)-aaa(3));
     if(idl_flag_animate_off==1)idl_offset_y*=0;
     
     idl_init=0;
     //   write,idl_init_pause;
     }
     redraw;
  
   
  pause,dp;
  oldlim=idl_old_lim;
  newlim=limits();
  
  
  check1=((newlim(2)-newlim(1))*4< (oldlim(2)-oldlim(1)));
  //if(idl_but_rotation_mode==1)check1=((newlim(2)-newlim(1))>1.2*(oldlim(2)-oldlim(1)));

  
  check2=idl_check_menu_push(oldlim=oldlim);

  push_R=((newlim(4)-newlim(3))>1.2*(oldlim(4)-oldlim(3)));
  push_L=((newlim(4)-newlim(3))<(1.0/1.2)*(oldlim(4)-oldlim(3)));
  push_but_R=check2*push_R;
  push_but_L=check2*push_L;

    if(push_but_L+push_but_R >0){
      if(push_L)LR=1;
      if(push_R)LR=2;
      limits,oldlim;
      if(idl_do_action_menu(LR,check2)){return 1;}
    
    
    
  }

  
    if(check1){
      limits,oldlim;
      idl_flag_stop=1;

      check2;  
    }
  
  


    
  if(idl_flag_stop){
    limits,oldlim;
    if((!is_void(count)))write,"Stop:",count;
    else write,"Stop";   
    animate,0;
    
  }
  

    //    if(idl_but_rotation_mode==1){
      
  if((check2==0)*(sum(abs(newlim(1:4)-oldlim(1:4)))>0)){
      
    if((numberof(idl_old_pos)>3)*(numberof(current_mouse())>3)){
      
      limits,oldlim;
      
      x=idl_orig_pos(newlim,oldlim,idl_old_pos);
      li=oldlim;
      ddy=((x(4)-x(2))/(li(4)-li(3)));
      ddx=((x(3)-x(1))/(li(2)-li(1)));
      ddr=sqrt(ddx^2+ddy^2);
      
      bu=idl_get_push_name(x,ddr,edge_ddr);
      ///write,(newlim(2)-newlim(1))/(oldlim(2)-oldlim(1));
      
      
      act=idl_get_action(bu,idl_map);
      
      
      //write,"animetion",ddx,ddy,bu,act;    

      if(idl_do_action(act,x,li,rot=rot,rot_hist=rot_hist))return 1;
     
  
          
    }
    //write,idl_rotation;
  }

  if(rot==1){
          if(idl_rotation==1)rot3,idl_rotation_speed(1),idl_rotation_speed(2);
      if(idl_rotation==2)rot3_ho,idl_rotation_speed(1),idl_rotation_speed(2),idl_rotation_speed(3);
  }
      
 
      while(idl_flag_stop==1){
        
        redraw;
        pause,10;
        
   
        idl_print_menu;
        if(idl_button_hide)idl_but_hide,1;
        
        redraw;
        li=limits();
        
   x= mouse(1, 2,"");
      //x= mouse(1, 1,"");
    

   ddy=((x(4)-x(2))/(li(4)-li(3)));
   ddx=((x(3)-x(1))/(li(2)-li(1)));
   ddr=sqrt(ddx^2+ddy^2);

   bu=idl_get_push_name(x,ddr,edge_ddr);
   
   button_id=idl_check_menu_push(oldlim=idl_old_lim);
     push_but_R=button_id*((bu=="3_click")+(bu=="3_drag"));
     push_but_L=button_id*((bu=="1_click")+(bu=="1_drag"));
     LR=0;
     if((bu=="3_click")+(bu=="3_drag"))LR=2;
     if((bu=="1_click")+(bu=="1_drag"))LR=1;
    
     if((push_but_R+push_but_L)>0){
              
       if(idl_do_action_menu(LR,button_id))return 1;
       
       if(idl_flag_stop==0){
         //write,"Start";
         if(!idl_flag_animate_off)animate,1;
         write,"Start";
         
       }
       
     }
              
      
     if(push_but_L + push_but_R ==0){


       act=idl_get_action(bu,idl_map);
       write,"stop",bu,act;

       
         if((act=="rotation_stop")+(act=="rotation_start")){
           idl_flag_stop=0;            
           if(!idl_flag_animate_off)animate,1;
           write,"Start";
       }      
       
       
       if(idl_do_action(act,x,li,rot=rot,rot_hist=rot_hist))return 1;
     
     }
      
  
     idl_old_pos=current_mouse();
  idl_old_lim=limits();
      }

 
  idl_old_pos=current_mouse();
  idl_old_lim=limits();
 
  if(idl_movie){
    if((idl_count!=0)*(idl_count%idl_movie_interval==0)){
      
      if(idl_movie_eps)outps,t=idl_count_movie;
      if(!idl_movie_eps)outpng,,t=idl_count_movie;
      idl_count_movie+=1;
    }
  }
  idl_count+=1;
    
  

  
}


func ro(pause_on)
/* DOCUMENT    ro
DEFINITION ro (pause_on)

rotates 3D-plottings with mouse, by using function "idl".
 
   KEYWORDS: 
   SEE ALSO: idl

<Example>
win2,offset_w=100;
win3;
clear3;
kuti;
lim3,1.5;
cage3,1;
draw3,1;
scale,0.8;
ro;

*/
{
  extern idl_init,idl_init_pause,idl_rotation_speed,idl_rotation,idl_ro_axis;
  idl_init_pause=0;
  if(!is_void(pause_on))idl_init_pause=1;
  idl_rotation=2;
  idl_rotation_speed=[0,0,0.001];
  idl_ro_axis=0;
  idl_init=1;
  // t=0;
  if(!idl_flag_animate_off)animate,1;
  while(1){
    //       current_mouse(0);
    //focused_window();
    //has_mouse(0);
    //    pl3surf,nv,xyzv;
    draw3_trigger;
    //rot3,0,0;
    draw3,1;
    //t+=1;
        if(idl(0,rot=1,rot_hist=1))break;
        //    if(idl(0,rot=1,rot_hist=0))break;
  }
  animate,0;  
}



//ro1;


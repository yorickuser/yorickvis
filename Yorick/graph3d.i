
/*
  GRAPH3D.I
  Additional functions for 3D-graphics written by Hiroshi C. Ito. 2018
  
 */

/* functions in this file (type "help, function_name" at yorick prompt for examples)
   
ro: rotates 3D-plottings with mouse.

win3: initializes the window to 3D-mode
changech: changes properties of cage3.
read_poly: reads polygon data for pl3surf and pl3tree to a text file.
write_poly: writes polygon data for pl3surf and pl3tree to a text file.

lim3: a short-name version of limit3.
lim32xz: adjusts the rotation and scale of plottings so that the scales of x- and z-axes in "win2" coincide with those of x- and z-axes on the 3D-cage.
lim32xy: adjusts the rotation and scale of plottings so that the scales of x- and y-axes in "win2" coincide with those of x- and y-axes on the 3D-cage.
lim32yz: adjusts the rotation and scale of plottings so that the scales of y- and z-axes in "win2" coincide with those of y- and z-axes on the 3D-cage.

spal: prepares two different palettes (mainly for pl3tree).
make_mypal : gets palette data.
make_xyz: transform data for plwf into data for pl3surf and pl3tree.
get_light:calculates brightness of each polygon consisting surface in the same manner with pl3surf.
*/

require,"plwf.i";
include,Y_DIR+"pl3d_modified.i",1;
include,Y_DIR+"slice3_modified.i",1;
include,Y_DIR+"tama.i",1;

func spal (name,name1){
/* DOCUMENT spal, name, name1
   DEFINITION spal(name,name1)
     prepares two different palettes (mainly for pl3tree).
     
   SEE ALSO:split_palette

   <Example>
   
   read_poly,nv0,xyzv0,"~/Yorick/poly/kuti.poly";
   read_poly,nv1,xyzv1,"~/Yorick/poly/tetra.poly";
   
   xyzv0+=[-1,0,0];
   xyzv1+=[1,0,0];

   win2;win3;
   spal,"rr","bb"
   clear3;
   pl3tree,nv0,xyzv0,mypal=0;
   pl3tree,nv1,xyzv1,mypal=1;
   lim3,2;
   draw3,1;
   scale,0.8;
 */
  if(is_void(name1))name1=name;
  str=".gp"
    stdir=Y_DIR+"palette/"
    str0=stdir+name+str;
  str1 = stdir+name1+str;
  split_palette,str0,str1;
  return;
}


func make_mypal(name)
/* DOCUMENT make_mypal(palette_name)
   DEFINITION make_mypal(palette_name)
     gets palette data.
   SEE ALSO: palette   

   <Example>
   
   read_poly,nv0,xyzv0,"~/Yorick/poly/kuti.poly";
   read_poly,nv1,xyzv1,"~/Yorick/poly/tetra.poly";
   
   xyzv0+=[-1,0,0];
   xyzv1+=[1,0,0];

   mygreen=make_mypal("gg");
   myblue=make_mypal("bb");
   win2;win3;
   clear3;
   pl3tree,nv0,xyzv0,mypal=mygreen;
   pl3tree,nv1,xyzv1,mypal=myblue;
   lim3,2;
   draw3,1;
   scale,0.8;

 */
{
  local r,g,b,rbuf,gbuf,bbuf,name;
  palette,query=1,rbuf,gbuf,bbuf;   
  pal,name;
  palette,query=1,r,g,b;
  palette,rbuf,gbuf,bbuf;   
return transpose([r,g,b]);
}

func make_mypal_rgb(pal_r,pal_g,pal_b){   
return transpose([pal_r,pal_g,pal_b]);
}


func win3(n,palname=)
/* DOCUMENT win3
   or win3, window
   DEFINITiON win3(n,palname=)
     initializes the window to 3D-mode
   SEE ALSO: cage3, setz3
 */
  {
      extern viewport_center_x,viewport_center_y;

      if(is_void(palname))palname="earth";
    cenx = viewport_center_x;
    ceny =viewport_center_y;

    get_style,landscape, systems, legends, clegends;
    xs=systems.viewport(1);
    xe=systems.viewport(2);
    ys=systems.viewport(3);
    ye=systems.viewport(4);
    vw=0.5*(xe-xs);
    vh=0.5*(ye-ys);
    
    
    vamp=1.3;
    xs=cenx-vw*vamp;
    xe=cenx+vw*vamp;
    ys=ceny-vh*vamp;
    ye=ceny+vh*vamp;
   
   
    window,n,style="nobox.gs",width=width,height=height;
    get_style,landscape, systems, legends, clegends;
    systems.viewport=[xs,xe,ys,ye];
    set_style, landscape, systems, legends, clegends        

    orient3;
    //orient3,0.5,2;
//light3, ambient=.6,diffuse=.4, specular=.7, sdir=[1,1,1];
//light3, ambient=.2,diffuse=.2, specular=.5, sdir=[1,1,1];
    //light3, ambient=.2,diffuse=.2, specular=.5, sdir=[1,1,1],spower=3;
light3, ambient=.2,diffuse=.8, specular=.9, sdir=[1,1,1],spower=3;
 setz3,7;
 //    pal,palname;
    return ;
}


func cagech(color,front=)
/* DOCUMENT cagech, black,front=1;
   DEFINITION cagech(color,front=)
   changes propaties of cage3.
   KEYWORDS: color --(char or RGB) color of backscreen of cage.
             front --(0/1) draw front three lims or not.        
   
   SEE ALSO:cage3

   <Example>
   win2;win3;
   kuti;
   lim3,2;
   cage3,1;
   cagech,cyan,front=1;
 
 */
{
  if(is_void(front))front=0;
  extern cage3_front;
  extern cage3_backscreen;
  if(!is_void(color))cage3_backscreen=color;
  cage3_front=front;
  cage3,0;cage3,1;
}

func get_light(nv,xyzv){
/* DOCUMENT get_light(nv, xyzv)
   DEFINITION get_light(nv,xyzv)
     returns 3D lighting for polygons with vertices XYZV.
     Difference from "get3_light" is that this function gives the
     same lighting as plwf(shade=1) and pl3surf.
     If NV is specified, XYZV should be 3-by-sum(nxyz), with NV being the
      list of numbers of vertices for each polygon (as for the plfp
      function).  If NV is not specified, XYZV should be a quadrilateral
      mesh, 3-by-ni-by-nj (as for the plf function).  In the first case,
      the return value is numberof(NV); in the second case, the
      return value is (ni-1)-by-(nj-1).
 
      The parameters of the lighting calculation are set by the
      light3 function.
   SEE ALSO: get3_light, get3_xy
 */
 local x ,y ,z;
    get3_xy, xyzv, x, y, z, 1;
return get3_light(transpose([x,y,z]), nv);
}


func get_light1(nv,xyzv){
/* DOCUMENT get_light(nv, xyzv)
     return 3D lighting for polygons with vertices XYZV.
     Difference from "get3_light" is that this function gives the
     same lighting as plwf(shade=1) and pl3surf.
     If NV is specified, XYZV should be 3-by-sum(nxyz), with NV being the
      list of numbers of vertices for each polygon (as for the plfp
      function).  If NV is not specified, XYZV should be a quadrilateral
      mesh, 3-by-ni-by-nj (as for the plf function).  In the first case,
      the return value is numberof(NV); in the second case, the
      return value is (ni-1)-by-(nj-1).
 
      The parameters of the lighting calculation are set by the
      light3 function.
   SEE ALSO: get3_light, get3_xy
 */
 local x ,y ,z;
    get3_xy, xyzv, x, y, z, 1;
return get3_light1(transpose([x,y,z]), nv);
}




func ro (nframe=,sav=,ster=,rotation=,speed=){
/* DOCUMENT    ro
or ro,rotation=3,speed=0.01,sav=1

DEFINITION ro (nframe=,sav=,ster=,rotation=,speed=)

rotates 3D-plottings with mouse.

 Rotate: Left drag
 Zoom/Pan: Ctrl + Left drag (up/down)
 Move: Shift + Left drag
 Switch rotation mode: Ctrl + Right
 End: Shift + Right
 Rotation animation: Right drag
 
 <During rotation animation (controlled by idl)>
 Pause/Restart: Right
 End animation: Shift + Right
 Rotation mode: Ended
 
   KEYWORDS: 
   SEE ALSO: mouse,idl

<Example>
win2;win3;
clear3;
kuti;
lim3,1.5;
cage3,1;
draw3,1;
scale,0.8;
ro;

*/
  write,"Rotation mode: Started";
  write,"";
  write,"Rotate: Left drag";
  write,"Zoom/Pan: Ctrl + Left drag (up/down)";
  write,"Move: Shift + Left drag";
  write,"Switch rotation mode: Ctrl + Right";
  write,"End: Shift + Right";
  write,"Rotation animation: Right drag";
  write,"";
  write,"<During rotation animation>";
  write,"Pause/Restart: Right";
  write,"End animation: Shift + Right";
  write,"";

  local xx,yy,z;
  
if(is_void(nframe))nframe=50000;
if(is_void(sav))sav=0; 
 if(is_void(rotation))rotation=0;
 if(is_void(speed))speed=0.1;
 flag_ro_axis=0;
 ro_amp=0.1;
do {
  x=array(0,11);
  if(rotation==0){
  x= mouse(1, 2,"");
  }
  li = limits();
  rox = (x(2)-x(4))/(li(4)-li(3));
  roy = (x(3)-x(1))/(li(2)-li(1));


  
if (x(10)==1){

  if(x(11)==4){
        ddy=((x(2)-x(4))/(li(4)-li(3)));
                ddx=((x(1)-x(3))/(li(2)-li(1)));
                ddr=sqrt(ddx^2+ddy^2);
            
                if(ddr<0.0001){
                  limits;
                }else{
                amp = exp(2.0*ddy);
                amp_pow=2*abs(ddy)/ddr;
                amp=amp^amp_pow;
                limits, x(1)-amp*(x(1)-li(1)),x(1)+amp*(li(2)-x(1)),x(2)-amp*(x(2)-li(3)),x(2)+amp*(li(4)-x(2));
                }
                            
  }else if(x(11)==0){

    if(flag_ro_axis==1){
      xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
      get3_xy, xyz, xx, yy, z, 1;
      xbuf=xx;ybuf=yy;
      xx-=xx(1);yy-=yy(1);
      xx=xx(2:);yy=yy(2:);
      rr=abs(xx,yy);
      xx=xx/rr;yy=yy/rr;
      roy=(x(4)-x(2))/(li(4)-li(3));
      rox=(x(3)-x(1))/(li(2)-li(1));
            
      ro_axis=abs(xx*rox +yy*roy)(mnx);
      dro=-2*(xx*roy -yy*rox)(ro_axis);
      
            
      if(ro_axis==3)rot3_ho,,,dro;
      if(ro_axis==1)rot3_ho,dro,,;
      if(ro_axis==2)rot3_ho,,dro,;
    }
    else{
        rot3,4*rox,4*roy;
    }
    
  }
    draw3,1;
    //      if(ster==1)stdraw3;
  /*
  xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
      get3_xy, xyz, xx, yy, z, 1;
      
plgl,2*yy([1,2]),2*xx([1,2]),color=red;
plgl,2*yy([1,3]),2*xx([1,3]),color=red;
plgl,2*yy([1,4]),2*xx([1,4]),color=red;
plgl,[-x(2)+x(4),0],[-x(1)+x(3),0],color=blue;
  */
}

 if(x(10)==2){
    
        limits,li(1)+(x(1)-x(3)),li(2)+(x(1)-x(3)),li(3)+(x(2)-x(4)),li(4)+(x(2)-x(4));
    
}

 
 if((x(10)==3)+(rotation>0)){
   
   if(x(11)==1){
     write,"Rotation mode: Ended"
       return;
   }
   if(x(11)==4){
     if(flag_ro_axis==0){flag_ro_axis=1;write,"Rotation along axis: On";}
     else{flag_ro_axis=0;write,"Rotation along axis: Off";}
   }else{
     write,"   Animation mode: Started";     
     ro_axis=0;
     dro=0.0;
     //x(11);
     if(flag_ro_axis==1){
      //write,"a";
        xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
        get3_xy, xyz, xx, yy, z, 1;
        xbuf=xx;ybuf=yy;
        xx-=xx(1);yy-=yy(1);
        xx=xx(2:);yy=yy(2:);
        rr=abs(xx,yy);
        xx=xx/rr;yy=yy/rr;
        roy=(x(4)-x(2))/(li(4)-li(3));
        rox=(x(3)-x(1))/(li(2)-li(1));
        
        ro_axis=abs(xx*rox +yy*roy)(mnx);
        dro=-2*(xx*roy -yy*rox)(ro_axis);
    }

    orig= save3();
    if(ster==1)stanimate,1;
    else animate,1;
    if(rotation>0){
      dro=speed;
      x(11)=1;
      ro_axis=rotation;
      rotation=0;
    }
   
    for(i=0; i<nframe;i++){
      if(flag_ro_axis==1){
        if(ro_axis==3)rot3_ho,,,dro*0.2*ro_amp;
        if(ro_axis==1)rot3_ho,dro*0.2*ro_amp,,;
        if(ro_axis==2)rot3_ho,,dro*0.2*ro_amp,;
      }else{
        rot3,rox*0.5*ro_amp,roy*0.5*ro_amp;
      }
      
      draw3,1;redraw;  
      if(ster==1)stdraw3;
      if(idl(0))break;
      
    }
    
    if(ster==1){
        stanimate,0;
        if(sav)restore3, orig;
        stdraw3;
        _draw3_changes=1
            draw3,1;
    }
    else {
      write,"   Animation mode: Ended";     

        animate,0;
        if(sav)restore3, orig;
    }
 }  
 }
}while(1);

 write,"Rotation mode: Ended";
}






func make_xyz(z,y,x,&nv,&xyzv,&colorv,cv=)
  /* DOCUMENT make_xyz,z,y,x,nv,xyzv
           or make_xyz,z,y,x,nv,xyzv,colorv,cv=1

     DEFINItioN make_xyz(z,y,x,&nv,&xyzv,&colorv,cv=)
     
     converts a quadrilateral mesh plotted using plf, plc,
     plfc and plwf to a polygon list plotted using pl3surf and pl3tree. 

     KEYWORDS:cv -- 1/0: output color value on each vertics by "get3_light" 
     SEE ALSO: xyz_wf, get3_light

     <Example>
     x= span(-3,3,32)(,-:1:32);
     y= transpose(x);
     z= sin(2*sqrt(x^2+y^2))+cos(x+y+0.13);
     make_xyz,z,y,x,nv,xyzv;

     win2;win3;
     pl3surf,nv,xyzv;
     lim3,3,3,6;
     cage3,1;
     draw3,1;
     scale,0.9;

   */
{
  
    xyzv= xyz_wf(z,y,x);
    ni= dimsof(z)(2);
    nj= dimsof(z)(3);
    list= indgen(1:ni-1)+ni*indgen(0:nj-2)(-,);
    xyzv= xyzv(,([0,1,ni+1,ni]+list(-,))(*));
    
    nv= array(4, (ni-1)*(nj-1));
    
    if(!is_void(cv)){
    colorv=array(0.0,ni,nj);
    mask=array(0,ni,nj);
    pv=array(0.0,ni-1,nj-1);
      pv(*) = get_light(nv, xyzv);
      colorv(1:ni-1,1:nj-1)+=pv;
      colorv(2:ni,1:nj-1)+=pv;
      colorv(1:ni-1,2:nj)+=pv;
      colorv(2:ni,2:nj)+=pv;
      mask(1:ni-1,1:nj-1)+=1;
      mask(2:ni,1:nj-1)+=1;
      mask(1:ni-1,2:nj)+=1;
      mask(2:ni,2:nj)+=1;
      colorv = colorv/double(mask);

      list= indgen(1:ni-1)+ni*indgen(0:nj-2)(-,);
    colorv= colorv(([0,1,ni+1,ni]+list(-,))(*));
    
      }
    return ;
    
}

  
  


func rot3v(xyzv,norm)
/* DOCUMENT rotate vertices by the angle between "norm" and [0,0,1].

   KEYWORDS: norm -- [xvalue,yvalue,zvalue].
     
   SEE ALSO:
 */
{
  v=xyzv;
  norm = double(norm);
  
  rxy=abs(norm(1),norm(2));
  rxyz=abs(norm(1),norm(2),norm(3));
  
  
  cphi=norm(3)/rxyz;
  sphi=rxy/rxyz;  
  buf=v(3,);
    v(3,)=cphi*buf-sphi*v(1,);
  v(1,)=sphi*buf+cphi*v(1,);
 
  
  
  if(rxy>0){
    ctheta=norm(1)/rxy;
    stheta=norm(2)/rxy;
    
  buf=v(1,);
    
  v(1,)=ctheta*buf-stheta*v(2,);
  v(2,)=stheta*buf+ctheta*v(2,);

  }
  return v;
}

func rotv3v(xyzv,norm)
{
    
    v=xyzv;
    norm=double(norm);
    
  rxy=abs(norm(1,),norm(2,))+1.0e-10;
  rxyz=abs(norm(1,),norm(2,),norm(3,));
  
  
  cphi=norm(3,)/rxyz;
  sphi=rxy/rxyz;
  
    ctheta=norm(1,mas)/rxy;
    stheta=norm(2,mas)/rxy;

    buf=v(1,);
    v(1,)=ctheta*buf-stheta*v(2,);
    v(2,)=1.0*stheta*buf+ctheta*v(2,);
  
  buf=v(3,);
    v(3,)=cphi*buf-sphi*v(1,);
  v(1,)=sphi*buf+cphi*v(1,);
 
  
  
  buf=v(1,);
    
  v(1,)=ctheta*buf-stheta*v(2,);
  v(2,)=stheta*buf+ctheta*v(2,);
  
  
  
  return v;
}

func lim3(x,y,z,aspect=)
/* DOCUMENT lim3, x_range
   or lim3, x_range, y_range, z_range
   or lim3, x, y, z
   or lim3, xyzv
   
   DEFINITION lim3(x,y,z,aspect=)

   A short-name version of limit3.
   
   SEE ALSO:limit3

   <Example>
   win2;win3;
   kuti;
   lim3,2;
   cage3,1; 
 */
{
  if(dimsof(x)(1)==0){
      if(is_void(z)){
        limit3,-x,x,-x,x,-x,x;
      }else{
        limit3,-x,x,-y,y,-z,z;
      }
  }
  if(dimsof(x)(1)==1){
      limit3,min(x),max(x),min(y),max(y),min(z),max(z),aspect=aspect;
    }
  if(dimsof(x)(1)==2){
      limit3,min(x(1,)),max(x(1,)),min(x(2,)),max(x(2,)),min(x(3,)),max(x(3,)),aspect=aspect;
    }
    

    
}


func lim32(theta,phi)
/* DOCUMENT lim32,0,0;
   DEFINITION lim32(theta,phi)

   Adjust the relationship between 3D-cage and viewpot.
   
   SEE ALSO:limit3

   
 
 */
{
    if(is_void(theta))theta=0;
    //if(is_void(pi))phi=0.5*pi;
    if(is_void(pi))phi=0.0;
    setz3;
    limit3,-0.5,0.5,-0.5,0.5,-0.5,0.5;
    orient3,theta,phi;
    //orient3,phi,theta;
}

func lim32xz(void)
  /* DOCUMENT lim32xz;
   DEFINITION func lim32xz(void)

   Adjusts the rotation and scale of plottings so that the scales of x- and z-axes in "win2" coincide with those of x- and z-axes on the 3D-cage.
   
   SEE ALSO:limit3

   <Example>
   win2;
   read_poly(nv,xyzv,"~/Yorick/poly/kuti.poly");
   pl3surf,nv,xyzv*0.3;
   cage3,1;
   draw3,1;
   lim32xz;
 
   limits,-0.7,0.7,-0.7,0.7;
   xyt,"x","z";
*/
{
  lim32,0,0;
}
func lim32xy(void)
/* DOCUMENT lim32xy;
   DEFINITION func lim32xy(void)

   Adjusts the rotation and scale of plottings so that the scales of x- and y-axes in "win2" coincide with those of x- and y-axes on the 3D-cage.
   
   SEE ALSO:limit3

   <Example>
   win2;
   read_poly(nv,xyzv,"~/Yorick/poly/kuti.poly");
   pl3surf,nv,xyzv*0.3;
   cage3,1;
   draw3,1;
   lim32xy;
 
   limits,-0.7,0.7,-0.7,0.7;
   xyt,"x","y";
*/
{
  lim32,0,0.5*pi;
}
func lim32yz(void)
/* DOCUMENT lim32yz;
   DEFINITION func lim32yz(void)

   Adjusts the rotation and scale of plottings so that the scales of x- and y-axes in "win2" coincide with those of x- and y-axes on the 3D-cage.
   
   SEE ALSO:limit3

   <Example>
   win2;
   read_poly(nv,xyzv,"~/Yorick/poly/kuti.poly");
   pl3surf,nv,xyzv*0.3;
   cage3,1;
   draw3,1;
   lim32yz;
 
   limits,-0.7,0.7,-0.7,0.7;
   xyt,"y","z";
*/
{
  lim32,0.5*pi,0;
}

func write_poly(nv,vv,file)
/* DOCUMENT write_poly,nv,vv,file
   DEFINITION write_poly(nv,vv,file)

   writes polygon data for pl3surf and pl3tree to a text file.
   
   SEE ALSO: read_poly

   <Example>

   read_poly,nv,xyzv,"p~/Yorick/oly/tetra.poly";
   win2,n=0;win3;
   pl3surf,nv,xyzv;
   lim3,xyzv;
   
   nv1=nv;
   xyzv1=xyzv;
   xyzv1(3,)=xyzv1(3,)^3;

   win2,n=1;win3;
   write_poly,nv1,xyzv1,"test.poly";
   read_poly,nv2,xyzv2,"test.poly";
   pl3surf,nv2,xyzv2;
   lim3,xyzv2;
*/

{
  f=open(file,"w");
  write,f,numberof(nv);
  write,f,nv;
  write,f,"\n";
  write,f,vv;
  close,f;
}

func read_poly(&nvv,&vvv,file)
/* DOCUMENT read_poly,nv,vv,file
   DEFINITION read_poly(nv,vv,file)

   read polygon data for pl3surf and pl3tree from a text file.
   
   SEE ALSO: write_poly

   <Example>

   read_poly,nv,xyzv,"~/Yorick/poly/tetra.poly";
   win2,n=0;win3;
   pl3surf,nv,xyzv;
   lim3,xyzv;
   
   nv1=nv;
   xyzv1=xyzv;
   xyzv1(3,)=xyzv1(3,)^3;

   win2,n=1;win3;
   write_poly,nv1,xyzv1,"test.poly";
   read_poly,nv2,xyzv2,"test.poly";
   pl3surf,nv2,xyzv2;
   lim3,xyzv2;
*/
{
  f=open(file,"r");
  nnvv=0;
  
  read,f,nnvv;
  nvv=array(0,nnvv);
  
  read,f,nvv;
  vvv=array(0.0,3,sum(nvv));
  read,f,vvv;
  close,f;
}

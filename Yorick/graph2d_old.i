
/*
  GRAPH2D.I
  Additional functions for graphics written by Hiroshi C. Ito. 2018
  
 */

/* functions in this file. (type "help, function_name" at yorick prompt for examples)

win2: changes window properties such as size, shape and ticks.

plgl:"plg" function with graph-legends on window.
plgf:"plg" function filling under the line with specified color.
plh: plots histogram from frequency data (with graph-legends as line segments).
plhf: plots histogram from frequency data (with graph-legends as filled boxes).
pler: plots error bars.

fp: plots line of specified function y=f(x).
fp2: plots a surface of 2D function f(x,y) with plwf.
fpfc: plots filled contour of 2D function z=f(x,y) with plfc.
cbfc: plots color bar with tickes for plfc function.
make_hist: make frequency data from raw data, and plot histogram.
hist2d: aggregates 2D dataset.
make_xy_plf: make x-y coordinates for plf.
xyt: plots titles for x- and y-axes with a slightly finer adjustment than xytitles.

pal: sets color palette.
cb: draws a color bar to the right of the plot by "plf" function.
fmal: resets plottings and graph-legend.
outpng: saves plottings in png format.
hcpng: saves plottings in png and/or eps format.

scalexy: scales plotting in horizontal and vertical directions separately.
scalex: scales plotting in horizontal direction.
scaley: scales plotting in vertical direction.
scale: scales plotting in horizontal and vertical directions by the same ratio.
I:short expression of "include" function.
*/
  
require,"style.i";


func I(file)
/* DOCUMENT I, file(without ".i")
   DEFINITION I(file)
     short-name version of "include, filename.i"
   SEE ALSO: include

   <Example>
   
   I,"graph2d"
   
 */
{
  include, file+".i";
  return;
}

func win2(width,height,axis=,hold=,n=,x_nMajor=,y_nMajor=,x_nMinor=,y_nMinor=,offset_w=,offset_h=,margin_w=,margin_h=,div_ratio=,div_ratio1=,div_margin=,dpi=,palname=)
/* DOCUMENT win2,400,250
   
   DEFINITION win2(width,height,axis=,hold=,n=,x_nMajor=,y_nMajor=,x_nMinor=,y_nMinor=,offset_w=,offset_h=,div_ratio=,div_ratio1=,div_margin=,dpi=)

   adjusts window for 2D-plot
   SEE ALSO: window

   <Example 1>
   win2,300,200
   fmal;
   fp,"sin(x)";
   
   <Example 2>   
   win2,n=0,axis=2;
   fmal;
   plsys,1;
   fp,"20*x^2";
   plsys,2;
   fp,"sin(x)";

   <Example 3>
   win2,500,200;
   kuti;
 */
{
extern viewport_center_x;
extern viewport_center_y;
extern my_legend_position;
    
    if(is_void(width)) width=400;
    if(is_void(height)) height=400;
    if(is_void(n)) n=0;
    if(is_void(axis))axis=1;
    if(axis==0)hold=1;
    if(is_void(offset_w))offset_w=0;
    if(is_void(offset_h))offset_h=0;
    if(is_void(div_ratio))div_ratio=0.5;
    if(is_void(div_ratio1))div_ratio1=0.5;
    if(is_void(div_margin))div_margin=0.0;
    if(is_void(margin_w))margin_w=60;
    if(is_void(margin_h))margin_h=60;
    
    //    rate=0.00035*1.25;
    rate=0.00035*1.5;

    cenx = viewport_center_x;
    //ceny =0.645;
    ceny =viewport_center_y;
    xs=cenx-(rate*(width-margin_w));
    xe=cenx+(rate*(width-margin_w));
    ys=ceny-(rate*(height-margin_h));
    ye=ceny+(rate*(height-margin_h));

    width=width+offset_w;
    height=height+offset_h;
    
    my_legend_position=[[xs,ye],[xe,ye]];


    if(axis==6){
      /*
      ye1=ye;
      ye2=ye;
      ys1=ys;
      ys2=ys;
      
      xs1=xs;
      xe1=div_ratio*(xe-xs)+xs;
      xs2=xe1;
      xe2=xe;
      */
      xe1=xe;
      xe2=xe;
      xs1=xs;
      xs2=xs;
      
      ys1=ys;
      ye1=div_ratio*(ye-ys)+ys;
      ys2=ye1;
      ye2=ye;
      my_legend_position=[[xs1,ye1],[xe1,ye1]];
    }
    if(axis==7){
      xdiv=div_ratio*(xe-xs)+xs;
      ydiv=div_ratio1*(ye-ys)+ys;
      
      xs3=xdiv+rate*div_margin;
      xe3=xe;
      xs4=xdiv+rate*div_margin;
      xe4=xe;
      
      ys3=ys;
      ye3=ydiv-rate*div_margin;
      ys4=ydiv+rate*div_margin;      
      ye4=ye;
      
      
      xe1=xdiv-rate*div_margin;
      xe2=xdiv-rate*div_margin;
      xs1=xs;
      xs2=xs;
      
      ys1=ys;
      ye1=ydiv-rate*div_margin;
      ys2=ydiv+rate*div_margin;
      ye2=ye;
      my_legend_position=[[xs1,ye1],[xe1,ye1]];
    }
    
    if(is_void(hold)){
        winkill,n;
        if(axis==-4){window,n,style=Y_DIR+"gs/my_box_no_ticks_white.gs",width=int(width),height=int(height);}
if(axis==-1){window,n,style=Y_DIR+"gs/my_box_no_ticks.gs",width=int(width),height=int(height);}
if(axis==-2){window,n,style=Y_DIR+"gs/my_box_no_labels.gs",width=int(width),height=int(height);}
        if(axis==-3){window,n,style=Y_DIR+"gs/my_box_no_ticks_y.gs",width=int(width),height=int(height);}
        
        if(axis==2){window,n,style=Y_DIR+"gs/my_box2.gs",width=int(width),height=int(height);}
        if(axis==3){window,n,style=Y_DIR+"gs/my_box2b.gs",width=int(width),height=int(height);}
        if(axis==4){window,n,style=Y_DIR+"gs/my_box2c.gs",width=int(width),height=int(height);}
        if(axis==5){window,n,style=Y_DIR+"gs/my_boxe.gs",width=int(width),height=int(height);}
        if(axis==6){window,n,style=Y_DIR+"gs/my_test_divide.gs",width=int(width),height=int(height);}
        if(axis==7){window,n,style=Y_DIR+"gs/my_test_divide4_noticks.gs",width=int(width),height=int(height),dpi=dpi;}
        
        if(axis==1){window,n,style=Y_DIR+"gs/my_box.gs",width=int(width),height=int(height),dpi=dpi;}
    }

    get_style,landscape, systems, legends, clegends;
    if(axis<6){
      systems.viewport=[xs,xe,ys,ye];
      if(axis==0){
        systems.ticks.horiz.flags=0x021;
        systems.ticks.vert.flags=0x021;
      }
      if(!is_void(x_nMajor))systems.ticks.horiz.nMajor=x_nMajor;
      if(!is_void(y_nMajor))systems.ticks.vert.nMajor=y_nMajor;
      if(!is_void(x_nMinor))systems.ticks.horiz.nMinor=x_nMinor;
      if(!is_void(y_nMinor))systems.ticks.vert.nMinor=y_nMinor;
    }
    
    if(axis==6){
      //systems.viewport=[[0.1757,0.25,0.4257,0.8643],[0.25,0.6143,0.4257,0.8643]];
           systems.viewport=[[xs1,xe1,ys1,ye1],[xs2,xe2,ys2,ye2]];
    }
    if(axis==7){
      //systems.viewport=[[0.1757,0.25,0.4257,0.8643],[0.25,0.6143,0.4257,0.8643]];
      systems.viewport=[[xs1,xe1,ys1,ye1],[xs2,xe2,ys2,ye2],[xs3,xe3,ys3,ye3],[xs4,xe4,ys4,ye4]];
    }
        
    set_style, landscape, systems, legends, clegends        
      if(is_void(palname))palname="earth";
      pal,palname;
 }




func pal (name,rev=)
/* DOCUMENT pal, name
   DEFINITION pal (name,rev=)
   sets color palette on palettename.gp.
   Palette files are at "palette" directory in Y_DIR.
   SEE ALSO: palette

   <Example>
   win2;
   kuti;
   pal,"sunrise";
   pal,"heat";
   pal,"gg";   
 */
{  
  if(!is_void(name)){
  str=".gp"
    stdir=Y_DIR+"palette/"
    str=stdir+name+str;
  palette,str;
  }
  if(rev==1){
    local r,g,b;
    palette,query=1,r,g,b;
        palette,r(::-1),g(::-1),b(::-1);
  }
  return;
}


func cb(cmin, cmax,ticks=,dxy=,w=,h=,sys=,dt=,label=)
/* DOCUMENT cb(cmin,cmax)
   DEFINITION cb(cmin, cmax,ticks=,dxy=,w=,h=,sys=,dt=,label=)
     plots a color bar to the right of the plot by "plf" function
     instead of "pli" function. 
     ("pli" function may cause some problems in output of images.)

     <Example>
     cb,0.0,1.0,ticks=[0.2,0.5,0.7],label=1;
 */
{
  if(is_void(dxy))dxy=[0,0];
  if(is_void(sys))plsys, 0;
 
  if(is_void(w))w = 0.02;
  if(is_void(h)) h = 0.2;

      get_style,landscape, systems, legends, clegends;

      x0 = systems.viewport(2)+dxy(1)+0.01;
      y0 = 0.5*(systems.viewport(3)+systems.viewport(4))-0.5*h+dxy(2);
      x1 = x0+w;
      y1 = y0+h;


  y = transpose(array(span(y0,y1,240),2));
  x = array(span(x0,x1,2),240);

  
  plf,y,y,x;



  plg, [y0,y1,y1,y0],[x1,x1,x0,x0], closed=1,
    marks=0,color="fg",width=1,type=1;
  if(!is_void(ticks)){
    if(is_void(dt))dt=0.005;
    dy=(y1-y0)/double(cmax-cmin);
    for(i=1;i<=numberof(ticks);i++){
      plg, array(dy*(ticks(i)-cmin)+y0,2), [x1+dt,x1],marks=0,color="fg",width=1,type=1;
      if(label==1)plt, pr1(ticks(i)), x1+2*dt,dy*(ticks(i)-cmin)+y0, justify="LH",color="black";
    
    
    }
  }
  
  if (!is_void(cmin)) {
    //plt, pr1(cmin), 0.5*(x0+x1),y0, justify="CT",color="black";
    //plt, pr1(cmax), 0.5*(x0+x1),y1, justify="CB",color="black";
  }
 if(is_void(sys)) plsys, 1;  /* assumes there is only one coordinate system */
}

func cbfc(z,levs=,colors=,dxy=,w=,h=,ticks=,label=)
/* DOCUMENT cbfc,z,levs=levs
   DEFINITION cbfc(z,levs=,colors=,dxy=,w=,h=,ticks=,label=)
   plots color bar with tickes for plfc function.
   SEE ALSO:

   <Example>
   win2;
   x= span(-3,3,128)(,-:1:128);
   y= transpose(x);
   z= 0.5*sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
   levs=span(-0.4,0.4,5);
   fma;
   plfc,z,y,x,levs=levs;
   limits;
   cbfc,z,levs=levs,ticks=1,label=1;

 */
{
  levs=double(levs);
  if(is_void(dxy))dxy=[0,0];
  if(is_void(sys))plsys, 0;
   if(is_void(ticks))ticks=0;
   if(is_void(label))label=0;
   
  if(is_void(w))w = 0.02;
  if(is_void(h)) h = 0.2;
  nx=2;
  ny=32;
  zmax=max(z);
  zmin=min(z);
  
  x=span(0,1,nx)(,-:1:ny);
  y=span(0,1,ny)(-:1:nx,);
  z=(zmax-zmin)*y+zmin;

  get_style,landscape, systems, legends, clegends;

  x0 = systems.viewport(2)+dxy(1)+0.01;
  y0 = 0.5*(systems.viewport(3)+systems.viewport(4))-0.5*h;
  x1 = x0+w;
  y1 = y0+h;

  x=x*w+x0+dxy(1);
  y=y*h+y0+dxy(2);
  
  plsys,0;
  if(!is_void(colors))plfc,z,y,x,levs=levs,colors=colors;
  else plfc,z,y,x,levs=levs;
  
  plg,[min(y),min(y),max(y),max(y)],[min(x),max(x),max(x),min(x)],closed=1,color=black,width=2;
  //write,"levs:",levs;

    if(ticks==1){
    if(is_void(dt))dt=0.005;
    plc,z,y,x,levs=levs,color=black,width=1;
    dy=(y1-y0)/(max(z)-min(z));
    for(i=1;i<=numberof(levs);i++){

      plg, array(dy*(levs(i)-min(z))+y0,2), [x1+dt,x1],marks=0,color="fg",width=1,type=1;
      if(label==1)plt, pr1(levs(i)), x1+2*dt,dy*(levs(i)-min(z))+y0, justify="LH",color="black";
    
    
    }
  }

  plsys,1;
}



func plgl(y,x,legend=,color=,type=,width=,position=,font=)
/* DOCUMENT plgl,y,x,legend=legend
   DEFINITION plgl(y,x,legend=,color=,type=,width=,position=,font=)
   
     "plg" function with legends on window.

     <Example>
     win2;
     x=span(0,6,64);
     fmal;
     plgl,sin(x),x,legend="sin(x)"
     plgl,cos(x),x,legend="cos(x)"
     plgl,(cos(x))^2,x,legend="cos(x)^2"
     scaley,0.8;
     
   SEE ALSO: plg
 */
  {
  extern my_legend_position;
  extern my_legend_number;
  extern my_legend_color;
  extern my_legend_outside,my_legend_side;
  l_length=0.02;

      get_style,landscape, systems, legends, clegends;
      my_legend_position=[[systems.viewport(1),systems.viewport(4)],[systems.viewport(2),systems.viewport(4)]];
      
if(is_void(y)){fma; my_legend_number=0;my_legend_color=-5;return;}
 if(is_void(color))color=my_legend_color;
 if(is_void(legend))legend="";
 if(my_legend_side=="right"){
   if(my_legend_outside==1){
     si=1.0;
     lp=my_legend_position(,2);
     just="LH";
   }else{
      si=-1.0;
     lp=my_legend_position(,2);
     just="RH";
   
   }
 }
 if(my_legend_side=="left"){
   if(my_legend_outside==0){
     si=1.0;
     lp=my_legend_position(,1);
     just="LH";
   }else{
     si=-1.0;
     lp=my_legend_position(,1);
     just="RH";
  
   }
 }
 marg_h=-0.02;
 marg_w=0.01;marg_b=0.005;
 dleg=my_legend_height*0.0015;
 lx=lp(1)+si*marg_w;
 ly=lp(2)+marg_h-my_legend_number*dleg;
  plg,y,x,color=color,type=type,width=width,legend=legend;
 if(!omit_legend){
     plsys,0;
     plg,[ly,ly],[lx,lx+si*l_length],color=color,type=type,width=width,legend="";
     plt,legend,lx+si*(l_length+marg_b),ly,justify=just,color="black",height=my_legend_height,font=font;

     redraw;
     plsys,1;
 }
 my_legend_number++;
 
 my_legend_color--;
 return;
}	

func fmal(void)
/* DOCUMENT fmal
   DEFINITION fmal(void)
   resets plottings and graph-legend.
   SEE ALSO: fma
 */
{
  plgl;
}

func fp(formula,xs,xe,color=,legend=)
/* DOCUMENT fp,formula
   fp(formula,xs,xe,color=,legend=)
plots 1D function

<Example>
win2;
fp,"sin(x)";
 */
{
    if(is_void(xs)) xs=0;
    if(is_void(xe)) xe=2.0;
    if(is_void(legend))legend=formula;
f = open(Y_DIR+"buf/buf.i","w");
write,f,"func function (x){ \n return " ,formula, ";}";

close,f;
include,Y_DIR+"buf/buf.i",1;

x = span(xs,xe,128);
y = function(x);

 plgl,y,x,legend=legend,color=color;
 limits;
return;
}

func fp2(formula,xs,xe,ys,ye,shade=,edges=,ecolor=,cmax=)
/* DOCUMENT fp2,formula
   DEFINITION fp2(formula,xs,xe,ys,ye,shade=,edges=,ecolor=,cmax=)
   plots a surface of 2D function f(x,y) with plwf.
   SEE ALSO: plwf, fp
   
   <Example>
   win2;win3;
   fp2,"sin(sqrt(x^2+y^2))",-5,5
 */
{
    if(is_void(xs)) xs=-2.0;
    if(is_void(xe)) xe=2.0;
    if(is_void(ys))ys=xs;
    if(is_void(ye))ye=xe;
    if(is_void(shade))shade=1;
   if(is_void(edges))edges=0;
   
    
    
f = open(Y_DIR+"buf.i","w");
write,f,"func function (x,y){ \n return " ,formula, ";}";

close,f;
include,Y_DIR+"buf.i",1;

x = span(xs,xe,64)(,-:1:64);
 y = transpose(x); 
z = function(x,y);
fma;
 if(is_void(cmax))cmax=max(z)*3; 
 plwf,z,y,x,shade=shade,edges=edges,ecolor=ecolor,cmax=cmax;
 cage3,1;
 limit3,xs,xe,ys,ye,min(z),max(z);
 setz3,40;
 orient3;
return;
}

func fpfc(formula,xs,xe,ys,ye,levs=,zero=,shade=,ho=,nn=)
/* DOCUMENT fpfc,formula
   DEFINITION fpfc(formula,xs,xe,ys,ye,levs=,zero=,shade=,ho=,nn=)
   plots filled contour of specified 2D function z=f(x,y) with plfc.
   SEE ALSO: plfc, cbfc

   <Example>
   win2;
   fpfc,"sin(sqrt(x^2+y^2))",-5,5
   
 */
{
    if(is_void(xs)) xs=-2.0;
    if(is_void(xe)) xe=2.0;
    if(is_void(ys))ys=xs;
    if(is_void(ye))ye=xe;
    if(is_void(nn))nn=64;
    if(is_void(shade))shade=1;
    
   
   
    
    
f = open(Y_DIR+"buf/buf.i","w");
write,f,"func function (x,y){ \n return " ,formula, ";}";

close,f;
include,Y_DIR+"buf/buf.i",1;

x = span(xs,xe,nn)(,-:1:nn);
 y = transpose(x); 
z = function(x,y);
if(is_void(ho))fma;
if(shade==1){
if(is_void(levs))levs=span(min(z),max(z),10); 
plfc,z,y,x,levs=levs;
}
if((!is_void(zero))&&(min(z)*max(z)<0))plc,z,y,x,levs=[0.0],color=zero;
limits;
return;
}


func make_hist(x,w,&yy,&xx,dl=,out=,ecol=,fcol=,average=,legend=,offset=,ho=,width=)
/* DOCUMENT makehist,x;
   or makehist,x,w,yy,xx,dl=dl,out=1
   DEFINITION make_hist(x,w,&yy,&xx,dl=,out=,ecol=,fcol=,average=,legend=,offset=,ho=,width=)
   
   KEYWORDS: dl -- width of division of data.
            out -- output histogram data yy and xx for other plot function. 
           ecol -- edge color.
           fcol -- filling color.

   makes histgram and plot it.        
         
   SEE ALSO: plh, histogram

   <Example>

   win2;
   make_hist,random(100),dl=0.1,fcol=green,legend="random";
   scaley,0.8;
   
 */
{ 
  if(is_void(dl)) dl=1.0;
  if(is_void(w)) w=x*0+1.0;
  if(is_void(out))out=0;
  
  if(is_void(offset))offset=-int(min(x)-1);
    //else offset=-min(x);
  
  
  
 yy=histogram(int((offset+x)/dl+1.5),w);
 xx=(indgen(numberof(yy))-1)*dl-offset;
 if(average==1){
 ysum=histogram(int((offset+x)/dl+1.5));
 yy(where(ysum))/=ysum(where(ysum));
 }
 if(out==0){
 if(is_void(ho))plgl; 
 plh,yy,xx,ecol=ecol,fcol=fcol,legend=legend,width=width;limits;
 }
 
 
}



func plh(y,x,ecol=,width=,fcol=,legend=,type=)
/* DOCUMENT plh,y,x
   DEFINITION plh(y,x,ecol=,width=,fcol=,legend=,type=)
     plots a histogram (Manhattan plot) of Y versus X.  That is,
     the result of a plh is a set of horizontal segments at the Y
     values connected by vertical segments at the X values.
   KEYWORDS: marks, color, type, width
   SEE ALSO: plg

   <Example>
   
   win2;     
   make_hist,random(100),array(1,100),yy,xx,dl=0.1,out=1;
   fmal;
   plh,yy,xx,ecol=red,fcol=blue,legend="random";
   scaley,0.8;
   scalex,0.8;
   
 */
{
  if(is_void(ecol))ecol=blue;
  x = grow(x(1)-(x(2)-x(1)),x)+0.5*(x(2)-x(1));
  
  swap= numberof(x)<numberof(y);
  if (swap) { yy= y; y= x; x= yy; }
  yy= xx= array(0.0, 2*min(numberof(y),numberof(x)));
  yy(1:-1:2)= yy(2:0:2)= y;
  xx(2:-2:2)= xx(3:-1:2)= x(2:-1);
  xx(1)= x(1);
  xx(0)= x(0);

  if (swap) { y= yy; yy= xx; xx= y; }
  
  fy=grow(0.0,yy,0.0);
  fx=grow(xx(1),xx,xx(numberof(xx)));
  fn=[numberof(fy)];
 
  fc=[char(fcol)];
  
  if(!is_void(fcol))plfp,fc,fy,fx,fn;
  
  plgl, fy, fx, color=ecol,width=width,legend=legend,type=type;
  
}


func plhf(y,x,ecol=,width=,fcol=,legend=,type=,l_width=,l_length=,font=,height=)
/* DOCUMENT plhf,y,x
   DEFINITION plhf(y,x,ecol=,width=,fcol=,legend=,type=,l_width=,l_length=,font=,height=)
     plots a histogram (Manhattan plot) of Y versus X with a legend with plfp.
   KEYWORDS: ecol, width, fcol, legend, type
   SEE ALSO: plgl,plh

   <Example>

   win2;     
   make_hist,random(100),array(1,100),yy,xx,dl=0.1,out=1;
   fmal;
   plhf,yy,xx,ecol=red,fcol=blue,legend="random";
   scaley,0.8;
   scalex,0.8;
 
 */
{
  extern my_legend_position;
  extern my_legend_number;
  extern my_legend_color;
  if(is_void(l_width))l_width=0.008;
  if(is_void(l_length))l_length=0.02;
  
  if(is_void(ecol))ecol=blue;
  x = grow(x(1)-(x(2)-x(1)),x)+0.5*(x(2)-x(1));
  
  swap= numberof(x)<numberof(y);
  if (swap) { yy= y; y= x; x= yy; }
  yy= xx= array(0.0, 2*min(numberof(y),numberof(x)));
  yy(1:-1:2)= yy(2:0:2)= y;
  xx(2:-2:2)= xx(3:-1:2)= x(2:-1);
  xx(1)= x(1);
  xx(0)= x(0);

  if (swap) { y= yy; yy= xx; xx= y; }
  
  fy=grow(0.0,yy,0.0);
  fx=grow(xx(1),xx,xx(numberof(xx)));
  fn=[numberof(fy)];
 
  fc=[char(fcol)];
  
  if(!is_void(fcol))plfp,fc,fy,fx,fn;
  
//plgl, fy, fx, color=ecol,width=width,legend=legend,type=type;
  plg, fy, fx, color=ecol,width=width,type=type;

  //l_length=0.02;
//if(is_void(y)){fma; my_legend_number=0;my_legend_color=-5;return;}
//if(is_void(color))color=my_legend_color;
 if(is_void(legend))legend="";
 if(my_legend_side=="right"){
     si=-1.0;
     lp=my_legend_position(,2);
     just="RH";
 }
 if(my_legend_side=="left"){
     si=1.0;
     lp=my_legend_position(,1);
     just="LH";
 }
 marg_h=-0.02;
 marg_w=0.01;marg_b=0.005;
 dleg=my_legend_height*0.0015;
 lx=lp(1)+si*marg_w;
 ly=lp(2)+marg_h-my_legend_number*dleg;
//plg,y,x,color=color,type=type,width=width,legend=legend;
 if(!omit_legend){
     plsys,0;
     //   plg,[ly,ly],[lx,lx+si*l_length],color=color,type=type,width=width,legend="";
     //plfp,fc,fy,fx,fn;
     //l_width=0.009;
     ldx=si*l_length;
     plfp,fc,[ly-l_width,ly-l_width,ly+l_width,ly+l_width],[lx,lx+ldx,lx+ldx,lx],[4];
     plg,[ly-l_width,ly-l_width,ly+l_width,ly+l_width],[lx,lx+ldx,lx+ldx,lx],color=ecol,type=type;
     plt,legend,lx+si*(l_length+marg_b),ly,justify=just,color="black",height=my_legend_height,font=font,height=height;

     redraw;
     plsys,1;
 }
 my_legend_number++;
 
 my_legend_color--;
 return;
}	


func plgf(y,x,lcolor=,lwidth=,fcolor=)
/* DOCUMENT plgf,y,x
   DEFINITION plgf(y,x,lcolor=,lwidth=,fcolor=)
   draws line and fill the region between the line and x-axis.

   <Example>
   
   win2;
   x=span(0,6,64);
   y=sin(x);
   plgf,y,x;
   SEE ALSO: plg, plh
 */
{
  if(is_void(fcolor))fcolor=250;
  x=grow(x(1),x,x(numberof(x)));
  y=grow(0.0,y,0.0);
  plfp,[char(fcolor)],y,x,[numberof(x)];
  plg,y,x,width=width,color=lcolor;
  return;
}




func xyt (xtitle, ytitle,adjust=,color=,height=,font=)
/* DOCUMENT xyt, xtitle, ytitle
   DEFINITION xyt (xtitle, ytitle,adjust=,color=,height=,font=)
   plots titles for x- and y-axes with a slightly finer adjustment than xytitles.
   <Example>
   
   win2;
   fp,"x^2";
   xyt,"Time","Distance";
   
   SEE ALSO: xytitles
 */
{
  if (is_void(adjust)) adjust= [0.,0.];
  if (is_void(color)) color= black;
  if(is_void(height))height=18;
  adjust+= [0.02,0.02]
  port= viewport();
  if (xtitle && strlen(xtitle))
    plt, xtitle, port(zcen:1:2)(1), port(3)-0.050+adjust(1),
      justify="CT",height=height,color=color,font=font;
  if (ytitle && strlen(ytitle))
    plt, ytitle, port(1)-0.050+adjust(2), port(zcen:3:4)(1),
      justify="CB", orient=1,height=height,color=color,font=font;
  
}



func outpng (ofile,view=,t=)
/* DOCUMENT outpng, ofile
   DEFINITION outpng (ofile,view=)
   saves plottings in png format.

   Calling "outpng" just after "win2" in a script may cause error. In such a case, "pause, 100" just before "outpng" can settle it down, as in <Example>. 
   SEE ALSO: hcps,hcpng, pause

   <Example>
   
   win2;
   fmal;
   fpfc,"sin(sqrt(x^2+y^2))",-5,5;
   {pause,100;outpng,"test";}
 */
{
  require,"png.i";
  
  if(is_void(view))view=1;

  if(is_void(ofile)){
    cwd=get_cwd();
    cd,Y_DIR+"buf";
    bufname="png_buf.png";
    if(!is_void(t)){
      bufname=swrite(format="frame%d%d%d%d%d.png",t%100000/10000,t%10000/1000,t%1000/100,t%100/10,t%10);
      view=0;
    }
    png2,bufname;
    cd,cwd;
    ofile=Y_DIR+"buf/"+bufname;
    if(view==1)system,viewer_bin+" "+ofile+" &";    
    
  }else{
    ofile=ofile+".png";
    png2,ofile;
    if(view==1)system,viewer_bin+" "+ofile+" &";    
  }
  write,"png output:",ofile;
  
}

func hcpng (name,dens,geom,epsi=,outps=,view=,bgcolor=,alpha=,t=)
/* DOCUMENT hapng, name
   DEFINITION hcpng (name,dens,geom,epsi=,outps=,view=,bgcolor=,alpha=)
   saves plotting in png and/or eps format.
   SEE ALSO: outpng, hcps

   <Example>

   win2;
   fmal;
   fpfc,"sin(sqrt(x^2+y^2))",-5,5;
   xyt,"x","y";
   hcpng,"test",300,400;
   
 */
{
  extern convert_bin,viewer_bin;
  if(is_void(view))view=1;
  if(is_void(outps))outps=0;
    if(is_void(dens))dens=100;
 
    if(is_void(epsi))epsi=1;
    if(name=="")name=Y_DIR+"buf/png_buf";
    if(is_void(name))name=Y_DIR+"buf/png_buf";
    if(!is_void(t)){
      name=Y_DIR+"buf/"+swrite(format="frame%d%d%d%d%d",t%100000/10000,t%10000/1000,t%1000/100,t%100/10,t%10);
      view=0;
    }

    psname=name;
    name=name+".png";
    
    if(is_void(bgcolor))bgcolor="white";
    if(is_void(alpha))alpha=0;
    bufdir="";
    outdir="";
    if(name=="png_buf")outdir=bufdir;
    hcps,(bufdir+name);suf=".ps";
    if(epsi==1){
        system, swrite(format="ps2epsi %s.ps %s.eps ", name,name);
        suf=".eps";
        remove,(name+".ps");    
    }
    
    write,"postscript output:",(name+suf);
    
        
        if(is_void(geom)){

          system,convert_bin+swrite(format=" -density %ix%i  %s %s",dens,dens,name+suf,name);
        }else{
          
          system,convert_bin+swrite(format=" -density %ix%i -geometry %ix%i %s %s",dens,dens,geom,geom,name+suf,name);
          
        
        }
        if(outps==0){
            remove,name+suf;
        
        }
       if(outps==1){
          rename,name+suf,psname+suf;
          remove,name+suf;
          write,"ps output:",psname+suf;
          if(((view==2)+(view==3))>0){
          system,swrite(format="gv %s  &", name);
        }
        }
 
       if(alpha==0)system,convert_bin+swrite(format=" %s -bordercolor %s -border 10x10 -background %s -alpha remove -flatten %s", name,bgcolor,bgcolor,name);
        write,"png output:",name;
        
        if(((view==1)+(view==3))>0)system,viewer_bin+swrite(format="  %s  &", name);

        
         
}


func outeps(name,t=){
  if(name=="")name=Y_DIR+"buf/png_buf";
  if(is_void(name))name=Y_DIR+"buf/png_buf";

  if(!is_void(t)){
    name=Y_DIR+"buf/"+swrite(format="frame%d%d%d%d%d",t%100000/10000,t%10000/1000,t%1000/100,t%100/10,t%10);
    view=0;
  }
  
  hcps,name;
  system, swrite(format="ps2epsi %s.ps %s.eps", name,name);
  system, swrite(format="rm %s.ps", name);
  write,"eps output:",name+".eps";
}

func outps(name,t=){
  if(name=="")name=Y_DIR+"buf/png_buf";
  if(is_void(name))name=Y_DIR+"buf/png_buf";

  if(!is_void(t)){
    name=Y_DIR+"buf/"+swrite(format="frame%d%d%d%d%d",t%100000/10000,t%10000/1000,t%1000/100,t%100/10,t%10);
    view=0;
  }
  
  hcps,name;
  write,"eps output:",name+".ps";
}


func pler(y,x,ey,ewidth=,elog=,color=,width=)
/* DOCUMENT pler, y, x, ey;
   DEFINITION pler(y,x,ey,ewidth=,elog=,color=,width=)
   plots error bars.
   
   SEE ALSO: plmk, plg

   <Example>
   
   x=span(1,6,20);
   y=sin(x);
   ey=0.1+0.5*sin(x);

   win2,n=0;
   fmal;
   pler,y,x,ey,elog=0,ewidth=0.1
   plmk,y,x,msize=0.3,marker=3;
  
 */
{
    if(is_void(ewidth))ewidth=0.005;    

if(elog==1) {
    delx=(limits()(2)/limits()(1))^(-ewidth);
    rx=x*(delx);
    lx=x/(delx);
}
    else{
    delx=(limits()(2)-limits()(1))*ewidth;
    rx=x+delx;
    lx=x-delx;
}


uy=y+ey;
ly=y-ey;

 pldj,x,ly,x,uy,color=color,width=width;
pldj,lx,ly,rx,ly,color=color,width=width;
pldj,lx,uy,rx,uy,color=color,width=width;
}



func make_xy_plf(y,x,&yy,&xx,lo=)
/* DOCUMENT make_xy_plf,y,x,yy,xx
   DEFINITION make_xy_plf(y,x,&yy,&xx,lo=)
   generates x-y corrdinates for plf.
   
   SEE ALSO: plf
   
   <Example>

   nn=8;
   x=span(-1,1,nn)(,-:1:nn);
   y=span(-1,1,nn)(-:1:nn,);
   z=sin(x^2+y^2+y+x);
   win2,n=0;
   fma;plf,z,y,x;

   make_xy_plf,y,x,yy,xx;
   win2,n=1;
   fma;plf,z,yy,xx;
 */

{
    if(is_void(lo)){
    xx=x;
    yy=y;
    }
    else{
    xx=log(x);
    yy=log(y);
    }
    
    dx=(xx(,1))(dif)(1);
    dy=(yy(1,))(dif)(1);
    
    xx1=xx(pcen,pcen);
    yy1=yy(pcen,pcen);
    
    xx1(1,)-=0.5*dx;
    xx1(0,)+=0.5*dx;
    yy1(,1)-=0.5*dy;
    yy1(,0)+=0.5*dy;
    
    if(!is_void(lo)){
    xx1=exp(xx1);
    yy1=exp(yy1);
    }
    xx=xx1;
    yy=yy1;
    
}


func hist2d(z,y,x,&zz,&yy,&xx,kx=,ky=,cut=,lo=)
/* DOCUMENT hist2d, z,y,x,zz,yy,xx
   DEFINITION hist2d(z,y,x,&zz,&yy,&xx,kx=,ky=,cut=,lo=)
   aggregates 2D dataset.
   
   SEE ALSO: make_hist

   <Example>
      
   nx=100;
   ny=110;
   kx=6;
   ky=6;
   x=span(-1,1,nx)(,-:1:ny);
   y=span(-1,1,ny)(-:1:nx,);
   z=sin(x^2+y^2+y+x);
   win2,n=0;
   fma;plf,z,y,x;
   hist2d,z,y,x,zz,yy,xx,kx=6,ky=6,cut=0;
   win2,n=1;
   fma;plf,zz,yy,xx;
 */
{
  if(lo==1){
    x=log(x);
    y=log(y);
  }
  nx=numberof(x(,1));
  ny=numberof(y(1,));
  if(is_void(cut))cut=0;
  if(cut==0){
    dx=(nx-kx*(nx/kx))/2;
    dy=(ny-ky*(ny/ky))/2;
    ddx=(nx-kx*(nx/kx))%2;
    ddy=(ny-ky*(ny/ky))%2;
    ddx;ddy;
    x=x(1+dx:-dx-ddx,1+dy:-ddy-dy);
    y=y(1+dx:-ddx-dx,1+dy:-ddy-dy);
    z=z(1+dx:-ddx-dx,1+dy:-ddy-dy);
  }
  if(cut==1){
    x=x(1:kx*(nx/kx),1:ky*(ny/ky));
    y=y(1:kx*(nx/kx),1:ky*(ny/ky));
    z=z(1:kx*(nx/kx),1:ky*(ny/ky));
  }
  if(cut==2){
    x=x(1-kx*(nx/kx):,1-ky*(ny/ky):);
    y=y(1-kx*(nx/kx):,1-ky*(ny/ky):);
    z=z(1-kx*(nx/kx):,1-ky*(ny/ky):);
  }


  

  xx=array(0.0,kx,nx/kx,ky,ny/ky);
  yy=xx;
  zz=xx;
  zz(*)=z(*);
  yy(*)=y(*);
  xx(*)=x(*);
  zz=zz(avg,,,);
  yy=yy(avg,,,);
  xx=xx(avg,,,);
  zz=zz(,avg,);
yy=yy(,avg,);
xx=xx(,avg,);

 if(lo==1){
   xx=exp(xx);
   yy=exp(yy);
 }

}




func scalexy(xratio,yratio,sidex=,sidey=)
/* DOCUMENT scalexy,xratio,yratio
   DEFINITION scalexy(xratio,yratio,sidex=,sidey=)
   scales plotting in horizontal and vertical directions separately.
   
   SEE ALSO: limits, scale, scalex, scaley

   <Example>
   win2;
   fp,"sin(x)";
   scalexy,0.8,0.5,sidey=1;
 */
{
  if(is_void(sidex))sidex=2;
  if(is_void(sidey))sidey=2;
  
  if((is_void(xratio))*(is_void(yratio))){
    xratio=0.9;
    yratio=0.9;
  }
    
  lim=limits();
  lim_cenx=0.5*(lim(1)+lim(2));
  lim_dx=0.5*(lim(2)-lim(1));
  lim_ceny=0.5*(lim(3)+lim(4));
  lim_dy=0.5*(lim(4)-lim(3));

  if(sidex==2){
  limx0=lim_cenx-lim_dx/xratio;
  limx1=lim_cenx+lim_dx/xratio;
  }
  if(sidex==1){
    limx0=lim(1);
    limx1=lim(1)+(lim(2)-lim(1))/xratio;
  }
  if(sidex==0){
    limx0=lim(2)-(lim(2)-lim(1))/xratio;
    limx1=lim(2);
  }
  
  if(sidey==2){
  limy0=lim_ceny-lim_dy/yratio;
  limy1=lim_ceny+lim_dy/yratio;  
  }
  if(sidey==1){
    limy0=lim(3);
    limy1=lim(3)+(lim(4)-lim(3))/yratio;
  }
  if(sidey==0){
    limy0=lim(4)-(lim(4)-lim(3))/yratio;
    limy1=lim(4);
  }

  
  limits,limx0,limx1,limy0,limy1;
}

func scalex(xratio,side=)
/* DOCUMENT scalex, xratio
   DEFINITION scalex(xratio,side=)
   scales plotting in horizontal direction.
   
   SEE ALSO: limits, scale, scaley, scalexy

   <Example>
   win2;
   fmal;
   fp,"sin(x)";
   scalex,0.8;
 */
{
  if(is_void(side))side=2;
  if(is_void(xratio))xratio=0.9;
  scalexy,xratio,1.0,sidex=side;
}
func scaley(yratio,side=)
/* DOCUMENT scaley, yratio
   DEFINITION scaley(yratio,side=)
   scales plotting in vertical direction.
   
   SEE ALSO: limits, scale, scalex, scalexy

   <Example>
   win2;
   fmal;
   fp,"sin(x)";
   scaley,0.5;
 */
{
  if(is_void(side))side=1;
  if(is_void(yratio))yratio=0.9;
  scalexy,1.0,yratio,sidey=side;
}


func scale(ratio)
/* DOCUMENT scale, ratio
   DEFINITION scale(ratio)
   scales plotting in vertical and horizontal direction by the same ratio.
   
   SEE ALSO: limits, scalex,scaley,scalexy

   <Example>
   win2;
   fmal;
   fp,"sin(x)";
   scale,0.7;
 */
{
  scalexy,ratio,ratio;
}

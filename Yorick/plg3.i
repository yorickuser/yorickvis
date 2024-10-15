/*
  PLG3.I
  functions for plotting 3D-curves, written by Hiroshi C. Ito. 2018
  
 */



func plg3 (z,y,x,color=,width=,n=)
/* DOCUMENT plg3, z,y,x,color="color",width=width

   <Example>
 t = span(1,10,128);
  y = cos(4*t)*1/(t+0.001)
  x  = sin(4*t)*1/(t+0.001)
  win2;win3;
  clear3;
  plg3,y,x*0-1,t,color="green";plg3,y,x,t,color="red";limit3,-1,1,-1,1,0,10;limits;cage3;
  
*/
{
  if (_draw3) {
    list= z;
    z= _nxt(list);
    y= _nxt(list);
    x= _nxt(list);
    color=_nxt(list);
    width=_nxt(list);
    n=_nxt(list);
  xyz=[x,y,z];
  xyz= transpose(xyz);
    get3_xy, xyz, x, y;


    plg, y,x,color=color,width=width,n=n;
    return;
   }

  
  //clear3;
  set3_object, plg3,_lst(z,y,x,color,width,n);
}

func plmk3 (z,y,x,marker=,mcolor=,msize=,width=)
/* DOCUMENT plg3, z,y,x,color="color",width=width
example:
t = span(1,10,128);
 y = cos(4*t)*1/(t+0.001)
 x = sin(4*t)*1/(t+0.001)
  clear3;plg3,y,x*0-1,t,color="green";plg3,y,x,t,color="red";limit3,-1,1,-1,1,0,10;limits;cage3;
  
*/
{
  if (_draw3) {
    list= z;
    z= _nxt(list);
    y= _nxt(list);
    x= _nxt(list);
    marker =_nxt(list);
    mcolor=_nxt(list);
    msize=_nxt(list);
    width=_nxt(list);
    
xyz=[x,y,z];
  xyz= transpose(xyz);
    get3_xy, xyz, x, y;
    plmk, y,x,marker=marker,color=mcolor,msize=msize,width=width;
    return;
   }

  
  //clear3;
set3_object, plmk3,_lst(z,y,x,marker,mcolor,msize,width);
}




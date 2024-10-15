//function1 is called by [left button]: changes palette
func function1(void){
  extern nlevs;
  nlevs=nlevs+1;
  write,"Contours are increased to:",nlevs;
}
func function2(void){
  extern nlevs;
  nlevs=nlevs-1;
  write,"Contours are decreased to:",nlevs;
}

nlevs=10;

func idl_demo1(dp){
if(is_void(dp))dp=20;
extern nlevs;
x= span(-3,3,64)(,-:1:64);
y= transpose(x);
  z= sin(2*sqrt(x^2+y^2))+cos(x+y+0.13);
  
  animate,1;
  
  for(t=0;t<=10000;t++){
    z= sin(2*sqrt(x^2+y^2)+0.02*t)+cos(x+y+0.013*t);
    fma;
    levs=span(-1.5,1.5,nlevs);
    plfc,z,y,x,levs=levs;
    plc,z,y,x,color=red,levs=levs;
    //    cbfc,[-2,2],levs=levs,ticks=1,label=1;
    xyt,"x","y";
    redraw;
    if(idl(dp,fun1=function1,fun2=function2))break;
  }
  animate,0;
}


win2;
idl_init=1;
idl_demo1,10;

func idl_demo2(void){
 
  x= span(-3,3,32)(,-:1:32);
  y= transpose(x);
  z= sin(2*sqrt(x^2+y^2))+cos(x+y+0.13);
  make_xyz,z,y,x,nv,xyzv;

  pl3surf,nv,xyzv;
  lim3,3,3,6;
  cage3,1;
  orient3;
  setz3,7;
  limits;
  draw3,1;
  scale,0.9;
   
  animate,1;
  for(t=0;t<=3000;t++){
    xyzv(3,)= sin(2*sqrt(xyzv(1,)^2+xyzv(2,)^2)+0.2*t)+cos(xyzv(1,)+xyzv(2,)+0.13*t);
    
    pl3surf,nv,xyzv;
    lim3,3,3,6;
    draw3,1;
    if(idl(20,t,rot=1))break;
  }
  animate,0;
}



idl_rotation=2;
idl_rotation_speed=[0,0,0.003];


win2,offset_w=100;
win3;
idl_init=1;
idl_init_pause=1;
idl_demo2;

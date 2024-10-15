
func function1(void){
  cpal=["earth","heat","sunrise","bb","cr"];
  id=1;
  n=read(prompt="Choose palette: 1: earth, 2: heat, 3: sunrise, 4: bb, 5: cr >",id);
  pal,cpal(id);
}

size = 120;
dt =0.2;
view_interval=100;
count_interval=1000;
a = 0.023;
b = 0.055;

gridx=span(0,1,size)(,-:1:size);
gridy=transpose(gridx);
dif_gridx=span(0.3,2.0,size)(,-:1:size);
dif_gridy=transpose(dif_gridx);
dif_rate_x = (8.0e-2)*dif_gridx;
dif_rate_y = (4.6e-2)*dif_gridy;

x=array(1.0,size,size);
y=array(0.001,size,size);
y(size/2,size/3) = 0.5;
diffuse_mask=grow(1,indgen(size),size);

func idl_demo3 (T,dp=){
  if(is_void(T))T=10000;
  if(is_void(dp))dp=1;
  fma;
  plfc,y,gridy,gridx,levs=spanl(0.05,0.6,20);
  xyt,"Diffusion rate for x", "Diffusion rate for y";
  limits;
  
  animate,1;
  for(t=0; t<=T;t++){
    diffuse_x=(x(,diffuse_mask)(,dif)(,dif)+x(diffuse_mask,)(dif,)(dif,));
    diffuse_y=(y(,diffuse_mask)(,dif)(,dif)+y(diffuse_mask,)(dif,)(dif,));
    x += dt*(-1.0*x*y*y + a*(1.0-x) +dif_rate_x*diffuse_x);
    y += dt*(x*y*y - (a+b)*y+dif_rate_y*diffuse_y);
    
    if(t%count_interval==0)t; 
    if(t%view_interval==0){
      fma;
      plfc,y,gridy,gridx,levs=spanl(0.05,0.6,20);
      xyt,"Diffusion rate for x", "Diffusion rate for y";
  
  
      if(idl(5,fun1=function1))break;
    }
    
  }
  animate,0;
}



win2,500,500;
idl_init_pause=1;

idl_init=1;
idl_demo3,100000;

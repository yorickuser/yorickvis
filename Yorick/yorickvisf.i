/*
  YORICKVISF.I
  Function for GUI visualization of data output from ongoing simulation, written by Hiroshi C. Ito. 2024

*/


//if(load_custom!=1){
  win2,500,500,offset_w=100;
  win3;
  orient3;
  win2,n=1;
  load_custom=1;
// }


include,"idlf.i";
include,"slice3_modifiedf.i";
label3=["x","y","z"];
    _3lmajor= [1,1,1]*0.015;
  _3lminor= [0.000001,0.000001,0.000001];
  _3xmargin=[2.5,2.5,2.5]*0.7;
  _3nmajor=[1,1,1]*10;
  
  label3_amp_dist=5.0;
  label3_font="timesI";
  label3off=[[0.0,0.0],[0.0,0.0],[0.0,0.0]];
  label3_height=20;
  
  ticks3_dirx=[0,1.0,0];s
  ticks3_diry=[1.0,0,0];
  ticks3_dirz=[1.0,0,0];
  ticks3_vert_axis="close";
  ticks3_hori_axis="bottom";
  ticks3_horiz_axis_amp=1.3;

include,"lcontour3f.i";


func read_met0(&nn,&met,filename){
  nn=0;
  f=open(filename,"r");
  read,f,nn;
  met=array(0.0,3,nn,nn);
  read,f,met;
  close,f;  
}

func read_met_mfem(nn,&met,filename){
  f=open(filename,"r");
  met=array(0.0,3,nn,nn);
  mcount=array(0,3,nn,nn);
  met_mfem=array(0.0,3,5,nn-1,nn-1);
  metcount=array(1,3,nn-1,nn-1);
  read,f,met_mfem;
  close,f;

   met(,1:nn-1,1:nn-1)=met_mfem(,1,,);
   mcount(,1:nn-1,1:nn-1)=metcount;
   
  met(,2:nn,1:nn-1)+=met_mfem(,2,,);
  mcount(,2:nn,1:nn-1)+=metcount;

    met(,2:nn,2:nn)+=met_mfem(,3,,);
  mcount(,2:nn,2:nn)+=metcount;

  met(,1:nn-1,2:nn)+=met_mfem(,4,,);
  mcount(,1:nn-1,2:nn)+=metcount;
  
  /*
  met(,1:nn-1,1:nn-1)=met_mfem(,3,,);
   mcount(,1:nn-1,1:nn-1)=metcount;
   
  met(,2:nn,1:nn-1)+=met_mfem(,4,,);
  mcount(,2:nn,1:nn-1)+=metcount;

  met(,1:nn-1,2:nn)+=met_mfem(,1,,);
  mcount(,1:nn-1,2:nn)+=metcount;
  met(,2:nn,2:nn)+=met_mfem(,2,,);
  mcount(,2:nn,2:nn)+=metcount;
  */
  met=met/mcount;
  
}


func calc_met_max(met0,&met,&met_max,&met_vec){
  nn=dimsof(met0)(3);
  met=array(0.0,2,2,nn,nn);
  met_max=array(0.0,nn,nn);
  met_vec=array(0.0,2,nn,nn);

  
  met(1,1,,)=met0(1,,);
  met(1,2,,)=met0(2,,);
  met(2,1,,)=met0(2,,);
  met(2,2,,)=met0(3,,);
    
  metb=met(,,*);  
  lam0=array(0.0,2,nn*nn);
  vvr=array(0.0,2,2,nn*nn);
  for(i=1;i<=nn*nn;i++){
    lam0(,i)=SVdec(metb(,,i),vr);
    vvr(,,i)=vr;
  }
  metb=[]; 
  
  
  idx=lam0(mxx,);
  lam=lam0(max,);
  lam_min=lam0(min,);
  lis=where(lam_min<0);
  if(numberof(lis)>0)lam_min(lis)=0.0;
  if(flag_met_max_area==1)met_max(*)=sqrt(lam(*)*lam_min(*));
  if(flag_met_max_area==0)met_max(*)=sqrt(lam(*));

  
  for(i=1;i<=nn;i++){  
    for(j=1;j<=nn;j++){
      id=(j-1)*nn+i;
      met_vec(,i,j)=vvr(,idx(id),id);
    }
  }
}


func get_lev(met_max,&lev,&metlen,nlevs=,power=,minlev=){
  extern flag_lev_max_min,flag_lev_just,lev_max,lev_min;
  
  metlen=met_max-1;
  metlen=metlen^power;


  if(is_void(minlev))minlev=min(metlen);
  if(flag_lev_max_min==0){  
    lev=span(minlev,max(metlen),nlevs);
  }else{
    lev_min1=abs(lev_min-1)^power;
    lev_max1=(lev_max-1)^power;
    lev=span(lev_min1,lev_max1,nlevs);
  }
  
 lev_orig=lev^(1/power)+1;
 return lev_orig;
}

func f2str1(value,format){
  if(is_void(format))format="%2.2f";
  val=[""];
  for(i=1;i<=numberof(value);i++)val=grow(val,swrite(format=format,value(i)));
  return val(2:);
}


func show_disc2(nlevs=,every=,dir=,color_samp=,dir_amp=,dir_color=,power=,edge_S=,mcolor=,msize=,marker=){
  extern met0,S,pms0,pms,met,pal_min,pal_max,cmaxpal,cminpal;
  if(is_void(dir))dir=1;
  if(is_void(edge_S))edge_S=0.02;
  if(is_void(every))every=4;
  if(is_void(color_samp))color_samp=120;
  if(is_void(nlevs))nlevs=10;
  if(is_void(dir_amp))dir_amp=0.05;
  if(is_void(dir_color))dir_color=cyan;
  if(is_void(power))power=1.0;
  if(is_void(mcolor))mcolor=yellow;
 if(is_void(marker))marker=3;
 if(is_void(msize))msize=0.3;

 pal_min=char(my_heat*cminpal+my_cool*(1-cminpal));
 pal_max=char(my_heat*cmaxpal+my_cool*(1-cmaxpal));


 //read_met,nn,met0,file_met;

   
  calc_met_max,met0,met,met_max,met_vec;

  rr=2.0;
  xx=span(-rr,rr,nn)(,-:1:nn);
  yy=transpose(xx);


  dmask=grow(1,indgen(nn),nn);

     
  dir=met_vec;
  

  pal1=my_cool;
  pal2=my_heat;
  
    my_pal=pal1;
  //  wei=span(-0.0,1.0,nlevs);
  if(flag_lev_just==1){
    wei=span(cminpal,cmaxpal,nlevs-1);
    colors=char(pal2(,color_samp)*wei(-:1:3,)+(1-wei(-:1:3,))*pal1(,color_samp));
    my_pal(,3:(nlevs+1))=colors;
    my_pal(,2)=colors(,1);
    my_pal(,(nlevs+2))=colors(,0);
    
  }
  if(flag_lev_just==0){
    wei=span(cminpal,cmaxpal,nlevs+1);
    colors=char(pal2(,color_samp)*wei(-:1:3,)+(1-wei(-:1:3,))*pal1(,color_samp));
    my_pal=pal1;
    my_pal(,2:(nlevs+2))=colors;
  }

  palette,my_pal(1,),my_pal(2,),my_pal(3,);

  lev_orig=get_lev(met_max,lev,metlen,nlevs=nlevs,power=power,minlev=minlev0);
 
  
    plfc,met_max,-yy,xx,levs=lev_orig,colors=char(indgen(nlevs+1));

    plc,met_max,-yy,xx,levs=lev_orig,color=black;
 
  pldj,xx(::every,::every)-dir_amp*dir(1,::every,::every),-yy(::every,::every)+dir_amp*dir(2,::every,::every),xx(::every,::every),-yy(::every,::every),color=dir_color;
  xyt,"X","Y",font="timesI";

 
 cbfc,grow(lev,metlen(*)),levs=lev,colors=char(indgen(nlevs+1)),tick_value=lev,tick_label=f2str1(lev_orig); 
  
}


func lcon31(nlevsl=,ambient=,diffiuse=,specular=,sdir=,z3=,angle=,theta=,mypal1=,mypal2=,lcon=){
  extern xmax,xmin,ymax,ymin,zmax,zmin,pal_min,pal_max,nlevs,z3_default,view0;
  if(is_void(nlevsl))nlevsl=20;
  if(is_void(nlevs))nlevs=8;
  if(is_void(ambient))ambient=.2;
  if(is_void(diffuse))diffuse=.8;
 if(is_void(specular))specular=.9;
 if(is_void(sdir))sdir=[3,3,1];
 if(is_void(z3))z3=z3_default;
 if(is_void(lcon))lcon=1;

 pal_min=char(my_heat*cminpal+my_cool*(1-cminpal));
 pal_max=char(my_heat*cmaxpal+my_cool*(1-cmaxpal));

 if(is_void(mypal1))mypal1=pal_min;
 if(is_void(mypal2))mypal2=pal_max;
 
 if(!is_void(angle)){
   if(angle=="left")oleft;
   if(angle=="right")oright;
   if(angle=="front")ofront;
   if(angle=="top")otop;
   if(angle=="front_left")ofront_left,theta=theta;
   
 }

 lev_orig=get_lev(met_max,lev,metlen,nlevs=nlevs,power=power,minlev=minlev0);
 make_xyz,metlen,xyz(2,,),xyz(1,,),nvmet,vvmet;

  light3, ambient=ambient,diffuse=diffuse, specular=specular, sdir=sdir,spower=3;

  clear3;
  lcontour31,nv,vv,vvmet(3,,),levs=lev,nlevsl=nlevsl,mypal1=mypal1,mypal2=mypal2,cmaxl=1.8,cminl=-0.2,everyl=1,line=1,ecol=char([0,0,0]),lcon=lcon;
  setz3,z3;
  xmax=max(vv(1,,));
  xmin=min(vv(1,,));ymax=max(vv(2,,));ymin=min(vv(2,,));zmax=max(vv(3,,));zmin=min(vv(3,,));
  limit3,xmin,xmax,ymin,ymax,zmin,zmax,aspect=[xmax-xmin,ymax-ymin,zmax-zmin];
  draw3,1;
  limits;
  scale,0.95;

  view0=save3();
}

func oleft(void){
  extern ticks3_vert_axis,ticks3_dirx,ticks3_diry,ticks3_dirz;
    ticks3_dirx=[0,0,1];
  ticks3_diry=[0,0,1];
  ticks3_dirz=[0,1,0];
ticks3_vert_axis="right";
 orient3,0*pi,0.5*pi;rot3,-0.0*pi,-0.5*pi+0.00001;
  //  orient3,0*pi,0.5*pi;rot3,-0.0*pi+0.00001,0.5*pi-0.00001 ;//left
  
  //  orient3,0*pi,-0.5*pi;rot3,-0.0*pi+0.00001,0.5*pi-0.00001 ;//left
}
func oright(void){
    extern ticks3_vert_axis,ticks3_dirx,ticks3_diry,ticks3_dirz;
  ticks3_dirx=[0,0,1];
  ticks3_diry=[0,0,1];
  ticks3_dirz=[0,1,0];
  ticks3_vert_axis="left";
  orient3,1*pi,-0.5*pi;rot3,-0.0*pi,-0.5*pi-0.00001 ;rot3,0.00001,0;
  
  //  orient3,1*pi,-0.5*pi;rot3,-0.0*pi,-0.5*pi ;rot3,0.00001,0;
  //  orient3,1*pi,-0.5*pi;rot3,-0.0*pi-0.00001,-0.5*pi-0.00001 ;
  //  orient3,0*pi,-0.5*pi;rot3,-0.0*pi-0.00001,-0.5*pi-0.00001 ;// right
}

func otop(void){
   extern ticks3_vert_axis,ticks3_dirx,ticks3_diry,ticks3_dirz;
   ticks3_dirx=[0,0,1];
  ticks3_diry=[1,0,0];
  ticks3_dirz=[1,0,0];
  ticks3_vert_axis="left";
  orient3,-1*pi-0.00001,0; // top
  //  orient3,-1*pi,0; // top
  //  orient3,-0.0,0.0; // top
}

func ofront(void){
   extern ticks3_vert_axis,ticks3_dirx,ticks3_diry,ticks3_dirz;
       ticks3_dirx=[0,1,0];
  ticks3_diry=[1,0,0];
  ticks3_dirz=[1,0,0];
  ticks3_vert_axis="left";
  orient3,1*pi,-0.5*pi;rot3,-0.00001,pi;//front
  //  orient3,1*pi,-0.5*pi;rot3,0,pi;//front
  // orient3,-1*pi+0.0001,0.5*pi+0.0001; // front
}

func ofront_left(theta=){
   extern ticks3_vert_axis,ticks3_dirx,ticks3_diry,ticks3_dirz; 
   if(is_void(theta))theta=0.75;
   ticks3_dirx=[0,1,0];
  ticks3_diry=[0,0,1];
  ticks3_dirz=[0,1,0];
  ticks3_vert_axis="left";
  orient3,1*pi,-0.5*pi;rot3,0,-0.5*pi;rot3,-0.0*pi,-theta*pi;

}

func function1(void){
  extern flag_lcon,flag_lcon31,flag_surface_contour,idl_menu_fun12;

  if(flag_lcon==1){
    flag_lcon=0;
   
  }else{
    flag_lcon=1;
  }
  
  state=["off","on"](flag_lcon+1);
  write("Smooth shading:",state);
  idl_menu_fun12=swrite(format=" Smooth:%s\n /Reload",state);

  fun_plot;
}

func function2(void){
  extern flag_lcon,idl_menu_fun12,readcount,outcount,f;
  readcount=0;
  outcount=0;

  close,f;
  f=open(file_data);
  nn=0;
  read,f,nn;



  state=["off","on"](flag_lcon+1);
  write("Smooth shading:",state);
  idl_menu_fun12=swrite(format=" Smooth:%s\n /Reload",state);



  fun_plot;
}

func function3(void){
  function34,1;
}
func function4(void){
  function34,-1;
}

func function34(value){
  extern nlevs,idl_menu_fun34;
  nlevs=nlevs+value;
  
  write("nlevs:",nlevs);
    idl_menu_fun34=swrite(format=" nlevs:%d",nlevs);
  window,1;fma;show_disc2,nlevs=nlevs,power=power;redraw;window,0;
  fun_plot;
}

func function5(void){
  function56,1;
}
func function6(void){
  function56,-1;
}

func function56(value){
  extern nlevsl,idl_menu_fun56;
  nlevsl=nlevsl+value;
  
  write("nlevsl:",nlevsl);
    idl_menu_fun56=swrite(format=" nlevsl:%d",nlevsl);
  fun_plot;
}

func fun_plot(di){
      extern vind,vflag,vcount,nv,vv,metv,flag_lcon,flag_lcon31,nlevsl,cmaxpal,cminpal;
      
  if(flag_lcon31>0){
    lev_orig=get_lev(met_max,levs,metlen,nlevs=nlevs,power=power,minlev=minlev0);
    
    pal_min=char(my_heat*cminpal+my_cool*(1-cminpal));
    pal_max=char(my_heat*cmaxpal+my_cool*(1-cmaxpal));
    
    clear3;
    lcontour31,nv,vv,vvmet(3,,),levs=levs,nlevsl=nlevsl,mypal1=pal_min,mypal2=pal_max,cmaxl=1.8,cminl=-0.2,everyl=1,line=1,ecol=char([0,0,0]),lcon=flag_lcon,vind=vind,flag=vflag,vcount=vcount;
  }else{
    clear3;pl3tree,nv,vv;
  }

    xmax=max(vv(1,,));
  xmin=min(vv(1,,));ymax=max(vv(2,,));ymin=min(vv(2,,));zmax=max(vv(3,,));zmin=min(vv(3,,));
  limit3,xmin,xmax,ymin,ymax,zmin,zmax,aspect=[xmax-xmin,ymax-ymin,zmax-zmin];

  draw3,1;
  
}

func viewr(void){
  window,0;
  animate,1;
  while(1){

      if((flag_plot_each==0)>0){
    draw3_trigger;
    //rot3,0,0;
    draw3,1;
    
  }else{
        if(flag_lcon31>0){
          nv_mask=[];vv_mask=[];
        }
        fun_plot;
      }
  
      if(idl(5,t,rot=1,fun1=function1,fun2=function2,fun3=function3,fun4=function4,fun5=function5,fun6=function6))break;
  }

animate,0;
}

func save_horn(hfile){
  extern nn,readcount,outcount,t,tcool,ttotal,xyz,met0;
  extern nv,vv,vid,vflag,vcount,met,met_max,met_vec,lev,metlen,nvmet,vvmet,done_vind;
  ff=open(hfile,"w");
  write,ff,readcount,outcount;
  write,ff,nn;
  write,ff,t,tcool,ttotal;
  write,ff,xyz;

  write,ff,met0;
  close,ff;
}

func load_horn(hfile,plot=){
  if(is_void(plot))plot=1;
  extern nn,readcount,outcount,t,tcool,ttotal,xyz,met0,nv,vv,vid,vflag,vcount,met,met_max,met_vec,lev,metlen,nvmet,vvmet,done_vind;
  ff=open(hfile,"r");
  read,ff,readcount,outcount;
  read,ff,nn;
  read,ff,t,tcool,ttotal;

  xyz=array(0.0,3,nn,nn);
  met0=array(0.0,3,nn,nn);
   
  read,ff,xyz;
  read,ff,met0;
  close,ff;
  
  make_xyz,xyz(3,,),xyz(2,,),xyz(1,,),nv,vv;
  light_face_init,nv,vv,vind,vflag,vcount;
  done_vind=1;

  calc_met_max,met0,met,met_max,met_vec;
  lev_orig=get_lev(met_max,lev,metlen,nlevs=nlevs,power=power,minlev=minlev0);
  make_xyz,metlen,xyz(2,,),xyz(1,,),nvmet,vvmet;

  if(plot==1){
    window,0;fun_plot;
    window,1;fma;show_disc2,nlevs=nlevs,power=power;window,0;

  }
}




/*_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/*/
/*_/_/_/_/_/_/_/_/_/_/ MAIN _/_/_/_/_/_/_/_/_/_/_/*/
/*_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/*/

flag_met_max_area=0;
flag_skip=0;
flag_mesh=1;
flag_plot_each=2;
flip_y=1;
flag_lcon=1;
flag_lcon31=1;
start=0;
loadhorn=0;


power=0.58;

flag_lev_max_min=0;
flag_lev_just=1;
minlev0=0.0;
nlevs=10;
nlevsl=20;
cmaxpal=0.9;
cminpal=0.0;
file_base="output"
  metric_mfem=0;
  
 idl_init_pause=1;
 idl_movie_eps=1;
 flag_init_orient3=1;


mfem=0;
mypal1="heat";
mypal2="cool";
read_met=read_met0;



param_file=Y_DIR+"tmp.i";
if(open(param_file,"r",1))include,param_file;


if(metric_mfem!=0)mfem=1;
if(mfem==1)read_met=read_met_mfem;

my_heat=make_mypal(mypal1);
my_cool=make_mypal(mypal2);




pal_min=char(my_heat*cminpal+my_cool*(1-cminpal));
pal_max=char(my_heat*cmaxpal+my_cool*(1-cmaxpal));

z3_default=20;

onoff=["on","off"];
idl_menu_fun34=swrite(format=" nlevs:%d",nlevs);
idl_menu_fun12=swrite(format=" Smooth:%s\n /Reload",["off","on"](flag_lcon+1));
idl_menu_fun56=swrite(format=" nlevsl:%d",nlevsl);

 
//func viewh(file_base){
//  extern metlen,xyz,file_outcount,file_data,file_met,f;



 n_nv=0;
 t=0;
 tcool=0;
 ttotal=0;
 amp_norm=1;
 idl_init=1;
 //idl_rotation=2;
 //idl_rotation_speed=[0,0,0.0];

readcount=0;
outcount=0;
nn=0;

if(loadhorn==0){
 file_outcount=swrite(format="%s_outcount.dat",file_base);
file_data=swrite(format="%s.dat",file_base);

 if(mfem==1){
   if(metric_mfem==1){
     file_met=pathform(pathsplit(file_base,delim="/")(:-1),delim="/")+"/metric.dat"
   }else{
   file_met=metric_mfem;
   }
 }else{
   file_met=swrite(format="%s_met.dat",file_base);
 }

 
 
 f=open(file_data,"r");

  read,f,nn;
xyz=array(0.0,3,nn,nn);
met0=xyz;
met=met0;


read_met,nn,met0,file_met;
calc_met_max,met0,met,met_max,met_vec;
 }


if(loadhorn==1){
 
  load_horn,file_base,plot=1;
  limits,-0.25,0.25,-0.25,0.25;
  setz3,z3_default;
  ofront_left;
 

 }

 window,0;
 animate,1;


cage3,1;
setz3,z3_default;

window,1;
fma;
show_disc2,nlevs=nlevs,power=power;

limits,-2,2,-2,2;
redraw;

window,0;


done_vind=0;

if(loadhorn==0){
while(1){
  
  g=open(file_outcount,"r");
  read,g,outcount;
  close,g;
  if(readcount<=outcount){
    readcount+=1;
    
    read,f,t,tcool,ttotal;
    write,"time:",t,int(100*t/double(tcool)),"%      total:",int(100*t/double(ttotal)),"%", "    readcount:",readcount;
        
    read,f,xyz;

    if(flip_y==1)xyz(2,,)*=-1;
    
    if((readcount<10)+(flag_skip==0)+(readcount<=outcount)>0){

      if((start==0)+((readcount<=1)+(readcount> start-5))>0){
        make_xyz,xyz(3,,),xyz(2,,),xyz(1,,),nv,vv;
        
        if(done_vind==0){
          light_face_init,nv,vv,vind,vflag,vcount;
          done_vind=1;
        }
        
        lev_orig=get_lev(met_max,lev,metlen,nlevs=nlevs,power=power,minlev=minlev0);

        make_xyz,metlen,xyz(2,,),xyz(1,,),nvmet,vvmet;
        
 
    }
    }
    
  }else{
    idl_flag_stop=1;
  }
  
  flag_plot=0;
  if((readcount<10)+(flag_skip==0)>0)flag_plot=1;
  if(readcount>outcount)flag_plot=0;
  
  if((flag_plot==0)*(flag_plot_each==0)>0){
    draw3_trigger;
    draw3,1;
    
  }else{
    clear3;
    
    if(flag_lcon31>0){
      nv_mask=[];vv_mask=[];
      lcontour31,nv,vv,vvmet(3,,),levs=lev,nlevsl=nlevsl,mypal1=pal_min,mypal2=pal_max,cmaxl=1.8,cminl=-0.2,everyl=1,line=1,ecol=char([0,0,0]),lcon=flag_lcon,vind=vind,flag=vflag,vcount=vcount;
      
    }else{
      pl3tree,nv,vv;
    }

    if(flag_init_orient3==1){
      if(mfem==1){
        orient3;
      }else{
      ofront_left;
      }
      setz3,z3_default;
      flag_init_orient3=0;
      light3, ambient=0.2,diffuse=0.8, specular=0.9, sdir=[3,3,1],spower=3;
    }
      xmax=max(vv(1,,));
      xmin=min(vv(1,,));ymax=max(vv(2,,));ymin=min(vv(2,,));zmax=max(vv(3,,));zmin=min(vv(3,,));
  limit3,xmin,xmax,ymin,ymax,zmin,zmax,aspect=[xmax-xmin,ymax-ymin,zmax-zmin];

 draw3,1;
    
  if(readcount==1){
    init_scale=0.5;
    if(mfem==1)init_scale=0.8;
    limits;scale,init_scale;
  }
  //if(readcount==1){limits,-0.4,0.4,-0.4,0.4;}
   
  }
    
if(readcount==start)break;
 
  if(idl(5,t,rot=1,fun1=function1,fun2=function2,fun3=function3,fun4=function4,fun5=function5,fun6=function6))break;
 }

animate,0;
close,f;

}

if(loadhorn==1){
  light3, ambient=0.2,diffuse=0.8, specular=0.9, sdir=[3,3,1],spower=3;  
  viewr;
 }

//viewh,file_base;


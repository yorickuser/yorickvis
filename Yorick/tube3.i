/*
  TUBE3.I
  functions for plotting 3D-tubes, written by Hiroshi C. Ito. 2018
  
 */


require,Y_DIR+"graph3d.i";
require,Y_DIR+"idl.i";

func tube3_demo(T=,ster=,nn=,cmax=){
    if(is_void(T))T=1000;
    z=span(-pi,pi,256)
        y=pi*sin(2.1*z);
    x=pi*cos(2*z)+sin(z+1);
    w=2*sin(z^2-2)+z;
    //clear3;tube3,x,w,y;lim3,3;

                           
    vv=transpose([y,w,x]);
                           
                           
    if(ster==1)stanimate,1;   
    else animate,1;
    for(i=1;i<=T;i++){
        rotv,vv,0.0,-0.02;
        clear3;
        tube3,vv(3,),vv(2,),vv(1,),1.5+0.7*sin(vv(3,)+i*0.2),nn=nn,cmax=cmax;
        lim3,4;
        draw3,1;
        if(ster==1)stdraw3;
 
        if(idl(5))break;
    }
    if(ster==1)stanimate,0;
    else animate,0;
if(ster==1)stdraw3;
 _draw3_changes=1
 draw3,1;   
}





func tube3(z,y,x,w,&nv,&xyzv,nn=,bias=,flat=,shad=,cmax=,cmin=,scaling=,rot=,closed=,out=,mypal=,scaling_ratio=)
/* DOCUMENT tube3,z,y,x,w
   DEFINITION tube3(z,y,x,w,&nv,&xyzv,nn=,bias=,flat=,shad=,cmax=,cmin=,scaling=)

   plots a tube-shape polygon. The width of the tube is specified by w.
   nn changes the shape of tube-slice.
     
   SEE ALSO: pl3tree

   <Example>

   t=span(-pi,pi,256)
   x=pi*sin(2.1*t);
   z=pi*cos(2*t)+sin(t+1);
   y=2*sin(t^2-2)+t;
   w=1.5+0.7*sin(z+1);
        
   win2;win3;
   clear3;
   tube3,z,y,x,w,nn=5;
   lim3,4;
   cage3,1;
  
 */
{
  if(is_void(scaling_ratio))scaling_ratio=0.1;
if(is_void(nn))nn=4;
if(is_void(w))w=z*0+1.0;
if(!is_void(scaling)){
    if(numberof(w)==1)w=w+z*0;    
    //   zz=(z-min(z))/max(z);
    //yy=(y-min(y))/max(y);
    //xx=(x-min(x))/max(x);
}

xyz= array(0.0, 3, nn,nn,2);
xyz(1,..)= span(-0.6,0.6,nn);
xyz(2,..)= span(-0.6,0.6,nn)(-,);
xyz(3,..)= span(-0.6,0.6,2)(-,-,);
r= abs(xyz(1,..),xyz(2,..));
 m3= mesh3(xyz, r);
 r=xyz=[];
 slice3, m3, 1,value=0.5, n_tube,xyz_tube;
 h_tube=where(xyz_tube(3,)>=0.0);
 l_tube=where(xyz_tube(3,)<0.0);
 xyz_tube(3,)=0.0;
 //dimsof(x);
 //dimsof(y);
 //dimsof(z);
 xyz= transpose([x,y,z]);

 
if(!is_void(scaling)){
    if((dimsof(scaling))(1)==0)scaling=scaling*[1.0,1.0,1.0];
        scaling*=scaling_ratio;
    xyz(1,) = (xyz(1,)-xyz(1,min))/(scaling(1)*(xyz(1,max)-xyz(1,min)));
    xyz(2,) = (xyz(2,)-xyz(2,min))/(scaling(2)*(xyz(2,max)-xyz(2,min)));
    xyz(3,) = (xyz(3,)-xyz(3,min))/(scaling(3)*(xyz(3,max)-xyz(3,min)));
}

if(is_void(flat)){
 if(is_void(closed)){
     
     if(numberof(xyz(1,))>2){
         pv=xyz(,dif)(,zcen);
         pv=grow([pv(,1)],pv,[pv(,0)]);
     }
     else {
         pv=xyz(,dif);
         pv=grow([pv(,1)],pv);
     }
     //dimsof(xyz);
     //dimsof(pv);
 }
 else if(closed==1){
     pv=(grow([xyz(,0)],xyz,[xyz(,1)]))(,dif)(,zcen);
     pv(,0)=pv(,1);
 }
}
 Ntube=numberof(z)-1;
 xyzv=xyz_tube(,,-:1:Ntube);

 

 xyzv=xyzv(,*);
  
 L_tube=(l_tube(,-:1:Ntube)+(sum(n_tube)*(indgen(Ntube)-1))(-,))(*)
   H_tube=(h_tube(,-:1:Ntube)+(sum(n_tube)*(indgen(Ntube)-1))(-,))(*)
   xyzv(,H_tube)*=w(-,2:)(,-:1:numberof(l_tube),)(,*);	
 xyzv(,L_tube)*=w(-,:-1)(,-:1:numberof(h_tube),)(,*);

 if(!is_void(bias)){ 
   xyzv(,H_tube)+=bias(-,2:)(,-:1:numberof(l_tube),)(,*);	
   xyzv(,L_tube)+=bias(-,:-1)(,-:1:numberof(h_tube),)(,*); 
 }

 if(is_void(flat)){ 
   get3a,pv,phi0,theta0;
   fa0=theta0*(2.0*double(phi0>0.5*pi)-1.0);
   mast=(phi0>0.5*pi)(dif);
   mast=grow([0],mast);
   
   
   if(numberof(mast)>0){
    mass=theta0*0;
    mass+=-1.0*(theta0+grow(theta0(2:),[0]))*mast;
    //mass+=-2.0*theta0*mast;
    mass=mass(psum);
    fa0+=mass;
}
if(!is_void(closed))fa0(0)=fa0(1);

phih=phi0(-:1:numberof(l_tube),2:)(*);
thetah=theta0(-:1:numberof(l_tube),2:)(*);
phil=phi0(-:1:numberof(l_tube),:-1)(*);
thetal=theta0(-:1:numberof(l_tube),:-1)(*);
fah=fa0(-:1:numberof(l_tube),2:)(*);
fal=fa0(-:1:numberof(l_tube),:-1)(*);

xyzv(,H_tube)=rota(xyzv(,H_tube),1,2,fah);
xyzv(,H_tube)=rota(xyzv(,H_tube),3,1,phih);
xyzv(,H_tube)=rota(xyzv(,H_tube),1,2,thetah);

xyzv(,L_tube)=rota(xyzv(,L_tube),1,2,fal);
xyzv(,L_tube)=rota(xyzv(,L_tube),3,1,phil);
xyzv(,L_tube)=rota(xyzv(,L_tube),1,2,thetal);
}
else{
 xyzv(,L_tube)=rotv3v((xyzv(,L_tube)),pvl);
 xyzv(,H_tube)=rotv3v((xyzv(,H_tube)),pvh);
     }

if(!is_void(scaling)){
 xyzv(,H_tube)+=(xyz)(,2:)(,-:1:numberof(l_tube),)(,*);	
 xyzv(,L_tube)+=(xyz)(,:-1)(,-:1:numberof(h_tube),)(,*);
 }
 else{
xyzv(,H_tube)+=(transpose([x,y,z]))(,2:)(,-:1:numberof(l_tube),)(,*);	
 xyzv(,L_tube)+=(transpose([x,y,z]))(,:-1)(,-:1:numberof(h_tube),)(,*);
 }
if(!is_void(scaling)){
    xyzv(1,) =xyzv(1,)*(x(max)-x(min))*scaling(1)+min(x);
    xyzv(2,) =xyzv(2,)*(y(max)-y(min))*scaling(2)+min(y);
    xyzv(3,) =xyzv(3,)*(z(max)-z(min))*scaling(3)+min(z);
}
 
 
 nv=array(4,numberof(xyzv(1,))/4);
 if(is_void(out))pl3tree,nv,xyzv,cmax=cmax,cmin=cmin,mypal=mypal;

 if((is_void(out))&&(shad==1))pl3tree,nv,xyzv*[1,1,0],array(char(245),numberof(nv));
 //xyzv=nv=[];
}

func rotv(&v,phi,theta){
v=rota(v,3,1,phi);
v=rota(v,1,2,theta);
}

func rota(v,d0,d1,theta)
{    
  buf=v(d0,);
  v(d0,)=cos(theta)*buf-sin(theta)*v(d1,);
  v(d1,)=sin(theta)*buf+cos(theta)*v(d1,);
  return v;
}

func get3a(norm,&phi,&theta)
{
    
    
    norm=double(norm);
  rxy=abs(norm(1,),norm(2,))+1.0e-10;
  rxyz=abs(norm(1,),norm(2,),norm(3,));
  cphi=norm(3,)/rxyz;
  sphi=rxy/rxyz;

  phi=acos(cphi);
  if(min(sphi)<0)phi(where(sphi<0))=2.0*pi-phi(where(sphi<0));
  
    ctheta=norm(1,)/rxy;
    stheta=norm(2,)/rxy;

    theta=acos(ctheta);
    if(min(stheta)<0)theta(where(stheta<0))=2.0*pi-theta(where(stheta<0));
}


func rotv3v(xyzv,norm)
{
    
    v=xyzv;
    norm=double(norm);
    
  rxy=abs(norm(1,),norm(2,))+1.0e-10;
  rxyz=abs(norm(1,),norm(2,),norm(3,));
  
  
  cphi=norm(3,)/rxyz;
  sphi=rxy/rxyz;
  
    ctheta=norm(1,)/rxy;
    stheta=norm(2,)/rxy;
    mass=double((cphi<0))*2-1.0;
    
    
    
    //mass(..)=1.0;
    buf=v(1,);
    v(1,)=ctheta*buf-mass*stheta*v(2,);
    v(2,)=mass*stheta*buf+ctheta*v(2,);
    //v(1,)=mass*ctheta*buf-stheta*v(2,);
    //v(2,)=stheta*buf+mass*ctheta*v(2,);
    


  buf=v(3,);
    v(3,)=cphi*buf-sphi*v(1,);
  v(1,)=sphi*buf+cphi*v(1,);
 
  
  
  buf=v(1,);
    
  v(1,)=ctheta*buf-stheta*v(2,);
  v(2,)=stheta*buf+ctheta*v(2,);
  
  
  
  return v;
}














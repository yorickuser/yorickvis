/*Some polygon shapes produced by 3D density function, written by Hiroshi C. Ito 2018*/


func tama{
nn = 60;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-2,2,nx);
  y=  xyz(2,..)= span(-2,2,nx)(-,);
  //y=  xyz(2,..)= span(-2.1,2,nx)(-,);
  z=  xyz(3,..)= span(-2,2,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));
    y32= sin(theta)^2*cos(theta)*cos(2*phi);


w= sin(exp(-y^2-x^2-z))*(x-sqrt(z^2))*sin(4*sqrt(y^2+z^2+x^2));




    m3= mesh3(xyz, w,r);
    r= theta= phi= xyz= y32=[];


clear3;

slice3, m3, 1,value=0.1, nv,xyzv;
//vc = slice3( m3, 1,value=0.2, nv,xyzv,2,2);
 //vc = get3_light(xyzv, nv); 

pxy= plane3([0,0,1],[0,0,0]);
    pyz= plane3([0,1,1],[0,0,0]);
//    pyz= plane3([1,0,0],[0,0,0]);
//vp= slice3(m3, pxy, np,xyzp, 1);  /* pseudo-colored slice */
//slice2, pxy, np,xyzp,vp;
//slice2x, pxy, nv,xyzv,, nvb,xyzvb;
//pl3tree, nvb,xyzvb;
//pl3tree, np,xyzp,vp,pyz;
pl3surf, nv,xyzv;
 limit3,-2,2,-2,2,-2,2;
//pl3tree, nv,xyzv,vc;
//light3;
//orient3;
//split_palette, "heat.gp";
}

func tower{
nn = 50;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-3,3,nx);
  y=  xyz(2,..)= span(-6,2,nx)(-,);
   z=  xyz(3,..)= span(-3,3,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));
    y32= sin(theta)^2*cos(theta)*cos(2*phi);


w= sin(exp(-x^2-z^2-y))*(x-y)*sin(4*sqrt(x^2+y^2+z^2));
    m3= mesh3(xyz, w,r);
    r= theta= phi= xyz= y32= [];



slice3, m3, 1,value=0.1, nv,xyzv;
 xyzvb=xyzv;
 xyzv(2,)=xyzvb(3,);
 xyzv(3,)=xyzvb(2,);
 xyzvb=[];

clear3;
pl3tree, nv,xyzv;
 limit3,-4,4,-4,4,-6,2;
}



func tetra(nn){
  if(is_void(nn))nn = 60;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-1,1,nx);
  y=  xyz(2,..)= span(-1,1,nx)(-,);
  z=  xyz(3,..)= span(-1,1,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));
y32= sin(theta)^2*cos(theta)*cos(2*phi);
//y32= sin(theta)^2*cos(theta)*cos(4*phi);
//y32= sin(2*theta)^2*cos(2*theta)*cos(4*phi);
//y32= sin(2*theta)*sin(2*theta)*sin(2*phi)*sin(2*phi);
//y32= sin(1.5*theta)^2*cos(1.5*theta)^2*cos(3*phi);
//y32= sin(1.2*theta)^2*cos(1.2*theta)*sin(3*phi);


w = r*(1.+1*y32);

 m3= mesh3(xyz,w,r);

    r= theta= phi= xyz= y32= [];


slice3, m3, 1,value=0.6, nv,xyzv;

 m3=[];
clear3;
pl3surf, nv,xyzv;

 limit3,-1,1,-1,1,-1,1;
}

func tetrab(nn){
if(is_void(nn))nn = 60;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-2,2,nx);
  y=  xyz(2,..)= span(-2,2,nx)(-,);
  z=  xyz(3,..)= span(-2,2,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));

r1= abs(1.0+xyz(1,..),0.8+xyz(2,..),xyz(3,..));
r2= abs(xyz(1,..),0.5+xyz(2,..),-1.0+xyz(3,..));
    theta1= acos(xyz(3,..)/r1);
    phi1= atan(.8+xyz(2,..),xyz(1,..)+1.0+(!r1));

    y321= sin(theta1)^2*cos(theta1)*cos(2*phi1);
//y321= sin(theta1)^2*cos(theta1)*cos(2*phi1);

//y32= sin(theta)^2*cos(theta)*cos(4*phi);

//y32= sin(theta)^2*cos(theta)*cos(4*phi);
y32= sin(2*theta)^2*cos(2*theta)*cos(4*phi);
//y32= sin(2*theta)*sin(2*theta)*sin(2*phi)*sin(2*phi);
//y32= sin(1.5*theta)^2*cos(1.5*theta)^2*cos(3*phi);
//y32= sin(1.2*theta)^2*cos(1.2*theta)*sin(3*phi);


w = 1/((1.+1*y32)*r)^4+1/((1.+1*y321)*r1)^4+1/r2^5;

 m3= mesh3(xyz,w,r);

    r= theta= phi= xyz= y32= [];
r1= theta1= phi1= y321= r2= [];

slice3, m3, 1,value=10.0, nv,xyzv;
 m3=[];
clear3;
pl3surf, nv,xyzv;
//pl3tree, nv1,xyzv1;
  limit3,-1.5,1.5,-1.5,1.5,-1.5,1.5;
}


func kuti(nn){
if(is_void(nn))nn = 20;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-1.5,1.5,nx);
  y=  xyz(2,..)= span(-1.5,1.5,nx)(-,);
  z=  xyz(3,..)= span(-1.5,1.5,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));
    y32= sin(theta)^2*cos(theta)*cos(2*phi);


//w= sin(exp(-x^2-z^2-y))*(x-sqrt(y^2))*sin(4*sqrt(x^2+y^2+z^2));
w= sin(1.5*exp(-x^2-z^2-y^2))*(x-sqrt(y^2))*sin(4*sqrt(x^2+y^2+z^2));

    m3= mesh3(xyz, w,r);
    r= theta= phi= xyz= y32= [];

slice3, m3, 1,value=0.1, nv,xyzv;


clear3;		
pl3surf, nv,xyzv;
 limit3,-1.5,1.5,-1.5,1.5,-1.5,1.5;
 limits;
}


func neji{
nn = 40;
  nx= nn;
    ny= nn;
    nz=nn;
    xyz= array(0.0, 3, nx,ny,nz);
  x=  xyz(1,..)= span(-1.5,1.5,nx);
  y=  xyz(2,..)= span(-1.5,1.5,nx)(-,);
  z=  xyz(3,..)= span(-1.5,1.5,nx)(-,-,);
    r= abs(xyz(1,..),xyz(2,..),xyz(3,..));
    theta= acos(xyz(3,..)/r);
    phi= atan(xyz(2,..),xyz(1,..)+(!r));
    y32= sin(theta)^2*cos(theta)*cos(2*phi);


    w=(4+sin(phi+5*z))*abs(x,y)
    m3= mesh3(xyz, w,abs(x,y));
    r= theta= phi= xyz= y32= [];

    slice3, m3, 1,value=2, nv,xyzv;
    //vp=slice3( m3, 1,value=2, nv,xyzv,2);


clear3;		
//pl3surf, nv,xyzv;
 pl3tree, nv,xyzv,mypal=0;
 pl3tree, nv,xyzv*0.7+[-1,0,0],mypal=1;
 pl3tree, nv,xyzv*0.5+[1,1,0],mypal=1;
 
 limit3,-1.5,1.5,-1.5,1.5,-1.5,1.5;
 limits;
}





/*
  LCONTOUR3F.I
  Modified file of lcontour3.i for yorickvisf.i, by Hiroshi C. Ito. 2024

  Funtsions  slice2v and slice2xv are slight modifications of slice2 and slice2x, respectively, in slice3.i written by Dr. David Munro.

*/

//require,"my_slice3c_test1.i";

/*
x= span(-3,3,64)(,-:1:64);
 y= transpose(x);
 z= 0.5*sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
clear3;plfc3,3*z,y,x,levs=span(-0.5,0.5,20),cutup=10,offset=span(-0.5,0.5,20)(9);plfc3,3*z,y,x,levs=span(-0.5,0.5,20),flat=0,cutdown=9,mypal=0,shade=1;lim3,3
*/


/*
x= span(-3,3,64)(,-:1:64);
 y= transpose(x);
 z= 0.5*sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
colorv=1;
make_xyz,z,y,x,nv,xyzv,colorv,cv=1;
lcontour3,nv,xyzv+[0,0,2],colorv,nlevs=40;

vp = get_light(nv, xyzv);
vp=char(199*(vp-min(vp))/double(max(vp)-min(vp)));
pl3tree,nv,xyzv+[0,0,-2],vp
limit3,-3,3,-3,3,-3,3;
limits;
*/

//  include,"~/Yorick/my_slice3_test31.i";
flag_surface_contour=0;

//surface_contour_edge_color=char([0,250,250]);
//surface_contour_edge_color=char([0,250,0]);
surface_contour_edge_width=1;
surface_contour_fast=1;
plgl3_zoffset=0.5/40;
//plgl3_zoffset=0.1/40;
//require,Y_DIR+"pl3d_modified.i";
//require,Y_DIR+"slice3_modified.i";
require,Y_DIR+"tama.i";


func plfc3(z,y,x,levs=,nlevs=,cmax=,cmin=,mypal=,flat=,cutdown=,shade=,offset=,cutup=,dim=)
/* DOCUMENT plfc3,z,y,x
   DEFINITION plfc3(z,y,x,levs=,nlevs=,cmax=,cmin=,mypal=,flat=,cutdown=,shade=,offset=,cutup=,dim=) 

   plots 3D filled contours for function z=f(y,x)
     
   SEE ALSO: lcontour3

   <Example>
   x= span(-3,3,64)(,-:1:64);
   y= transpose(x);
   z= sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
   win2;win3;
   spal,"earth","heat";
   clear3;
   plfc3,z,y,x,levs=span(min(z),max(z),20),flat=0,mypal=0;
   plfc3,z,y,x,levs=span(min(z),max(z),20),flat=1,mypal=1,offset=-2;lim3,3,3,2;
   
*/
{
  //if(is_void(mypal))mypal=1;
  if(is_void(offset))offset=0.0;
  if(is_void(flat))flat=1;
  if(is_void(dim))dim=3;

    
  flat=(flat+1)%2;
  local nv,xyzv;
  //mask=([1,2,3]+dim-1)%3+1;
  mask=([1,2,3]-dim+5)%3+1
  make_xyz,z,y,x,nv,xyzv,colorv,cv=1;
  xyzv=xyzv(mask,);
  flag0=(mask!=3)+flat*(mask==3);
  flag1=offset*(mask==3);

  lcontour3,nv,xyzv*double(flag0)+double(flag1),xyzv(dim,),nvb,xyzvb,levs=levs,nlevs=nlevs,cmax=cmax,cmin=cmin,mypal=mypal,cutdown=cutdown,shade=shade,cutup=cutup;
  
//lcontour3,nv,xyzv*[flat,1,1]+[offset,0,0],xyzv(1,),nvb,xyzvb,levs=levs,nlevs=nlevs,cmax=cmax,cmin=cmin,mypal=mypal,cutdown=cutdown,shade=shade,cutup=cutup;

//lcontour3,nv,xyzv*[1,1,flat]+[0,0,offset],xyzv(3,),nvb,xyzvb,levs=levs,nlevs=nlevs,cmax=cmax,cmin=cmin,mypal=mypal,cutdown=cutdown,shade=shade,cutup=cutup;
  }


func plwf3(z,y,x,cmax=,cmin=,mypal=){
make_xyz,z,y,x,nv,xyzv;
 pl3tree,nv,xyzv,cmax=cmax,cmin=cmin,mypal=mypal;
  }


func lcon3(nv,xyzv,levs=,nlevs=,cmax=,cmin=,mypal=)
/* DOCUMENT plfc3,z,y,x
   DEFINITION plfc3(z,y,x,levs=,nlevs=,cmax=,cmin=,mypal=,flat=,cutdown=,shade=,offset=,cutup=,dim=) 

   emurates smooth shading
     
   SEE ALSO: lcontour3

   <Example>
   nn=64;
   x= span(-3,3,nn)(,-:1:nn);
   y= transpose(x);
   z= sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
   make_xyz,z,y,x,nv,xyzv;
   win2;win3;
   clear3;
   lcon3,nv,xyzv,nlevs=40;
   lim3,3,3,2;
   pal,"cr";
   
*/

{
    vp=get_light(nv,xyzv);
    colorv=light_face(nv,xyzv,vp);
    lcontour3,nv,xyzv,colorv,levs=levs,nlevs=nlevs,cmax=cmax,cmin=cmin,mypal=mypal;
}


func lcontour3(nv,xyzv,colorv,&nvout,&xyzvout,levs=,nlevs=,ecol=,cmax=,cmin=,every=,shade=,out=,mypal=,cutdown=,cutup=)
/* DOCUMENT lcontour3,nv,xyzv
         or lcontour3,nv,xyzv,nlevs=30,cmax=1.5
         or lcontour3,nv,xyzv,nvout,xyzvout,out=1

         cuts the polygon "nv,xyzv" into each peaces between
         contours based on value of "colorv" and fill the pieces
         baced on "colorv".
         "colorv" must have same shape of "xyzv(1,)" (= xyzv(2,)=xyzv(3,)).  

   KEYWORDS: levs -- [value1, value2,..,valuen] : a list of values
                     at whch you want contours.
            nlevs -- integer : number of contours.
             ecol -- char/RGB: edge color
            every -- integer: skip every "every" pieace.
              out -- 1/0: output polygon data for other ploting function.
   SEE ALSO: lcon3, plfc3

   <Example>
      nn=64;
   x= span(-3,3,nn)(,-:1:nn);
   y= transpose(x);
   z= sin(3*sqrt(x^2+y^2)+0.2)*cos((x-y+sin(0.1)));
   make_xyz,z,y,x,nv,xyzv;
   win2;win3;
   clear3;
   vp=get_light(nv,xyzv);
   colorv=light_face(nv,xyzv,vp);
   lcontour3,nv,xyzv,colorv,nlevs=30;
   pal,"cr";

   lim3,3,3,2;
   
 */
{
    
  if(is_void(levs)){
  if(is_void(nlevs))nlevs=20;
  }else {
    if(levs(1)>min(colorv))levs=grow(min(colorv),levs);
    nlevs=numberof(levs);
  }
  if(is_void(cutdown))cutdown=0;
    if(is_void(cutup))cutup=nlevs+1;
    
    if(is_void(cmax))cmax=max(colorv);
    if(is_void(cmin))cmin=min(colorv);
    
  if(is_void(every))every=1;
  if(is_void(mypal))mypal=-1;  
  
  //if(is_void(levs))levs=span(-1.0,1.0,nlevs)*0.5*(max(colorv)-min(colorv));
if(is_void(levs))levs=(max(colorv)-min(colorv))*span(0,1.0,nlevs) +min(colorv);
   
col=bytscl(levs, cmin=cmin, cmax=cmax);
 if(numberof(mypal==1)){
   //mypal;
   if(mypal>-1)col= split_bytscl(levs, mypal, cmin=cmin, cmax=cmax); 
 }
    nvv=0;
    xyzvv=0;
    cvalue=0;
    count=0;
    
      for(i=1; i<=nlevs-1;i++){        
      if((max(colorv)>levs(i))&&(min(colorv)<levs(i))){
          slice2xv, colorv-levs(i),nv,xyzv,colorv,nvb,xyzvb,colorvb;

          count++;
          if((count-1)%every==0){
              if(count==cutdown+1){
                  nvv=nvb;
                  xyzvv=xyzvb;
                  cvalue=char(array(col(i),numberof(nvb)));
                  
                  //cvalue=(array(col(i),numberof(nvb)));
              }
              if((count<cutup)&&(count>cutdown+1)){
                  nvv=grow(nvv,nvb);
                  xyzvv=grow(xyzvv,xyzvb);
                  cvalue=grow(cvalue,char(array(col(i),numberof(nvb))));
                  //cvalue=grow(cvalue,(array(col(i),numberof(nvb))));
                  
              }
              /*
                pl3tree,nvb,xyzvb,char(array(col(i),numberof(nvb)));
                limit3,-1.5,1.5,-1.5,1.5,-1.5,1.5;
                draw3,1;
              */
          }
      }
      }
      
     if(numberof(nvv)!=1){
          if(count<cutup){
              
              nvv=grow(nvv,nv);
              xyzvv=grow(xyzvv,xyzv);
              cvalue=grow(cvalue,char(array(col(nlevs),numberof(nv))));
          }
          
         if(!is_void(out)){
            nvout=nvv;
            xyzvout=xyzvv;
            return;
          }
         
         if(numberof(mypal)>1){
           
           
           if(!is_void(shade))pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax,mypal=mypal;
           else pl3tree,nvv,xyzvv,mypal(,int(cvalue)),ecol=ecol,cmax=cmax;
           //pl3tree,nvv,xyzvv,cvalue,mypal=mypal;
           
         }else{
           if(mypal>-1){
             if(!is_void(shade))pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax,mypal=mypal;
             else pl3tree,nvv,xyzvv,cvalue,ecol=ecol,cmax=cmax,mypal=mypal;
           }else{
             if(!is_void(shade))pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax;
             else pl3tree,nvv,xyzvv,cvalue,ecol=ecol,cmax=cmax;
         

           }
           
         }
         
              }
          return;
}

func lcontour3b(nv,xyzv,colorv,&nvout,&xyzvout,&nv_line,&vv_line,&cv_line,levs=,nlevs=,ecol=,cmax=,cmin=,every=,shade=,out=,mypal=,cutdown=,cutup=,everyl=,le=,le_low=,dle=,edge_value=)
{
  extern  flag_surface_contour;
  extern surface_contour_edge_color,nv_mask;
  if(is_void(levs)){
  if(is_void(nlevs))nlevs=20;
  }else {
    if(levs(1)>min(colorv))levs=grow(min(colorv),levs);
    nlevs=numberof(levs);
  }
  if(is_void(cutdown))cutdown=0;
    if(is_void(cutup))cutup=nlevs+1;
    
    if(is_void(cmax))cmax=max(colorv);
    if(is_void(cmin))cmin=min(colorv);
    
  if(is_void(every))every=1;
    if(is_void(everyl))everyl=1;
  if(is_void(mypal))mypal=-1;
  //if(!is_void(ecol))surface_contour_edge_color=ecol;
  
  //if(is_void(levs))levs=span(-1.0,1.0,nlevs)*0.5*(max(colorv)-min(colorv));
if(is_void(levs))levs=(max(colorv)-min(colorv))*span(0,1.0,nlevs) +min(colorv);
   
col=bytscl(levs, cmin=cmin, cmax=cmax);
 if(numberof(mypal)==1){
   //mypal;
   if(mypal>-1)col= split_bytscl(levs, mypal, cmin=cmin, cmax=cmax); 
 }
 nvv=[];
 xyzvv=[];
 edge_valuev=[];
 cvalue=0;
 count=0;
 ic=1;
  for(i=1; i<=nlevs-1;i++){
 //for(i=1; i<=6;i++){
   if((max(colorv)>levs(i))&&(min(colorv)<levs(i))){
     slice2xvv, colorv-levs(i),nv,xyzv,colorv,edge_value,nvb,xyzvb,colorvb,edge_valueb;
    ic=i;
 
       //       write,dimsof(nvb2);
       //}
    
     //slice2xv, colorv-(levs(i)+0.001),nvb2,xyzvb2,colorvb2,nvb,xyzvb,colorvb;
     //cvalue2=char(array(col(nlevs),numberof(nvb2)));

     
     count++;
     if((count-1)%every==0){
       if(count==cutdown+1){
         
         nvv=nvb;
         xyzvv=xyzvb;
                  cvalue=char(array(col(i),numberof(nvb)));
                  edge_valuev=edge_valueb;
                  //cvalue=(array(col(i),numberof(nvb)));
              }
              if((count<cutup)&&(count>cutdown+1)){
                  nvv=grow(nvv,nvb);
                  xyzvv=grow(xyzvv,xyzvb);
                  edge_valuev=grow(edge_valuev,edge_valueb);
                  cvalue=grow(cvalue,char(array(col(i),numberof(nvb))));
                  //cvalue=grow(cvalue,(array(col(i),numberof(nvb))));
                  
              }
              /*
                pl3tree,nvb,xyzvb,char(array(col(i),numberof(nvb)));
                limit3,-1.5,1.5,-1.5,1.5,-1.5,1.5;
                draw3,1;
              */
          }
      }
      }
      
     if(numberof(nvv)>0){
       // if(count<cutup){
       if(numberof(nv)>0){  
              nvv=grow(nvv,nv);
              // dimsof(xyzvv);
              //dimsof(xyzv);
              xyzvv=grow(xyzvv,xyzv);
              edge_valuev=grow(edge_valuev,edge_value);
              cvalue=grow(cvalue,char(array(col(ic+1),numberof(nv))));
       }
       
       if(!is_void(out)){
         nvout=nvv;
            xyzvout=xyzvv;
            return;
          }
         
         if(numberof(mypal)>1){
           
         
           if(!is_void(shade)){
             
             pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax,cmin=cmin,mypal=mypal;
            
           }else {
             //             int(cvalue);
             //                          pl3tree,nvv,xyzvv,mypal(,int(cvalue)+1),ecol=ecol,cmax=cmax,cmin=cmin;


                          colorvb_mask= (edge_valuev<le+dle)*(edge_valuev > le-dle);
                          if(!is_void(le_low)){
                          colorvb_mask_low= (edge_valuev<le_low+dle)*(edge_valuev>le_low-dle);
                            
                          colorvb_mask+=colorvb_mask_low*2;
                          }
                          /*
                          vf= histogram(1+nvv(psum))(1:-1);
                          vf(1)+= 1;
                          vf= vf(psum);
                                     nv_mask0=nvv*0;
                          
                          aaaa=vf(where(colorvb_mask));
                          nv_mask0(aaaa)=1;
                          
                           nv_mask=grow(nv_mask0,nv_mask);
                          */
                          vv_mask=grow(colorvb_mask,vv_mask);
                          pl3tree,nvv,xyzvv,mypal(,int(cvalue)+1),ecol=ecol,cmax=cmax,cmin=cmin,vvmask=colorvb_mask;
             //pl3tree,nvv,xyzvv,int(cvalue),ecol=ecol,cmax=cmax,cmin=cmin,mypal=mypal;
             //pl3tree,nvv,xyzvv,mypal(,int(cvalue)+1),ecol=ecol,cmax=2.0,cmin=0;
             
             
             // pl3tree,nvv,xyzvv,mypal=mypal,ecol=ecol,cmax=cmax;
           //pl3tree,nvv,xyzvv,cvalue,mypal=mypal;
           }
         }else{
           if(mypal>-1){
             if(!is_void(shade))pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax,mypal=mypal,cmin=cmin;
             else pl3tree,nvv,xyzvv,cvalue,ecol=ecol,cmax=cmax,mypal=mypal,cmin=cmin;
           }else{
             if(!is_void(shade))pl3tree,nvv,xyzvv,ecol=ecol,cmax=cmax,cmin=cmin;
             else pl3tree,nvv,xyzvv,cvalue,ecol=ecol,cmax=cmax,cmin=cmin;
         

           }
           
         }
         
     }

   
     
     //     pl3tree,nvb2,xyzvb2,,ecol=ecol,cmax=cmax,cmin=cmin;
     //pl3tree,nvd2,xyzvb2,ecol=ecol,cmax=cmax,cmin=cmin;
     //return;
}

func lcontour31(nv,xyzv,colorv,&nvout,&xyzvout,levs=,nlevs=,levsl=,nlevsl=,ecol=,cmax=,cmin=,cmaxl=,cminl=,every=,shade=,out=,mypal=,mypal1=,mypal2=,cutdown=,cutup=,everyl=,lcon=,omit=,line=,vind=,flag=,vcount=)
/* DOCUMENT lcontour31,nv,xyzv,colorv
         or lcontour31,nv,xyzv,colorv,nlevs=10,nlevsl=30

         cuts the polygon "nv,xyzv" into each peaces between
         contours based on value of "colorv" and fill the pieces with a pallete
         baced on "colorv".
         "colorv" must have same shape of "xyzv(1,)" (= xyzv(2,)=xyzv(3,)).  

   KEYWORDS: levs -- [value1, value2,..,valuen] : a list of values
                     at whch you want contours.
            nlevs -- integer : number of contours.
            nlevsl -- integer : number of contours for light sheding.
             ecol -- char/RGB: edge color
            every -- integer: skip every "every" pieace.
              out -- 1/0: output polygon data for other ploting function.
   SEE ALSO: lcontour3

   <Example>
   nn=64;
   x= span(-3,3,nn)(,-:1:nn);
   y= transpose(x);
   z= sin(sqrt(x^2+y^2)+0.2)*cos(x-y^2);
   make_xyz,z,y,x,nv,xyzv;
   win2;win3;
   clear3;
   orient3,-pi/3,pi/3;
   lcontour31,nv,xyzv,xyzv(3,),nlevsl=20,nlevs=4,lcon=1,cmaxl=2,cminl=-1;
   lim3,3,3,3;
   cage3,1;

 */
{
  extern  flag_surface_contour,surface_contour_edge_color,nv_mask,vv_mask;
  
    flag_surface_contour=0;
    nv_mask=[];
    //  vv_mask=[];
 
    if(is_void(line))line=1;
    
    if(line==1){
        flag_surface_contour=1;
        surface_contour_edge_color=ecol;
      
    }
  if(is_void(levs)){
    if(is_void(nlevs))nlevs=20;
  }else {
    //if(levs(1)>min(colorv))levs1=grow(min(colorv),levs1);
    
    //levs=levs1;
    if(is_void(nlevs))nlevs=numberof(levs);
  }

  if(is_void(nlevsl))nlevsl=20;

  
  if(is_void(cutdown))cutdown=0;
  if(is_void(cutup))cutup=nlevs+1;
  if(is_void(lcon))lcon=0;
  if(is_void(cmax))cmax=max(colorv);
  if(is_void(cmin))cmin=min(colorv);
 
  // if(is_void(cmaxl))cmaxl=2.0;
  //if(is_void(cminl))cminl=0.0;
  
  if(is_void(every))every=1;
  if(is_void(mypal))mypal=-1;
  if(is_void(mypal1))mypal1="gg";
  if(is_void(mypal2))mypal2="rr";
  
 
  vvv_line=[];
  cvv_line=[];

  nvvb2=[];
  vvvb2=[];

  //  colorv=lv;
  vp=get_light(nv,xyzv);

 
  lv=light_face(nv,xyzv,vp,vind=vind,flag=flag,vcount=vcount);
  
  
  //    dimsof(colorv);
  //dimsof(lv);
  nvl=nv;
  xyzvl=xyzv;

  if(typeof(mypal2)=="string")mypal2=make_mypal(mypal2);
  if(typeof(mypal1)=="string")mypal1=make_mypal(mypal1);
    //wei=span(-0.1,1.1,nlevs);
    wei=span(-0.0,1.0,nlevs);
    //wei(where(wei<0))=0.0;
    //wei(where(wei>1))=1.0;
  
  //if(is_void(levs))levs=span(-1.0,1.0,nlevs)*0.5*(max(colorv)-min(colorv));
    if(is_void(levs)){
      levs=(max(colorv)-min(colorv))*span(0,1.0,nlevs) +min(colorv);
      //levs;
    }

    omit_mask=array(0,numberof(levs)+1);
    if(!is_void(omit)){
      if(sum(omit)>0)omit_mask(omit)=1;
      if(sum(omit)<0){
        omit_mask+=1;
        omit_mask(-1*omit)=0;
          }
    }
 levsl=(max(lv)-min(lv))*span(0,1.0,nlevsl) +min(lv);
 
col=bytscl(levsl, cmin=cminl, cmax=cmaxl);
 if(numberof(mypal==1)){
   //mypal;
   if(mypal>-1)col= split_bytscl(levsl, mypal, cmin=cminl, cmax=cmaxl); 
 }
    nvv=[];
    xyzvv=[];
    cvalue=0;
    count=0;
    ic=0;
    for(i=1; i<=nlevs-1;i++){        
      //write,levs;
      flag_layer=((max(colorv)>levs(i))*(min(colorv)<levs(i)));
      flag_mono_layer=(i<nlevs)*(min(colorv)>=levs(i))*(max(colorv)<=levs(i+1));
      //write,i,flag_mono_layer;
      
      if(flag_mono_layer==1){
        //write,"mono layer!";
        flag_layer=2;
        line=0;
        flag_surface_contour=0;
      }

      //      write,"layer:",i,flag_layer,levs(i),max(colorv),min(colorv);

      //      if(flag_layer==1){
      if(flag_layer>0){
        
        if(flag_layer==1){
          slice2xvv, colorv-levs(i),nv,xyzv,colorv,lv,nvb,xyzvb,colorvb,lvb;
        }
        if(flag_layer==2){
          nvb=nv;xyzvb=xyzv;lvb=lv;
          omit_mask(i)=1;
        }
        ic=i;           

   
        count++;
   
          
        nvv=grow(nvv,nvb);
        xyzvv=grow(xyzvv,xyzvb);
        //cvalue=grow(cvalue,(array(col(i),numberof(nvb))));
          
          
          
        mmpal=char(wei(i)*mypal2+(1.0-wei(i))*mypal1);      
        if(omit_mask(ic)==0){
          //write,"last layer:",ic;
          if(lcon==1){
            if(count>1)lcontour3b,nvb,xyzvb,lvb,mypal=mmpal,levs=levsl,cmax=cmaxl,cmin=cminl,everyl=everyl,le=levs(i),le_low=levs(i-1),dle=(max(levs)-min(levs))*0.00001,edge_value=colorvb;
            else lcontour3b,nvb,xyzvb,lvb,mypal=mmpal,levs=levsl,cmax=cmaxl,cmin=cminl,everyl=everyl,le=levs(i),dle=(max(levs)-min(levs))*0.00001,edge_value=colorvb;
            
          }
          if(lcon==0){
            //pl3tree,nvb,xyzvb,mypal=mmpal,cmax=cmaxl,cmin=cminl;
            if(flag_layer==1){
              colorvb_mask= (colorvb<levs(i)+(max(levs)-min(levs))*0.00001)*(colorvb>levs(i)-(max(levs)-min(levs))*0.00001);
              if(count>1){
                colorvb_mask_low= (colorvb<levs(i-1)+(max(levs)-min(levs))*0.00001)*(colorvb>levs(i-1)-(max(levs)-min(levs))*0.00001);
                
                colorvb_mask+=colorvb_mask_low*2;
              
              }
            }else{
              colorvb_mask= (colorvb*0+1>0);
            }
            
            pl3tree,nvb,xyzvb,mypal=mmpal,cmax=cmaxl,cmin=cminl,vvmask=colorvb_mask;
            
          }   
        }
        
      }
    }
    
    // if(0){
    if(omit_mask(ic+1)==0){ 
                  
          mmpal=char(wei(ic+1)*mypal2+(1.0-wei(ic+1))*mypal1);      
          //lcontour3,nv,xyzv,lv,mypal=mmpal,levs=levsl,cmax=cmaxl,cmin=cminl,everyl=everyl;


          if(lcon==1)lcontour3b,nv,xyzv,lv,mypal=mmpal,levs=levsl,cmax=cmaxl,cmin=cminl,everyl=everyl,le=levs(ic),le_low=levs(ic-1),dle=(max(levs)-min(levs))*0.00001,edge_value=colorv;
          if(lcon==0){
            
            //            pl3tree,nv,xyzv,mypal=mmpal,cmax=cmaxl,cmin=cminl;
          colorv_mask= (colorv<levs(ic)+(max(levs)-min(levs))*0.00001)*(colorv>levs(ic)-(max(levs)-min(levs))*0.00001)
            pl3tree,nv,xyzv,mypal=mmpal,cmax=cmaxl,cmin=cminl,vvmask=colorv_mask;
            
          }
          
          nvv=grow(nvv,nv);
          xyzvv=grow(xyzvv,xyzv);

    }

   
}




func sortvf(dim,&v,&vind,&flag,&vcount,&list){
  if(dim<4){
  list_buf=1;
  
  for(i=1;i<= numberof(vcount)-1;i++){    
    st=vcount(i);
    ed=vcount(i+1)-1;
    list_buf=sort(v(dim,st:ed))+st-1;
    list(st:ed)=list_buf;
  }
    v=v(,list);
    vind=vind(list);
    flag_buf=((grow([1.0],v(dim,dif)))>0)
    flag=(flag+flag_buf>0);
   
    vcount=where(grow(flag,[1]));
    write,"dim: ",dim
   
    sortvf,dim+1,v,vind,flag,vcount,list;
  }
  else return;
}

      

      
func light_face_init(nv,xyzv,&vind,&flag,&vcount){

  vf= histogram(1+nv(psum))(1:-1);
  vf(1)+= 1;
  vf= vf(psum);
  vind=indgen(numberof(vf));
  list=vind;
  flag=vind*0;
              
  vcount=[1,numberof(vind)+1];
  sortvf,1,xyzv,vind,flag,vcount,list; 
}

func light_face(nv,xyzv,vp,vind=,flag=,vcount=){

  
  vf= histogram(1+nv(psum))(1:-1);
  vf(1)+= 1;
  vf= vf(psum);
              


  if(is_void(vind)){
  vind=indgen(numberof(vf));
  list=vind;
  flag=vind*0;
  vcount=[1,numberof(vind)+1];    
    sortvf,1,xyzv,vind,flag,vcount,list;

  }
  //  flag;
    
  vn=vcount(dif);
  mask=flag(psum);
  //mask;
  //dimsof(mask);
  buf=histogram(mask,vp(vf(vind)));
  
  buf/=double(vn);
  vf=double(vf)
      
  vf(vind)=buf(mask);
  return vf;
  
}

func light_facev(nv,xyzv,vp){

  vf= histogram(1+nv(psum))(1:-1);
  vf(1)+= 1;
  vf= vf(psum);
  vind=indgen(numberof(vf));
  list=vind;
  flag=vind*0;
              
  vcount=[1,numberof(vind)+1];
  sortvf,1,xyzv,vind,flag,vcount,list; 
  vn=vcount(dif);
  mask=flag(psum);
  dimsof(histogram(mask,vp(1,vf(vind))));
  numberof(vf);
  
  bu=histogram(mask,vp(1,vf(vind)));
  buf=transpose(array(bu,3));
  buf(2,)=histogram(mask,vp(2,vf(vind)));
  buf(3,)=histogram(mask,vp(3,vf(vind)));
  dimsof(buf);
  dimsof(vn);
  buf/=double(vn(-:1:3,));
  vv=array(0.0,3,numberof(vf))
      
  vv(,vind)=buf(,mask);
  return vv;
  
}







/* ------------------------------------------------------------------------ */

func slice2xvv(plane, &nverts, &xyzverts, &values, &lv,&nvertb, &xyzvertb, &valueb,&lvb)
/* DOCUMENT slice2, plane, nverts, values, xyzverts

     Slice a polygon list, retaining only those polygons or
     parts of polygons on the positive side of PLANE, that is,
     the side where xyz(+)*PLANE(+:1:3)-PLANE(4) > 0.0.
     The NVERTS, VALUES, and XYZVERTS arrays serve as both
     input and output, and have the meanings of the return
     values from the slice3 function.

   SEE ALSO: slice2, slice2_precision
 */
{
  _slice2x= 1;
  return slice2vv(plane, nverts, xyzverts, values, lv,nvertb, xyzvertb, valueb,lvb);
}


func slice2vv(plane, &nverts, &xyzverts, &values, &lv,&nvertb, &xyzvertb, &valueb,&lvb)
/* DOCUMENT slice2, plane, nverts, xyzverts
         or slice2, plane, nverts, xyzverts, values

     Slice a polygon list, retaining only those polygons or
     parts of polygons on the positive side of PLANE, that is,
     the side where xyz(+)*PLANE(+:1:3)-PLANE(4) > 0.0.
     The NVERTS, XYZVERTS, and VALUES arrays serve as both
     input and output, and have the meanings of the return
     values from the slice3 function.  It is legal to omit the
     VALUES argument (e.g.- if there is no fcolor function).

     In order to plot two intersecting slices, one could
     slice (for example) the horizontal plane twice (slice2x) -
     first with the plane of the vertical slice, then with minus
     that same plane.  Then, plot first the back part of the
     slice, then the vertical slice, then the front part of the
     horizontal slice.  Of course, the vertical plane could
     be the one to be sliced, and "back" and "front" vary
     depending on the view point, but the general idea always
     works.

   SEE ALSO: slice3, plane3, slice2x, slice2_precision
 */
{
  have_values= !is_void(values);

  /* get the list of indices into nverts (or values) for each of
   * the points in xyzverts */
  ndxs= histogram(1+nverts(psum))(1:-1);
  ndxs(1)+= 1;
  ndxs= ndxs(psum);

  /* form dot products of all the points with the given plane */
  //dp= xyzverts(+,)*plane(+:1:3) - plane(4);
  dp = plane;
  /* separate into lists of unclipped and partially clipped polys */
  if (!slice2_precision) {
    /* if precision is not set, slice exactly at dp==0.0, with
     * any points exactly at dp==0.0 treated as if they had dp>0.0 */
    keep= (dp>=0.0);
  } else {
    /* if precision is set, polygons are clipped to +-precision,
     * so that any poly crossing +precision is clipped to dp>=+precision,
     * any poly crossing -precision is clipped to dp<=-precision, and
     * any poly lying entirely between +-precision is discarded entirely */
    keep= (dp>=slice2_precision);
  }
  nkeep= long(histogram(ndxs, keep));
  mask0= (nkeep==nverts);
  mask1= (nkeep!=0 & !mask0);
  list1= where(mask1);
  if (numberof(list1)) {
    nvertc= nverts(list1);
    //if (have_values) valuec= values(list1);
    list= where(mask1(ndxs));
    xyzc= xyzverts(, list);
    valuec= values(list);
 
    //  list;
    //dimsof(lv);
    //dimsof(values);
    lvc= lv(list);
  }
  if (_slice2x) {
    if (!slice2_precision) {
      mask2= !nkeep;
      nvertc0= nvertc;
      valuec0= valuec;
      lvc0= lvc;
      xyzc0= xyzc;
    } else {
      keep2= (dp>-slice2_precision);
      nkeep2= long(histogram(ndxs, keep2));
      mask2= (nkeep!=0 & nkeep<nverts);
      list2= where(mask2);
      if (numberof(list2)) {
	nvertc0= nverts(list2);
	//if (have_values) valuec0= values(list2);
	listc= where(mask2(ndxs));
	xyzc0= xyzverts(, listc);
        valuec0= values(listc);
        lvc0= lv(listc);
      }
      mask2= !nkeep2;
    }
    list2= where(mask2);
    if (numberof(list2)) {
      nvertb= nverts(list2);
      //if (have_values) valueb= values(list2);
      xyzvertb= xyzverts(, where(mask2(ndxs)));
      valueb= values(where(mask2(ndxs)));
      lvb= lv(where(mask2(ndxs)));
    } else {
      nvertb= valueb= xyzvertb= lvb=[];
    }
  }
  list0= where(mask0);
  if (numberof(list0)<numberof(nverts)) {
    nverts= nverts(list0);
    //if (have_values) values= values(list0);
    xyzverts= xyzverts(, where(mask0(ndxs)));
    values= values(where(mask0(ndxs)));
    lv= lv(where(mask0(ndxs)));
  }

  /* done if no partially clipped polys */
  if (!numberof(list1) && !numberof(listc)) return;
  if (!numberof(list1)) goto skip;

  /* get dot products and keep list for the clipped polys */
  dp= dp(list);
  if (slice2_precision) dp-= slice2_precision;
  keep= (dp>=0.0);

  /* get the indices of the first and last points in each clipped poly */
  last= nvertc(psum);
  frst= last - nvertc + 1;

  /* get indices of previous and next points in cyclic order */
  prev= next= indgen(0:numberof(keep)-1);
  prev(frst)= last;
  next(prev)= indgen(numberof(keep));

  _slice2_partvv;

  grow, nverts, nvertc;
  if (have_values) grow, values, valuec;
  if (have_values) grow, lv, lvc;
  grow, xyzverts, xyzc;

  if (_slice2x) {
  skip:
    nvertc= nvertc0;
    valuec= valuec0;
    lvc= lvc0;
    xyzc= xyzc0;
    if (!slice2_precision) {
      keep= !keep;
    } else {
      dp= dp(listc)+slice2_precision;
      keep= (dp>=0.0);
    }

    _slice2_partvv;

    grow, nvertb, nvertc;
    //if (have_values) grow, valueb, valuec;
    grow, xyzvertb, xyzc;
    grow, valueb, valuec;
    grow, lvb, lvc;
  }
}

local slice2_precision;
/* DOCUMENT slice2_precision= precision
     Controls how slice2 (or slice2x) handles points very close to
     the slicing plane.  PRECISION should be a positive number or zero.
     Zero PRECISION means to clip exactly to the plane, with points
     exactly on the plane acting as if they were slightly on the side
     the normal points toward.  Positive PRECISION means that edges
     are clipped to parallel planes a distance PRECISION on either
     side of the given plane.  (Polygons lying entirely between these
     planes are completely discarded.)

     Default value is 0.0.

   SEE ALSO: slice2, slice2x
 */
slice2_precision= 0.0;

func _slice2_partvv
{
  extern nvertc, xyzc, valuec,lvc;

  //numberof(xyzc(1,));
  //numberof(valuec);
  /* find the points where any edges of the polys cut the plane */
  mask0= (!keep) & keep(next);   /* off-->on */
  list0= where(mask0);
  if (numberof(list0)) {
    list= next(list0);
    dpl= dp(list0)(-,);
    dpu= dp(list)(-,);
    xyz0= (xyzc(,list0)*dpu-xyzc(,list)*dpl)/(dpu-dpl);
    value0=(valuec(list0)*dpu(1,)-valuec(list)*dpl(1,))/(dpu(1,)-dpl(1,));
    lv0=(lvc(list0)*dpu(1,)-lvc(list)*dpl(1,))/(dpu(1,)-dpl(1,));
    
  }
  mask1= (!keep) & keep(prev);   /* on-->off */
  list1= where(mask1);
  if (numberof(list1)) {
    list= prev(list1);
    dpl= dp(list1)(-,);
    dpu= dp(list)(-,);
    xyz1= (xyzc(,list1)*dpu-xyzc(,list)*dpl)/(dpu-dpl);
    value1= (valuec(list1)*dpu(1,)-valuec(list)*dpl(1,))/(dpu(1,)-dpl(1,));
    lv1= (lvc(list1)*dpu(1,)-lvc(list)*dpl(1,))/(dpu(1,)-dpl(1,));
  }

  /* form an index list xold which gives the indices in the original
   * xyzc list at the places in the new, sliced xyzc list */
  mask= keep+mask0+mask1;  /* 0, 1, or 2 */
  list= mask(psum);  /* index values in new list */
  xold= array(0, list(0));
  mlist= where(mask);
  xold(list(mlist))= mlist;
  dups= where(mask==2);
  if (numberof(dups)) xold(list(dups)-1)= dups;
  
  /* form the new, sliced xyzc vertex list */
  xyzc= xyzc(,xold);
  valuec=valuec(xold);
  lvc=lvc(xold);
  // numberof(valuec);
  //numberof(value0);
  //numberof(xyzc);
  //numberof(xyz0);
  
  //  valuec
  //value0
  if (numberof(list0)) {
      xyzc(,list(list0))= xyz0;
      
      valuec(list(list0))= value0;
      lvc(list(list0))= lv0;
  }
  if (numberof(list1)) {
      xyzc(,list(list1)-mask(list1)+1)= xyz1;
      valuec(list(list1)-mask(list1)+1)= value1;
      lvc(list(list1)-mask(list1)+1)= lv1;
  }
  /* get the list of indices into nvertc (or valuec) for each of
   * the points in xyzc */
  ndxs= histogram(1+last)(1:-1);
  ndxs(1)+= 1;
  ndxs= ndxs(psum);
  /* compute the new number of vertices */
  nvertc= histogram(ndxs(xold));
}

















/* ------------------------------------------------------------------------ */

func slice2xv(plane, &nverts, &xyzverts, &values, &nvertb, &xyzvertb, &valueb)
/* DOCUMENT slice2, plane, nverts, values, xyzverts

     Slice a polygon list, retaining only those polygons or
     parts of polygons on the positive side of PLANE, that is,
     the side where xyz(+)*PLANE(+:1:3)-PLANE(4) > 0.0.
     The NVERTS, VALUES, and XYZVERTS arrays serve as both
     input and output, and have the meanings of the return
     values from the slice3 function.

   SEE ALSO: slice2, slice2_precision
 */
{
  _slice2x= 1;
  return slice2v(plane, nverts, xyzverts, values, nvertb, xyzvertb, valueb);
}


func slice2v(plane, &nverts, &xyzverts, &values, &nvertb, &xyzvertb, &valueb)
/* DOCUMENT slice2, plane, nverts, xyzverts
         or slice2, plane, nverts, xyzverts, values

     Slice a polygon list, retaining only those polygons or
     parts of polygons on the positive side of PLANE, that is,
     the side where xyz(+)*PLANE(+:1:3)-PLANE(4) > 0.0.
     The NVERTS, XYZVERTS, and VALUES arrays serve as both
     input and output, and have the meanings of the return
     values from the slice3 function.  It is legal to omit the
     VALUES argument (e.g.- if there is no fcolor function).

     In order to plot two intersecting slices, one could
     slice (for example) the horizontal plane twice (slice2x) -
     first with the plane of the vertical slice, then with minus
     that same plane.  Then, plot first the back part of the
     slice, then the vertical slice, then the front part of the
     horizontal slice.  Of course, the vertical plane could
     be the one to be sliced, and "back" and "front" vary
     depending on the view point, but the general idea always
     works.

   SEE ALSO: slice3, plane3, slice2x, slice2_precision
 */
{
  have_values= !is_void(values);

  /* get the list of indices into nverts (or values) for each of
   * the points in xyzverts */
  ndxs= histogram(1+nverts(psum))(1:-1);
  ndxs(1)+= 1;
  ndxs= ndxs(psum);

  /* form dot products of all the points with the given plane */
  //dp= xyzverts(+,)*plane(+:1:3) - plane(4);
  dp = plane;
  /* separate into lists of unclipped and partially clipped polys */
  if (!slice2_precision) {
    /* if precision is not set, slice exactly at dp==0.0, with
     * any points exactly at dp==0.0 treated as if they had dp>0.0 */
    keep= (dp>=0.0);
  } else {
    /* if precision is set, polygons are clipped to +-precision,
     * so that any poly crossing +precision is clipped to dp>=+precision,
     * any poly crossing -precision is clipped to dp<=-precision, and
     * any poly lying entirely between +-precision is discarded entirely */
    keep= (dp>=slice2_precision);
  }
  nkeep= long(histogram(ndxs, keep));
  mask0= (nkeep==nverts);
  mask1= (nkeep!=0 & !mask0);
  list1= where(mask1);
  if (numberof(list1)) {
    nvertc= nverts(list1);
    //if (have_values) valuec= values(list1);
    list= where(mask1(ndxs));
    xyzc= xyzverts(, list);
    valuec= values(list);
  }
  if (_slice2x) {
    if (!slice2_precision) {
      mask2= !nkeep;
      nvertc0= nvertc;
      valuec0= valuec;
      xyzc0= xyzc;
    } else {
      keep2= (dp>-slice2_precision);
      nkeep2= long(histogram(ndxs, keep2));
      mask2= (nkeep!=0 & nkeep<nverts);
      list2= where(mask2);
      if (numberof(list2)) {
	nvertc0= nverts(list2);
	//if (have_values) valuec0= values(list2);
	listc= where(mask2(ndxs));
	xyzc0= xyzverts(, listc);
        valuec0= values(listc);
      }
      mask2= !nkeep2;
    }
    list2= where(mask2);
    if (numberof(list2)) {
      nvertb= nverts(list2);
      //if (have_values) valueb= values(list2);
      xyzvertb= xyzverts(, where(mask2(ndxs)));
      valueb= values(where(mask2(ndxs)));
    } else {
      nvertb= valueb= xyzvertb= [];
    }
  }
  list0= where(mask0);
  if (numberof(list0)<numberof(nverts)) {
    nverts= nverts(list0);
    //if (have_values) values= values(list0);
    xyzverts= xyzverts(, where(mask0(ndxs)));
    values= values(where(mask0(ndxs)));
  }

  /* done if no partially clipped polys */
  if (!numberof(list1) && !numberof(listc)) return;
  if (!numberof(list1)) goto skip;

  /* get dot products and keep list for the clipped polys */
  dp= dp(list);
  if (slice2_precision) dp-= slice2_precision;
  keep= (dp>=0.0);

  /* get the indices of the first and last points in each clipped poly */
  last= nvertc(psum);
  frst= last - nvertc + 1;

  /* get indices of previous and next points in cyclic order */
  prev= next= indgen(0:numberof(keep)-1);
  prev(frst)= last;
  next(prev)= indgen(numberof(keep));

  _slice2_partv;

  grow, nverts, nvertc;
  if (have_values) grow, values, valuec;
  grow, xyzverts, xyzc;

  if (_slice2x) {
  skip:
    nvertc= nvertc0;
    valuec= valuec0;
    xyzc= xyzc0;
    if (!slice2_precision) {
      keep= !keep;
    } else {
      dp= dp(listc)+slice2_precision;
      keep= (dp>=0.0);
    }

    _slice2_partv;

    grow, nvertb, nvertc;
    //if (have_values) grow, valueb, valuec;
    grow, xyzvertb, xyzc;
    grow, valueb, valuec;
  }
}

local slice2_precision;
/* DOCUMENT slice2_precision= precision
     Controls how slice2 (or slice2x) handles points very close to
     the slicing plane.  PRECISION should be a positive number or zero.
     Zero PRECISION means to clip exactly to the plane, with points
     exactly on the plane acting as if they were slightly on the side
     the normal points toward.  Positive PRECISION means that edges
     are clipped to parallel planes a distance PRECISION on either
     side of the given plane.  (Polygons lying entirely between these
     planes are completely discarded.)

     Default value is 0.0.

   SEE ALSO: slice2, slice2x
 */
slice2_precision= 0.0;

func _slice2_partv
{
  extern nvertc, xyzc, valuec;

  //numberof(xyzc(1,));
  //numberof(valuec);
  /* find the points where any edges of the polys cut the plane */
  mask0= (!keep) & keep(next);   /* off-->on */
  list0= where(mask0);
  if (numberof(list0)) {
    list= next(list0);
    dpl= dp(list0)(-,);
    dpu= dp(list)(-,);
    xyz0= (xyzc(,list0)*dpu-xyzc(,list)*dpl)/(dpu-dpl);
    value0=(valuec(list0)*dpu(1,)-valuec(list)*dpl(1,))/(dpu(1,)-dpl(1,));
    
  }
  mask1= (!keep) & keep(prev);   /* on-->off */
  list1= where(mask1);
  if (numberof(list1)) {
    list= prev(list1);
    dpl= dp(list1)(-,);
    dpu= dp(list)(-,);
    xyz1= (xyzc(,list1)*dpu-xyzc(,list)*dpl)/(dpu-dpl);
    value1= (valuec(list1)*dpu(1,)-valuec(list)*dpl(1,))/(dpu(1,)-dpl(1,));
  }

  /* form an index list xold which gives the indices in the original
   * xyzc list at the places in the new, sliced xyzc list */
  mask= keep+mask0+mask1;  /* 0, 1, or 2 */
  list= mask(psum);  /* index values in new list */
  xold= array(0, list(0));
  mlist= where(mask);
  xold(list(mlist))= mlist;
  dups= where(mask==2);
  if (numberof(dups)) xold(list(dups)-1)= dups;
  
  /* form the new, sliced xyzc vertex list */
  xyzc= xyzc(,xold);
  valuec=valuec(xold);
  // numberof(valuec);
  //numberof(value0);
  //numberof(xyzc);
  //numberof(xyz0);
  
  //  valuec
  //value0
  if (numberof(list0)) {
      xyzc(,list(list0))= xyz0;
      
      valuec(list(list0))= value0;
  }
  if (numberof(list1)) {
      xyzc(,list(list1)-mask(list1)+1)= xyz1;
      valuec(list(list1)-mask(list1)+1)= value1;
  }
  /* get the list of indices into nvertc (or valuec) for each of
   * the points in xyzc */
  ndxs= histogram(1+last)(1:-1);
  ndxs(1)+= 1;
  ndxs= ndxs(psum);
  /* compute the new number of vertices */
  nvertc= histogram(ndxs(xold));
}















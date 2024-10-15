func make_mypal(palname,rgb){
  if(is_void(rgb))rgb=[1,2,3];
  if(!is_void(palname))pal,palname;
  palette,r,g,b,query=1;
  pale=transpose([r,g,b]);
  return transpose([pale(rgb(1),),pale(rgb(2),),pale(rgb(3),)]);
}

func make_palette(file,r,g,b){
  if(is_void(r))palette,r,g,b,query=1;
  f=open(file,"w");
  write,f,"ncolors=",numberof(r),"\n";
  write,f,r,g,b;
  close,f;
  return;
}
  



func pale (name){
n = 240;
m = 255;
i = (span(0,m,n)-110)*0.4+150;
//i = (span(0,m,n)-120)*0.4+150;
 
//sigmoid
//r = m*(1/(1+exp(-0.07*(i-0.55*m))));
//convex
//r = m*exp(-((i-0.5*m)/50)^2);
//concave
//r = m*(1-exp(-((i-0.5*m)/50)^2));

if(name == "rb"){
r = m*(1-exp(-((i-0.6*m)/30)^2));
g=m*(1/(1+exp(0.09*(i-0.6*m)))); 
b=m*(1/(1+exp(-0.09*(i-0.6*m)))); 

}



if(name == "blue"){


r = m*(1/(1+exp(-0.07*(i-0.7*m))));
g= m*(1/(1+exp(-0.07*(i-0.6*m))));
b= 0.88*m*(1-exp(-((i-0.35*m)/70)^2))+30;
}

if(name == "koge"){
r = m*(1/(1+exp(-0.07*(i-0.6*m))));
g=r;
b= m*(1-exp(-((i-0.5*m)/40)^2));
}

if(name == "wine"){
r = m*(1/(1+exp(-0.07*(i-0.6*m))));
g= m*(1-exp(-((i-0.5*m)/40)^2));
b= m*(1-exp(-((i-0.5*m)/40)^2));
}

if(name == "bg2"){
r =i*0+0.2;
g = m*(1/(1+exp(0.07*(i-0.6*m))));
b= m*(1/(1+exp(-0.07*(i-0.6*m))));
}
if(name == "gb2"){
r =i*0+0.2;
b = m*(1/(1+exp(0.07*(i-0.6*m))));
g= m*(1/(1+exp(-0.07*(i-0.6*m))));
}
if(name == "rg2"){
b =i*0+0.2;
g = m*(1/(1+exp(0.07*(i-0.6*m))));
r= m*(1/(1+exp(-0.07*(i-0.6*m))));
}
if(name == "gr2"){
b =i*0+0.2;
r = m*(1/(1+exp(0.07*(i-0.6*m))));
g= m*(1/(1+exp(-0.07*(i-0.6*m))));
}


if(name == "cr"){
r = m*(1-exp(-((i-0.6*m)/30)^2));
g=m*(1-exp(-((i-0.5*m)/30)^2));
b=m*(1/(1+exp(-0.09*(i-0.6*m)))); 
}

if(name == "sunrise"){
r = m*(1-exp(-((i-0.6*m)/30)^2));
g=m*(1-exp(-((i-0.55*m)/25)^2));
b=m*(1/(1+exp(-0.09*(i-0.6*m)))); 
}


if(name == "by"){
r = m*(1-exp(-((i-0.6*m)/30)^2));
g=m*(1-exp(-((i-0.6*m)/26)^2));
b=m*(1/(1+exp(-0.09*(i-0.6*m)))); 
}
if(name == "rg"){
b = m*(1-exp(-((i-0.5*m)/80)^2));
g=m*(1-exp(-((i-0.6*m)/20)^2));
r=m*(1/(1+exp(-0.09*(i-0.6*m)))); 
}


if(name == "yb"){
b = m*(1-exp(-((i-0.6*m)/30)^2));
r=m*(1-exp(-((i-0.5*m)/30)^2));
g=m*(1/(1+exp(-0.09*(i-0.6*m)))); 

}
if(name == "te"){
g = m*(1-exp(-((i-0.6*m)/30)^2));
//b=m*(1/(1+exp(-0.09*(i-0.6*m)))); 

b=m*(1-exp(-((i-0.4*m)/30)^2));
r=m*(1/(1+exp(-0.09*(i-0.6*m)))); 

}


palette,r,g,b;


}

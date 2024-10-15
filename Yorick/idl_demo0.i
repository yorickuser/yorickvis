line_color=red;

idl_init_pause=1;
idl_init=1;

x=span(0,12,100);
win2;
animate,1;
for(i=0;i<=10000;i++){
fma;
plg,sin(i*0.05+x)+cos(-i*0.08+1.5*x+1),x,color=line_color;
if(idl(20))break;
}
animate,0;

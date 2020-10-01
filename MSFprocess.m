function [sys,x0] = MSF(t,x,u,flag,param,fname)

global dist NREJ NREC Bd Wd sumLB sumLD 
  
if abs(flag) == 1
  % Return state derivatives.
  sys = msfplant(x,u);
elseif abs(flag) == 3
  % Return system outputs.
  if t==0; msfplant(x,u); sumLb=0; sumLD=0; end
  sys = [x(22) x(44)-273 x(67)-273 x(68) Bd Wd];  
elseif flag == 0
  % Initalize the system
  x0=load(fname);
  sys = [68, 0, 6, 3, 0, 0];
  dist=param(1:13); 
  NREJ=param(14);
  NREC=param(15);
  sumLB=0;
  sumLD=0;
  clear tout xout
else
  sys = [];  
end

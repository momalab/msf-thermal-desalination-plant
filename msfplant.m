   function [DELTA]=Plant(XP,UP)  
 
   global dist NREJ NREC Bd Wd sumLB sumLD
   
   NSTG=NREJ+NREC; 
	N0=0*NSTG;
	N1=1*NSTG;
	N2=2*NSTG;
	N3=3*NSTG;	
	NN1=NSTG-NREJ+1;
   
   AB=1260.0/22.0;
   AD=63.0/22.0;
	AHC=77314.8/19.0;
	AHR=7919.1/3.0;
	AS=3225.7;
	WN=3.0;
   KD=1.0;
   K=0.68;
	C=0.625;
   H=0.11;
	G=9.81;
   W=0.50;
   
	TREF	=	273.15;
	B0		=	UP(1)+0.0066667;
	TFEED	=	UP(2)+TREF;
	WS		=	UP(3)+0.074;
	US 	=	dist(1); 
   U		=	dist(2);
	WF		=	dist(3); 
	REJ	=	dist(4);
	REC	=	0.0;
	TS		=	dist(5)+TREF; 
	WMK	=	WF-REJ-REC;
   Wdss  =  dist(6);
   Bdss  =  dist(7);
   RLss  =  dist(8);
   RLDss =  dist(11);
   kc    =  [dist(9) dist(12)];
   ki    =  [dist(10) dist(13)];
   
   
	for I=1:NSTG
		RL(I)=XP(I);
		TB(I)=XP(N1+I);
      TF(I)=XP(N2+I);
   end
   TB0   = XP(N3+1);	   
   RLD   = XP(N3+2);   
	TFREC = TB(NSTG);
	DTS   = TS-(TF(1)+TB0)*0.5;

%  Calculate the physical properties

	for I=1:NSTG
	   PP=PRESS(TB(I));
      PB(I)=PP;
   end
	HLV0 = LATENT(TS);
   PB0  = PRESS(TB0);

	RHOB0=1016.0;
	CPB0=1.00;
	RHOB=1032.4;
	RHOF=1029.6;
	CPB=1.00;
	CPF=1.00;
	CPV=0.4865;
	BPR=2.192;
	FMW=23654.0;
	HLV=563.7959;
	HV=625.1971;
	FMC=34736.09;
   
   
% calculate the brine flow rates

	for I=1:NSTG-1
      if I==1; 
         DP=PB0-PB(I);
	   else
	      DP=PB(I-1)-PB(I);
	   end
	   DH=RL(I)-C*H;
	   if I==NSTG;  DH=RL(I); WN=W; end
	   DPDH=DP*1.01d5+G*RHOB*DH;
	   BR(I)=WN*K*RL(I)*sqrt(max(0.0D0,DPDH*RHOB));
      BR(I)=BR(I)*60.0/1000.0;
  end
  Bd=Bdss+kc(1)*(RLss-RL(22))+kc(1)*ki(1)*sumLB;
  sumLB=sumLB+(RLss-RL(22));
  
% calculate the vapor flow rates
	
  for I=1:NSTG
	   if(I==NREC)
	      DT(I)=TB(I)-BPR/1.8-(TFREC+TF(I))*0.5;
	   elseif(I==NSTG)
	      DT(I)=TB(I)-BPR/1.8-(TFEED+TF(I))*0.5;
	   else
		  DT(I)=TB(I)-BPR/1.8-(TF(I+1)+TF(I))*0.5;
	   end
	   if(I<=NREC)
	     VR(I)=U*AHC*DT(I)/HLV/1000.0;
	   else
	     VR(I)=U*AHR*DT(I)/HLV/1000.0;
	   end
	end

	DL(1)=VR(1);	 
	for I=2:NSTG-1;
	  DL(I)=DL(I-1)+VR(I);
   end
   Wd=Wdss+kc(2)*(RLDss-RLD)+kc(2)*ki(2)*sumLD;
   sumLD=sumLD+(RLDss-RLD);
   
% develope the state equations here      

   I=1;
   DELTA(N0+I)=(B0-BR(I)-VR(I))*1000.0/RHOB/AB;
	DELTA(N1+I)=B0*CPB*(TB0-TB(I));
   DELTA(N1+I)=DELTA(N1+I)-VR(I)*(HV-CPB*(TB(I)-TREF));
   DELTA(N1+I)=DELTA(N1+I)*1000.0/AB/RHOB/CPB/RL(I);
				       
   DELTA(N2+I)=B0*CPF*(TF(I+1)-TF(I))*1000;
   DELTA(N2+I)=DELTA(N2+I)+U*AHC*DT(I);
   DELTA(N2+I)=DELTA(N2+I)/FMW/CPF;
       
   for I=2:NREC
      DELTA(N0+I)=(BR(I-1)-BR(I)-VR(I))*1000/RHOB/AB;
	   DELTA(N1+I)=BR(I-1)*CPB*(TB(I-1)-TB(I));
      DELTA(N1+I)=DELTA(N1+I)-VR(I)*(HV-CPB*(TB(I)-TREF));
	   DELTA(N1+I)=DELTA(N1+I)*1000.0/AB/RHOB/CPB/RL(I);
	   if(I==NREC)
	     DELTA(N2+I)=B0*CPF*(TFREC-TF(I))*1000;
	   else
	     DELTA(N2+I)=B0*CPF*(TF(I+1)-TF(I))*1000;
	   end
	   DELTA(N2+I)=DELTA(N2+I)+U*AHC*DT(I);
	   DELTA(N2+I)=DELTA(N2+I)/FMW/CPF;
  end

  for I=NREC+1:NSTG-1
     DELTA(N0+I)=(BR(I-1)-BR(I)-VR(I))*1000/RHOB/AB;
	  DELTA(N1+I)=BR(I-1)*CPB*(TB(I-1)-TB(I));
     DELTA(N1+I)=DELTA(N1+I)-VR(I)*(HV-CPB*(TB(I)-TREF));
     DELTA(N1+I)=DELTA(N1+I)*1000.0/AB/RHOB/CPB/RL(I);	 
	  DELTA(N2+I)=WF*CPF*(TF(I+1)-TF(I))*1000;
	  DELTA(N2+I)=DELTA(N2+I)+U*AHR*DT(I);
	  DELTA(N2+I)=DELTA(N2+I)/FMW/CPF;
 end

 I=NSTG;    
 DELTA(N0+I)=(BR(I-1)-Bd-VR(I)-B0+WMK)*1000/RHOB/AB;
 DELTA(N1+I)=BR(I-1)*CPB*(TB(I-1)-TB(I));
 DELTA(N1+I)=DELTA(N1+I)+WMK*CPB*(TF(NN1)-TB(I));
 DELTA(N1+I)=DELTA(N1+I)-VR(I)*(HV-CPB*(TB(I)-TREF));
 DELTA(N1+I)=DELTA(N1+I)*1000.0/AB/RHOB/CPB/RL(I);
 DELTA(N2+I)=WF*CPF*(TFEED-TF(I))*1000;
 DELTA(N2+I)=DELTA(N2+I)+U*AHR*DT(I);
 DELTA(N2+I)=DELTA(N2+I)/FMW/CPF;
	 
 DTS=WS*HLV0/US/AS;
 DELTA(N3+1)=(B0*(CPF*TF(1)-CPB0*TB0)*1000.0+US*AS*DTS)/FMC/CPF;
 
 DELTA(N3+2)=(-Wd+DL(I-1)+VR(I))*1000/RHOB/AD;

 return




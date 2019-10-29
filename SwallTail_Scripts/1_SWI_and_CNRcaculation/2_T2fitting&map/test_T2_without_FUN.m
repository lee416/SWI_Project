close all;clc;clear all;

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);
pathname_D0='E:\SwallowTail_Project\Subjects';

Subjects=[201];
echoNum=7; % varify from subject 201~203 >>7,204~209 >>8,210~222 >>7,
Scan_num=[1];

%%%%% T2 fitting knowledge 
deltaTE=7.1; %% from header
TE1=9.5;
x=1:echoNum;
xdata=TE1+((x-1).*deltaTE); %% data be fit
% ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
g0=[1 100];%% guess range

 for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
%    h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss))))); 
     if Subjects(ss)<10
     pathname_SWI0=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_SWI0=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
     else 
     pathname_SWI0=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
     end
     
%%%%%%%%%%%%% SWI data load %%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pathname_SWI0); %%SWI data file
SWI_direc0 = spm_select('list', pathname_SWI0, '\.img');
SWI_data= SWI_direc0(1:echoNum,:);
SWI_mag_data = spm_read_vols(spm_vol(strcat(pathname_SWI0,'\',SWI_data)));
% figure;imagesc(SWI_mag_data(:,:,30,1)); axis image;colormap(gray);title('SWI')

%%%%%%%%%%%%% T1mask data load %%%%%%%%%%%%%%%%%%%%%%%%%%
T1mask_direc = strcat(pathname_SWI0,'\T1_mask');
cd(T1mask_direc)
T1mask_select = spm_select('list', T1mask_direc, '\.img');
T1mask0= spm_read_vols(spm_vol(strcat(T1mask_direc,'\',T1mask_select)));
% figure;imagesc(T1mask(:,:,30));axis image;colormap(gray);title('T1mask')

%%%% start, T2 map
xxx=size(SWI_mag_data,1);
yyy=size(SWI_mag_data,2);
zzz=size(SWI_mag_data,3);
T2map=zeros(xxx,yyy,zzz);
T1mask=round(T1mask0);
cd(mfile_dir)  %% to script file

%%%% T2 fitting 
% ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
% g0=[1 100];%% guess range
for zz=30:30
% for zz=1:size(SWI_mag_data,3)
 h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
 for jj=1:yyy
 waitbar(jj/yyy)
    for ii=1:xxx
  if T1mask(ii,jj,zz) ==1
clear ydata; ydata=zeros(1,echoNum);   %% make sure data for lsqcurvefit is double type
ydata(1:echoNum)=SWI_mag_data(ii,jj,zz,:);
g=lsqcurvefit(@fun_lsqcurfit_T2,g0,xdata,ydata);
% Amp=g(1);
T2=g(2) 
T2map(ii,jj,zz)=T2;
clear g;

  end
  end
 end
   close(h)
end

     end
 end
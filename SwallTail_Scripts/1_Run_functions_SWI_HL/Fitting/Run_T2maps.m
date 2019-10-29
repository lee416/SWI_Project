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
%%%%%%%%%%%%%%%%%%%%%%%%%

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
     
     %%%% start, T2 map
     [T2map]=fun_T2map(pathname_SWI0,mfile_dir,echoNum,xdata)
     figure;imagesc(T2map(:,:,30));axis image;colormap(gray);title('T2map of',num2str(ss))
     %%% end, T2map
 
 
% close(h)
     end
 end

















% %%%% curve fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deltaTE=7.1; %% unkown
% TE1=9.5;
% x=1:6;
% xdata=TE1+((x-1).*deltaTE); %% data be fit
% % ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
% g0=[1 100];%% guess range
% cd('E:\SwallowTail_Project\SwallTail_Scripts\1_Run_functions_SWI\Fitting');
% T2map=zeros(size(img,1),size(img,2),size(img,3));
% 
% 
% for zz=30:30
% %  h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
%   for ii=1:size(img,2)
%   for jj=1:size(img,2)
% %    waitbar(ii/matrix_size)
% clear ydata; ydata=zeros(1,6);   %% make sure data for lsqcurvefit is double type
% ydata(1:6)=img(jj,ii,zz,:);
% g=lsqcurvefit(@fun_lsqcurfit_T2,g0,xdata,ydata);
% Amp=g(1); T2=g(2); 
% T2map(jj,ii,zz)=T2;
% 
% % SIc_est = Amp*exp(-xdata/T2);
% % figure;plot(xdata,ydata,'r*');title(strcat('QAQ'));
% % hold on;plot(xdata,SIc_est,'b');
% % xlabel('echo, serial');ylabel('Signal Intensity');
% 
%   end
%   end
% end
% 
% figure;imagesc(T2map(:,:,30));axis image;colormap(gray)



close all;clc;clear all;

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

cd('E:\SwallowTail_Project\Subjects\Sub_001\Scan1\SWI_Data\MatData_All');
load mag_img_Mat 
img= mag_img_Mat;
% slice=60;
img_zeros=zeros(size(img,1),size(img,2),size(img,3),size(img,4));
TE=6;

%%%% T2 fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaTE=7.1; %% unkown
TE1=9.5;
x=1:6;
xdata=TE1+((x-1).*deltaTE); %% data be fit
% ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
g0=[1 100];%% guess range

cd(mfile_dir);
T2map=zeros(size(img,1),size(img,2),size(img,3));

for zz=29:30
%  h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
  for ii=1:size(img,2)
  for jj=1:size(img,2)
%    waitbar(ii/matrix_size)
clear ydata; ydata=zeros(1,6);   %% make sure data for lsqcurvefit is double type
ydata(1:6)=img(jj,ii,zz,:);
g=lsqcurvefit(@fun_lsqcurfit_T2,g0,xdata,ydata);
Amp=g(1); T2=g(2); 
T2map(jj,ii,zz)=T2;

% SIc_est = Amp*exp(-xdata/T2);
% figure;plot(xdata,ydata,'r*');title(strcat('QAQ'));
% hold on;plot(xdata,SIc_est,'b');
% xlabel('echo, serial');ylabel('Signal Intensity');

  end
  end
end

figure;imagesc(T2map(:,:,30));axis image;colormap(gray);title('T2cuvreDATA')



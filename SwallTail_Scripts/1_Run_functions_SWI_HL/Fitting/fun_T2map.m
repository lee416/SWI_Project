function [T2map]=fun_T2map(pathname_SWI0,mfile_dir,echoNum,xdata)
%%%%%%%%%%%%% SWI data load %%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pathname_SWI0); %%SWI data file
SWI_direc0 = spm_select('list', pathname_SWI0, '\.img');
SWI_data= SWI_direc0(1:echoNum,:);
SWI_mag_data = spm_read_vols(spm_vol(strcat(pathname_SWI0,'\',SWI_data)));
%%%%%%%%%%%%% T1mask data load %%%%%%%%%%%%%%%%%%%%%%%%%%
T1mask_direc = strcat(pathname_SWI0,'\T1_mask');
cd(T1mask_direc)
T1mask_select = spm_select('list', pathname_SWI0, '\.img');
T1mask= spm_read_vols(spm_vol(strcat(pathname_SWI0,'\',T1mask_select)));

%%%%%%%%%%%%% T2 fitting 
% ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
cd(mfile_dir) %% to script file
g0=[1 100]; %% guess range
T2map=zeros(size(SWI_mag_data,1),size(SWI_mag_data,2),size(SWI_mag_data,3));
%%%%[ii, jj, zz]

for zz=1:size(SWI_mag_data,3)
 h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
 for jj=1:size(SWI_mag_data,2)
       waitbar(jj/size(SWI_mag_data,2))
  for ii=1:size(SWI_mag_data,1)
  if T1mask(ii,jj,zz)>1
clear ydata; ydata=zeros(1,echoNum);   %% make sure data for lsqcurvefit is double type
ydata(1:echoNum)=SWI_mag_data(jj,ii,zz,:);
g=lsqcurvefit(@fun_lsqcurfit_T2,g0,xdata,ydata);
Amp=g(1); T2=g(2); 
T2map(jj,ii,zz)=T2;
  else
T2map(jj,ii,zz)=0;
  end
  end
 end
   close(h)
end



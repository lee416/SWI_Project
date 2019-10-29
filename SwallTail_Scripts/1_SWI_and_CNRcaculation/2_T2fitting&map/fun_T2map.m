function      [T2map]=fun_T2map(pathname_SWI0,mfile_dir,echoNum,xdata,g0)

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
T2map=zeros(size(SWI_mag_data,1),size(SWI_mag_data,2),size(SWI_mag_data,3));
T1mask=round(T1mask0);
cd(mfile_dir)  %% to script file

%%%% T2 fitting 
% ydata=signal(:)'; %% data(y axis) be fit, flip [6,1]>>[1,6]
% g0=[1 100];%% guess range
for zz=30:30
% for zz=1:size(SWI_mag_data,3)
%  h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
 for jj=1:size(SWI_mag_data,2)
%  waitbar(jj/size(SWI_mag_data,2))
  for ii=1:size(SWI_mag_data,1)
   if T1mask(ii,jj,zz) ==1
   clear ydata; ydata=zeros(1,echoNum);   %% make sure data for lsqcurvefit is double type
   ydata(1:echoNum)=SWI_mag_data(ii,jj,zz,:);
   g=lsqcurvefit(@fun_lsqcurfit_T2,g0,xdata,ydata);
% Amp=g(1);
   T2=g(2); 
   T2map(ii,jj,zz)=T2;
%    fitted_ydata = g(1).*exp(-xdata./g(2));
%    clear g;
%    figure;plot(xdata,ydata,'r*');hold on
%    plot(xdata,fitted_ydata,'b')
  end
  end
 end
%    close(h)
end



function fun_run_aveSWI_Heather(Data_dir,matrix_size,SWI_img, mag_img,unwrapped_phase_img)

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

SWI_img_ave=mean(SWI_img,4);
% SWI_img_ave=mean(SWI_img(:,:,:,5:7),4);
fun_write_Dicom_SWIave_Heather(Data_dir,matrix_size,SWI_img_ave);
% for sss=1:matrix_size(3)
% figure;
% imagesc(SWI_img_ave(:,:,display_slice)');axis image;colormap gray;axis off
% title(strcat('SWI Ave',num2str(sss)))
% pause;close all
% %m(iss)=getframe;          
% %movie(m(iss), 0.3);
% end

cd(mfile_dir)

mag_img_ave=mean(mag_img,4);
fun_write_Dicom_MagAve_Heather(Data_dir,matrix_size,mag_img_ave);
% for sss=1:matrix_size(3)
% figure;
% imagesc(mag_img_ave(:,:,display_slice)');axis image;colormap gray;axis off
% title(strcat('Mag Ave',num2str(sss)))
% pause;close all
% %m(iss)=getframe;          
% %movie(m(iss), 0.3);
% end
cd(mfile_dir)

unwrapped_phase_img_ave=mean(unwrapped_phase_img,4);
fun_write_Dicom_PhaseAve_Heather(Data_dir,matrix_size,unwrapped_phase_img_ave);
% for sss=1:matrix_size(3)
% figure;
% imagesc(unwrapped_phase_img_ave(:,:,display_slice)');axis image;colormap gray;axis off
% title(strcat('Phase Ave',num2str(sss)))
% pause;close all
% %m(iss)=getframe;          
% %movie(m(iss), 0.3);
% end
cd(mfile_dir)

%%%%%%%%%%%%%%% start, save .mat files for ROI analysis %%%%%%%%%%%%%%%%%
for ssq=1:matrix_size(3)
 SWI_img_ave_Mat(:,:,ssq)=SWI_img_ave(:,:,ssq)';
 mag_img_ave_Mat(:,:,ssq)=mag_img_ave(:,:,ssq)';
 unwrapped_phase_img_ave_Mat(:,:,ssq)=unwrapped_phase_img_ave(:,:,ssq)';
end

for eeq=1:matrix_size(4)
 for ssq=1:matrix_size(3)
  SWI_img_Mat(:,:,ssq,eeq)=SWI_img(:,:,ssq,eeq)';
  mag_img_Mat(:,:,ssq,eeq)=mag_img(:,:,ssq,eeq)';
  unwrapped_phase_img_Mat(:,:,ssq,eeq)=unwrapped_phase_img(:,:,ssq,eeq)';
 end
end

cd(Data_dir);
mkdir('MatData_All'); 
saveMatDir_Final=strcat(Data_dir,'\MatData_All');
cd(saveMatDir_Final)

save SWI_img_ave_Mat SWI_img_ave_Mat
save mag_img_ave_Mat mag_img_ave_Mat
save unwrapped_phase_img_ave_Mat unwrapped_phase_img_ave_Mat

save SWI_img_Mat SWI_img_Mat
save mag_img_Mat mag_img_Mat
save unwrapped_phase_img_Mat unwrapped_phase_img_Mat

%%%%%%%%%%%%%%% end, save .mat files for ROI analysis %%%%%%%%%%%%%%%%%
cd(mfile_dir)



clear all;close all; clc;

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Subjects=[801];
Scan_num=[1];
echo_display=[4];
display_slice=[35 36];

pathname_1='D:\SwallowTail_Project\Subjects_inIMA';
% pathname='E:\SwallowTail_Project\SubjectsROW\Sub_214\Scan1\SWI';

for ss=1: size(Subjects,2)
  for ssq=1:size(Scan_num,2)
   if Subjects(ss)<10
    pathname=strcat(pathname_1,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
   elseif Subjects(ss)<=99&Subjects(ss)>=10
    pathname=strcat(pathname_1,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
   else 
    pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
   end
Data_dir=pathname;
[iField,voxel_size,matrix_size,CF,delta_TE,TE,B0_dir]=...
Read_Siemens_DICOM(Data_dir); 

matrix_size(4)=size(iField,4);
spatial_complex=iField;
mag_img=abs(iField);
img_k=zeros(matrix_size(1),matrix_size(2),matrix_size(3),size(iField,4));
wrapped_phase_img=zeros(matrix_size(1),matrix_size(2),matrix_size(3),size(iField,4));

 figure;imagesc(mag_img(:,:,33,echo_display)');axis image;colormap(gray)

for echo_n=1:size(iField,4)
 for ssq=1:size(iField,3)
   wrapped_phase_img(:,:,ssq,echo_n)=(-1).*angle(spatial_complex(:,:,ssq,echo_n)); %% (-1).* is for Siemens' phase encoding direction.
 end
end
%  figure;imagesc(wrapped_phase_img(:,:,33,echo_display)');axis image;colormap(gray)

for sse=1:size(iField,4)
 for ss1=1:matrix_size(3)
  img_k(:,:,ss1,sse)=spatial_complex(:,:,ss1,sse); 
  kimg(:,:,ss1,sse)=(fftshift(fft2(fftshift(img_k(:,:,ss1,sse)))));
%  kimg(:,:,ss)=fftshift(kimg(:,:,ss),1);
 end
end
% figure;imagesc(abs(kimg(:,:,display_slice(ss),echo_display(ss))));axis image; axis off;colormap gray

[SWI_img unwrapped_phase_img phase_mask]=fun_run_SWI_Heather(ss,Data_dir,TE, spatial_complex,mag_img,kimg,display_slice,echo_display,matrix_size);

figure;imagesc(flipud(rot90(abs(SWI_img(:,:,33,echo_display(ss))))));axis image; axis off;colormap gray;title('SWI')

fun_run_aveSWI_Heather(Data_dir,matrix_size,SWI_img, mag_img,unwrapped_phase_img);

  end
end




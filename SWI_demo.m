clc;clear all;close all

addpath ./spm8/
Data_dir='C:\Users\Charles\Desktop\paper\lead_coversation\data';
[iField,voxel_size,matrix_size,CF,delta_TE,TE,B0_dir]=Read_Siemens_DICOM(Data_dir); 
spatial_complex=iField(:,:,42:50); % spatial domain data
size(spatial_complex)
% save spatial_complex spatial_complex
wrapped_phase_img=zeros(matrix_size(1),matrix_size(2),matrix_size(3),size(iField,4));
phase_data=wrapped_phase_img(:,:,42:50,4);
save phase_data phase_data


%%%  load spatial data a*bi (408*416*6)
% load spatial_complex
slice= 4;

% mag Img
mag_img=abs(spatial_complex); 
figure;imagesc(mag_img(:,:,slice)');axis image;colormap(gray);
title('mag')

% get phase Img for angle(arctan in Matlab)
wrapped_phase_img(:,:,slice)=(-1).*angle(spatial_complex(:,:,slice)); %% (-1).* is for Siemens' phase encoding direction.
% figure;imagesc(wrapped_phase_img(:,:,slice)');axis image;colormap(gray);
% title('phase')

% fft kspace data
kimg(:,:,slice)=(fftshift(fft2(fftshift(spatial_complex(:,:,slice)))));
% figure;imagesc(abs(kimg(:,:,slice)));axis image; axis off;colormap gray;
% title('kspace')

% filter mask
filter_k=zeros(size(spatial_complex,1),size(spatial_complex,2));
filter_size=52;
for q=1:size(spatial_complex,1)
  for w=1:size(spatial_complex,2)
    D2=(q-204)^2+(w-208)^2;
    filter_k(q,w)=exp(-D2/(2*filter_size^2));
  end
end
% figure;imagesc(filter_k(:,:)');axis image;colormap(gray);title('phase');colorbar;
% title('kspace filter')

%%% None wrapped (the high phase data) 
% low pass spatial 
low_pass_img(:,:,slice)=fftshift(ifft2(fftshift(kimg(:,:,slice).*(filter_k))));
high_pass_phase1(:,:,slice)=(-1).*angle(spatial_complex(:,:,slice)./low_pass_img(:,:,slice));
figure; imagesc((high_pass_phase1(:,:,slice))');axis image; axis off;colormap gray
title('None wrapped Phase Img')
% figure; imagesc(abs(low_pass_img(:,:,slice))');axis image; axis off;colormap gray;
% title('filter spatial Img')

% phase mask (-pi~0 mask)
 for jj=1:size(spatial_complex,2)
    for ii=1:size(spatial_complex,1)
     if high_pass_phase1(ii,jj,slice)<=0
        high_pass_phase_Mask(ii,jj,slice)=1;
     elseif high_pass_phase1(ii,jj,slice)>0
        high_pass_phase_Mask(ii,jj,slice)=(-high_pass_phase1(ii,jj,slice)+(pi))/((pi));
     end
    end
 end
figure; imagesc((high_pass_phase_Mask(:,:,slice))');axis image; axis off;colormap gray;colorbar;
title('PhaseMask')

% 5 times phase
phase_mask=high_pass_phase_Mask.^5;

% SWI making
SWI_img=mag_img(:,:,slice).*phase_mask(:,:,slice);
figure;imagesc(flipud(rot90(abs(SWI_img))));axis image; axis off;colormap gray;
title('SWI')



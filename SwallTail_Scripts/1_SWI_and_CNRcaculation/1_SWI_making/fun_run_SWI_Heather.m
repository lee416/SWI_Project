function [SWI_img unwrapped_phase_img phase_mask]=fun_run_SWI_Heather(ss,Data_dir,TE, spatial_complex,mag_img,kimg,display_slice,echo_display,matrix_size)

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

%%%%%%%%%%%%%%%%%%% Make a low-pass gaussian filter %%%%%%%%%%%%%%%%%%%%
% filter_k=zeros(matrix_size(1),matrix_size(2));
filter_k=zeros(matrix_size(1),matrix_size(2));

%%% for matrix size 408x416
filter_size=52;
for q=1:matrix_size(1)
  for w=1:matrix_size(2)
    D2=(q-204)^2+(w-208)^2;
    filter_k(q,w)=exp(-D2/(2*filter_size^2));
  end
end

low_pass_img=zeros(matrix_size(1),matrix_size(2),matrix_size(3),matrix_size(4));
for ess=1:matrix_size(4)
 for iss=1:matrix_size(3)
  low_pass_img(:,:,iss,ess)=fftshift(ifft2(fftshift(kimg(:,:,iss,ess).*(filter_k))));
%   imagesc(abs(low_pass_img(:,:,iss)));axis image; axis off;colormap gray
%   m(iss)=getframe;          
%   movie(m(iss), 0.3);
%  pause
 end
end
figure; imagesc(abs(low_pass_img(:,:,display_slice(ss),echo_display(ss)))');axis image; axis off;colormap gray;
title('LowPassImg')

high_pass_phase1=zeros(matrix_size(1),matrix_size(2),matrix_size(3),matrix_size(4));
for ekk=1:matrix_size(4)
for ikk=1:matrix_size(3)
 high_pass_phase1(:,:,ikk,ekk)=(-1).*angle(spatial_complex(:,:,ikk,ekk)./low_pass_img(:,:,ikk,ekk));
%  imagesc(abs(high_pass_phase1(:,:,ikk)));axis image; axis off;colormap gray
%  m(ikk)=getframe;          
%  movie(m(ikk), 0.3);
%  pause
end
end
figure; imagesc((high_pass_phase1(:,:,display_slice(ss),echo_display(ss)))');axis image; axis off;colormap gray
title('UnwrappedPhaseImg')

unwrapped_phase_img=high_pass_phase1;
fun_write_Dicom_Phase_Heather(Data_dir,matrix_size,TE,unwrapped_phase_img);
cd(mfile_dir)


%%%%%%%%%%% Start, Creat Phase Mask %%%%%%%%%%%
% max_phase=max(max(high_pass_phase1(:,:,68))); %% max=3.14
% min_phase=min(min(high_pass_phase1(:,:,68))); %% min=-3.14
 [ high_pass_phase_Mask]=fun_positive_mask_Heather(high_pass_phase1,matrix_size);
figure; imagesc((high_pass_phase_Mask(:,:,display_slice(ss),echo_display(ss)))');axis image; axis off;colormap gray;
title('HighpassPhaseMask')

% %%%%% Display Phase Mask %%%%
% for ees=1:matrix_size(4)
% for sss=1:matrix_size(3)
%     figure;imagesc(high_pass_phase_Mask(:,:,sss,4)');axis image;colormap gray;title('positive mask without multiplication')
%     pause;close all
%     %m(sss)=getframe;          
%     %movie(m(sss), 0.3);
% end
% end

phase_mask=high_pass_phase_Mask.^5;

SWI_img=mag_img.*phase_mask;
% for sss=1:matrix_size(3)
% figure;
% imagesc(SWI_img(:,:,sss,echo_display)');axis image;colormap gray;title(strcat('SWI',num2str(sss)))
% pause;close all
% %m(iss)=getframe;          
% %movie(m(iss), 0.3);
% end
fun_write_Dicom_SWI_Heather(Data_dir,matrix_size,TE,SWI_img);
cd(mfile_dir)
















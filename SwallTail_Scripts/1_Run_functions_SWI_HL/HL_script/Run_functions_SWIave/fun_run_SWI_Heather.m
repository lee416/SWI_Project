function [SWI_img unwrapped_phase_img phase_mask]=fun_run_SWI_Heather(ss,Data_dir,TE, spatial_complex,mag_img,kimg,display_slice,echo_display,matrix_size)

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

% matrix_size=size(mag_img);
% % function [high_pass_phase_2]=fun_positive_mask_Heather(high_pass_phase_11,matrix_size)
% clear all;clc;close all;
% 
% mfile_which= mfilename('fullpath');
% mfile_dir=fileparts(mfile_which);
% 
% %%%%%%%%%%%%%% start, import data %%%%%%%%%%
% Title='Please input Data Directory and display echo';
% Prompt={'Data_dir','display_echo','display_slice'};
% LineNo=1;
% % DefAns={'H:\Parkinson Diseases\Subjects_Test\Sub_203\QSM_Data','4','30'};
% DefAns={'D:\Parkinson Diseases\Subjects_Test\Sub_001\QSM_Data','4','30'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% % slicenumber=str2num(answer{1});
% % Matrix_size=str2num(answer{2});
% Data_dir=(answer{1});
% echo_display=str2num(answer{2});
% display_slice=str2num(answer{3});
% [iField,voxel_size,matrix_size,CF,delta_TE,TE,B0_dir]=...
% Read_Siemens_DICOM(Data_dir); %% Heather, added
% %%%%%%%%%%%%%%%% end, import data %%%%%%%%%%

% matrix_size(4)=size(iField,4);
% spatial_complex=iField;
% mag_img=abs(iField);
% img_k=zeros(matrix_size(1),matrix_size(2),matrix_size(3),size(iField,4));
% wrapped_phase_img=zeros(matrix_size(1),matrix_size(2),matrix_size(3),size(iField,4));
% 
% for echo_n=1:size(iField,4)
%  for ssq=1:size(iField,3)
%    wrapped_phase_img(:,:,ssq,echo_n)=(-1).*angle(spatial_complex(:,:,ssq,echo_n)); %% (-1).* is for Siemens' phase encoding direction.
%  end
% end
% %  figure;imagesc(wrapped_phase_img(:,:,display_slice,echo_display)');axis image;colormap(gray)
% 
% for sse=1:size(iField,4)
%  for ss=1:matrix_size(3)
%   img_k(:,:,ss,sse)=spatial_complex(:,:,ss,sse); 
%   kimg(:,:,ss,sse)=(fftshift(fft2(fftshift(img_k(:,:,ss,sse)))));
% %  kimg(:,:,ss)=fftshift(kimg(:,:,ss),1);
%  end
% end
% figure;imagesc(abs(kimg(:,:,display_slice,echo_display)));axis image; axis off;colormap gray

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

% %%%% for matrix size 512
% filter_size=64;
% for q=1:matrix_size(2)
%   for w=1:matrix_size(1)
%     D2=(q-245)^2+(w-256)^2;
%     filter_k(q,w)=exp(-D2/(2*filter_size^2));
%   end
% end

%%%%% for matrix size 256
% filter_size=32;
% for q=1:matrix_size(2)
%     for w=1:matrix_size(1)
%         D2=(q-128)^2+(w-128)^2;
%         filter_k(q,w)=exp(-D2/(2*filter_size^2));
%     end
% end

% %%%% for matrix size 128
% filter_size=16;
% for q=1:matrix_size(2)
%     for w=1:matrix_size(1)
%         D2=(q-64)^2+(w-64)^2;
%         filter_k(q,w)=exp(-D2/(2*filter_size^2));
%     end
% end

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
figure; imagesc(abs(low_pass_img(:,:,display_slice(ss),echo_display(ss)))');axis image; axis off;colormap gray

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
unwrapped_phase_img=high_pass_phase1;
fun_write_Dicom_Phase_Heather(Data_dir,matrix_size,TE,unwrapped_phase_img);
cd(mfile_dir)


%%%%%%%%%%% Start, Creat Phase Mask %%%%%%%%%%%
% max_phase=max(max(high_pass_phase1(:,:,68))); %% max=3.14
% min_phase=min(min(high_pass_phase1(:,:,68))); %% min=-3.14
 [ high_pass_phase_Mask]=fun_positive_mask_Heather(high_pass_phase1,matrix_size);

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

% for sss=1:matrix_size(3)
% figure;
% imagesc(phase_mask(:,:,sss,echo_display)');axis image;colormap gray;title(strcat('phase mask',num2str(sss)))
% pause;close all
% %m(iss)=getframe;          
% %movie(m(iss), 0.3);
% end
%%%%%%%%%%% End, Creat Phase Mask %%%%%%%%%%%

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
















function [CBF_GM_ave CBF_WM_ave CBF_Global_ave]=GM_WM_Global_CBF_Calculation(ss,Subjects,pathname, pathname_anat)
Subjects_ID=Subjects(ss);
[tmp_data vol_GM]=fun_read_spm_GM(pathname_anat);
T1_GM=tmp_data;
[tmp_data vol_WM]=fun_read_spm_path_T1WM(pathname_anat);
T1_WM=tmp_data;
[tmp_data]=fun_read_spm_path_Global(ss,Subjects,pathname);
Global_mask_0=tmp_data;
% [tmp_data]=fun_read_spm_path_Thresholded_CBF_Mask(ss,Subjects,pathname);
% Thresholded_CBF_mask=tmp_data;
[tmp_data]=fun_read_spm_path_CBF(pathname,Subjects_ID);
CBF_map=tmp_data;

size_vol=size(T1_GM);
slicenumber=size_vol(3);

% for ss=1:slicenumber
%     figure;imagesc(T1_GM(:,:,ss));axis image;colormap(gray)
% end
% close all

% for ss=1:slicenumber
%     figure;imagesc(T1_WM(:,:,ss));axis image;colormap(gray)
% end
% close all

GM_mask=zeros(size_vol(1),size_vol(2),size_vol(3));
WM_mask=zeros(size_vol(1),size_vol(2),size_vol(3));
Global_mask=zeros(size_vol(1),size_vol(2),size_vol(3));
CBF_GM=zeros(size_vol(1),size_vol(2),size_vol(3));
CBF_WM=zeros(size_vol(1),size_vol(2),size_vol(3));
CBF_Global=zeros(size_vol(1),size_vol(2),size_vol(3));

for ss=1:slicenumber
    for ii=1:size_vol(1)
        for jj=1:size_vol(2)
            %if T1_GM(ii,jj,ss)>0
            if T1_GM(ii,jj,ss)>=0.8&CBF_map(ii,jj,ss)>0
                GM_mask(ii,jj,ss)=GM_mask(ii,jj,ss)+1;
            end
            %if T1_WM(ii,jj,ss)>0
            if T1_WM(ii,jj,ss)>=0.9&CBF_map(ii,jj,ss)>0
                WM_mask(ii,jj,ss)=WM_mask(ii,jj,ss)+1;
            end
            if Global_mask_0(ii,jj,ss)>0&CBF_map(ii,jj,ss)>0
                Global_mask(ii,jj,ss)=1;
            end
        end
    end
end

spm_write_GM_mask(GM_mask,vol_GM,pathname_anat);

fname_saved = sprintf('WM_mask_beforeErode.img');
spm_write_WM_mask(WM_mask,vol_WM,pathname_anat,fname_saved);
%spm_write_GM_WM_mask(Global_mask);

%%%%%%%%% image erosion %%%%%%%%%%%
SE=ones(2);
%SE=[1 0;0 1];
%SE = strel('disk',0.5);  
%SE = strel('ball',5,5);

for qq=1:size_vol(3)
 %T1_WM_eroded(:,:,qq) = bwmorph(T1_WM(:,:,qq),'erode'); %% use ones(3) for erosion
 %T1_WM_eroded(:,:,qq)=imerode(T1_WM(:,:,qq),SE);
 WM_mask_eroded(:,:,qq)=imerode(WM_mask(:,:,qq),SE);
end

% tmp_montage = [];
% for ss=1:slicenumber
%     tmp_montage(:,:,1,ss) = rot90(WM_mask_eroded(:,:,ss));
% end
% figure, montage(tmp_montage),colormap(gray(150));
% caxis([0 1]);axis off;

fname_saved = sprintf('WM_mask_afterErode.img');
spm_write_WM_mask_eroded(WM_mask_eroded,vol_WM,pathname_anat,fname_saved);


%%%%%%%%%%% display all Masks and CBF maps %%%%%%%%%%%%%
tmp_montage = [];
for ss=1:slicenumber
%     imagesc(GM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
    tmp_montage(:,:,1,ss) = rot90(GM_mask(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 1]);axis off;
%movie(m,1,10);

tmp_montage = [];
for ss=1:slicenumber
%     imagesc(WM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
  tmp_montage(:,:,1,ss) = rot90(WM_mask(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 1]);axis off;
%movie(m,1,10);

tmp_montage = [];
for ss=1:slicenumber
    tmp_montage(:,:,1,ss) = rot90(WM_mask_eroded(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 1]);axis off;

tmp_montage = [];
for ss=1:slicenumber
%     imagesc(Global_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
    tmp_montage(:,:,1,ss) = rot90(Global_mask(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 1]);axis off;
%movie(m,1,10);

tmp_montage = [];
for ss=1:slicenumber
%     imagesc(CBF_map(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
 tmp_montage(:,:,1,ss) = rot90(CBF_map(:,:,ss));
end
%movie(m,1,3);
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 150]);axis off;

pause
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ss=1:slicenumber
    for ii=1:size_vol(1)
        for jj=1:size_vol(2)
            if CBF_map(ii,jj,ss)>0
            CBF_GM(ii,jj,ss)=CBF_map(ii,jj,ss).*GM_mask(ii,jj,ss);
            end
        end
    end
end
CBF_GM_ave=sum(sum(sum(CBF_GM)))/sum(sum(sum(GM_mask)));

for ss=1:slicenumber
    for ii=1:size_vol(1)
        for jj=1:size_vol(2)
            if CBF_map(ii,jj,ss)>0
            %CBF_WM(ii,jj,ss)=CBF_map(ii,jj,ss).*WM_mask(ii,jj,ss);
            CBF_WM(ii,jj,ss)=CBF_map(ii,jj,ss).*WM_mask_eroded(ii,jj,ss);
            end
        end
    end
end
%CBF_WM_ave=sum(sum(sum(CBF_WM)))/sum(sum(sum(WM_mask)));
CBF_WM_ave=sum(sum(sum(CBF_WM)))/sum(sum(sum(WM_mask_eroded)));

for ss=1:slicenumber
    for ii=1:size_vol(1)
        for jj=1:size_vol(2)
            if CBF_map(ii,jj,ss)>0
            CBF_Global(ii,jj,ss)=CBF_map(ii,jj,ss).*Global_mask(ii,jj,ss);
            end
        end
    end
end
CBF_Global_ave=sum(sum(sum(CBF_Global)))/sum(sum(sum(Global_mask)));

% for ss=1:slicenumber
%     figure;imagesc(CBF_Global(:,:,ss));axis image;colormap(gray);
% end
% close all

% for ss=1:slicenumber
%     figure;imagesc(CBF_GM(:,:,ss));axis image;colormap(gray);
% end
% close all

% for ss=1:slicenumber
%     figure;imagesc(CBF_WM(:,:,ss));axis image;colormap(gray);
% end
% close all

[CBF_GM_ave CBF_WM_ave CBF_Global_ave]













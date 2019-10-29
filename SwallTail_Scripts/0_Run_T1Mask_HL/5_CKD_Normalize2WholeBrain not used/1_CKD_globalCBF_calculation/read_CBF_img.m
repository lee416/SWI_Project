%clear all, clc
clear all
%close all

[tmp_data, pathname]=fun_read_spm;
CBF_map=tmp_data;

size_vol=size(CBF_map);

slicenumber=size_vol(3);

% figure
% for ss=1:slicenumber-1
%     %figure;imagesc(CBF_map(:,:,ss)');axis image;colormap(gray(150));colorbar;caxis([0 150]) 
%    subplot(4,5,ss)
%    imshow(rot90(CBF_map(:,:,ss)),[0 150]);axis image;colormap(gray(150));caxis([0 150]);axis off;
% end

tmp_montage = [];
for ss=1:slicenumber
    %figure;imagesc(CBF_map(:,:,ss)');axis image;colormap(gray(150));colorbar;caxis([0 150]) 
   tmp_montage(:,:,1,ss) = rot90(CBF_map(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 150]);axis off;
%caxis([0 1]);axis off;

%%%%%%%% creat ANALYZE format %%%%%%%%%
% newname=sprintf('CBF_map_s011.img'); 
% fidout=fopen(newname,'w');  
% fwrite(fidout,CBF_map);
% fclose(fidout);
%%% then use ImageJ to read CBF_map and save as ANALYZE format
%1. File-->import-->Raw
%2. Image type: 8-bit
%    Width/Height/Number of images: xx/xx/xx
%    Offset to first image: 0 bytes
%    Gap between images:0
%3. File-->Save as--> Analyze 7.5


% %%%%%%%%% call Masks from CBF_map_seg, not from T1_seg %%%%%%
% 
% [tmp_data, pathname]=fun_read_spm2(pathname);
% CBF_GM=tmp_data;
% [tmp_data, pathname]=fun_read_spm2(pathname);
% CBF_WM=tmp_data;
% 
% GM_mask=zeros(size_vol(1),size_vol(2),size_vol(3));
% WM_mask=zeros(size_vol(1),size_vol(2),size_vol(3));
% 
% for ss=1:slicenumber
%     for ii=1:size_vol(1)
%         for jj=1:size_vol(2)
%             if CBF_GM(ii,jj,ss)~=0
%             %if T1_GM(ii,jj,ss)>=0.3
%                 GM_mask(ii,jj,ss)=GM_mask(ii,jj,ss)+1;
%             end
%             if CBF_WM(ii,jj,ss)~=0
%             %if T1_WM(ii,jj,ss)>=0.3
%                 WM_mask(ii,jj,ss)=WM_mask(ii,jj,ss)+1;
%             end
%         end
%     end
% end
% 
% for ss=1:slicenumber
%     imagesc(GM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
% end
% close
% 
% for ss=1:slicenumber
%     imagesc(WM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
% end
% close 
% 
% CBF_GM=CBF_map.*GM_mask;
% CBF_GM_ave=sum(sum(sum(CBF_GM)))/sum(sum(sum(GM_mask)));
% CBF_WM=CBF_map.*WM_mask;
% CBF_WM_ave=sum(sum(sum(CBF_WM)))/sum(sum(sum(WM_mask)));





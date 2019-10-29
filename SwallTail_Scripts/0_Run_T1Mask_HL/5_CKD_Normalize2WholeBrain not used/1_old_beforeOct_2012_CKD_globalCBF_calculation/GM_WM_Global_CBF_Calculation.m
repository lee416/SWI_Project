function [CBF_GM_ave CBF_WM_ave CBF_Global_ave]=GM_WM_Global_CBF_Calculation(ss,Subjects,pathname, pathname_anat)
[tmp_data]=fun_read_spm_GM(pathname_anat);
T1_GM=tmp_data;
[tmp_data]=fun_read_spm_path_T1WM(pathname_anat);
T1_WM=tmp_data;
[tmp_data]=fun_read_spm_path_Global(ss,Subjects,pathname);
Global_mask=tmp_data;
[tmp_data]=fun_read_spm_path_CBF(pathname);
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
CBF_GM=zeros(size_vol(1),size_vol(2),size_vol(3));
CBF_WM=zeros(size_vol(1),size_vol(2),size_vol(3));
CBF_Global=zeros(size_vol(1),size_vol(2),size_vol(3));

for ss=1:slicenumber
    for ii=1:size_vol(1)
        for jj=1:size_vol(2)
            %if T1_GM(ii,jj,ss)>0
            if T1_GM(ii,jj,ss)>=0.8
                GM_mask(ii,jj,ss)=GM_mask(ii,jj,ss)+1;
            end
            %if T1_WM(ii,jj,ss)>0
            if T1_WM(ii,jj,ss)>=0.9
                WM_mask(ii,jj,ss)=WM_mask(ii,jj,ss)+1;
            end
            if Global_mask(ii,jj,ss)>0
                Global_mask(ii,jj,ss)=1;
            end
        end
    end
end

%%%%%%%%%%% display all Masks and CBF maps %%%%%%%%%%%%%
% for ss=1:slicenumber
%     imagesc(GM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
% end
% %movie(m,1,3);
% close
% 
% for ss=1:slicenumber
%     imagesc(WM_mask(:,:,ss));axis image;colormap(gray);
%     m(ss)=getframe;
% end
% %movie(m,1,3);
% close

for ss=1:slicenumber
    imagesc(Global_mask(:,:,ss));axis image;colormap(gray);
    m(ss)=getframe;
end
%movie(m,1,3);
close

for ss=1:slicenumber
    imagesc(CBF_map(:,:,ss));axis image;colormap(gray);
    m(ss)=getframe;
end
%movie(m,1,3);
close

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
            CBF_WM(ii,jj,ss)=CBF_map(ii,jj,ss).*WM_mask(ii,jj,ss);
            end
        end
    end
end
CBF_WM_ave=sum(sum(sum(CBF_WM)))/sum(sum(sum(WM_mask)));

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













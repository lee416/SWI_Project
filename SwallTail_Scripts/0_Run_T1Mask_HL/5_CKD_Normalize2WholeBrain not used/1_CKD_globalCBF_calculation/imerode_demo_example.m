Subjects=[4 47 207 210];
%Subjects=[341];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='G:\CKD_data\Subjects';
end


ss=1;
%for ss=1:size(Subjects,2)
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/anat_anlz/');
     else 
     pathname=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/anat_anlz/');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz\');
     else 
     pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz\');
    end
   end
%end

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

%spm_write_GM_mask(GM_mask,vol_GM,pathname_anat);

fname_saved = sprintf('WM_mask_beforeErode.img');
spm_write_WM_mask(WM_mask,vol_WM,pathname_anat,fname_saved);
%spm_write_GM_WM_mask(Global_mask);


%%%%%%%%% image erosion %%%%%%%%%%%
%SE=ones(2);
SE=[1 0;0 1];
%SE = strel('disk',0.5);  
%SE = strel('ball',5,5);

for qq=1:size_vol(3)
 %T1_WM_eroded(:,:,qq) = bwmorph(T1_WM(:,:,qq),'erode'); %% use ones(3) for erosion
 %T1_WM_eroded(:,:,qq)=imerode(T1_WM(:,:,qq),SE);
 T1_WM_eroded(:,:,qq)=imerode(WM_mask(:,:,qq),SE);
end

tmp_montage = [];
for ss=1:slicenumber
    tmp_montage(:,:,1,ss) = rot90(T1_WM_eroded(:,:,ss));
end
figure, montage(tmp_montage),colormap(gray(150));
caxis([0 1]);axis off;

fname_saved = sprintf('WM_mask_afterErode.img');
spm_write_WM_mask(T1_WM_eroded,vol_WM,pathname_anat,fname_saved);




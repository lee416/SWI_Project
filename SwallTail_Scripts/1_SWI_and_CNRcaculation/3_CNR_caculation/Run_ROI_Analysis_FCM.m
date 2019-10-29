% % clear all;clc;close all;
filepath=pwd;
mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

%%%%%%%%%%% start, load data %%%%%%%%%%%%
% Title='Please input Data Directory and display echo';
% Prompt={'Data_dir','display_echo','display_slice'};
% LineNo=1;
% DefAns={'H:\Parkinson Diseases\Subjects_Test\Sub_202\QSM_Data','4','33'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% Data_dir=(answer{1});
% echo_display=str2num(answer{2});
% display_slice=str2num(answer{3});

%%%%% new %%%%%
Scan_num=[1];
echo_display=[4];
display_slice=[35 36];
% pathname='F:\Subjects\Sub_001\Scan1\SWI_Data';
pathname00='E:\SwallowTail_Project\Subjects_inIMA\';
subject='Sub_201';
pathname0='\Scan1\SWI\MatData_All';

%%%%% new files created %%%%%
% saveMatDir_Final=strcat(pathname00,'\MatData_All');
saveMatDir_Final=strcat(pathname00,subject,pathname0);
cd(saveMatDir_Final)
load SWI_img_ave_Mat
load mag_img_ave_Mat
load unwrapped_phase_img_ave_Mat

load SWI_img_Mat 
load mag_img_Mat 
load unwrapped_phase_img_Mat 

cd(mfile_dir)
img_all=SWI_img_ave_Mat;
% clear SWI_mIP_*
matrix_size=size(SWI_img_Mat );
slicenumber=matrix_size(3);
%%%%%%%%%%% end, load data %%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start, draw ROI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% slice selection
% startslice=25;
% endslice=36;
%  for ppp=startslice:endslice
%     figure;imagesc(img_all(:,:,ppp));colormap(gray(256));axis('image');axis off;title(strcat('slice',num2str(ppp)));
%     pause
%     close all
%  end

%%%% 201>>29,202>>31

%%%%%%% start, preview of the images with nigrosome-1, ROI set
Title='Please input ROI slice numbers';
Prompt={'ROI slice number 1','ROI slice number 2','Partition number'};
LineNo=1;
DefAns={'32','2'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
ROI_slice=str2num(answer{1});
partition_number=str2num(answer{2});
% for sss=(ROI_slice-1):(ROI_slice+1)
%  figure;imagesc(img_all(:,:,sss));colormap(gray(256));axis('image');axis off;title(strcat('MAKE SURE slice',num2str(sss)));
% end
% close all
%%%%%%% end, preview of the images with nigrosome-1

%%%% ROI of nigrosome-1 mask made
ROI_Img_All_Left=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
ROI_Img_All_Right=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
ROI_Img_All=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
for sss=(ROI_slice-1):(ROI_slice+1)
 figure;imagesc(img_all(:,:,sss));colormap(gray(256));axis('image');axis off;title(strcat('Draw Left ROI in slice',num2str(sss)));
 [ROI_Img_All_Left(:,:,sss),xi1,yi1] = roipoly;
 title(strcat('Draw Right ROI in slice',num2str(sss)));
 [ROI_Img_All_Right(:,:,sss),xi2,yi2] = roipoly;
 hold on;
 plot(xi1,yi1,'b-*');
 plot(xi2,yi2,'r-*');
%  close
% % pause
end
SWI_ROI_All_L=SWI_img_ave_Mat.*ROI_Img_All_Left;
SWI_ROI_All_R=SWI_img_ave_Mat.*ROI_Img_All_Right;
SWI_ROI_All_All=SWI_ROI_All_L+SWI_ROI_All_R; %%  SWI_ROI_All_All=mask of nigrosome-1
SWI_roimask=SWI_ROI_All_All;
% figure;imagesc(SWI_ROI_All_All(:,:,32));colormap(gray(256));axis('image');axis off;title(strcat('mask',num2str(32)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end, draw ROI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start, Run FCM Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mask_All=zeros(matrix_size(1),matrix_size(2),matrix_size(3),partition_number);
Mask_All_L=zeros(matrix_size(1),matrix_size(2),matrix_size(3),partition_number);
Mask_All_R=zeros(matrix_size(1),matrix_size(2),matrix_size(3),partition_number);

for ssl=(ROI_slice-1):(ROI_slice+1)
%%%%%%%% start, Left side %%%%%%%    
ROI_Img_All_Left_ss=reshape(ROI_Img_All_Left(:,:,ssl),[matrix_size(1)*matrix_size(2) 1]);
SWI_ROI_All_L_ss=reshape(SWI_ROI_All_L(:,:,ssl),[matrix_size(1)*matrix_size(2) 1]);
[center,U,obj_fcn] = fcm(SWI_ROI_All_L_ss(find(ROI_Img_All_Left_ss==1)),partition_number);
original_location_L=(find(ROI_Img_All_Left_ss==1))';
% original_location=(find(ROI_Img_All_Left_ss==1)))';
U_Matrix(:,:,ssl)=U(:,:);
maxU=max(U_Matrix(:,:,ssl));
 
  for ppl=1:partition_number
   index_ppl=original_location_L(find(U_Matrix(ppl,:,ssl)==maxU));
%    index_ppl=original_location(find(U(:,:)==maxU));
   pjj_ppl=ceil(index_ppl./matrix_size(1));% position of colume direction
   pii_ppl=index_ppl-matrix_size(1)*(pjj_ppl-1);% position of row direction
   for kk=1:length(index_ppl)
    ikko=pii_ppl(kk);
    jkko=pjj_ppl(kk);
    Mask_All(ikko,jkko,ssl,ppl)=1;  %%% Mask_All=416x408x60xpartitionn_number
    Mask_All_L(ikko,jkko,ssl,ppl)=1;  %%% Mask_All_L=416x408x60xpartitionn_number
   end   
  end
%  figure;imagesc(Mask_All(:,:,ssl,1));axis image
%  figure;imagesc(Mask_All(:,:,ssl,2));axis image
 clear U_Matrix
 clear U;clear maxU;clear index_ppl
 %%%%%%%%%% end, Left side %%%%%%%  
 
 %%%%%%%% start, Right side %%%%%%%    
ROI_Img_All_Right_ss=reshape(ROI_Img_All_Right(:,:,ssl),[matrix_size(1)*matrix_size(2) 1]);
SWI_ROI_All_R_ss=reshape(SWI_ROI_All_R(:,:,ssl),[matrix_size(1)*matrix_size(2) 1]);
[center,U,obj_fcn] = fcm(SWI_ROI_All_R_ss(find(ROI_Img_All_Right_ss==1)),partition_number);
original_location_R=(find(ROI_Img_All_Right_ss==1))';
% original_location=(find(ROI_Img_All_Right_ss==1)))';
U_Matrix(:,:,ssl)=U(:,:);
maxU=max(U_Matrix(:,:,ssl));
 
  for ppl=1:partition_number
   index_ppl=original_location_R(find(U_Matrix(ppl,:,ssl)==maxU));
%    index_ppl=original_location(find(U(:,:)==maxU));
   pjj_ppl=ceil(index_ppl./matrix_size(1));% position of colume direction
   pii_ppl=index_ppl-matrix_size(1)*(pjj_ppl-1);% position of row direction
   for kk=1:length(index_ppl)
    ikko=pii_ppl(kk);
    jkko=pjj_ppl(kk);
    Mask_All(ikko,jkko,ssl,ppl)=1;  %%% Mask_All=416x408x60xpartitionn_number
    Mask_All_R(ikko,jkko,ssl,ppl)=1;  %%% Mask_All_L=416x408x60xpartitionn_number
   end   
  end
%  figure;imagesc(Mask_All(:,:,ssl,1));axis image
%  figure;imagesc(Mask_All(:,:,ssl,2));axis image
 clear U_Matrix
 clear U;clear maxU;clear index_ppl
 %%%%%%%% end, right side %%%%%%%  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end, Run FCM Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start, plot cluster voxels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% start, sorted cluster
mean_cluster_L=zeros(partition_number,matrix_size(3));  %%% mean_cluster=2x60, 2 is the partition number
mean_cluster_R=zeros(partition_number,matrix_size(3));  %%% mean_cluster=2x60, 2 is the partition number
cluster_order_location_L=zeros(partition_number,matrix_size(3)); 
cluster_order_location_R=zeros(partition_number,matrix_size(3)); 
masknigrosomeL=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masknigrosomeR=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masksubstantianigraL=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masksubstantianigraR=zeros(matrix_size(1),matrix_size(2),matrix_size(3));


for ssq=(ROI_slice-1):(ROI_slice+1) 
  for pnn=1:partition_number
    mean_cluster_L(pnn,ssq)=sum(sum(Mask_All_L(:,:,ssq,pnn).*img_all(:,:,ssq)))/sum(sum(Mask_All_L(:,:,ssq,pnn)));
    mean_cluster_R(pnn,ssq)=sum(sum(Mask_All_R(:,:,ssq,pnn).*img_all(:,:,ssq)))/sum(sum(Mask_All_R(:,:,ssq,pnn)));
  end 
  sorted_order_L=sort(mean_cluster_L(:,ssq),1);
  sorted_order_R=sort(mean_cluster_R(:,ssq),1);
%   for pnn=1:partition_number
%     cluster_order_location(pnn)=find(mean_cluster(:,ssq)==sorted_order(pnn));
%   end
for pnn=1:partition_number
  cluster_order_location_L(pnn,ssq)=find(mean_cluster_L(:,ssq)==sorted_order_L(pnn));
  cluster_order_location_R(pnn,ssq)=find(mean_cluster_R(:,ssq)==sorted_order_R(pnn));
  %mean_cluster(cluster_order_location((partition_number-3):partition_number),ssq); %%% the most bright clusters
end
end
%%%% end, sorted cluster

Title='Please input number of cluster for nigrosom1';
Prompt={'nigrosome cluster num'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
nigrosome_cluster_num=str2num(answer{1});

for ssl=(ROI_slice-1):(ROI_slice+1)
   figure;imagesc(img_all(:,:,ssl));colormap(gray(256));axis('image');axis off;title(strcat('slice',num2str(ssl)));
   hold on;
%    ROI_PP_index=find(ROI_Img_All_Left(:,:,ssl)==1);
%    pjj=ceil(ROI_PP_index./matrix_size(1));% position of colume direction
%    pii=ROI_PP_index-matrix_size(1)*(pjj-1);% position of row direction
%    plot(pjj,pii,'w.')   

NN_num=nigrosome_cluster_num;
 for qql=(partition_number-NN_num+1):partition_number
    for jj=1:matrix_size(2)
      for ii=1:matrix_size(1)
        if Mask_All_L(ii,jj,ssl,cluster_order_location_L(qql,ssl))==1|Mask_All_R(ii,jj,ssl,cluster_order_location_R(qql,ssl))==1 %% cluster_order_location is the order-sorted clusters' original locations
         plot(jj,ii,'g.');        
         hold on
        end
        if Mask_All_L(ii,jj,ssl,cluster_order_location_L(qql,ssl))==1
         masknigrosomeL(ii,jj,ssl)=1;       
        end
        if Mask_All_R(ii,jj,ssl,cluster_order_location_R(qql,ssl))==1
         masknigrosomeR(ii,jj,ssl)=1;       
        end              
        
      end
    end
 end

    
 for qql=1:(partition_number-NN_num)
    for jj=1:matrix_size(2)
      for ii=1:matrix_size(1)
        if Mask_All_L(ii,jj,ssl,cluster_order_location_L(qql,ssl))==1|Mask_All_R(ii,jj,ssl,cluster_order_location_R(qql,ssl))==1 %% cluster_order_location is the order-sorted clusters' original locations
         plot(jj,ii,'r.');
         hold on
        end
        if Mask_All_L(ii,jj,ssl,cluster_order_location_L(qql,ssl))==1
         masksubstantianigraL(ii,jj,ssl)=1;       
        end
        if Mask_All_R(ii,jj,ssl,cluster_order_location_R(qql,ssl))==1
         masksubstantianigraR(ii,jj,ssl)=1;       
        end                  
      end
    end
 end
%     figure;imagesc(masknigrosomeL(:,:,ssl));colormap(gray(256));axis('image');axis off;title(strcat('L nigro slice',num2str(ssl)));
%     figure;imagesc(masknigrosomeR(:,:,ssl));colormap(gray(256));axis('image');axis off;title(strcat('R nigro slice',num2str(ssl)));
%     figure;imagesc(masksubstantianigraL(:,:,ssl));colormap(gray(256));axis('image');axis off;title(strcat('L substantianigra slice',num2str(ssl)));
%     figure;imagesc(masksubstantianigraR(:,:,ssl));colormap(gray(256));axis('image');axis off;title(strcat('R substantianigra slice',num2str(ssl)));
    pause;close all
 ssl
end
cd(saveMatDir_Final)
save SWI_roimask SWI_roimask
save masknigrosomeL masknigrosomeL
save masknigrosomeR masknigrosomeR
save masksubstantianigraL masksubstantianigraL
save masksubstantianigraR masksubstantianigraR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end, plot cluster voxels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















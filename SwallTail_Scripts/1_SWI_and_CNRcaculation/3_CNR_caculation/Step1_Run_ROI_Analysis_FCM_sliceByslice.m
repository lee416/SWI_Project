clear all;clc;close all;

filepath=pwd;
mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

%%%%% new %%%%%
% Subjects=[205];
% Scan_num=[1];
% echo_display=[4];
% display_slice=[35 36];
% pathname='F:\Subjects\Sub_001\Scan1\SWI_Data';

Subjects=[207];
pathname00='E:\SwallowTail_Project\Subjects_inIMA\';
subject=strcat('Sub_',int2str(Subjects(1)));
pathname0='\Scan1\SWI\MatData_All';
ROI_slice1=27;
ROI_slice2=28;
aaaa=ROI_slice1:ROI_slice2;

%%%% 201>>28,29 202>>29,30 203>>29,30 204>>27,28 //// 205>>25 206>>27,28
%%%% 207>>23,24 208>>(28),29,(30) 209>>28,29 210>>29 211>>11,12 212>>25,26 
%%%% 213>>27,28 214>>(22),23,24,25 217>>22,23 218>>29,30 219>>26,27
%%%% 220>>29,30,31 221>>(32),33 222>>26,27 223>> 801>>
%%%% X: 215>>14, 216>>X

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
partition_number=2; %% devide 2space nigrosome-1 & subnigra

%%%% ROI of nigrosome-1 mask made
ROI_Img_All_Left=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
ROI_Img_All_Right=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
ROI_Img_All=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
for sss=aaaa
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

for ssl=aaaa
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
close all
%%%% start, sorted cluster
mean_cluster_L=zeros(partition_number,matrix_size(3));  %%% mean_cluster=2x60, 2 is the partition number
mean_cluster_R=zeros(partition_number,matrix_size(3));  %%% mean_cluster=2x60, 2 is the partition number
cluster_order_location_L=zeros(partition_number,matrix_size(3)); 
cluster_order_location_R=zeros(partition_number,matrix_size(3)); 
masknigrosomeL=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masknigrosomeR=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masksubstantianigraL=zeros(matrix_size(1),matrix_size(2),matrix_size(3));
masksubstantianigraR=zeros(matrix_size(1),matrix_size(2),matrix_size(3));


for ssq=aaaa
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

% Title='Please input number of cluster for nigrosom1';
% Prompt={'nigrosome cluster num'};
% LineNo=1;
% DefAns={'1'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% nigrosome_cluster_num=str2num(answer{1});
nigrosome_cluster_num=1;

for ssl=aaaa
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
%     pause;close all
%  ssl
end
% %%%%%%%%%%%%%%%%   CNR    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% CNR cal 
matrix_1=SWI_img_ave_Mat;                           %%% 1=SWI_img_ave_Mat
matrix_2=mag_img_ave_Mat;                           %%% 2=mag_img_ave_Mat
matrix_3=unwrapped_phase_img_ave_Mat;               %%% 3=unwrapped_phase_img_ave_Mat
matrix_4=SWI_img_Mat(:,:,:,4);                      %%% 4=SWI_img_Mat
matrix_5=mag_img_Mat(:,:,:,4);                      %%% 5=mag_img_Mat
matrix_6=unwrapped_phase_img_Mat(:,:,:,4);          %%% 6=unwrapped_phase_img_Mat
Big_matrix=cat(4,matrix_1,matrix_2,matrix_3,matrix_4,matrix_5,matrix_6);
mask=cat(4,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR);
%%%% sets
num_of_MRI=6;
num_of_CNR=4;
total_of_CNR=num_of_MRI*num_of_CNR;
%%%% sets

CNR_Data=zeros(size(Subjects,2),total_of_CNR);
cd(mfile_dir)
[CNR_matrix0]=fun_CNR_calculation(Big_matrix,mask,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR,num_of_MRI,num_of_CNR,total_of_CNR);
CNR_Data(size(Subjects,2),:)=[CNR_matrix0];
CNR_swi_ave=[CNR_matrix0(1) CNR_matrix0(3) CNR_matrix0(2) CNR_matrix0(4)]
CNR_mag_ave=[CNR_matrix0(5) CNR_matrix0(7) CNR_matrix0(6) CNR_matrix0(8)]
CNR_unwrapped_phase_ave=[CNR_matrix0(9) CNR_matrix0(11) CNR_matrix0(10) CNR_matrix0(12)]
CNR_SWI=[CNR_matrix0(13) CNR_matrix0(15) CNR_matrix0(14) CNR_matrix0(16)]
CNR_mag=[CNR_matrix0(17) CNR_matrix0(19) CNR_matrix0(18) CNR_matrix0(20)]
CNR_unwrapped_phase= [CNR_matrix0(21) CNR_matrix0(23) CNR_matrix0(22) CNR_matrix0(24)]

cd(saveMatDir_Final)
save CNR_Data CNR_Data
save SWI_roimask SWI_roimask
save masknigrosomeL masknigrosomeL
save masknigrosomeR masknigrosomeR
save masksubstantianigraL masksubstantianigraL
save masksubstantianigraR masksubstantianigraR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end, plot cluster voxels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















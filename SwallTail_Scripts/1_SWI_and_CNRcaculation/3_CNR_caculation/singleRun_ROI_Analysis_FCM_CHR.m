
cd(saveMatDir_Final)

load SWI_img_ave_Mat
load mag_img_ave_Mat
load unwrapped_phase_img_ave_Mat

load SWI_img_Mat 
load mag_img_Mat 
load unwrapped_phase_img_Mat 

load masknigrosomeL
load masknigrosomeR
load masksubstantianigraL 
load masksubstantianigraR 

matrix_size=size(SWI_img_ave_Mat);

%%%%%%  SWI_img_ave_Mat
SWI_img_ave_NL=SWI_img_ave_Mat.*masknigrosomeL;
SWI_img_ave_NR=SWI_img_ave_Mat.*masknigrosomeR;
SWI_img_ave_SubL=SWI_img_ave_Mat.*masksubstantianigraL;
SWI_img_ave_SubR=SWI_img_ave_Mat.*masksubstantianigraR;
figure;imagesc(SWI_img_ave_NL(:,:,31));colormap(gray(256));axis('image');axis off;title(strcat('L nigro slice',num2str(31)));
% figure;imagesc(SWI_img_ave_Mat(:,:,31));colormap(gray(256));axis('image');axis off;title(strcat('L nigro slice',num2str(31)));
% SWI_CNR_N2Sub_L=(sum(sum(sum(SWI_img_ave_NL)))/sum(sum(sum(masknigrosomeL))))/(sum(sum(sum(SWI_img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));
%%%%%left
SWI_CNR_NL_mean=(sum(sum(sum(SWI_img_ave_NL)))/sum(sum(sum(masknigrosomeL))));
SWI_CNR_SubL_mean=(sum(sum(sum(SWI_img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));
SWI_CNR_N2Sub_L=SWI_CNR_NL_mean/SWI_CNR_SubL_mean;
SWI_CNR_N2Sub_L_p=(SWI_CNR_NL_mean-SWI_CNR_SubL_mean)*100/SWI_CNR_SubL_mean;
%%%%%right
CNR_NR_mean=(sum(sum(sum(SWI_img_ave_NR)))/sum(sum(sum(masknigrosomeR))));
CNR_SubR_mean=(sum(sum(sum(SWI_img_ave_SubR)))/sum(sum(sum(masksubstantianigraR))));
CNR_N2Sub_R=CNR_NR_mean/CNR_SubR_mean;
CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_SubR_mean;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%  mag_img_ave_Mat  %%%%%
mag_img_ave_NL=mag_img_ave_Mat.*masknigrosomeL;
mag_img_ave_NR=mag_img_ave_Mat.*masknigrosomeR;
mag_img_ave_SubL=mag_img_ave_Mat.*masksubstantianigraL;
mag_img_ave_SubR=mag_img_ave_Mat.*masksubstantianigraR;
figure;imagesc(mag_img_ave_NL(:,:,31));colormap(gray(256));axis('image');axis off;title(strcat('L nigro slice',num2str(31)));
% figure;imagesc(mag_img_ave_Mat(:,:,31));colormap(gray(256));axis('image');axis off;title(strcat('L nigro slice',num2str(31)));
% SWI_CNR_N2Sub_L=(sum(sum(sum(mag_img_ave_NL)))/sum(sum(sum(masknigrosomeL))))/(sum(sum(sum(mag_img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));

mag_CNR_NL_mean=(sum(sum(sum(mag_img_ave_NL)))/sum(sum(sum(masknigrosomeL))));
mag_CNR_SubL_mean=(sum(sum(sum(mag_img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));
mag_CNR_N2Sub_L=mag_CNR_NL_mean/mag_CNR_SubL_mean;
mag_CNR_N2Sub_L_p=(mag_CNR_NL_mean-mag_CNR_SubL_mean)*100/mag_CNR_SubL_mean;

CNR_NR_mean=(sum(sum(sum(mag_img_ave_NR)))/sum(sum(sum(masknigrosomeR))));
CNR_SubR_mean=(sum(sum(sum(mag_img_ave_SubR)))/sum(sum(sum(masksubstantianigraR))));
CNR_N2Sub_R=CNR_NR_mean/CNR_SubR_mean;
CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_SubR_mean;






















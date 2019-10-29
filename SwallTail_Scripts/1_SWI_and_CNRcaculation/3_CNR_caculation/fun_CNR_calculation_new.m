function [CNR_matrix0]=fun_CNR_calculation_new(Big_matrix,mask,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR,num_of_MRI,num_of_CNR,total_of_CNR);

%function [ high_pass_phase_Mask]=fun_positive_mask_Heather(high_pass_phase1,matrix_size)

CNR_matrix0=zeros(1,total_of_CNR);

for qq=1:num_of_MRI
    img_ave_NL= Big_matrix(:,:,:,qq).*mask(:,:,:,1);
    img_ave_NR= Big_matrix(:,:,:,qq).*mask(:,:,:,2);
    img_ave_SubL= Big_matrix(:,:,:,qq).*mask(:,:,:,3);
    img_ave_SubR= Big_matrix(:,:,:,qq).*mask(:,:,:,4);
    %left    
    CNR_NL_mean=(sum(sum(sum(img_ave_NL)))/sum(sum(sum(masknigrosomeL))));
    CNR_SubL_mean=(sum(sum(sum(img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));
    CNR_NL_matrix=img_ave_NL(:,end)_
    CNR_SubL_std=
    
    CNR_N2Sub_L=CNR_NL_mean/CNR_SubL_mean;
    CNR_N2Sub_L_p=(CNR_NL_mean-CNR_SubL_mean)*100/CNR_SubL_mean;
   
    %right    
    CNR_NR_mean=(sum(sum(sum(img_ave_NR)))/sum(sum(sum(masknigrosomeR))));
    CNR_SubR_mean=(sum(sum(sum(img_ave_SubR)))/sum(sum(sum(masksubstantianigraR))));
    
    
    CNR_N2Sub_R=CNR_NR_mean/CNR_SubR_mean;
    CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_SubR_mean;
    
    CNR_matrix0(1,(num_of_CNR*qq-3):num_of_CNR*qq)=[CNR_N2Sub_L CNR_N2Sub_L_p CNR_N2Sub_R CNR_N2Sub_R_p];
end
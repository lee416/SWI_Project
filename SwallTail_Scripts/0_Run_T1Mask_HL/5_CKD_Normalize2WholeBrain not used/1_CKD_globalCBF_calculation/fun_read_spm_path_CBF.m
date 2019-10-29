function [tmp_data]=fun_read_spm_path_CBF(pathname,Subjects_ID)
%filename_data=strcat('Masked_Thresholded_rpcasl_CBF_s',int2str(Subjects_ID),'.img');
% %filename_data=strcat('Masked_meanCBF_rpcasl_s',int2str(Subjects_ID),'.img');
% %filename_data=strcat('meanCBF_0_rpcasl_rest078','.img'); 
% spmImg.InputFullpath =strcat(pathname,filename_data);
% tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));

filename_data=strcat('Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects_ID),'.img');
spmImg.InputFullpath =strcat(pathname,filename_data);
tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));


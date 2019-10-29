function [tmp_data]=fun_read_spm_path_T1WM(pathname_anat)

filename_data=strcat('c2ranat_anlz','.img'); 
spmImg.InputFullpath =strcat(pathname_anat,filename_data);
tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));



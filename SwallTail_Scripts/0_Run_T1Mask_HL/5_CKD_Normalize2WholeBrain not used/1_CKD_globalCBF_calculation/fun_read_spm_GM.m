function [tmp_data vol_GM]=fun_read_spm_GM(pathname_anat)

filename_data=strcat('c1ranat_anlz','.img'); 
spmImg.InputFullpath =strcat(pathname_anat,filename_data);
tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));
vol_GM = spm_vol(spmImg.InputFullpath);


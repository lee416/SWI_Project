function [new_filename_1 new_filename_2]=fun_filename_fmri_Dicom_CKD_fMRI(pathname_A,pathname_2,scan_number)

for s=1:scan_number
    if s<=9  
    %filename_data=strcat('_00',int2str(s),'.dcm');
    filename_data_1=strcat('_00',int2str(s),'.hdr');
    filename_data_2=strcat('_00',int2str(s),'.img');
    elseif s>=10&s<=99 
    %filename_data=strcat('_0',int2str(s),'.dcm'); 
    filename_data_1=strcat('_0',int2str(s),'.hdr');
    filename_data_2=strcat('_0',int2str(s),'.img');
    else
    %filename_data=strcat('_',int2str(s),'.dcm');
    filename_data_1=strcat('_',int2str(s),'.hdr');
    filename_data_2=strcat('_',int2str(s),'.img');
    end
    spmImg.InputFullpath_hdr =strcat(pathname_A,pathname_2,filename_data_1);  
    spmImg.InputFullpath_img =strcat(pathname_A,pathname_2,filename_data_2);  
    new_filename_1(s,:)=spmImg.InputFullpath_hdr;
    new_filename_2(s,:)=spmImg.InputFullpath_img;
end


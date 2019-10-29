function [new_filename]=fun_filename_fmri_Dicom_CKD(pathname,pathname_2)

for s=1:102
    if s<=9  
    %filename_data=strcat('_00',int2str(s),'.dcm');
    %filename_data=strcat('_00',int2str(s),'.hdr');
    filename_data=strcat('_00',int2str(s),'.img');
    elseif s>=10&s<=99 
    %filename_data=strcat('_0',int2str(s),'.dcm'); 
    %filename_data=strcat('_0',int2str(s),'.hdr');
    filename_data=strcat('_0',int2str(s),'.img');
    else
    %filename_data=strcat('_',int2str(s),'.dcm');
    %filename_data=strcat('_',int2str(s),'.hdr');
    filename_data=strcat('_',int2str(s),'.img');
    end
    spmImg.InputFullpath =strcat(pathname,pathname_2,filename_data);  
    new_filename(s,:)=spmImg.InputFullpath;
end


function [new_filename_1 new_filename_2]=fun_filename_fmri_PD_QSM(pathname_2,scan_number)

for s=1:(scan_number*2)
  if s<=scan_number
    if (s)<=9
    filename_data_1=strcat('QSM_Mag_TE_0',int2str(0),int2str((s)),'.hdr');
    filename_data_2=strcat('QSM_Mag_TE_0',int2str(0),int2str((s)),'.img');
    elseif (s)>=10&(s)<=99 
    filename_data_1=strcat('QSM_Mag_TE_',int2str(0),int2str((s)),'.hdr');
    filename_data_2=strcat('QSM_Mag_TE_',int2str(0),int2str((s)),'.img');
    else
    filename_data_1=strcat('QSM_Mag_TE_',int2str((s)),'.hdr');
    filename_data_2=strcat('QSM_Mag_TE_',int2str((s)),'.img');
    end
  else
    if (s-scan_number)<=9
    filename_data_1=strcat('QSM_Pha_TE_0',int2str(0),int2str((s-scan_number)),'.hdr');
    filename_data_2=strcat('QSM_Pha_TE_0',int2str(0),int2str((s-scan_number)),'.img');
    elseif (s-scan_number)>=10&(s-scan_number)<=99 
    filename_data_1=strcat('QSM_Pha_TE_',int2str(0),int2str((s-scan_number)),'.hdr');
    filename_data_2=strcat('QSM_Pha_TE_',int2str(0),int2str((s-scan_number)),'.img');
    else
    filename_data_1=strcat('QSM_Pha_TE_',int2str((s-scan_number)),'.hdr');
    filename_data_2=strcat('QSM_Pha_TE_',int2str((s-scan_number)),'.img');
    end
  end
    spmImg.InputFullpath_hdr =strcat(pathname_2,filename_data_1);  
    spmImg.InputFullpath_img =strcat(pathname_2,filename_data_2);  
    new_filename_1(s,:)=spmImg.InputFullpath_hdr;
    new_filename_2(s,:)=spmImg.InputFullpath_img;
   
end

%     if s<=9  
%     filename_data_1=strcat('pcasl_rest00',int2str(s),'.hdr');
%     filename_data_2=strcat('pcasl_rest00',int2str(s),'.img');
%     %filename_data=strcat('pcasl_rest00',int2str(s),'.nii');
%      elseif s>=10&s<=99 
%     filename_data_1=strcat('pcasl_rest0',int2str(s),'.hdr'); 
%     filename_data_2=strcat('pcasl_rest0',int2str(s),'.img');
%     %filename_data=strcat('pcasl_rest0',int2str(s),'.nii'); 
%       else
%     filename_data_1=strcat('pcasl_rest',int2str(s),'.hdr');
%     filename_data_2=strcat('pcasl_rest',int2str(s),'.img');
%     %filename_data=strcat('pcasl_rest',int2str(s),'.nii');
%     end
%     spmImg.InputFullpath_1 =strcat(pathname,filename_data_1);  
%     spmImg.InputFullpath_2 =strcat(pathname,filename_data_2);  
%     new_filename(s,:,1)=spmImg.InputFullpath_1;
%     new_filename(s,:,2)=spmImg.InputFullpath_2;

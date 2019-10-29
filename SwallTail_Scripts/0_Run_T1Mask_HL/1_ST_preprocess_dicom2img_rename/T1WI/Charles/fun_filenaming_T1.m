%%%%% for "fun_mvRename_T1"

function [new_filename_T1]=fun_filenaming_T1(pathname_D)

    filename_1=strcat('anat_anlz','.hdr'); 
    filename_2=strcat('anat_anlz','.img');
  
    new_filename_T1(1,:)=strcat(pathname_D,filename_1); 
    new_filename_T1(2,:)=strcat(pathname_D,filename_2);  

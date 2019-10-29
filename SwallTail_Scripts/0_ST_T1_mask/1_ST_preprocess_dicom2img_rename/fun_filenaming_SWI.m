%%%%% for "fun_mvRename_T1"

function [new_filename_SWI]=fun_filenaming_SWI(pathname_SWI0,echo)
    clear new_filename_SWI
for aaa =1:echo
    filename_data_1=strcat('SWI_magne',int2str(aaa),'.hdr');
    filename_data_2=strcat('SWI_magne',int2str(aaa),'.img');
    filename_data_3=strcat('SWI_phase',int2str(aaa),'.hdr');
    filename_data_4=strcat('SWI_phase',int2str(aaa),'.img'); 
    
    new_filename_SWI(aaa,:)=strcat(pathname_SWI0,filename_data_1);
    new_filename_SWI(aaa+echo,:)=strcat(pathname_SWI0,filename_data_2);  
    new_filename_SWI(2*echo+aaa,:)=strcat(pathname_SWI0,filename_data_3);  
    new_filename_SWI(3*echo+aaa,:)=strcat(pathname_SWI0,filename_data_4);  
end
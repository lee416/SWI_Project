function [new_filename]=fun_filename_pcasl_Autism(pathname_0)

for s=1:80    
    if (s-1)<=9  
    filename_data=strcat('pcasl_rest0',int2str(0),int2str((s-1)),'.img');
    %filename_data=strcat('pcasl_rest0',int2str(0),int2str((s-1)),'.hdr');
    else    
    filename_data=strcat('pcasl_rest0',int2str((s-1)),'.img');
    %filename_data=strcat('pcasl_rest0',int2str((s-1)),'.hdr');
   end
    new_filename(s,: )=strcat(pathname_1,filename_data);  
end


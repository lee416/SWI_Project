clear all
% close all
clc

Subjects=[201];
Scan_num=[1];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='H:\MCA_Stroke_TMU\Subjects';
end

Title='Please input number of average,slicenumber';
Prompt={'Number of averagex2','slicenumber','matrix size'};
LineNo=1;
DefAns={'32','26','64'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
Average_2N=str2num(answer{1});
slicenumber=str2num(answer{2});
Matrix_size=str2num(answer{3});

for ss=1:size(Subjects,2)
 for ssq=1:size(Scan_num,2)
    %for ss=18:18
    h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(ss))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     else 
     pathname=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','MCA_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','MCA_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     else 
     pathname=strcat(pathname_1,'\','MCA_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     end
   end
   [Filename]=fun_read_spm_rpcasl_MCA(Average_2N,slicenumber,pathname,Matrix_size);
   [perfnum,glcbf] =asl_perf_subtract_MCA_pASL(Filename);
%    [perfnum,glcbf] =asl_perf_subtract_MCA(Filename);
   close(h)
 end
end


% for ss=1:size(Subjects,2)
%   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
%    if System_Flag==0       
%      if Subjects(ss)<10
%      pathname=strcat(pathname_1,'/','R0','00',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname=strcat(pathname_1,'/','R0','0',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
%      else 
%      pathname=strcat(pathname_1,'/','R0',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
%      end
%    else         
%      if Subjects(ss)<10
%      pathname=strcat(pathname_1,'\','R0','00',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname=strcat(pathname_1,'\','R0','0',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
%      else 
%      pathname=strcat(pathname_1,'\','R0',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
%     end
%    end    
% %    %%%%%%%%%%%%
% %    h=waitbar(ss/(size(Subjects,2)-Autism_Controls),strcat('subject',(int2str(ss))));
% %     %for ss=18:18
% %     if Subjects(ss)<10
% %      pathname=strcat(pathname_1,'\','R0','00',int2str(Subjects(ss)),'\pcasl_rest\');
% %      elseif Subjects(ss)<=99&Subjects(ss)>=10
% %      pathname=strcat(pathname_1,'\','R0','0',int2str(Subjects(ss)),'\pcasl_rest\');
% %     else 
% %      pathname=strcat(pathname_1,'\','R0',int2str(Subjects(ss)),'\pcasl_rest\');
% %     end 
% %     %%%%%%%%%%%%%
%     [Filename]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size);
%     [perfnum,glcbf] =asl_perf_subtract_CKD(Filename);
%    close(h)
% end


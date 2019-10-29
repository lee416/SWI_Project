clear all
close all
clc

% CKD_Subjects=[5 6 36 40 10 17 22 25 26 51];
% Control_Subjects=[218 221 222 208 220];
% Subjects=[CKD_Subjects Control_Subjects];
%Subjects=[212 219 223 224 228];

% CKD_Subjects=[7 53 54 56 57 61 64 65 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];

CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 266 267];

% CKD_Subjects=[62 67 72 73 74 75 76 77 82];
% Control_Subjects=[246 248 249 254];

Subjects=[CKD_Subjects Control_Subjects];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='F:\CKD_PatientData_Raw\Subjects';
end

Title='Please input number of average,slicenumber';
Prompt={'Number of averagex2','slicenumber','matrix size'};
LineNo=1;
DefAns={'80','20','64'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
Average_2N=str2num(answer{1});
slicenumber=str2num(answer{2});
Matrix_size=str2num(answer{3});

for ss=1:size(Subjects,2)
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
     pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\pcasl_rest\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\pcasl_rest\');
     else 
     pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\pcasl_rest\');
    end
   end
   [Filename]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size);
   [perfnum,glcbf] =asl_perf_subtract_CKD(Filename);
   close(h)
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


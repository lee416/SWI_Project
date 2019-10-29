clear all
close all

% CKD_Subjects=[7 53 54 56 57 61 64 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];

% CKD_Subjects=[62 67 72 73 74 75 76 77 82];
% Control_Subjects=[246 248 249 254];

CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 266 267];

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
 pathname_1='E:\CKD_PatientData_Raw\Subjects';
end

CBF_GM_WM_Global_ave_Table=zeros(size(Subjects,2),3);

for ss=1:size(Subjects,2)
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/anat_anlz/');
     else 
     pathname=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/anat_anlz/');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz\');
     else 
     pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\pcasl_rest\');
     pathname_anat=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz\');
    end
   end
[CBF_GM_ave CBF_WM_ave CBF_Global_ave]=GM_WM_Global_CBF_Calculation(ss,Subjects,pathname,pathname_anat);
CBF_GM_WM_Global_ave_Table(ss,:)=[CBF_GM_ave CBF_WM_ave CBF_Global_ave];
close(h)
end

globalCBF=CBF_GM_WM_Global_ave_Table(:,3);

save globalCBF globalCBF
save CBF_GM_WM_Global_ave_Table CBF_GM_WM_Global_ave_Table


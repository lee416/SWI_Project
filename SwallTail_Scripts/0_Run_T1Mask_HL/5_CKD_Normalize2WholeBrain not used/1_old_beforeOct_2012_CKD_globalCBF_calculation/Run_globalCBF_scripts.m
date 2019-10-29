Subjects=[41 42 43 44 46 47 48 49 50 209 210 211 213  214 215 216 217];

% Title='Please input the System type';
% Prompt={'0 for Mac, 1 for PC'};
% LineNo=1;
% DefAns={'0'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='G:\CKD_data\Subjects';
end

% Title='Please input number of Controls from Autism';
% Prompt={'Number of Autism Controls'};
% LineNo=1;
% DefAns={'11'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% Autism_Controls=str2num(answer{1});

CBF_GM_WM_Global_ave_Table=zeros((size(Subjects,2)),3);

for ss=1:size(Subjects,2)%% the last subjects are Autism controls
    %for ss=18:18
    h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(ss))));
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




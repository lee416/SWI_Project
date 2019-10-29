%Subjects=[311 1	2	3	4	8	9	11	12	13	14	15	16	19	20	21	23	24	35	38	39	201	202	203	204	205	207	101	103	112	118	125	153	204	216	217	227	331 ]; %% the last two, s204, s206 are CKD control%
%Subjects=[41 42 43 44 46 47 48 49 50 209 210 211 213  214 215 216 217];
%Subjects_reverse=[12 13 19 20 23]; %% label-control subjects

CKD_Subjects=[5 6 36 40 10 17 22 25 26 51];
Control_Subjects=[218 221 222 208 220];
Subjects=[CKD_Subjects Control_Subjects];


Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='G:\CKD_data\Subjects';
end

Title='Please input number of average,slicenumber';
Prompt={'Number of averagex2','slicenumber','matrix size'};
LineNo=1;
DefAns={'80','20','64'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
Average_2N=str2num(answer{1});
slicenumber=str2num(answer{2});
Matrix_size=str2num(answer{3});

% Title='Please input number of Controls from Autism';
% Prompt={'Number of Autism Controls'};
% LineNo=1;
% DefAns={'11'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% Autism_Controls=str2num(answer{1});

for ss=1:size(Subjects,2)%% the last subjects are Autism controls
  h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
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
%    %%%%%%%%%%%%
%    h=waitbar(ss/(size(Subjects,2)-Autism_Controls),strcat('subject',(int2str(ss))));
%     %for ss=18:18
%     if Subjects(ss)<10
%      pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\pcasl_rest\');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\pcasl_rest\');
%     else 
%      pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\pcasl_rest\');
%     end 
%     %%%%%%%%%%%%%
    [Filename]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size);
    [perfnum,glcbf] =asl_perf_subtract_CKD(Filename);
   close(h)
end

% %% label-control subjects
% for ss=1:size(Subjects_reverse,2)%% the last subjects are Autism controls
%    h=waitbar(ss/(size(Subjects_reverse,2)),strcat('subject',(int2str(ss))));
%     if System_Flag==0       
%      if Subjects_reverse(ss)<10
%      pathname=strcat(pathname_1,'/','s','00',int2str(Subjects_reverse(ss)),'/pcasl_rest/');
%      elseif Subjects_reverse(ss)<=99&Subjects_reverse(ss)>=10
%      pathname=strcat(pathname_1,'/','s','0',int2str(Subjects_reverse(ss)),'/pcasl_rest/');
%      else 
%      pathname=strcat(pathname_1,'/','s',int2str(Subjects_reverse(ss)),'/pcasl_rest/');
%      end
%    else         
%      if Subjects_reverse(ss)<10
%      pathname=strcat(pathname_1,'\','s','00',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
%      elseif Subjects_reverse(ss)<=99&Subjects_reverse(ss)>=10
%      pathname=strcat(pathname_1,'\','s','0',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
%      else 
%      pathname=strcat(pathname_1,'\','s',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
%     end
%     end
% %     %for ss=18:18
% %     if Subjects_reverse(ss)<10
% %      pathname=strcat(pathname_1,'\','s','00',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
% %      elseif Subjects_reverse(ss)<=99&Subjects_reverse(ss)>=10
% %      pathname=strcat(pathname_1,'\','s','0',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
% %     else 
% %      pathname=strcat(pathname_1,'\','s',int2str(Subjects_reverse(ss)),'\pcasl_rest\');
% %     end
%     [Filename]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size);
%     [perfnum,glcbf] =asl_perf_subtract_CKD_reverse(Filename);
%    close(h)
% end


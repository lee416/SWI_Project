clear all
close all
clc

CKD_Subjects=[1	2 3	4 5	6 7	8 9	10 12 13 14	15 16 17 19	20 21 22 23	24 25 26 27	28 29 30 31 32 33 34 ...
    35 36 37 38 39 40 41 42	43 44 45 46	47 48 49 50	51 53 54 56	57 60 61 62	66 67 71 72 73 74 75 76 77 79 80 82	83 85 86 87	91];
Control_Subjects=[201 202 203 204 206	207	208	209	210	211	212	213	214	215	216	217	218	...
    219	220	221	222	223	224	225	226	227	228	229	232	233	234	235	238	239	240	241	242	243	244	245	246	247	248	249	251	253	254	255	256	257	258	259	262	263	264	266	267];
Subjects=[CKD_Subjects Control_Subjects];

HCT_Sub_CKD=[27.90 36.00 33.00 32.10 39.20 35.90 39.60 33.40 37.90 43.80 35.60 41.60 39.20 35.90 43.80 40.90 36.70 34.90 41.40 39.80 35.30 38.90 35.10 32.40 33.30...
    38.90 38.90 43.10 38.10 40.90 35.90 38.90 46.60 37.80 35.70 44.30 45.20 35.20 39.80 41.90 38.60 38.40 47.60 38.90 24.70 33.60 34.30 38.60 40.40 26.80 45.70 44.20 37.00 ...
    39.40 42.80 37.70 45.30 32.40 42.70 38.30 40.20 44.20 37.10 21.60 36.00 42.40 28.50 35.80 40.80 36.20 32.20 43.00 29.60];
HCT_Sub_Control=[40.90 41.50 39.40 43.60 39.70 40.30 48.50 51.30 27.30 45.20 39.60 39.30 42.10 36.20 36.40 48.70 38.40 41.00 39.40 39.80 42.80...
    41.30 37.10 50.90 41.80 41.30 37.90 41.80 36.70 42.10 39.60 43.20 39.80 42.40 39.80 40.20 34.20 42.10 49.10 39.60 37.60 45.30 43.90 42.20 36.80 41.80 40.20 40.30...
    43.40 39.90 42.30 46.70 42.30 43.10 44.70 41.10 37.00];
HCT_Sub_all=[HCT_Sub_CKD HCT_Sub_Control];
HCT_Sub_all=HCT_Sub_all./100;

% Age_Sub_CKD=[18.150 21.044 19.075 8.764 14.653 14.653 15.935 16.187 16.887 17.268 11.776 15.524 15.672 19.026 15.519 16.170 14.172 14.960 17.608 18.051 14.473...
%     15.494 13.594 11.809 11.401 20.737 13.665 12.540 8.578 17.265 10.796 11.425 18.024 13.517 13.339 15.825 14.284 14.254 15.658 22.867 11.105 14.974 17.109 16.170 ...
%     13.377 10.316 22.974 10.314 16.693 21.558 24.507 17.134 12.786 17.961 16.863 23.795 25.652 11.625 11.453 18.949 15.683 16.189 18.327 11.187 15.494 15.614 15.324 ...
%     21.142 16.622 13.909 13.301 15.278 19.532];
% Age_Sub_Control=[14.459 16.767 11.267 21.723 11.496 8.980 16.890 17.295 11.644 13.657 21.829 15.075 16.304 12.134 14.371 20.830 14.355 17.268 ...
%     19.932 18.336 14.793 15.176 16.646 16.403 12.507 12.507 14.672 12.362 11.034 12.280 9.355 22.987 12.280 13.566 10.133 14.678 21.216 20.072 15.373 12.493...
%     9.207 18.730 17.054 22.295 11.661 25.046 18.330 18.604 21.189 16.778 15.532 17.558 14.511 14.180 17.539 16.176 12.487 ];
% Age_Sub_all=[Age_Sub_CKD Age_Sub_Control];
% 
% Gender_Sub_CKD=[1 	1 	1 	1 	0 	0 	1 	1 	1 	0 	1 	1 	0 	0 	1 	0 	1 	0 	1 	0 	0 	1 	0 	0 	0 	0 ...
%     1 	1 	1 	1 	1 	1 	1 	1 	0 	1 	0 	1 	1 	1 	1 	1 	1 	1 	0 	1 	0 	1 	1 	0 	1 	1 	1 	1 	0 ...	
%     0 	1 	1 	0 	1 	1 	1 	0 	1 	0 	1 	0 	0 	1 	1 	1 	1 	1 ];
% Gender_Sub_Control=[0 	0 	0 	1 	1 	0 	1 	1 	0 	1 	0 	0 	0 	1 	0 	1 	0 	0 	0 	0 	1 	0 	0 	1 	0 ...
%     1 	0 	0 	0 	1 	0 	1 	1 	1 	0 	1 	0 	1 	1 	1 	0 	1 	0 	0 	1 	0 	1 	0 	1 	0 	0 	1 	1 	1 	1 	1 	1 ]; 
% Gender_Sub_all=[Gender_Sub_CKD Gender_Sub_Control];


Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname_1='H:\CKD_PatientData_Raw\Subjects';
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
%   for ss=1
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
   HCT_Sub=HCT_Sub_all(ss);
   [perfnum,glcbf] =asl_perf_subtract_CKD_HCTcorr(Filename,HCT_Sub);
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


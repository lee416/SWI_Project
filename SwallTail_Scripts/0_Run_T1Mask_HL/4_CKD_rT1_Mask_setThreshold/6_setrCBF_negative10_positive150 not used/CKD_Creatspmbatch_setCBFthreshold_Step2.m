clear all
% close all

%Subjects=[41 42 43 44 46 47 48 49 50 209 210 211 213  214 215 216 217];
%pathname_1='/Volumes/Untitled/CKD_data/Subjects';
%pathname_1='G:\CKD_data\Subjects';

% CKD_Subjects=[1 2 3 4 8 9 11 12 13 14 15 16 19 20 21 23 24 35 38 39 41 42 43 44 46 47 48 49 50 ...
%     5 6 36 40 10 17 22 25 26 51];
% Control_Subjects=[201 202 203 204 206 207 209 210 211 213 214 215 216 217 ...
%     218 221 222 208 220];
% Subjects=[CKD_Subjects Control_Subjects];

%Subjects=[212 219 223 224 228];

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

%%% Step 1
%------------- this is for Autism and controls -------------------%
for ss=1:size(Subjects,2)%% the last two s0204, s0206 are CKD controls
     if Subjects(ss)<10
     pathname_2=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_s',int2str(Subjects(ss)),'.img');
     %filename_data_2=strcat(pathname_2,'/','CBF_Mask_s',int2str(Subjects(ss)),'.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_2=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_s',int2str(Subjects(ss)),'.img');
     %filename_data_2=strcat(pathname_2,'/','CBF_Mask_s',int2str(Subjects(ss)),'.img');
    else 
     pathname_2=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_s',int2str(Subjects(ss)),'.img');
     %filename_data_2=strcat(pathname_2,'/','CBF_Mask_s',int2str(Subjects(ss)),'.img');
     end
    
     filename_data_1=strcat(pathname_2,'/','Masked_cmeanCBF_simple_outlier_s',int2str(Subjects(ss)),'.img');
     filename_data_2=strcat(pathname_2,'/','CBF150_Mask_ceman_simpleoutlier_s',int2str(Subjects(ss)),'.img');

    %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.util.imcalc.input={filename_data_1,filename_data_2};
    %matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_Thresholded_rpcasl_CBF_s',int2str(Subjects(ss)),'.img');
    matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
    matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
    matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1.*i2');
end

%pathname_1_Autism='/Volumes/Untitled/Autism_data/Subjects';

% %--------- this is for CKD controls -------------------------%
% for ss=(size(Subjects,2)-1):size(Subjects,2)%% the last two s0204, s0206 are CKD controls
%     if Subjects(ss)<10
%      pathname_2=strcat(pathname_1,'/','R','000',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_2,'/','CBF_Mask_R',int2str(Subjects(ss)),'.img');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname_2=strcat(pathname_1,'/','R','00',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_2,'/','CBF_Mask_R',int2str(Subjects(ss)),'.img');
%     else 
%      pathname_2=strcat(pathname_1,'/','R','0',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','Masked_meanCBF_rpcasl_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_2,'/','CBF_Mask_R',int2str(Subjects(ss)),'.img');
%     end
%     
%     %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
%     matlabbatch{1,ss}.spm.util.imcalc.input={filename_data_1, filename_data_2};
%     matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%     matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
%     matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1.*i2');
% end

save(['CKD_Create_CBFThreshold_batch_Step2.mat'],'matlabbatch');

%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



clear all
% close all

% CKD_Subjects=[1 2 3 4 8 9 11 12 13 14 15 16 19 20 21 23 24 35 38 39 41 42 43 44 46 47 48 49 50 ...
%     5 6 36 40 10 17 22 25 26 51];
% Control_Subjects=[201 202 203 204 206 207 209 210 211 213 214 215 216 217 ...
%     218 221 222 208 220];
% Subjects=[CKD_Subjects Control_Subjects];

% Subjects=[212 219 223 224 228];

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
 pathname_1='F:\CKD_PatientData_Raw\Subjects';
end

%%%%%%%% ------------- this is for CKD and controls ------------------- %%%%%%%%%
for ss=1:size(Subjects,2) 
     if Subjects(ss)<10
     pathname_pcasl=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/');
     %filename_data_1=strcat(pathname_pcasl,'s',int2str(Subjects(ss)),'_Norm_masked_thresholded_CBF','.img');
     %filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
     %filename_data_1=strcat(pathname_pcasl,'Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_pcasl=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_pcasl,'s',int2str(Subjects(ss)),'_Norm_masked_thresholded_CBF','.img');
%      filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
    else 
     pathname_pcasl=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_pcasl,'s',int2str(Subjects(ss)),'_Norm_masked_thresholded_CBF','.img');
%      filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
     end
     filename_data_1=strcat(pathname_pcasl,'Masked_Thresholded_cmean_rCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');    
     filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat'); 
    %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.spatial.normalise.write.subj.matname={filename_data_2};
    matlabbatch{1,ss}.spm.spatial.normalise.write.subj.resample={filename_data_1};
end

% pathname_1_Autism='/Volumes/Untitled/CKD_data/Subjects';
% `
% %%% -------------- this is for CKD controls ------------------------- %%%
% for ss=(size(Subjects,2)-1):size(Subjects,2)%% the last two s0204, s0206 are CKD controls
%      if Subjects(ss)<10
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','000',int2str(Subjects(ss)),'/pcasl_rest/');
%      pathname_anat=strcat(pathname_1_Autism,'/','R','000',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','00',int2str(Subjects(ss)),'/pcasl_rest/');
%      pathname_anat=strcat(pathname_1_Autism,'/','R','00',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
%     else 
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','0',int2str(Subjects(ss)),'/pcasl_rest/');
%      pathname_anat=strcat(pathname_1_Autism,'/','R','0',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%      filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
%     end
%     
%     %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
%     matlabbatch{1,ss}.spm.spatial.normalise.write.subj.matname={filename_data_2};
%     matlabbatch{1,ss}.spm.spatial.normalise.write.subj.resample={filename_data_1};
% end

save(['rCBF_CKD_Create_Normalization_batch.mat'],'matlabbatch');

%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



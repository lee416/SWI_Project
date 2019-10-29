clear all
% close all

load('globalCBF.mat');

% CKD_Subjects=[7 53 54 56 57 61 64 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];

% CKD_Subjects=[62 67 72 73 74 75 76 77 82];
% Control_Subjects=[246 248 249 254];

% CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
% Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 266 267];

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

%%% ----------------- this is for CKD and controls -----------------------%%%
 for ss=1:size(Subjects,2)%% the last part of subjects are Autism controls
     if Subjects(ss)<10
     pathname_pcasl=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_s',int2str(Subjects(ss)),'.img');
     filename_data=strcat(pathname_pcasl,'Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_pcasl=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_s',int2str(Subjects(ss)),'.img');
     filename_data=strcat(pathname_pcasl,'Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
    else 
     pathname_pcasl=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest/');
     %filename_data=strcat(pathname_pcasl,'Masked_Thresholded_rpcasl_CBF_s',int2str(Subjects(ss)),'.img');
     filename_data=strcat(pathname_pcasl,'Masked_Thresholded_cmeanCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
     end
    output_dir=pathname_pcasl;
 %--- Load Autism_Normalize_batch_Sample.mat to see the format and index to be edited in the following matlabbatch ---%  
 matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
 matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_Thresholded_cmean_rCBF_SimpleOutlier_s',int2str(Subjects(ss)),'.img');
 %matlabbatch{1,ss}.spm.util.imcalc.output=strcat('s',int2str(Subjects(ss)),'_Norm_masked_thresholded_CBF.img');
 matlabbatch{1,ss}.spm.util.imcalc.outdir={output_dir};
 matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1/',num2str(globalCBF(ss)));
end

% pathname_1_Autism='/Volumes/Untitled/Autism_data/Subjects';
% 
% %%% ----------------- this is for Autism controls ---------------------- %%%
% for ss=(size(Subjects,2)-Autism_Controls):size(Subjects,2)
%  if Subjects(ss)<10
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','000',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','00',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%     else 
%      pathname_pcasl=strcat(pathname_1_Autism,'/','R','0',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.img');
%     end
%  %--- Load Autism_Normalize_batch_Sample.mat to see the format and index to be edited in the following matlabbatch ---%  
%  matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
%  matlabbatch{1,ss}.spm.util.imcalc.output=strcat('R',int2str(Subjects(ss)),'_Norm_masked_thresholded.img');
%  matlabbatch{1,ss}.spm.util.imcalc.outdir={output_dir};
%  matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1/',num2str(globalCBF(ss)));
% end

save(['CKD_Normalization2WholeBrain.mat'],'matlabbatch');

%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);

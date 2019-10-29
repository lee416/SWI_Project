clear all
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

%%% -------------------- this is for CKD and controls ------------------- %%%
for ss=1:size(Subjects,2)%% the last part of controls are autism control
  for ssq=1:size(Scan_num,2)
    if Subjects(ss)<10
     pathname_2=strcat(pathname_1,'\','MCA_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'/pcasl_rest/');   
     filename_data_1=strcat(pathname_2,'s',int2str(Subjects(ss)),'_rT1_mask.img');
     filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest046.img');
%      filename_data_2=strcat(pathname_2,'cmeanCBF_simple_outlier.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_2=strcat(pathname_1,'\','MCA_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'/pcasl_rest/');   
     filename_data_1=strcat(pathname_2,'s',int2str(Subjects(ss)),'_rT1_mask.img');
     filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest046.img');
    else 
     pathname_2=strcat(pathname_1,'\','MCA_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'/pcasl_rest/');   
     filename_data_1=strcat(pathname_2,'s',int2str(Subjects(ss)),'_rT1_mask.img');
     filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest046.img');
    end    
    %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.util.imcalc.input={filename_data_1,filename_data_2};
    %matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_meanCBF_rpcasl_s',int2str(Subjects(ss)),'.img');
    matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_cmeanCBF_simple_outlier_s',int2str(Subjects(ss)),'.img');
    matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
    matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1.*i2');
  end
end

%pathname_1_Autism='/Volumes/Untitled/Autism_data/Subjects';
% %%% ------------------ this is for Autism controls -----------------------%%%
% for ss=(size(Subjects,2)-Autism_Controls):size(Subjects,2)%% the last two s0204, s0206 are CKD controls
%     if Subjects(ss)<10
%      pathname_2=strcat(pathname_1_Autism,'/','R','000',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','R',int2str(Subjects(ss)),'_rT1_mask.img');
%      filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest078.img');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname_2=strcat(pathname_1_Autism,'/','R','00',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','R',int2str(Subjects(ss)),'_rT1_mask.img');
%      filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest078.img');
%     else 
%      pathname_2=strcat(pathname_1_Autism,'/','R','0',int2str(Subjects(ss)),'/pcasl_rest/');
%      filename_data_1=strcat(pathname_2,'/','R',int2str(Subjects(ss)),'_rT1_mask.img');
%      filename_data_2=strcat(pathname_2,'meanCBF_0_rpcasl_rest078.img');
%     end    
%     %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
%     matlabbatch{1,ss}.spm.util.imcalc.input={filename_data_1,filename_data_2};
%     matlabbatch{1,ss}.spm.util.imcalc.output=strcat('Masked_meanCBF_rpcasl_R',int2str(Subjects(ss)),'.img');
%     matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
%     matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1.*i2');
% end


save(['MCA_Create_MultiplyMask_batch.mat'],'matlabbatch');

%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



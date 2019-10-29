clear all
% close all

Subjects=[202];
Scan_num=[1];

% Title='Please input the System type';
% Prompt={'0 for Mac, 1 for PC'};
% LineNo=1;
% DefAns={'1'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% System_Flag=str2num(answer{1});

% if System_Flag==0
%  pathname_1='/Volumes/Untitled/CKD_data/Subjects';
% else
 pathname_1='E:\SwallowTail_Project\Subjects';
% end

%%% Step 2
%------------- this is for CKD and controls -------------------%
for ss=1:size(Subjects,2)%% the last part of controls are autism control
  for ssq=1:size(Scan_num,2)
  if Subjects(ss)<10
     pathname_2=strcat(pathname_1,'\','Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\T1_mask');
     filename_data=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','s',int2str(Subjects(ss)),'_rT1Step1.img');    
   elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_2=strcat(pathname_1,'\','Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\T1_mask');
     filename_data=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','s',int2str(Subjects(ss)),'_rT1Step1.img');
   else 
     pathname_2=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\T1_mask');
     filename_data=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','s',int2str(Subjects(ss)),'_rT1Step1.img');
   end
   
    %--- Load Autism_rT1Mask_batch_Sample_Step2.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
    matlabbatch{1,ss}.spm.util.imcalc.output=strcat('s',int2str(Subjects(ss)),'_rT1_mask.img');
    matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
    %matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1>0');
    matlabbatch{1,ss}.spm.util.imcalc.expression='i1>0';
%     matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
%     matlabbatch{1,ss}.spm.util.imcalc.output=strcat('s',int2str(Subjects(ss)),'_rT1_mask.img');
%     matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
%     matlabbatch{1,ss}.spm.util.imcalc.expression='i1>0';
  end
end

%pathname_1_Autism='/Volumes/Untitled/Autism_data/Subjects';

% %--------- this is for Autism controls, not done yet -------------------------%

% for ss=(size(Subjects,2)-Autism_Controls):size(Subjects,2)%% the last two s0204, s0206 are CKD controls
%     if Subjects(ss)<10
%      pathname_2=strcat(pathname_1,'\','R','000',int2str(Subjects(ss)),'\pcasl_rest\');
%      filename_data=strcat(pathname_1,'\','R','000',int2str(Subjects(ss)),'\anat_anlz\','R',int2str(Subjects(ss)),'_rT1Step1.img');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname_2=strcat(pathname_1,'\','R','00',int2str(Subjects(ss)),'\pcasl_rest\');
%      filename_data=strcat(pathname_1,'\','R','00',int2str(Subjects(ss)),'\anat_anlz\','R',int2str(Subjects(ss)),'_rT1Step1.img');
%     else 
%      pathname_2=strcat(pathname_1,'\','R','0',int2str(Subjects(ss)),'\pcasl_rest\');
%      filename_data=strcat(pathname_1,'\','R','0',int2str(Subjects(ss)),'\anat_anlz\','R',int2str(Subjects(ss)),'_rT1Step1.img');
%    end
%     %--- Load Autism_rT1Mask_batch_Sample_Step2.mat to see the format and index to be edited in the following matlabbatch ---%
%     matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
%     matlabbatch{1,ss}.spm.util.imcalc.output=strcat('R',int2str(Subjects(ss)),'_rT1_mask.img');
%     matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_2};
%     matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1>0');
% end

save(['SWI_Create_rT1Mask_batch_Step2.mat'],'matlabbatch');

%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



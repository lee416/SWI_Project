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


%------------- this is for CKD and controls -------------------%
for ss=1:size(Subjects,2)%% the last part of controls are autism control
  for ssq=1:size(Scan_num,2)
    if Subjects(ss)<10
%      pathname_2=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/','ranat_anlz.img');
     filename_data_1=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','ranat_anlz.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     filename_data_1=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','ranat_anlz.img');
    else 
     filename_data_1=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','ranat_anlz.img');
    end   
    %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.spatial.preproc.data={filename_data_1};
    matlabbatch{1,ss}.spm.spatial.preproc.output.GM=[1 1 1];
    matlabbatch{1,ss}.spm.spatial.preproc.output.WM=[1 1 1];
    matlabbatch{1,ss}.spm.spatial.preproc.output.CSF=[1 1 1];
end
end

save(['SWI_Batch_Segmen202.mat'],'matlabbatch');

%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



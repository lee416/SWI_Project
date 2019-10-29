% CKD_Subjects=[7 53 54 56 57 61 64 65 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];

% CKD_Subjects=[62 67 72 73 74 75 76 77 82];
% Control_Subjects=[246 248 249 254];

Subjects=[201];
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
 pathname_1='F:\SwallowTail_Project\Subjects';
% end

%------------- this is for CKD and controls -------------------%
for ss=1:size(Subjects,2)%% the last part of controls are autism control
  for ssq=1:size(Scan_num,2)
    if Subjects(ss)<10
%      pathname_2=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/');
%      filename_data_1=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/anat_anlz/','anat_anlz.img');
%      filename_data_2=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest/','meanpcasl_rest000.img');

     filename_data_1=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','anat_anlz.img');
     filename_data_2=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\','SWI_magne1.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     filename_data_1=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','anat_anlz.img');
     filename_data_2=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\','SWI_magne1.img');
    else 
     filename_data_1=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\','anat_anlz.img');
     filename_data_2=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\','SWI_magne1.img');
    end
    
    %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
    matlabbatch{1,ss}.spm.spatial.coreg.estwrite.source={filename_data_1};
    matlabbatch{1,ss}.spm.spatial.coreg.estwrite.ref={filename_data_2};
end
end
% save(['Sub_Batch_Coregist_rT1.mat'],'matlabbatch');
save(['Batch_Coregist_rT1_TRY.mat'],'matlabbatch');


%% open the above-created batch and run all subjects at the same time or follow run saved batch without spmGUI
%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);



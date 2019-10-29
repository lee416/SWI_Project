% function dicom2img(files)
close all;clear all;clc

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Subjects=[401];%204~211, NeedChanged210,222,223,801
echo=7; % varify from subject 201~203 >>7,204~210, 222>>8,211~221 >>7,
Scan_num=[1];

 pathname_1='D:\SwallowTail_Project\Subject_Normal_Raw';
 pathname_D0='D:\SwallowTail_Project\Subjects';

% if(nargin < 1)
 for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
%for ss=1:size(Subjects,2)
   %for ss=18:18
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss))))); 
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)));
     pathname_D=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     pathname_SWI0=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)));
     pathname_D=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     pathname_SWI0=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     else 
     pathname=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)));
     pathname_D=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     pathname_SWI0=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     end
     
 cd(pathname)
 name=ls;
 nameread=name(3,:);
 pathname2name=strcat(pathname,'\',nameread);
 cd(pathname2name)
 
%%%%%%%% skip for 222, 223,801 since folders differ
 brain=ls;
 brainread=brain(3,:);
 pathname2brain=strcat(pathname2name,'\',brainread);
%%%%%%% make sure "pathname2name" >> "pathname2brain" %%%%%%%%

%%%%%%%% T1 data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 cd(pathname2brain)
 T1dir=ls('T1_MPRAGE_*');
 pathnameT1=strcat(pathname2brain,'\',T1dir); % be changed
 cd(pathnameT1)
 
 files = spm_select('list', pathnameT1, '\.IMA');
 spm_get_defaults
 hdr = spm_dicom_headers(files);
 spm_dicom_convert(hdr);

%%%%%%%% SWI data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 cd(pathname2brain)   %%%%%%%  make sure "pathname2name" >> "pathname2brain"
 SWIdir=ls('T2_FLAIR_SAG_*'); % 1~3,10~23,801
%  SWIdir=ls('T2_FLAIR_SAGT_*'); % 4~9
 pathnameSWI=strcat(pathname2brain,'\',SWIdir); %%%%%%%  make sure "pathname2name" >> "pathname2brain
 
 %%% magnetic (1,:)
 cd(pathnameSWI(1,:))
 files = spm_select('list', strcat(pathnameSWI(1,:)), '\.IMA');
 spm_get_defaults
 hdr = spm_dicom_headers(files);
 spm_dicom_convert(hdr);
 clear files
 %%% phase (2,:)
 cd(pathnameSWI(2,:))
 files = spm_select('list', strcat(pathnameSWI(2,:)), '\.IMA');
 spm_get_defaults
 hdr = spm_dicom_headers(files);
 spm_dicom_convert(hdr);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 display('done!')
 clear files 
 %%%%%% file removing
 cd(mfile_dir)
 fun_mvRename_T1(mfile_dir,pathnameT1,pathname_D,pathnameSWI,pathname_SWI0,echo);
 %%%%%%
 
close(h)
     end
 end
% end









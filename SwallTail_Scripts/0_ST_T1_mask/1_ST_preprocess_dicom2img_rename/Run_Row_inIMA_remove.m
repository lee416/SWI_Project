close all;clear all;clc

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

pathname_1='E:\SwallowTail_Project\Subjects_inIMA';
pathname_D0='E:\SwallowTail_Project\Result';

Subjects=[216:221]; % 204~211, NeedChanged210,222,223,801
Subjects=[222 223 801]; % 204~211, NeedChanged210,222,223,801
Scan_num=[1];
% ss=1;ssq=1;
% pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)));
% pathname_SWI_D0=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\Sub_','00',int2str(Subjects(ss)));
     pathname_SWI_D0=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\Sub_','0',int2str(Subjects(ss)));
     pathname_SWI_D0=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     else 
     pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)));
     pathname_SWI_D0=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI\');
     end
cd(pathname)
name=ls;
nameread=name(3,:);
pathname2name=strcat(pathname,'\',nameread);
cd(pathname2name)
%%%%%%%% skip for 201 222, 223,801 since folders differ
% brain=ls;
% brainread=brain(3,:);
% pathname2brain=strcat(pathname2name,'\',brainread);

%%%%%%% make sure "pathname2name" >> "pathname2brain" %%%%%%%%
cd(pathname2name)
%%%%%%%% SWI data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SWIdir=ls('T2_FLAIR_SAG_*'); % 1~3,10~23,801
%  SWIdir=ls('T2_FLAIR_SAGT_*'); % 4~9
pathnameSWI=strcat(pathname2name,'\',SWIdir); %%%%%%%  make sure "pathname2name" >> "pathname2brain
 
%%% magnetic (1,:)
clear files
cd(pathnameSWI(1,:))
files = spm_select('list', strcat(pathnameSWI(1,:)), '\.IMA');
spm_get_defaults
pathname_SWI_mag=strcat(pathname_SWI_D0,'\magne');

for ii=1:size(files,1)
  copyfile(files(ii,:),pathname_SWI_D0,'f');
  copyfile(files(ii,:),pathname_SWI_mag,'f');
end

%%% phase (2,:)
clear files
cd(pathnameSWI(2,:))
files = spm_select('list', strcat(pathnameSWI(2,:)), '\.IMA');
spm_get_defaults
pathname_SWI_pha=strcat(pathname_SWI_D0,'\phase');
for ii=1:size(files,1)
  copyfile(files(ii,:),pathname_SWI_D0,'f');
  copyfile(files(ii,:),pathname_SWI_pha,'f');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     end
end


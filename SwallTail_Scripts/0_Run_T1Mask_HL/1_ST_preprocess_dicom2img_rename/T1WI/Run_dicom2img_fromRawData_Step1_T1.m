% function dicom2img(files)

clear all;clc

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Subjects=[201:223 801];
Scan_num=[1];

 pathname_1='G:\SwallowTail_Project\Subject_Normal_Raw';
 pathname_A0='G:\SwallowTail_Project\Subjects';

% if(nargin < 1)
 for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
%for ss=1:size(Subjects,2)
   %for ss=18:18
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss))))); 
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)));
     pathname_A=strcat(pathname_A0,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)));
     pathname_A=strcat(pathname_A0,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     else 
     pathname=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)));
      pathname_A=strcat(pathname_A0,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz\');
     end
     
 cd(pathname)
 name=ls;
 nameread=name(3,:);
 pathname2name=strcat(pathname,'\',nameread);
 cd(pathname2name)
 
 brain=ls;
 brainread=brain(3,:);
 pathname2brain=strcat(pathname2name,'\',brainread);
 cd(pathname2brain)
 
 T1dir=ls('T1_MPRAGE_*');
  pathnameT1=strcat(pathname2brain,'\',T1dir);  
 cd(pathnameT1)
 
 files = spm_select('list', pathnameT1, '\.IMA');
 spm_get_defaults
 hdr = spm_dicom_headers(files);
 spm_dicom_convert(hdr);
 display('done!')
 clear files
 
 
 %%%%%% 
 cd(mfile_dir)
 fun_mvRename_T1(mfile_dir,pathnameT1,pathname_A);
 %%%%%%
 
close(h)
cd(mfile_dir)
     end
 end
% end

% return;







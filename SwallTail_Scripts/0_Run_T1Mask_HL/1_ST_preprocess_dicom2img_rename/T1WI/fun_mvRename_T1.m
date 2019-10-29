%%%%%%%%%%%%%% Start, description from the website %%%%%%%%%%%%%%%%%
% Use the MOVEFILE function (as suggested by mtrw).
% Use the SYSTEM function to execute an operating system command. For example (on Windows):
% system('rename temp.txt hello.txt');
% system(['rename ' a ' ' b]);  % If the file names are stored in strings
% Use the shell escape operator (!) to invoke a system command. For example (on Windows):
% 
% !rename temp.txt hello.txt
% If the file names are stored in strings, you would need to use EVAL:
% 
% a = 'temp.txt';
% b = 'hello.txt';
% eval(['!rename ' a ' ' b]);
% movefile('myfile.m','d:/work/restricted/test1.m','f')
%%%%%%%%%%%%%%%%% end, description from the website %%%%%%%%%%%%%%%%%%
% clear all
% close all
function fun_mvRename_T1(mfile_dir,pathnameT1,pathname_A)
% script_dir=pwd;
% cd(script_dir)
 cd(mfile_dir)
[new_filename]=fun_filename_T1(pathname_A);

cd(pathnameT1)
files(1,:) = spm_select('list', pathnameT1, '\.hdr');
files(2,:) = spm_select('list', pathnameT1, '\.img');

   for ii=1:size(new_filename,1)
    movefile(files(ii,:),new_filename(ii,:),'f');
%    copyfile(files(ii,:),new_filename(ii,:),'f');
   new_filename(1,:)
   end
  
 cd(mfile_dir)

% Subjects=[202];
% Scan_num=[1];
% Echo_number=7;
% scan_number=Echo_number;
% 
% mfile_which= mfilename('fullpath');
% mfile_dir=fileparts(mfile_which);
% 
%  pathname_1='H:\Parkinson Diseases\Subjects';


%  for ss=1:size(Subjects,2)
%   for ssq=1:size(Scan_num,2)
%    h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
%   
%      if Subjects(ss)<10
%      pathname=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data\');
%      pathname_2=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data_IMG\');
%      elseif Subjects(ss)<=99&Subjects(ss)>=10
%      pathname=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data\');
%      pathname_2=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data_IMG\');
%      else 
%      pathname=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data\');
%      pathname_2=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\QSM_Data_IMG\'); 
%     
%    end
% 
% [new_filename_1 new_filename_2]=fun_filename_fmri_SPM_PD_QSM(pathname_2,scan_number);
% cd(pathname)
% 
% files_1 = spm_select('list', pathname, '\.hdr');
% files_2 = spm_select('list', pathname, '\.img');
%  
% %   for ii=1:size(new_filename_1,1)
% %    movefile(files_1(ii,:),new_filename_1(ii,:),'f');
% %    movefile(files_2(ii,:),new_filename_2(ii,:),'f');
% %    ii
% %   end
%  
% close(h)
% cd(mfile_dir)
%   end
%  end




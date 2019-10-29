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
clear all
close all

% CKD_Subjects=[7 53 54 56 57 58 59 61 64 65 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];
CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 267];
Subjects=[CKD_Subjects Control_Subjects];

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Title='Please input the System type and scan number';
Prompt={'0 for Mac, 1 for PC','scans'};
LineNo=1;
DefAns={'1','102'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});
scan_number=str2num(answer{2});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Origingal CKD data from Katie/data from Katie/CKD_Data_April_2013';
 pathname_A='/Volumes/Untitled/CKD_data/Subjects';
else
%  pathname_1='G:\CKD_PatientData_Raw\Original_CKD_data_from_Katie\CKD_Data_April_2014';
%  pathname_A='G:\CKD_PatientData_Raw\Subjects';
 pathname_1='H:\CKD_Backup_2014\DatafromNina_Sep2014';
 pathname_A='F:\CKD_PatientData_Raw\Subjects';
end

for ss=1:size(Subjects,2)
%for ss=3:3
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   % h=waitbar(ss/26,strcat('subject',(int2str(ss))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','nick','00',int2str(Subjects(ss)),'/fmri_s00',int2str(Subjects(ss)));
     pathname_2=strcat('/s00',int2str(Subjects(ss)),'/fmri_s00',int2str(Subjects(ss)),'/fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','nick','0',int2str(Subjects(ss)),'/fmri_s0',int2str(Subjects(ss)));
     pathname_2=strcat('/s0',int2str(Subjects(ss)),'/fmri_s0',int2str(Subjects(ss)),'/fmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'/','nick',int2str(Subjects(ss)),'/fmri_s',int2str(Subjects(ss)));
     pathname_2=strcat('/s',int2str(Subjects(ss)),'/fmri_s',int2str(Subjects(ss)),'/fmri_s',int2str(Subjects(ss))); 
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','nick','00',int2str(Subjects(ss)),'\fmri_s00',int2str(Subjects(ss)));
     pathname_2=strcat('\s00',int2str(Subjects(ss)),'\fmri_s00',int2str(Subjects(ss)),'\fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','nick','0',int2str(Subjects(ss)),'\fmri_s0',int2str(Subjects(ss)));
     pathname_2=strcat('\s0',int2str(Subjects(ss)),'\fmri_s0',int2str(Subjects(ss)),'\fmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'\','nick',int2str(Subjects(ss)),'\fmri_s',int2str(Subjects(ss)));
     pathname_2=strcat('\s',int2str(Subjects(ss)),'\fmri_s',int2str(Subjects(ss)),'\fmri_s',int2str(Subjects(ss))); 
     end
   end

[new_filename_1 new_filename_2]=fun_filename_fmri_SPM_CKD_fMRI(pathname_A,pathname_2,scan_number);
cd(pathname)

files_1 = spm_select('list', pathname, '\.hdr');
files_2 = spm_select('list', pathname, '\.img');
 
  for ii=1:size(new_filename_1,1)
   movefile(files_1(ii,:),new_filename_1(ii,:),'f');
   movefile(files_2(ii,:),new_filename_2(ii,:),'f');
   ii
  end
 
close(h)
cd(mfile_dir)
end




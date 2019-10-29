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

Subjects=[201];
Scan_num=[1];

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Title='Please input the System type and scan number';
Prompt={'0 for Mac, 1 for PC','scans'};
LineNo=1;
DefAns={'1','32'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});
scan_number=str2num(answer{2});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Origingal CKD data from Katie/data from Katie/CKD_Data_Jan_2013';
 pathname_A='/Volumes/Untitled/CKD_data/Subjects';
else
%  pathname_1='G:\CKD_PatientData_Raw\Original_CKD_data_from_Katie\CKD_Data_May_2014';
%  pathname_A='G:\CKD_PatientData_Raw\Subjects';
 pathname_1='H:\MCA_Stroke_TMU\Subjects';
 pathname_A='H:\MCA_Stroke_TMU\Subjects';
end

 for ss=1:size(Subjects,2)
  for ssq=1:size(Scan_num,2)
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','nick','00',int2str(Subjects(ss)),'/pcasl_rest');
     pathname_2=strcat('/s00',int2str(Subjects(ss)),'/pcasl_rest/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','nick','0',int2str(Subjects(ss)),'/pcasl_rest');
     pathname_2=strcat('/s0',int2str(Subjects(ss)),'/pcasl_rest/');
     else 
     pathname=strcat(pathname_1,'/','nick',int2str(Subjects(ss)),'/pcasl_rest');
     pathname_2=strcat('/s',int2str(Subjects(ss)),'/pcasl_rest/'); 
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','MCA_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     pathname_2=strcat(pathname_1,'\','MCA_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','MCA_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     pathname_2=strcat(pathname_1,'\','MCA_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     else 
     pathname=strcat(pathname_1,'\','MCA_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\');
     pathname_2=strcat(pathname_1,'\','MCA_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\pcasl_rest\'); 
     end
   end

[new_filename_1 new_filename_2]=fun_filename_fmri_SPM_MCA_pCASL(pathname_2,scan_number);
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
 end




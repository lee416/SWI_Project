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
% Subjects=[CKD_Subjects Control_Subjects];

CKD_Subjects=[62 67 72 73 74 75 76 77 78 82];
Control_Subjects=[246 248 249 250 254];
Subjects=[CKD_Subjects Control_Subjects];


mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Title='Please input the System type and scan number';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname='/Volumes/Untitled/CKD_data/Subjects';
else
 pathname='G:\CKD_PatientData_Raw\Subjects';
end

for ss=1:size(Subjects,2)
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname_A=strcat('/s00',int2str(Subjects(ss)),'/');
     pcasl_dir=strcat('anat_anlz');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_A=strcat('/s0',int2str(Subjects(ss)),'/');
     pcasl_dir=strcat('anat_anlz');
     else 
     pathname_A=strcat('/s',int2str(Subjects(ss)),'/');
     pcasl_dir=strcat('anat_anlz');
     end
   else         
     if Subjects(ss)<10
     pathname_A=strcat('\s00',int2str(Subjects(ss)),'\');
     pcasl_dir=strcat('anat_anlz');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_A=strcat('\s0',int2str(Subjects(ss)),'\');
     pcasl_dir=strcat('anat_anlz');
     else 
     pathname_A=strcat('\s',int2str(Subjects(ss)),'\');
     pcasl_dir=strcat('anat_anlz');
     end
   end
   
   pathname_AB=strcat(pathname, pathname_A);
   cd(pathname_AB);
   mkdir (pcasl_dir)
   
close(h)
cd(mfile_dir)
end




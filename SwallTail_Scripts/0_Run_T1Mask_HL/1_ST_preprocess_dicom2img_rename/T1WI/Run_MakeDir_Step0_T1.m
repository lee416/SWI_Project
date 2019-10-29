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
% close all

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Subjects=[202:223 801];
Scan_num=[1];

% Title='Please input the System type';
% Prompt={'0 for Mac, 1 for PC'};
% LineNo=1;
% DefAns={'1'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% System_Flag=str2num(answer{1});

% if System_Flag==0
%  pathname_1='/Volumes/Untitled/CKD_data/Origingal CKD data from Katie/data from Katie/CKD_Data_Oct_2013';
% else
 %pathname_1='F:\CKD_data\Subjects';
%  pathname_1='G:\CKD_PatientData_Raw\Original_CKD_data_from_Katie\CKD_Data_May_2014';
 pathname='G:\SwallowTail_Project\Subjects\';
% end

% Title='Please input the System type and scan number';
% Prompt={'0 for Mac, 1 for PC'};
% LineNo=1;
% DefAns={'1'};
% answer=inputdlg(Prompt,Title,LineNo,DefAns);
% System_Flag=str2num(answer{1});
% 
% if System_Flag==0
%  pathname='/Volumes/Untitled/CKD_data/Subjects';
% else
%  pathname='F:\CKD_PatientData_Raw\Subjects';
% end

 for ss=1:size(Subjects,2)
   for ssq=1:size(Scan_num,2)
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
     if Subjects(ss)<10
     pathname_1=strcat('Sub_00',int2str(Subjects(ss)));
     pathname_A=strcat('\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_1=strcat('Sub_0',int2str(Subjects(ss)));
     pathname_A=strcat('\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)));
     else 
     pathname_1=strcat('Sub_',int2str(Subjects(ss)),'\');
     pathname_A=strcat('\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)));
     end
   Scan_dir=strcat('Scan',int2str(Scan_num(ssq)));
   T1WI_dir=strcat('anat_anlz');
   cd(pathname);
   mkdir(pathname_1);   
   pathname_Scan=strcat(pathname, pathname_1);
   cd(pathname_Scan);
   mkdir (Scan_dir)
   pathname_AB=strcat(pathname, pathname_A);
   cd(pathname_AB);
   mkdir (T1WI_dir)
   
close(h)
cd(mfile_dir)
   end
end




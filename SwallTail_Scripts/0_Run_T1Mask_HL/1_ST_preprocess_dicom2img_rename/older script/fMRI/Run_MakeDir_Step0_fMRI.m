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

%Subjects=[1 2 3 4 8 9 11 12 13 14 15 16 19 20 21 23 24 35 38 39 40 41 42 44 47 49 50 201 202 203 204 205 206 207 209 210];
%Subjects=[43 46 48 211 213 214 215 216 217];
%Subjects=[5 6 36 218 221 222];
%Subjects=[10 17 18 22 25 26 40 51 208 212 220];
%Subjects=[212 219 223 224 228];

CKD_Subjects=[27 29 30 31 32 33 37 45 52];
Control_Subjects=[225 226 227 229 232 235 237 239 241 242 243 244 245];
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
 pathname='G:\CKD_data\Subjects';
end

for ss=1:size(Subjects,2)
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname_A=strcat('/s00',int2str(Subjects(ss)),'/');
     fmri_dir=strcat('fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_A=strcat('/s0',int2str(Subjects(ss)),'/');
     fmri_dir=strcat('fmri_s0',int2str(Subjects(ss)));
     else 
     pathname_A=strcat('/s',int2str(Subjects(ss)),'/');
     fmri_dir=strcat('fmri_s',int2str(Subjects(ss)));
     end
   else         
     if Subjects(ss)<10
     pathname_A=strcat('\s00',int2str(Subjects(ss)),'\');
     fmri_dir=strcat('fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_A=strcat('\s0',int2str(Subjects(ss)),'\');
     fmri_dir=strcat('fmri_s0',int2str(Subjects(ss)));
     else 
     pathname_A=strcat('\s',int2str(Subjects(ss)),'\');
     fmri_dir=strcat('fmri_s',int2str(Subjects(ss)));
     end
   end
   
   pathname_AB=strcat(pathname, pathname_A);
   cd(pathname_AB);
   mkdir (fmri_dir)
   
close(h)
cd(mfile_dir)
end




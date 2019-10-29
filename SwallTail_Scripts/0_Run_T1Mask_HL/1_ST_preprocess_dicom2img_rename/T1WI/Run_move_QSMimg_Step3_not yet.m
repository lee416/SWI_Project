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

% CKD_Subjects=[7 53 54 56 57 58 59 61 64 65 66 69 70 71];
% Control_Subjects=[230 233 234 237 238 240 242 247];

% CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
% Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 267];

CKD_Subjects=[62 67 72 73 74 75 76 77 82];
Control_Subjects=[246 248 249 250 254];   

Subjects=[CKD_Subjects Control_Subjects];

% CKD_Subjects=[10 17 22 25 26 51];
% Control_Subjects=[208 220];
% Subjects=[CKD_Subjects Control_Subjects];

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Title='Please input the System type and scan number';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
else
 %pathname_1='G:\CKD_PatientData_Raw\Subjects';
 pathname_1='G:\CKD_PatientData_Raw\Subjects';
end

%pathname_1='G:\CKD_data\Subjects';

for ss=1:size(Subjects,2)
  h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
    if Subjects(ss)<10
     %pathname_2=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz\');
     filename_data_1_img=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.img');
     filename_data_1_hdr=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.hdr');
     filename_data_2_img=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.img');
     filename_data_2_hdr=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.hdr');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     %pathname_2=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz\');
     filename_data_1_img=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.img');
     filename_data_1_hdr=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.hdr');
     filename_data_2_img=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.img');
     filename_data_2_hdr=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.hdr');
    else 
     %pathname_2=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz\');
     filename_data_1_img=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.img');
     filename_data_1_hdr=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz\','anat_anlz.hdr');
     filename_data_2_img=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.img');
     filename_data_2_hdr=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\anat_anlz_fmri\','anat_anlz.hdr');
    end
    files_hdr=filename_data_1_hdr;
    files_img=filename_data_1_img;
    new_filename_hdr=filename_data_2_hdr;
    new_filename_img=filename_data_2_img;
   
   for ii=1:size(new_filename_hdr,1)
    copyfile(files_hdr(ii,:),new_filename_hdr(ii,:),'f')
    copyfile(files_img(ii,:),new_filename_img(ii,:),'f')
   end
   close(h)
  
end

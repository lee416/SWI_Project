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

%movefile('nick001_0001_0001.dcm','/Volumes/Untitled/fMRIPulseOX/test.dcm','f')

Subjects=[1 2 3 4 8 9 11 12 13 14 15 16 19 20 21 23 24 35 38 39 40 41 42 44 47 49 50 201 202 203 204 205 206 207 209 210]; 

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
 pathname_delete='/Volumes/Untitled/CKD_data/Subjects/tobedeleted';
else
 pathname_1='F:\CKD_data\Subjects';
 pathname_delete='F:\CKD_data\Subjects\tobedeleted';
end

for ss=6:size(Subjects,2)
%for ss=7:7
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   % h=waitbar(ss/26,strcat('subject',(int2str(ss))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/fmri_s00',int2str(Subjects(ss)));
     pathname_2=strcat('/rfmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/fmri_s0',int2str(Subjects(ss)));
     pathname_2=strcat('/rfmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/fmri_s',int2str(Subjects(ss)));
     pathname_2=strcat('/rfmri_s',int2str(Subjects(ss)));   
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\fmri_s00',int2str(Subjects(ss)));
     pathname_2=strcat('\rfmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\fmri_s0',int2str(Subjects(ss)));
     pathname_2=strcat('\rfmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\fmri_s',int2str(Subjects(ss)));
     pathname_2=strcat('\rfmri_s',int2str(Subjects(ss))); 
    end
   end

[new_filename]=fun_filename_fmri_Dicom_CKD(pathname,pathname_2);
cd(pathname)
%files = spm_select('list', pathname, '\.dcm');
%files = spm_select('list', pathname, '\.hdr');
%files = spm_select('list', pathname, '\.img');
 for ii=1:size(new_filename,1)
  movefile(new_filename(ii,:),pathname_delete,'f')
 end
close(h)
%cd('/Volumes/Untitled/fMRI PulseOX/PhLEMv2.0_Heather_AllSubjects/1_fMRI_preprocess_dicom2img_rename')
cd('F:\fMRI PulseOX\PhLEMv2.0_Heather_AllSubjects\1_fMRI_preprocess_dicom2img_rename')
end




function dicom2img(files)

Subjects=[202];
Scan_num=[1];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Origingal CKD data from Katie/data from Katie/CKD_Data_May_2013';
else
 %pathname_1='F:\CKD_data\Subjects';
%   pathname_1='G:\CKD_PatientData_Raw\Original_CKD_data_from_Katie\CKD_Data_May_2014';
  pathname_1='H:\Parkinson Diseases\Subjects';
 % H:\Parkinson Diseases\Subjects\Sub_202\anat_anlz
end

if(nargin < 1)
 for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
   %for ss=18:18
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   %h=waitbar(ss/26,strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','nick','00',int2str(Subjects(ss)),'/anat_anlz/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','nick','0',int2str(Subjects(ss)),'/anat_anlz/');
     else 
     pathname=strcat(pathname_1,'/','nick',int2str(Subjects(ss)),'/anat_anlz/');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','Sub_','00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','Sub_','0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz');
     else 
     pathname=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\anat_anlz');
    end
   end
cd(pathname)
files = spm_select('list', pathname, '\.IMA');
spm_get_defaults
hdr = spm_dicom_headers(files);
spm_dicom_convert(hdr);
display('done!')
close(h)
 end
 end
end

return;







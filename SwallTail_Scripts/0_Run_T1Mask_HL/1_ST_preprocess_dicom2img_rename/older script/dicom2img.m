function dicom2img(files)

Subjects=[40 41 42 44 47 49 50 209 210];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Subjects';
 %pathname_1='/Volumes/Untitled/Autism_Data/ASL from Vanessa/Data from Vanessa May 18 2012/datapull_050612';
else
 %pathname_1='G:\CKD_data\Subjects';
 pathname_1='G:\CKD_data\Origingal CKD data from Katie\data from Katie\CKD_Data_Sep_2012';
end

if(nargin < 1)
 for ss=1:size(Subjects,2)
   %for ss=18:18
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
    if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'/pcasl_rest');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'/pcasl_rest');
     else 
     pathname=strcat(pathname_1,'/','s',int2str(Subjects(ss)),'/pcasl_rest');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','s','00',int2str(Subjects(ss)),'\pcasl_rest');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','s','0',int2str(Subjects(ss)),'\pcasl_rest');
     else 
     pathname=strcat(pathname_1,'\','s',int2str(Subjects(ss)),'\pcasl_rest');
    end
   end
cd(pathname)
files = spm_select('list', pathname, '\.dcm');
spm_get_defaults
hdr = spm_dicom_headers(files);
spm_dicom_convert(hdr);
display('done!')
close(h)
 end
end

return;







function dicom2img(files)

%Subjects=[1 2 3 4 8 9 11 12 13 14 15 16 19 20 21 23 24 35 38 39 40 41 42 44 47 49 50 201 202 203 204 205 206 207 209 210]; 
%Subjects=[43 46 48 211 213 214 215 216 217];
%Subjects=[5 6 36 218 221 222];
%Subjects=[10 17 18 22 25 26 51 208 212 220];
%Subjects=[51];
% Subjects=[212 219 223 224 228];

% CKD_Subjects=[27 29 30 31 32 33 37 45 52];
% Control_Subjects=[225 226 227 229 232 235 237 239 241 242 243 244 245];

CKD_Subjects=[28 34 60 79 80 81 83 85 86 87 88 90 91];
Control_Subjects=[251 253 255 256 257 258 259 260 261 262 263 264 267]; %s266 no data
Subjects=[CKD_Subjects Control_Subjects];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'1'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/Untitled/CKD_data/Origingal CKD data from Katie/data from Katie/CKD_Data_Oct_2013';
else
%  pathname_1='G:\CKD_data\Origingal CKD data from Katie\data from Katie\CKD_Data_Oct_2013';
 pathname_1='H:\CKD_Backup_2014\DatafromNina_Sep2014';
end

if(nargin < 1)
 for ss=1:size(Subjects,2)
%for ss=1:size(Subjects,2)
   %for ss=18:18
   h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
   %h=waitbar(ss/26,strcat('subject',(int2str(Subjects(ss)))));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','nick','00',int2str(Subjects(ss)),'/fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','nick','0',int2str(Subjects(ss)),'/fmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'/','nick',int2str(Subjects(ss)),'/fmri_s',int2str(Subjects(ss)));
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','nick','00',int2str(Subjects(ss)),'\fmri_s00',int2str(Subjects(ss)));
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','nick','0',int2str(Subjects(ss)),'\fmri_s0',int2str(Subjects(ss)));
     else 
     pathname=strcat(pathname_1,'\','nick',int2str(Subjects(ss)),'\fmri_s',int2str(Subjects(ss)));
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







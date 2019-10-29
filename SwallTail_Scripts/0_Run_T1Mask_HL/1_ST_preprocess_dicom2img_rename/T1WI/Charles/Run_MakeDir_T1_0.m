clear all;close all;

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

Subjects=[201:223 801];
Scan_num=[1];
pathname='E:\SwallowTail_Project\Subjects\';


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
   
   %%%% for SWI new files
   SWI_dir=strcat('SWI');
   mkdir(SWI_dir);
   %%%%%%%%
   
close(h)
cd(mfile_dir)
   end
end




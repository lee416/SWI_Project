close all;clear all;clc

mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);

pathname_1='D:\SwallowTail_Project\Subjects_inIMA';
pathname_D0='D:\SwallowTail_Project\Result';

Subjects=[201:223 801];
Scan_num=[1];
ss=1;ssq=1;
% pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
% pathname_D=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)));

for ss=1:size(Subjects,2)
     for ssq=1:size(Scan_num,2)
        if Subjects(ss)<10
        pathname=strcat(pathname_1,'\Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
        pathname_D=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)));
        elseif Subjects(ss)<=99&Subjects(ss)>=10
        pathname=strcat(pathname_1,'\Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
        pathname_D=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)));
        else 
        pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI');
        pathname_D=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)));
        end
Subjects(ss)
%%%%%%%% data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RESULTdir=strcat(pathname,'\MatData_All'); 
cd(RESULTdir)
clear files
files = ls(RESULTdir);
mkdir(pathname_D)
for qqq=3:size(files,1)
copyfile(files(qqq,:),pathname_D,'f');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     end
end


clear all;clc;close all;

filepath=pwd;
mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);
cd(filepath)

Subjects=[201 203:214 217:223 801];
% Subjects=[201]
size(Subjects);
pathname00='D:\Subjects';
pathname0='D:\SwallowTail_Project\Subjects_inIMA';
pathnameD='D:\SwallowTail_Project\SwallTail_Scripts\2_Excel';

for ss=1: size(Subjects,2)
    if Subjects(ss)<10
        pathnameT2=strcat(pathname00,'\Sub_00',int2str(Subjects(ss)),'\Scan1\SWI');
        pathnameROI=strcat(pathname0,'\Sub_00',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');
    elseif Subjects(ss)<=99&Subjects(ss)>=10
        pathnameT2=strcat(pathname00,'\Sub_0',int2str(Subjects(ss)),'\Scan1\SWI');
        pathnameROI=strcat(pathname0,'\Sub_0',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');
    else
        pathnameT2=strcat(pathname00,'\Sub_',int2str(Subjects(ss)),'\Scan1\SWI');
        pathnameROI=strcat(pathname0,'\Sub_',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');

           cd(pathnameT2)
           load T2map
           T2map_matrix=zeros(size(T2map,2),size(T2map,1),size(T2map,3));
           for cc = 1:size(T2map,3)
               for bb = 1:size(T2map,2)
                   for aa = 1:size(T2map,1)
                        T2map_matrix(1+size(T2map,2)-bb,aa,cc) = T2map(aa,bb,cc);
                   end
               end
           end      
%            figure;imagesc(T2map_matrix(:,:,30))
           
           cd(pathnameROI)
           load SWI_img_ave_Mat SWI_img_ave_Mat
           load masknigrosomeL masknigrosomeL
           load masknigrosomeR masknigrosomeR
           load masksubstantianigraL masksubstantianigraL
           load masksubstantianigraR masksubstantianigraR
           mask=cat(4,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR);
           %%% mask 1=masknigrosomeL, 2=masknigrosomeR, 3=masksubstantianigraL, 4=masksubstantianigraR
           size(mask(:,:,:,1));
           T2_NL = T2map_matrix.*mask(:,:,:,1);
           T2_NR = T2map_matrix.*mask(:,:,:,2);
           T2_SubL=T2map_matrix.*mask(:,:,:,3);
           T2_SubR=T2map_matrix.*mask(:,:,:,4);

           %left
           CNR_NL_mean=(sum(sum(sum(T2_NL)))/sum(sum(sum(masknigrosomeL))));
           CNR_SubL_mean=(sum(sum(sum(T2_SubL)))/sum(sum(sum(masksubstantianigraL))));
           CNR_N2Sub_L=CNR_NL_mean/CNR_SubL_mean;
           CNR_N2Sub_L_p=(CNR_NL_mean-CNR_SubL_mean)*100/CNR_SubL_mean;
           %right    
           CNR_NR_mean=(sum(sum(sum(T2_NR)))/sum(sum(sum(masknigrosomeR))));
           CNR_SubR_mean=(sum(sum(sum(T2_SubR)))/sum(sum(sum(masksubstantianigraR))));
           CNR_N2Sub_R=CNR_NR_mean/CNR_SubR_mean;
           CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_SubR_mean;
           
           CNR_matrix0(ss,:)=[CNR_N2Sub_L CNR_N2Sub_R CNR_N2Sub_L_p CNR_N2Sub_R_p];
%           CNR_matrix0
           
           
    end
end
cd(pathnameD)
save CNR_matrix0 CNR_matrix0


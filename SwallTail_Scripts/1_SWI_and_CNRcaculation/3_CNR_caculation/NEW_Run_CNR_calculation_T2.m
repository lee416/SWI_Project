clear all;clc;close all;

filepath=pwd;
mfile_which= mfilename('fullpath');
mfile_dir=fileparts(mfile_which);
cd(filepath)

Subjects=[201 203:214 217:223 801];
% Subjects=[201]
size(Subjects);
pathname00='E:\Subjects_T2'; % T2 location
pathname0='E:\SwallowTail_Project\Subjects_inIMA'; % nigro Substan Location
pathnameD='E:\SwallowTail_Project\SwallTail_Scripts\1_SWI_and_CNRcaculation\3_CNR_caculation';

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
           m1=size(T2_NL,1); % 408
           m2=size(T2_NL,2); % 416
           m3=size(T2_NL,3); % 60

           %left
           CNR_NL_mean=(sum(sum(sum(T2_NL)))/sum(sum(sum(masknigrosomeL))));
           CNR_SubL_mean=(sum(sum(sum(T2_SubL)))/sum(sum(sum(masksubstantianigraL))));          
           %%%% STD preparation  (Pure img_ave_NL (without 0) %%%%%%%%%%%%%%%%%
           CNR_NL_matrix0=zeros(1,m1*m2);    CNR_NL_matrix=zeros(1,m1*m2*m3);
           CNR_SubL_matrix0=zeros(1,m1*m2);    CNR_SubL_matrix=zeros(1,m1*m2*m3);
           for qqq=1:m3
           CNR_NL_matrix0=reshape(T2_NL(:,:,qqq),1,m1*m2);
           CNR_NL_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_NL_matrix0;
           CNR_SubL_matrix0=reshape(T2_SubL(:,:,qqq),1,m1*m2);
           CNR_SubL_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_SubL_matrix0;
           end % (:,:,:) >> (1,:)
           %%% 0 cut
           CNR_NL_matrix(find(CNR_NL_matrix==0))=[];
           CNR_SubL_matrix(find(CNR_SubL_matrix==0))=[];
           %%% combine NL SubL
           CNR_NL_SubL=[CNR_NL_matrix CNR_SubL_matrix];
           %%%% STD Left
           CNR_NL_SubL_STD=std(CNR_NL_SubL);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            CNR_N2Sub_L=CNR_NL_mean/CNR_SubL_mean;
%            CNR_N2Sub_L_p=(CNR_NL_mean-CNR_SubL_mean)*100/CNR_SubL_mean;
           %%%% Correct CNR (mean/std)
           CNR_N2Sub_L=(CNR_NL_mean-CNR_SubL_mean)/CNR_NL_SubL_STD;
           CNR_N2Sub_L_p=(CNR_NL_mean-CNR_SubL_mean)*100/CNR_NL_SubL_STD;
 
           %right    
        CNR_NR_mean=(sum(sum(sum(T2_NR)))/sum(sum(sum(masknigrosomeR))));
        CNR_SubR_mean=(sum(sum(sum(T2_SubR)))/sum(sum(sum(masksubstantianigraR))));
        %%%% STD preparation  (Pure img_ave_NL (without 0) %%%%%%%%%%%%%%%%%
        CNR_NR_matrix0=zeros(1,m1*m2);    CNR_NR_matrix=zeros(1,m1*m2*m3);
        CNR_SubR_matrix0=zeros(1,m1*m2);    CNR_SubR_matrix=zeros(1,m1*m2*m3);
        for qqq=1:m3
            CNR_NR_matrix0=reshape(T2_NR(:,:,qqq),1,m1*m2);
            CNR_NR_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_NR_matrix0;
            CNR_SubR_matrix0=reshape(T2_SubR(:,:,qqq),1,m1*m2);
            CNR_SubR_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_SubR_matrix0;
         end% (:,:,:) >> (1,:) 
        %%% 0 cut
        CNR_NR_matrix(find(CNR_NR_matrix==0))=[];
        CNR_SubR_matrix(find(CNR_SubR_matrix==0))=[];
        %%% combine NR SubR
        CNR_NR_SubR=[CNR_NR_matrix CNR_SubR_matrix];
        %%%% STD Right
        CNR_NR_SubR_STD=std(CNR_NR_SubR);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Correct CNR (mean/std)
        CNR_N2Sub_R=(CNR_NR_mean-CNR_SubR_mean)/CNR_NR_SubR_STD;
        CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_NR_SubR_STD;

%            CNR_N2Sub_R=CNR_NR_mean/CNR_SubR_mean;
%            CNR_N2Sub_R_p=(CNR_NR_mean-CNR_SubR_mean)*100/CNR_SubR_mean;
           
           CNR_matrix0(ss,:)=[CNR_N2Sub_L CNR_N2Sub_R CNR_N2Sub_L_p CNR_N2Sub_R_p];
%           CNR_matrix0
           
           
    end
end
cd(pathnameD)
save CNR_matrix0 CNR_matrix0
CNR_table=array2table(CNR_matrix0);
writetable(CNR_table,'CNR_SubjectsT2.xlsx')


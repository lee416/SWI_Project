clear all; clc;
m_dir=(pwd);

Subjects=[201:214 217:223 801];
% Subjects=[201];
Scan_num=[1];
num_of_MRI=6; %types we got
num_of_CNR=4;
total_of_CNR=num_of_MRI*num_of_CNR;
CNR_Data=zeros(size(Subjects,2),total_of_CNR);

pathname_1='E:\SwallowTail_Project\Subjects_inIMA';

% ss=1;ssq=1;
for ss=1: size(Subjects,2)
    if Subjects(ss)<10
        pathname=strcat(pathname_1,'\Sub_00',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');
        elseif Subjects(ss)<=99&Subjects(ss)>=10
        pathname=strcat(pathname_1,'\Sub_0',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');
        else 
        pathname=strcat(pathname_1,'\Sub_',int2str(Subjects(ss)),'\Scan1\SWI\MatData_All');
    end
% load
    cd(pathname);     
    load SWI_img_ave_Mat
    load mag_img_ave_Mat
    load unwrapped_phase_img_ave_Mat
    load SWI_img_Mat 
    load mag_img_Mat 
    load unwrapped_phase_img_Mat
    
    load masknigrosomeL
    load masknigrosomeR
    load masksubstantianigraL 
    load masksubstantianigraR 
    matrix_1=SWI_img_ave_Mat;                           %%% 1=SWI_img_ave_Mat
    matrix_2=mag_img_ave_Mat;                           %%% 2=mag_img_ave_Mat
    matrix_3=unwrapped_phase_img_ave_Mat;               %%% 3=unwrapped_phase_img_ave_Mat
    matrix_4=SWI_img_Mat(:,:,:,4);% 4= 4th echo         %%% 4=SWI_img_Mat
    matrix_5=mag_img_Mat(:,:,:,4);                      %%% 5=mag_img_Mat
    matrix_6=unwrapped_phase_img_Mat(:,:,:,4);          %%% 6=unwrapped_phase_img_Mat
    Big_matrix=cat(4,matrix_1,matrix_2,matrix_3,matrix_4,matrix_5,matrix_6);
    mask=cat(4,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR);
    
    CNR_matrix0=zeros(1,total_of_CNR);
    for qq=1:num_of_MRI
    img_ave_NL= Big_matrix(:,:,:,qq).*mask(:,:,:,1);
    img_ave_NR= Big_matrix(:,:,:,qq).*mask(:,:,:,2);
    img_ave_SubL= Big_matrix(:,:,:,qq).*mask(:,:,:,3);
    img_ave_SubR= Big_matrix(:,:,:,qq).*mask(:,:,:,4); 
    m1=size(img_ave_NL,1); % 408
    m2=size(img_ave_NL,2); % 416
    m3=size(img_ave_NL,3); % 60
    %left    
        CNR_NL_mean=(sum(sum(sum(img_ave_NL)))/sum(sum(sum(masknigrosomeL))));
        CNR_SubL_mean=(sum(sum(sum(img_ave_SubL)))/sum(sum(sum(masksubstantianigraL))));
        %%%% Pure img_ave_NL (without 0) %%%%%%%%%%%%%%%%%
        CNR_NL_matrix0=zeros(1,m1*m2);    CNR_NL_matrix=zeros(1,m1*m2*m3);
        CNR_SubL_matrix0=zeros(1,m1*m2);    CNR_SubL_matrix=zeros(1,m1*m2*m3);
        for qqq=1:m3
        CNR_NL_matrix0=reshape(img_ave_NL(:,:,qqq),1,m1*m2);
        CNR_NL_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_NL_matrix0;
        CNR_SubL_matrix0=reshape(img_ave_SubL(:,:,qqq),1,m1*m2);
        CNR_SubL_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_SubL_matrix0;
        end
        %%% 0 cut
        CNR_NL_matrix(find(CNR_NL_matrix==0))=[];
        CNR_SubL_matrix(find(CNR_SubL_matrix==0))=[];
        %%% combine NL SubL
        CNR_NL_SubL=[CNR_NL_matrix CNR_SubL_matrix];
        %%%% STD Left
        CNR_NL_SubL_STD=std(CNR_NL_SubL);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Correct CNR (mean/std)
        CNR_N2Sub_L=(CNR_NL_mean-CNR_SubL_mean)/CNR_NL_SubL_STD;
        CNR_N2Sub_L_p=(CNR_NL_mean-CNR_SubL_mean)*100/CNR_NL_SubL_STD;

    %right    
        CNR_NR_mean=(sum(sum(sum(img_ave_NR)))/sum(sum(sum(masknigrosomeR))));
        CNR_SubR_mean=(sum(sum(sum(img_ave_SubR)))/sum(sum(sum(masksubstantianigraR))));
        %%%% Pure img_ave_NL (without 0) %%%%%%%%%%%%%%%%%
        CNR_NR_matrix0=zeros(1,m1*m2);    CNR_NR_matrix=zeros(1,m1*m2*m3);
        CNR_SubR_matrix0=zeros(1,m1*m2);    CNR_SubR_matrix=zeros(1,m1*m2*m3);
    for qqq=1:m3
        CNR_NR_matrix0=reshape(img_ave_NR(:,:,qqq),1,m1*m2);
        CNR_NR_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_NR_matrix0;
        CNR_SubR_matrix0=reshape(img_ave_SubR(:,:,qqq),1,m1*m2);
        CNR_SubR_matrix(1,1+m1*m2*(qqq-1):m1*m2*qqq)=CNR_SubR_matrix0;
    end
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
    CNR_matrix0(1,(num_of_CNR*qq-3):num_of_CNR*qq)=[CNR_N2Sub_L CNR_N2Sub_L_p CNR_N2Sub_R CNR_N2Sub_R_p];
    end
    
%     CNR_matrix0
    CNR_Data(ss,:)=[CNR_matrix0];
    CNR_Data

end
CNR_table=array2table(CNR_Data);
cd(m_dir)
writetable(CNR_table,'CNR_SubjectsNEW.xlsx')
    
    
    

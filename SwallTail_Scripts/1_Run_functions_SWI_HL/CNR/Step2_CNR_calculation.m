% cd(saveMatDir_Final)
% cd('G:\Subjects\Sub_001\Scan1\SWI_Data\MatData_All');
cd('E:\SwallowTail_Project\Subjects_inIMA\Sub_201\Scan1\SWI\MatData_All')
m_dir=(pwd);

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
matrix_4=SWI_img_Mat(:,:,:,4);                      %%% 4=SWI_img_Mat
matrix_5=mag_img_Mat(:,:,:,4);                      %%% 5=mag_img_Mat
matrix_6=unwrapped_phase_img_Mat(:,:,:,4);          %%% 6=unwrapped_phase_img_Mat

Big_matrix=cat(4,matrix_1,matrix_2,matrix_3,matrix_4,matrix_5,matrix_6);
mask=cat(4,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR);
% % % 1=masknigrosomeL
% % % 2=masknigrosomeR
% % % 3=masksubstantianigraL
% % % 4=masksubstantianigraR

Subjects=[1];
Scan_num=[1];
echo_display=[4];
display_slice=[35];

Title='Please input num of MRI types & CNR types';
Prompt={'num of MRI types','num of CNR types'};
LineNo=1;
DefAns={'6','4'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
num_of_MRI=str2num(answer{1});
num_of_CNR=str2num(answer{2});
total_of_CNR=num_of_MRI*num_of_CNR;

CNR_Data=zeros(size(Subjects,2),total_of_CNR);

% cd('G:\1_Run_functions_SWI')
cd('E:\SwallowTail_Project\Subjects_inIMA\Sub_201')
[CNR_matrix0]=fun_CNR_calculation(Big_matrix,mask,masknigrosomeL,masknigrosomeR,masksubstantianigraL,masksubstantianigraR,num_of_MRI,num_of_CNR,total_of_CNR);
CNR_Data(size(Subjects,2),:)=[CNR_matrix0];
CNR_Data(size(Subjects,2),:)=[CNR_matrix0]



% pathname_1='G:\Subjects'
% 
% for ss=1: size(Subjects,2)
%   for ssq=1:size(Scan_num,2)
%       if Subjects(ss)<10
%     pathname=strcat(pathname_1,'\','Sub_00',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI_Data');
%    elseif Subjects(ss)<=99&Subjects(ss)>=10
%     pathname=strcat(pathname_1,'\','Sub_0',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI_Data');
%    else 
%     pathname=strcat(pathname_1,'\','Sub_',int2str(Subjects(ss)),'\Scan',int2str(Scan_num(ssq)),'\SWI_Data');
%   end
%    [CNR_matrix0]=fun_CNR_calculation(num_of_MRI,num_of_CNR,total_of_CNR);
%    CNR_Data(ss,:)=[CNR_matrix0];
% end
 
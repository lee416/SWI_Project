clc;clear all;
Subjects=[201:214 217:223 801];

savedir='D:\SwallowTail_Project\SwallTail_Scripts\2_Excel';
pathname_D0='D:\SwallowTail_Project\Result';
%%%%%%%%%%%%%%%%%% 215 216 not yet
Num_Subjects=size(Subjects,2);
num_of_MRI=6;
num_of_CNR=4;
total_of_CNR=num_of_MRI*num_of_CNR;

CNR_Subjects=zeros(Num_Subjects,total_of_CNR);
size(CNR_Subjects)


% ss=1;ssq=1;
% pathname_D=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)));

for ss=1:size(Subjects,2)
        if Subjects(ss)<10
        pathname_D=strcat(pathname_D0,'\Sub_00',int2str(Subjects(ss)));
        elseif Subjects(ss)<=99&Subjects(ss)>=10
        pathname_D=strcat(pathname_D0,'\Sub_0',int2str(Subjects(ss)));
        else 
        pathname_D=strcat(pathname_D0,'\Sub_',int2str(Subjects(ss)));
        end
cd(pathname_D)
load CNR_Data
CNR_matrix0=CNR_Data;
CNR_Subjects(ss,:)=[...
    CNR_matrix0(1) CNR_matrix0(3) CNR_matrix0(2) CNR_matrix0(4) ...
    CNR_matrix0(5) CNR_matrix0(7) CNR_matrix0(6) CNR_matrix0(8) ...
    CNR_matrix0(9) CNR_matrix0(11) CNR_matrix0(10) CNR_matrix0(12) ...
    CNR_matrix0(13) CNR_matrix0(15) CNR_matrix0(14) CNR_matrix0(16) ...
    CNR_matrix0(17) CNR_matrix0(19) CNR_matrix0(18) CNR_matrix0(20) ...
    CNR_matrix0(21) CNR_matrix0(23) CNR_matrix0(22) CNR_matrix0(24)]
%%%%%%%%%%%%%%%%%% L %%%%%%%%%%%% L %%%%%%%%%%%%% R %%%%%%%%%%% R %%%%%%%%%
% CNR_swi_ave=[CNR_matrix0(1) CNR_matrix0(3) CNR_matrix0(2) CNR_matrix0(4)];
% CNR_mag_ave=[CNR_matrix0(5) CNR_matrix0(7) CNR_matrix0(6) CNR_matrix0(8)];
% CNR_unwrapped_phase_ave=[CNR_matrix0(9) CNR_matrix0(11) CNR_matrix0(10) CNR_matrix0(12)];
% CNR_SWI=[CNR_matrix0(13) CNR_matrix0(15) CNR_matrix0(14) CNR_matrix0(16)];
% CNR_mag=[CNR_matrix0(17) CNR_matrix0(19) CNR_matrix0(18) CNR_matrix0(20)];
% CNR_unwrapped_phase= [CNR_matrix0(21) CNR_matrix0(23) CNR_matrix0(22) CNR_matrix0(24)];

table_Subject0{ss}={strcat('Sub_',int2str(Subjects(ss)))};
end
table_Subject=table_Subject0';

cd(savedir)
CNR_Subjects_table=array2table(CNR_Subjects);
writetable(CNR_Subjects_table,'CNR_Subjects1.xlsx')
% DHA_data_4Stat_table = array2table(DHA_data_4Stat); %% array >> table
% writetable(DHA_data_4Stat_table,'DHA_data_4Stat.xlsx'); %% save a new table as 'DHA_data_4Stat.xlsx'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% variable name settng
varname00= {...
    'L_CNR_swi_ave','L_CNR_swi_ave_percent','R_CNR_swi_ave','R_CNR_swi_ave_percent',...
    'L_CNR_SWI','L_CNR_SWI_percent','R_CNR_SWI','R_CNR_SWI_percent'...
    'L_CNR_mag_ave','L_CNR_mag_ave_percent','R_CNR_mag_ave','R_CNR_mag_ave_percent'...
    'L_CNR_mag','L_CNR_mag_percent','R_CNR_mag','R_CNR_mag_percent'...
    'L_CNR_unwrapped_phase_ave','L_CNR_unwrapped_phase_ave_percent','R_CNR_unwrapped_phase_ave','R_CNR_unwrapped_phase_ave_percent'...
    'L_CNR_unwrapped_phase','L_CNR_unwrapped_phase_percent','R_CNR_unwrapped_phase','R_CNR_unwrapped_phase_percent'};

varname = num2cell(zeros(Num_Subjects,total_of_CNR)); 

% varname = num2cell(zeros(Num_DHA_Var,Num_DHA_Ratio)); % num2cell cell>> number
%%%% cellstr = create cell array of strings from character array
% for qqr= 1:Num_Subjects %% 4
%     for qq= 1:total_of_CNR %% 14
%     varname{qqr,qq}=cellstr(strcat(varname00{qq}));
%     end
% end
% varname= reshape(varname,1,total_of_CNR); % reshpe 'varname' array to '1'*'Num_DHA_Var*Num_DHA_Ratio'

%%%% find max string_number of cell 
% size(varname_HL{1,5}{1,1},2) open{cell} in {1,5} in {1,1}
% cell_size=zeros(1,size(varname,2)); 
%  
% for css=1:size(varname,2)  
%     cell_size(1,css)=size(varname{1,css}{1,1},2); 
% end
% max_cell_size=max(cell_size);
% 
% %%%% create a zeros array 56(names)* 30(longest_name_num)
% varname_str=char(zeros(total_of_CNR,max_cell_size)); % char >>convert to character array(or it willl be numbers)
% for ppr=1:Num_DHA_Var*Num_DHA_Ratio  
%     varname_str(ppr,1:(size(char(varname{ppr}),2)))=char(varname{ppr}); 
% end 
%  





















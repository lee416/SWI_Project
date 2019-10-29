clc;clear all;
Num_Subjects=51;
Num_DHA_Var=14;
Num_DHA_Ratio=4;

% read excel files as a table in matlab
DHA_data0 = readtable('Matlab_Data_1128_2018.xlsx','Sheet',1,'Range','D2:G716');
DHA_data = table2array(DHA_data0);
% DHA_data = DHA_data{:,:}; %% extract data from table

% reorganize the order of matrix

DHA_data_4Stat=zeros(Num_Subjects,Num_DHA_Var*Num_DHA_Ratio);

for ss= 1:Num_Subjects
    tempdata = DHA_data((Num_DHA_Var*(ss-1)+1):Num_DHA_Var*ss,:);
    DHA_data_4Stat(ss,:) = reshape(tempdata(1:end), 1, Num_DHA_Var*Num_DHA_Ratio); 
end

DHA_data_4Stat_table = array2table(DHA_data_4Stat); %% array >> table
% writetable(DHA_data_4Stat_table,'DHA_data_4Stat.xlsx'); %% save a new table as 'DHA_data_4Stat.xlsx'

%%%% variable name settng
varname0 = {'mwanNWM_', 'maxNWM_', 'medianNWM_', 'stdNWM_'};
varname1 = {...
'c_lesion_5th',...
'c_lesion_25th',...
'c_lesion_50th',...
'c_lesion_75th',...
'c_lesion_100th',...
'mean_dynHis_lesion',... 
'median_dynHis_lesion',...
'SD_dynHis_lesion',... 
'Peak_Height_lesion',...
'Mode_lesion',...
'Kurtosis_K_lesion', ... 
'Kurtosis_Kh_lesion',...
'Skew_K_lesion',...
'Skew_Kh_lesion'}; 

%%%% cellstr = create cell array of strings from character array
varname = num2cell(zeros(Num_DHA_Var,Num_DHA_Ratio)); % num2cell cell>> number

for qqr= 1:Num_DHA_Ratio %% 4
    for qq= 1:Num_DHA_Var %% 14
    varname{qq,qqr}=cellstr(strcat(varname0{qqr},varname1{qq})); % combine varname0 + varname1
    end
end
varname= reshape(varname,1,Num_DHA_Var*Num_DHA_Ratio); % reshpe 'varname' array to '1'*'Num_DHA_Var*Num_DHA_Ratio'

%%%% find max string_number of cell 
% size(varname_HL{1,5}{1,1},2) open{cell} in {1,5} in {1,1}
cell_size=zeros(1,size(varname,2)); 
 
for css=1:size(varname,2)  
    cell_size(1,css)=size(varname{1,css}{1,1},2); 
end
max_cell_size=max(cell_size);

%%%% create a zeros array 56(names)* 30(longest_name_num)
varname_str=char(zeros(Num_DHA_Ratio*Num_DHA_Var,max_cell_size)); % char >>convert to character array(or it willl be numbers)
for ppr=1:Num_DHA_Var*Num_DHA_Ratio  
    varname_str(ppr,1:(size(char(varname{ppr}),2)))=char(varname{ppr}); 
end 
 




















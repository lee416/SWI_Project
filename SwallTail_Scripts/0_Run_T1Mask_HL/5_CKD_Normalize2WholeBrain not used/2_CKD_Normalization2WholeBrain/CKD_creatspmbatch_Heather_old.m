Subjects=[7 142 146	154	177 179	188	194	195	198	201	202	218	225	242	243	244	258	264	320	329	330 101 103 112 118 153 204 216 217 227 331 204 206]; %% the last two, s204, s206 are CKD control%
globalCBF=[	66.6641	51.2885	45.0783	43.3038	62.6296	51.8617	69.7871	48.4332	48.2323	65.6035	54.8517	71.2917	66.6591	57.0791	47.5183	73.8139	54.5534	58.0549	53.7024	63.9984	56.6915	51.5349	56.6446	65.1566	87.9065	48.7334	50.7454	64.1333	44.6733	43.5398	39.7908	57.6617	32.377	65.5456	];

save globalCBF globalCBF

pathname_1='/Volumes/Untitled/Autism_Data/wmeanCBF_rpcasl';
%load('globalCBF.mat');
CBF_all=zeros(size(Subjects,2),3);

%------------- this is for Autism and controls -------------------%
for ss=1:size(Subjects,2)-2%% the last two s0204, s0206 are CKD controls
    if Subjects(ss)<10
     filename_data=strcat(pathname_1,'/','R','000',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     filename_data=strcat(pathname_1,'/','R','00',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
    else 
    filename_data=strcat(pathname_1,'/','R','0',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
    end  
 %--- Load Autism_Normalize_batch_Sample.mat to see the format and index to be edited in the following matlabbatch ---%  
 matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
 matlabbatch{1,ss}.spm.util.imcalc.output=strcat('R',int2str(Subjects(ss)),'_Norm.img');
 matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_1};
 matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1/',num2str(globalCBF(ss)));
end

%--------- this is for CKD controls -------------------------%
for ss=(size(Subjects,2)-1):size(Subjects,2) %% the last two s0204, s0206 are CKD controls
    if Subjects(ss)<10
     filename_data=strcat(pathname_1,'/','s','000',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     filename_data=strcat(pathname_1,'/','s','00',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
    else 
    filename_data=strcat(pathname_1,'/','s','0',int2str(Subjects(ss)),'_wmeanCBF_0_rpcasl_rest078.img');
    end  
 %--- Load Autism_Normalize_batch_Sample.mat to see the format and index to be edited in the following matlabbatch ---%  
 matlabbatch{1,ss}.spm.util.imcalc.input={filename_data};
 matlabbatch{1,ss}.spm.util.imcalc.output=strcat('s',int2str(Subjects(ss)),'_Norm.img');
 matlabbatch{1,ss}.spm.util.imcalc.outdir={pathname_1};
 matlabbatch{1,ss}.spm.util.imcalc.expression=strcat('i1/',num2str(globalCBF(ss)));
end

save(['Autism_Normalization2WholeBrain.mat'],'matlabbatch');

%--- run saved batch without spmGUI ---%
% spm_jobman('run',matlabbatch);

%Subjects=[7 142 146	154	177 179	188	194	195	198	201	202	218	225	242	243	244	258	264	320	329	330 101 103 112 118 153 204 216 217 227 331 204 206]; %% the last two, s204, s206 are CKD control%
Subjects=[341 343 345 346 347 349 350 352 353 355 356 357 358 360 361 363 364];

pathname_1='/Volumes/Untitled/Autism_Data/Subjects';

%------------- this is for Autism and controls -------------------%
for ss=1:size(Subjects,2)
     h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(ss))));
    if Subjects(ss)<10
     pathname_pcasl=strcat(pathname_1,'/','R','000',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','R','000',int2str(Subjects(ss)),'/anat_anlz/');
     filename_data_1=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.hdr');
     %filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname_pcasl=strcat(pathname_1,'/','R','00',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','R','00',int2str(Subjects(ss)),'/anat_anlz/');
     filename_data_1=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.hdr');
     %filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
    else 
     pathname_pcasl=strcat(pathname_1,'/','R','0',int2str(Subjects(ss)),'/pcasl_rest/');
     pathname_anat=strcat(pathname_1,'/','R','0',int2str(Subjects(ss)),'/anat_anlz/');
     filename_data_1=strcat(pathname_pcasl,'wMasked_Thresholded_rpcasl_CBF_R',int2str(Subjects(ss)),'.hdr');
     %filename_data_2=strcat(pathname_anat,'ranat_anlz_seg_sn.mat');
    end
    
    delete(filename_data_1);
    close(h)
    
%     %--- Load Autism_rT1Mask_batch_Sample_Step1.mat to see the format and index to be edited in the following matlabbatch ---%
%     matlabbatch{1,ss}.spm.spatial.normalise.write.subj.matname={filename_data_2};
%     matlabbatch{1,ss}.spm.spatial.normalise.write.subj.resample={filename_data_1};
end



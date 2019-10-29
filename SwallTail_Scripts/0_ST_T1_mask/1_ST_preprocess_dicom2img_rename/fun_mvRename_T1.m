%%%%% for "1_Run_dicom2img_FromRawData_T1"

function fun_mvRename_T1(mfile_dir,pathnameT1,pathname_D,pathnameSWI,pathname_SWI0,echo)
% script_dir=pwd;
 cd(mfile_dir)
 % cd('E:\SwallowTail_Project\SwallTail_Scripts\0_Run_T1Mask\1_ST_preprocess_dicom2img_rename\T1WI\Charles')
% [new_filename_T1]=fun_filenaming_T1(pathname_D);
% 
% cd(pathnameT1)
% clear files
% files(1,:) = spm_select('list', pathnameT1, '\.hdr');
% files(2,:) = spm_select('list', pathnameT1, '\.img');
% %%%% files(:,:) space needed
% 
%    for ii=1:size(new_filename_T1,1)
%    movefile(files(ii,:),new_filename_T1(ii,:),'f');
% %  copyfile(files(ii,:),new_filename_T1(ii,:),'f');
%    end

%%%%%  SWI selection & remove  %%%%%%%%%%%%%%%%%%%%%%%%%%%
[new_filename_SWI]=fun_filenaming_SWI(pathname_SWI0,echo);
% pathnameSWI(1,:) >> mag
% pathnameSWI(2,:) >> phase
% this Scan have 7,8 echo T2* == echo
% cd(pathnameSWI0)
% delete *.img
% delete *.hdr

cd(pathnameSWI(1,:))
clear files
files(1:echo,:) = spm_select('list', pathnameSWI(1,:), '\.hdr');
files(1+echo:2*echo,:) = spm_select('list', pathnameSWI(1,:), '\.img');

   for ii=1:size(files,1)
%    movefile(files(ii,:),new_filename_SWI(ii,:),'f');
   copyfile(files(ii,:),new_filename_SWI(ii,:),'f');
   end

cd(pathnameSWI(2,:))
clear files
files(1:echo,:) = spm_select('list', pathnameSWI(2,:), '\.hdr');
files(1+echo:2*echo,:) = spm_select('list', pathnameSWI(2,:), '\.img');

   for ii=1:size(files,1)
%    movefile(files(ii,:),new_filename_SWI(2*echo+ii,:),'f');
   copyfile(files(ii,:),new_filename_SWI(ii,:),'f');
   end
   
 cd(mfile_dir)





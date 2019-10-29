function spm_write_GM_mask(GM_mask,vol_GM,pathname_anat)

script_path=pwd;
 
% if (nargin < 1)
%     [fname,sts] = spm_select;
%     if (sts == 0)
%         fprintf('abk_4Dto3D: Operation cancelled.\n');
%         return;
%     end
% end
 

img=GM_mask;
sz = size(img);
tvol = vol_GM(1);
tvol = rmfield(tvol,'private');
tvol.descrip = 'generated by spm_write_GM_mask.m';
tvol.fname = sprintf('GM_mask_beforeErode.img');

cd(pathname_anat)

spm_write_vol(tvol,img);

cd(script_path);

%/Volumes/Untitled/CKD_data/CKD_SPM_Scripts/5_CKD_Normalize2WholeBrain/1_CKD_globalCBF_calculation

%%%%%%%%%% original spm_write example from abk_4Dto3D %%%%%%%%%%%%%

%function abk_4Dto3D(fname)

% 
% % function abk_4Dto3D(fname)
% %
% % Splits a 4D nifti file into a series of 3D nifti files.
% % Needs SPM functions to work. If input file is fdata.nii,
% % the output files will have filenames like fdata_001.nii,
% % fdata_002.nii, etc.
%  
% if (nargin < 1)
%     [fname,sts] = spm_select;
%     if (sts == 0)
%         fprintf('abk_4Dto3D: Operation cancelled.\n');
%         return;
%     end
% end
%  
% vol = spm_vol(fname);
% img = spm_read_vols(vol);
% sz = size(img);
%  
% tvol = vol(1);
% tvol = rmfield(tvol,'private');
% tvol.descrip = 'generated by abk_4Dto3D.m';
%  
% [dn,fn,ext] = fileparts(fname);
%  
% for ctr=1:sz(4)
%     tvol.fname = sprintf('%s%s%s_%.3d%s',dn,filesep,fn,ctr,ext);
%     fprintf('Writing %s\n',tvol.fname);
%     spm_write_vol(tvol,img(:,:,:,ctr));
% end
% fprintf('done.\n');
% end
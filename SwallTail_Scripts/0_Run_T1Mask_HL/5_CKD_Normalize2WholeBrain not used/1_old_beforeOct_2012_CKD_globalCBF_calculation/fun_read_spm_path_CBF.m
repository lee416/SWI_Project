function [tmp_data]=fun_read_spm_path_CBF(pathname)

filename_data=strcat('meanCBF_0_rpcasl_rest078','.img'); 
spmImg.InputFullpath =strcat(pathname,filename_data);
tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));

% pathname=pathname(1:45);
% pathname=strcat(pathname,'/','pcasl_rest');
% cd(pathname);
% [spmImg.InputFilename , spmImg.InputPathname ] = ...
%  uigetfile('wmeanCBF_0_rpcasl_rest078.img', 'CBF Image File');
% 
% pathname=spmImg.InputPathname;
% 
% % [filename,pathname] = uigetfile();
% % filename=strcat(spmImg.InputPathname,spmImg.InputFilename);
% % fid=fopen([filename],'r');
% % a=fread(fid,'int32');
% 
% % Make sure the user did not hit cancel
% if(~ischar(spmImg.InputFilename)),
%     tmp_tipMsg1 = sprintf('You must select an input file!!!\n\n');
%     tmp_tipMsg2 = sprintf('%sClick OK and Select an input file.',...
%         tmp_tipMsg1);
%     tmp_tip = msgbox(tmp_tipMsg2,'Error!','error');
%     uiwait(tmp_tip);       
%     return;
% end
% spmImg.InputFullpath = ...
%     [spmImg.InputPathname,spmImg.InputFilename];
% 
% tmp_data = spm_read_vols(spm_vol(spmImg.InputFullpath));

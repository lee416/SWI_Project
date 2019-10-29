function [Filename]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size)
%function [tmp_data]=fun_read_spm_rpcasl_CKD(Average_2N,slicenumber,pathname,Matrix_size)

% [spmImg.InputFilename , spmImg.InputPathname ] = ...
%  uigetfile('*.img', 'Select Motion-Corrected Image File');

%pathname=pathname_pcasl;

% % Make sure the user did not hit cancel
% if(~ischar(spmImg.InputFilename)),
%     tmp_tipMsg1 = sprintf('You must select an input file!!!\n\n');
%     tmp_tipMsg2 = sprintf('%sClick OK and Select an input file.',...
%         tmp_tipMsg1);
%     tmp_tip = msgbox(tmp_tipMsg2,'Error!','error');
%     uiwait(tmp_tip);       
%     return;
% end

%h = waitbar(0,'Please wait... separation is processing...'); 
tmp_data=zeros(Matrix_size,Matrix_size,slicenumber,Average_2N);

for s=1:Average_2N
    %waitbar(s/40);
    if (s-1)<=9  
    filename_data=strcat('rpcasl_rest0',int2str(0),int2str((s-1)),'.img');
    %spmImg.InputFilename=strcat('rpcasl_rest0',int2str(0),int2str((s-1)),'.img');
    %spmImg.InputFilename=strcat('pcasl_rest0',int2str(0),int2str((s-1)),'.img');
    else 
    filename_data=strcat('rpcasl_rest0',int2str((s-1)),'.img'); 
    %spmImg.InputFilename=strcat('rpcasl_rest0',int2str((s-1)),'.img'); 
    %spmImg.InputFilename=strcat('pcasl_rest0',int2str((s-1)),'.img'); 
    end
    %spmImg.InputFullpath = ...
    %[spmImg.InputPathname,spmImg.InputFilename];
    spmImg.InputFullpath =strcat(pathname,filename_data);
    Filename(s,:)=spmImg.InputFullpath;
    %tmp_data(:,:,:,s) = spm_read_vols(spm_vol(spmImg.InputFullpath));
end
%close(h)


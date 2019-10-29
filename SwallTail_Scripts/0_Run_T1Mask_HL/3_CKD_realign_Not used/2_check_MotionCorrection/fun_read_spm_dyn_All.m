function [tmp_data, pathname]=fun_read_spm_dyn_All(Average_2N,slicenumber)

[spmImg.InputFilename , spmImg.InputPathname ] = ...
 uigetfile('*.img', 'Select Motion-Corrected Image File');

pathname=spmImg.InputPathname;

% Make sure the user did not hit cancel
if(~ischar(spmImg.InputFilename)),
    tmp_tipMsg1 = sprintf('You must select an input file!!!\n\n');
    tmp_tipMsg2 = sprintf('%sClick OK and Select an input file.',...
        tmp_tipMsg1);
    tmp_tip = msgbox(tmp_tipMsg2,'Error!','error');
    uiwait(tmp_tip);       
    return;
end

%h = waitbar(0,'Please wait... separation is processing...'); 
tmp_data=zeros(64,64,slicenumber,Average_2N);

for s=1:Average_2N
    %waitbar(s/40);
    if (s-1)<=9  
    spmImg.InputFilename=strcat('rpcasl_rest0',int2str(0),int2str((s-1)),'.img');
    %spmImg.InputFilename=strcat('pcasl_rest0',int2str(0),int2str((s-1)),'.img');
    else    
    spmImg.InputFilename=strcat('rpcasl_rest0',int2str((s-1)),'.img'); 
    %spmImg.InputFilename=strcat('pcasl_rest0',int2str((s-1)),'.img'); 
    end
    spmImg.InputFullpath = ...
    [spmImg.InputPathname,spmImg.InputFilename];
    tmp_data(:,:,:,s) = spm_read_vols(spm_vol(spmImg.InputFullpath));
end
%close(h)


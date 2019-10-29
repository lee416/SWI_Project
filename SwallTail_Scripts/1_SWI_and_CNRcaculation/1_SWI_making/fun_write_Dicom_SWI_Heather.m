function fun_write_Dicom_SWI_Heather(Data_dir,matrix_size,TE,SWI_img)

%   Last modified by Alexey Dimov on 2016.05.13
dicomDir=Data_dir;

% function y = write_QSM_dir(QSM,dicomDir,saveDir) % Heather, comment out
warning( 'off', 'all' );

% if ~exist('qsm_DICOM','dir')
%     mkdir('qsm_DICOM')
% end

% %%% start, comment out, Heather
% QSM_Phase = permute(iFreq,[2,1,3]); %change row/column order due to differences in representations in DICOM and Matlab
% QSM_Phase1 = int16(QSM_Phase*1000);
% %%% end, comment out, Heather

SWI_IMG= permute(SWI_img,[2,1,3,4]); %change row/column order due to differences in representations in DICOM and Matlab
SWI_IMG1 = int16(SWI_IMG*1);

% %%% added, Heather
% for sss=1:size(QSM_Phase1,3)
%  QSM_Phase1_1(:,:,sss)=(QSM_Phase1(:,:,sss)');
% end

filelist = dir(dicomDir);
i=1;
while i<=length(filelist)
    if filelist(i).isdir==1
        filelist = filelist([1:i-1 i+1:end]);   % eliminate folders
    else
        i=i+1;
    end
end

sliceNum = size(SWI_IMG1,3);
echoNum=size(SWI_IMG1,4); %%% Added, Heather
% sliceIdx = 0;%% Heather, comment out
% echoIdx=0; %%% added, Heather
% imIdx = 1;%% Heather, comment out
% UID = dicomuid;%% Heather, comment out
%saveDir = [saveDir '/' 'QSM_Phase']; %% Heather, comment out
saveDir=Data_dir; %% Heather, added
cd(saveDir);%% Heather, added
% mkdir(saveDir); %% Heather, commnet out
mkdir('SWI_IMG_Results'); %% Heather, added
saveDir_Final=strcat(saveDir,'\SWI_IMG_Results');%% Heather, added

for echoIdx=1:echoNum;
% for echoIdx=1:2;
  %%%% start, added, Heather
   cd(saveDir_Final);%% Heather, added
   mkdir(strcat('Echo_',num2str(echoIdx))); %% Heather, added
   saveDir_Final_Echo=strcat(saveDir_Final,'\','Echo_',num2str(echoIdx));%% Heather, added
   sliceIdx = 0;
   imIdx = 1;
   UID = dicomuid;
   %%%% end, added, Heather
 while sliceIdx < sliceNum
    fid = fopen([dicomDir '/' filelist(imIdx).name]);
    if fid>0
        sliceIdx=sliceIdx + 1;
        fclose(fid);
        info = dicominfo([dicomDir '/' filelist(imIdx).name]);
        %--
        info.SeriesDescription = 'SWI IMG';
        info.SeriesInstanceUID = UID;
        info.SeriesNumber = 99;
%         info.EchoNumber = 1; %% Heather, comment out
%         info.EchoTime = 0.0; %% Heather, comment out
        info.EchoNumber = echoIdx; %% added, Heather
        info.EchoTime = TE(echoIdx); %% added, Heather
        info.InstanceNumber = sliceIdx;
%     dicomwrite(QSM_Phase1(:,:,sliceIdx),[saveDir '/' num2str(sliceIdx) '.dcm'], info); %% Heahter, comment out
        dicomwrite(SWI_IMG1(:,:,sliceIdx,echoIdx),[saveDir_Final_Echo '/' num2str(sliceIdx) '-' num2str(echoIdx) '.dcm'], info); 
    end
    imIdx = imIdx + 1;
 end
end

% %%%%%%%%%%%%%
% while sliceIdx < sliceNum
%     fid = fopen([dicomDir '/' filelist(imIdx).name]);
%     if fid>0
%         sliceIdx=sliceIdx + 1;
%         fclose(fid);
%         info = dicominfo([dicomDir '/' filelist(imIdx).name]);
%         %--
%         info.SeriesDescription = 'Unwrapped Phase recon';
%         info.SeriesInstanceUID = UID;
%         info.SeriesNumber = 99;
%         info.EchoNumber = 1;
%         info.EchoTime = 0.0;
%         info.InstanceNumber = sliceIdx;
%         %--
% %         dicomwrite(QSM_Phase1(:,:,sliceIdx),[saveDir '/' num2str(sliceIdx) '.dcm'], info); %% Heahter, comment out
%         dicomwrite(Unwrapped_Phase(:,:,sliceIdx),[saveDir_Final '/' num2str(sliceIdx) '.dcm'], info);  %% Heather, added
% %         dicomwrite(QSM_Phase1_1(:,:,sliceIdx),[saveDir_Final '/' num2str(sliceIdx) '.dcm'], info);  %% Heather, added
%     end
%     imIdx = imIdx + 1;
% end
% %%%%%%%%%%%%%%%%%%

% addpath(saveDir); %% Heather, comment out
% addpath(saveDir_Final); %% Heather, added

warning( 'on', 'all' )

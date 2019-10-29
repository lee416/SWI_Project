function fun_realign_asl_Heather(Filename)
%you can do it in the batch mode using the batch_realign.m
% get the images. Make sure you have addpath for spm5 or 8
%P=spm_select(); %original from Ze Wang
%par;

%P=spm_select(80,'image'); % comment out,Heather
P=Filename; %% Heather

global defaults;
spm_defaults;

% Get realignment defaults
defs = defaults.realign;

% Flags to pass to routine to calculate realignment parameters
% (spm_realign)

%as (possibly) seen at spm_realign_ui,
% -fwhm = 5 for fMRI
% -rtm = 0 for fMRI
% for this particular data set, we did not perform a second realignment to the mean
% the coregistration between the reference control and label volume is also omitted
reaFlags = struct(...
    'quality', defs.estimate.quality,...  % estimation quality
    'fwhm', 5,...                         % smooth before calculation
    'rtm', 1,...                          % whether to realign to mean
    'PW',''...                            %
    );
%spm_realign_asl_PC(P, reaFlags);
spm_realign_asl(P, reaFlags);

% Flags to pass to routine to create resliced images
% (spm_reslice)
resFlags = struct(...
    'interp', 1,...                       % trilinear interpolation
    'wrap', defs.write.wrap,...           % wrapping info (ignore...)
    'mask', defs.write.mask,...           % masking (see spm_reslice)
    'which',2,...                         % write reslice time series for later use
    'mean',1);                            % do write mean image
spm_reslice(P, resFlags);


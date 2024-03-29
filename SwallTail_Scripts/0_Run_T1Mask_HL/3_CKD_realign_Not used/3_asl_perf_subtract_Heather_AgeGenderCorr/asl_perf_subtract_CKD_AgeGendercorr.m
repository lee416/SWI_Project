function [perfnum,glcbf] =asl_perf_subtract_CKD_AgeGendercorr(Filename, age_sub, gender_sub)

%% start, comment out, Heather
% function [perfnum,glcbf] = asl_perf_subtract_CKD(Filename,FirstimageType, SubtractionType,...
%            SubtractionOrder,Flag,Timeshift,AslType,labeff,MagType,Labeltime,Delaytime,Slicetime,TE,M0img,M0seg,maskimg)
%%end, comment out, Heather

% function [perfnum] = asl_perf_subtract(Filename,FirstimageType, SubtractionType,...
%           SubtractionOrder,Flag,Timeshift,AslType,labeff,MagType,Labeltime,Delaytime,Slicetime,TE,M0img,M0seg,maskimg)
% file: asl_perf_subtract.m
%   Copyright by Ze Wang
%   Ze Wang @cfn Upenn 2004
%   zewang@mail.med.upenn.edu  or  redhat_w@yahoo.com
% A MATLAB function for calculating perfusion difference images or absolute perfusion images from the label/control ASL image pairs.
% This code uses several SPM I/O functions, you may need to install SPM8, or 5 first.  
% The code can be run in MATLAB(5.3 or above) with SPM99, SPM2, SPM5, or SPM8 on
% Redhat Linux 9 or Windows2K,XP. 
% Note: Matlab refers to the Matlab software produced by Mathworks, Natick,
% MA; SPM(99, 2, 5, or 8) refers to the statistical parametric mapping
% software distributed by Wellcome Trust Center for Neuroimaging. 
%
% Reference: Ze Wang, Geoffrey K. Aguirre, Hengyi Rao, Jiongjiong Wang,
% Maria A. Fernandez-Seara, Anna R. Childress, and John A. Detre, Epirical
% optimization of ASL data analysis using an ASL data processing toolbox:
% ASLtbx, Magnetic Resonance Imaging, 2008, 26(2):261-9.
%
% 
% 
% The ASL perfusion sequences (CASL or PASL, works on Siemens Trio 3T)
% using EPI readout are freely avaiable for academic use, please refer to: http://cfn.upenn.edu/perfusion/sequences.htm
%
% License:
%   This file, asl_perf_subtract is the core part of the ASLtbx.
%     ASLtbx is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     ASLtbx is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with ASLtbx.  If not, see <http://www.gnu.org/licenses/>.
%
%  This code can be freely used or changed for academic purposes. All commercial applications are not allowed without the formal 
%    permission from the Center for functional neuroimaging at the University of Pennsylvania, Medicine School through the authors. 
%    This file is part of the ASL toolbox, which also includes a manual and other files for ASL quality control, and will be 
%    avaiable freely through cfn.upenn.edu. 
%
% Subtraction methods:
%    The methods used here are based on the "simple subtraction", "surround subtraction" and "sinc subtract" approaches described in
%    Aguirre et al (2002) Experimental design and the relative sensitivity of perfusion and BOLD fMRI, NeuroImage. Later version might add other subtraction routines.
%
% CBF quantification:
% For casl, the CBF value is calculated by:
%   CBF (ml/100g/min) = 60*100*deltaM*lambda*R/(2*alp*M0*(exp(-w*R)-exp(-(t+w)*R))
%   where deltaM = ASL perfusion difference, lambda = blood/tissue water partition coefficient, R =longitudinal relaxation rate of blood,
%       alp = tagging efficiency, M0 =  equilibrium magnetization of brain,
%       w = post-labeling delay, t = duration of the labeling RF pulse
%       train.
%   regular values for some parameters are lambda=0.9g/ml,
%   for 3T, alp=0.68, R=1/1664ms  was R=0.67sec-1 in Wang 03  but should be smaller than that according to the literature.
%   for 1.5T, alp=0.71, R=0.83sec-1.
%   Please refer to: Wang J, Alsop DC, et al. (2003) Arterial transit time imaging with flow encoding arterial spin tagging (FEAST).
%   Magn Reson Med. 50(3), page600, formula [1]
%     might be changed to
%   CBF (ml/100g/min) = 60*100*deltaM*lambda*R1tissue/(2*alp*M0*(exp(-w*R1b)(1-exp(-(t)*R1tissue)))  according to Buxton's model.
% For PASL,
%   CBF (ml/100g/min) = deltaM/(2*M0b*tao*exp(-T1/T1b)*qTI)
%   and M0b=A*M0WM*exp((1/T2wm-1/T2b)*TE) here approximated by M0b=A*M0WM, 
%   T1 is the inversion time for different slice; T1b is the constant relaxation time of arterial blood.
%   tao is actually TI1 in QUIPPS II
%   qTI is close to unit, and is set to 0.85 in Warmuth 05. In addition, we
%   introduce the label efficiency in the calculation.
%   A=1.06, T2wm and T2b are 55 msec and 100 for 1.5T, 40 80 for 3T, 30 60 for 4T;
%   M0WM means the mean value in an homogenous white matter region, and it could be selected by drawing an ROI in the M0 image.
%   Please refer to: 1) Buxton et al, 1998 MRM 40:383-96, 2) Warmuth C., Gunther M. and Zimmer G. Radiology, 2003; 228:523-532.
%   Note (Nov 19 2010) T2wm and T2b at 3T were changed to 44.7 and 43.6, T2csf if used was set to 74.9 according to Cavusoglu 09 MRI
% Concurrent pseudo-BOLD images
%      It is possible to get part of BOLD signal if the sequence is T2* weighted.
%      the pseudo-BOLD images can be extracted using: 1) take the average of each 
%      control/label pair, 2) just take the control image of each pair. You can
%      do this by commenting out the corresponding line in lines 557/558. e.g.,
%      comment out BOLDimg=(Vconimg+Vlabimg)/2.; and enable BOLDimg=Vconimg;
%      will enable the 2nd option.
% Usages:
%    If you are using ASL sequences from Dr. John A Detre's lab, you can
%    follow the default setting in the GUI.
% Arguments:
%     Both 3D and 4D NIfTI format and 3D Analyze images are supported now.
%     FirstimageType - integer variable indicats the type of first image.
%        - 0:label; 1:control; for the sequence (PASL and CASL) distributed by CFN, the first image is set to be label.
%     Select raw images (*.img, images in a order of control1.img, label1.img, control2.img, label2.img,....;
%        or images in an order of label1.img, control1.img, label2.img, control2.img, .... )
%    SubtractionType - integer variable indicats which subtraction method will be used
%        -0: simple subtraction; 1: surround subtraction; 2: sinc subtractioin.
%           For control-label:
%              if the raw images are: (C1, L1, C2, L2, C3...), the simple subtraction are: (C1-L1, C2-L2...)
%                 the surround subtraction is: ((C1+C2)/2-L1, (C2+C3)/2-L2,...), the sinc subtraction is: (C3/2-L1, C5/2-L2...)
%              if the raw images are: (L1, C1, L2, C2...), the simple subtraction are: (C1-L1, C2-L2...)
%                 the surround subtraction will be: (C1-(L1+L2)/2, C2-(L2+L3)/2,...), the sinc subtraction will be: (C1-L3/2, C2-L5/2...)
%           and vice versa for label-control
%    SubtractionOrder - integer value indicats the subtraction orientation
%           1: control-label; 0: label-control
%    Note: a gold stand to get the correct subtraction order is to check the CBF value in grey matter. If most grey matter voxels have negative
%          CBF values, you should switch to the other subtraction order. Usually, for CASL, you should choose control-label, and for the FAIR based PASL data, 
%            you should select  label - control
%          When background suppression is applied, the subtraction order may need to be flipped also. Like CASL
%          with background suppression, the subtraction should be label-control.
%
%    Flag - flag vector composed of [MaskFlag,MeanFlag,CBFFlag,BOLDFlag,OutPerfFlag,OutCBFFlag,QuantFlag,ImgFormatFlag,D4Flag]
%          MaskFlag - integer variable indicating whether perfusion images are
%               masked by BOLD image series, usually, it's masked to remove the
%               background noise and those non-perfusion regions.
%               - 0:no mask; 1:masked
%
%          MeanFlag - integer variable indicating whether mean image of all perfusion images are produced
%               - 0:no mean image; 1: produced mean image
%          CBFFlag - indicator for calculating cbf. 1: calculated, 0: no
%          BOLDFlag - generate pseudo BOLD images from the tag-utag pairs.
%
%          
%          OutPerfFlag: write perf signal to disk or not? 1 yes, 0:no
%          OutCBFFlag: write CBF signal to disk or not?
%          QuantFlag: using a unique M0 value for the whole brain? 1:yes, 0:no.
%          ImgFormatFlag: 0 (default) means saving images in Analyze format, 1 means using NIFTI
%          D4Flag       : 0 (default) - no, 1 - yes
%    labeff  -  labeling efficiency, 0.95 for PASL, 0.68 for CASL, 0.85 for pCASL, this should be measured for onsite scanner.
%    MagType - indicator for magnet field strength, 1 for 3T, 0 for 1.5T,
%    Timeshift - only invalid for sinc interpolation, it's a value between
%    0 and 1 to shift the labeled image forward or backward.
%
%    AslType - 0 means PASL, 1 means CASL
%    Labeltime-time for labelling arterial spins. (sec)
%    Delaytime - delay time for labeled spin to enter the imaging slice,
%               this argument is used to transfer TI2 (the second interval) in QUIPSS.
%    Slicetime - 2D: time for getting one slice, which can calculated by #phase encoding lines/bandwidthperpixel [+ fat saturation time and crusher time+ slice selection gradient time + phase refocusing gradient time]  
%               #number of phase encoding lines usually is the same as the image dimension along y since phase encoding is
%               generally applied along y direction in 2D imaging. For 64x64 imaging matrix, it is 64. The easiest way to get slicetime is:
%               get the minimal TR by clicking the "TR" window in the protocol panel, then slicetime=(minTR-labelingtime-delaytime)/#slices.
%                3D: should be set to 0.
%    M0img - M0 image acquired with short TE long TR.
%    M0seg - segmented white matter M0 image needed for automatically
%           calculating the PASL cbf images.
%    maskimg - a predefined mask image, for background suppression data,
%    please specify a mask or change the corresponding threshold in the
%    code.
%  Outputs:
%     perfnum: perfusion image number.
%     Images written to the disk: Perfusion images, BOLD images, and CBF
%     images (if the flags are turned on correspondingly).
%     global perfusion difference signals and CBF values will be saved to a txt file.  
%
%  Example:
%    With user interface to select the input parameters:
%           asl_perf_subtract
%   Batch mode for PASL CBF calculation:
%           FirstimageType: label first, SubtractionType: 0 (simple subtraction)
%           SubtractionOrder: 1 (control-label),
%           Flag: [1 1 1 0 0 1 1 1]: [removing out-of-brain voxels, generating mean images, calculating qCBF, not saving pseudo bold,
%                   not saving perf diff images, save qCBF series, using unique M0 for all voxels, saving results in NIFTI format, saving image series in 4D], 
%                  Timeshift=0.5 (used in sinc subtraction), AslType: 0 (PASL), labeff:0.9, MagType: 1 (3T),
%                  Labeltime:2 (idle for PASL), Delaytime: 0.8 sec, Slicetime: 45 msec, TE: 20 msec,M0img,M0seg,maskimg
%           asl_perf_subtract(Filename,0, 0, 1, [1 1 1 0 0 1 1 1 1], ...
%                             0.5, 0, 0.9, 1, 2, 0.8, 45, 20, M0, M0seg, maskimg);
%   Ze Wang @cfn Upenn 2004
%   zewang@mail.med.upenn.edu  or  redhat_w@yahoo.com
%   History:
%   Modified: 11-08-2004
%   Modified: 04-12-05. Changed the perfusion image and CBF image
%   generating part to remove outliers.
%   Modified 10-04-05. Improved the cbf calculation part to be faster, using 6 point sinc interpolation.
%                   10-19-05. Modified the outlier mask for global time seriese calculation. Improved sinc
%                   interpolation.
%   Modified 10-22-05. Absolute threshold is used for local outlier cleaning.
%   11-16-2005 A bug fixed by Robert Kraft for displaying nonsquare image for M0 calculation in the PASL part. 
%   11-30-2005 parameters adjusted for calculating CBF for PASL data. 
%   07-20-2006 outlier threshold was adjusted to -40~150, this is an empirical range for removing within volume outliers. 
%   04-20-2007 parameters were named consistently for CASL and PASL, and
%   code was tested in SPM5.
%   07-08-2008 added an option (Flag(7)) for CBF calibration using M0 from each
%   voxel. This will be particularly useful for ASL with array coil.
%   08-11-2008 supported 4D I/O. Only tested with spm5. 
%   19-Nov-2010 update T1 T2 of blood and tissue according to the literature. Corrected the quantification method for using voxel-wise M0. 
%               for using single M0, the water/tissue ratio was also changed according to the literature. Descriptions for PASL
%               quantification were updated, more details provided for using q, lambda etc
%               Adapted some changes made by Michael Harms. 

% close all;
spmver = spm('ver',[],1);
modernSPM = any(strcmp(spmver,{'SPM5','SPM8'}));
% Define some constants
BPTransTime=200;          % Blood pool transit time
TissueTransTime=1500;     % Tissue transit time
MinGrayT1=900;            % Min T1 of gray matter in ms
MaxGrayT1=1600;           % Max T1 of gray matter in ms
MinWhiteT1=300;           % Min T1 of wht matter in ms
MaxWhiteT1=900;           % Max T1 of wht matter in ms
TI1=700;                  % Tagging bolus duration in ms, for the QUIPSS II 
qTI=0.85;
% lambda=0.9*100*60;
%r1a=1/1493; %0.67 per sec %1/BloodT1 depends on field

pos=1;%added by Heather

relthresh=0.12;           % Relative threshold for creating the mask.
relthresh=0.05;

%----- Start, comment out, Heather
% try Filename;
%    ;
% catch
%    if modernSPM
%        Filename=spm_select(Inf,'any','Select ASL imgs', [],pwd,'.img$');
%    else
%     Filename = spm_get(Inf,'*.img','Select ASL imgs');
%    end
% end
% if isempty(Filename)
%    if modernSPM
%        Filename=spm_select(Inf,'any','Select ASL imgs', [],pwd,'.img$');
%    else
%     Filename = spm_get(Inf,'*.img','Select ASL imgs');
%    end 
% end
% if isempty(Filename), fprintf('No images selected!\n');return;end;
%----- End, comment out, Heather


%% Start, comment out, Heather
% pos=1;
% try FirstimageType;
%    ;
% catch
%    FirstimageType = spm_input('1st image type, 0:label; 1:control', pos, 'e', 0);
% end
%% End, comment out, Heather

FirstimageType=0; %% Heather

%% Start, comment out, Heather
% try SubtractionType;
%    ;
% catch
%    pos=pos+1;
%    SubtractionType = spm_input('Select subtraction method', pos, 'm',...
%                        '*simple subtraction|surround subtraction|sinc subtraction',...
%                        [0 1 2], 0);
% end
%% End, comment out, Heather

SubtractionType =0; %Heather


%% Start, comment out, Heather
% if SubtractionType==2,
%    try Timeshift;
%        ;
%    catch
%    %if nargin<6
%        pos=pos+1;
%        Timeshift = spm_input('Time shift for sinc interpolation', pos, 'e', 0.5);
%    end
%  %if FirstimageType==0 Timeshift=-1*Timeshift; end;
% end;
%% End, comment out, Heather
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Note here, the sinc subtraction is C1-L1/2 or L1/2 -C1, but when the raw image sequence is L1 C1, L2 C2,... the
%% L1/2 should be between L1 and L2, otherwise, it should be between 0 and
%% L1.
%if nargin<4

%% Start, comment out, Heather
% try SubtractionOrder;
%    ;
% catch
%    pos=pos+1;
%    SubtractionOrder = spm_input('Select subtraction order', pos, 'm',...
%                        'label-control|control-label',...
%                        [0 1], 2);
% end
%% End, comment out, Heather

SubtractionOrder =1% Heather, control-label

%% Start, comment out, Heather
% try Flag;
%    MaskFlag=Flag(1);
%    MeanFlag=1;
%    BOLDFlag=0; CBFFlag=1;
%    OutPerfFlag=0;OutCBFFlag=1;
%    QuantFlag=1;  % (default) using a unique M0 value from a ROI for all voxels;
%    ImgFormatFlag=0;   % (default) save images in Analyze format
%    D4Flag=0;         % this is to be compatible with old scripts
%    if length(Flag)>1,  MeanFlag=Flag(2);end
%    if length(Flag)>2,  CBFFlag=Flag(3); end
%    if length(Flag)>3,  BOLDFlag=Flag(4);end
%    if length(Flag)>4,  OutPerfFlag=Flag(5);end
%    if length(Flag)>5,  OutCBFFlag=Flag(6)*CBFFlag; end
%    if length(Flag)>6,  QuantFlag=Flag(7);end
%    if length(Flag)>7,  ImgFormatFlag=Flag(8);end
%    if length(Flag)>8,  D4Flag=Flag(9); end
% catch
%    pos=pos+1;
%    MaskFlag = spm_input('Applying mask for output? 0:no; 1:yes', pos, 'e', 1);
MaskFlag=0;% Heather
%    pos=pos+1;
%    MeanFlag = spm_input('Create mean images? 0:no; 1:yes', pos, 'e', 1);
MeanFlag=1;% Heather
%    pos=pos+1;
%    CBFFlag = spm_input('Calculate qCBF? 0:no; 1:yes', pos, 'e', 1);
CBFFlag=1;
%    pos=pos+1;
%    BOLDFlag = spm_input('Output pseudo BOLD imgs? 0:no; 1:yes', pos, 'e', 0
BOLDFlag=0;
%    pos=pos+1;
%    OutPerfFlag = spm_input('Save delta M imgs? 0:no; 1:yes', pos, 'e', 0);
OutPerfFlag=1;
%    pos=pos+1;
%    if CBFFlag
%         OutCBFFlag = spm_input('Save qCBF imgs? 0:no; 1:yes', pos, 'e', 1);
OutCBFFlag=1;
%         pos=pos+1;
%         QuantFlag   = spm_input('Using a unique M0 value for all voxels? 0:no; 1:yes', pos, 'e', 1);
QuantFlag=0;
%    else
%        OutCBFFlag =0;
%    end
%    pos=pos+1;
%    ImgFormatFlag=spm_input('Output image format? 0:Analyze; 1:Nifti', pos, 'e', 0);
ImgFormatFlag=0;
%    pos=pos+1;
%    D4Flag=spm_input('saving 4D image series? 0:no; 1:yes', pos, 'e', 1);
D4Flag=1;
% end
%% End, comment out, Heather

if ~modernSPM, ImgFormatFlag=0; end

%% start, comment out, Heather
% if ImgFormatFlag, imgaffix='.nii';
% else imgaffix='.img'; end
%% end, comment out, Heather

imgaffix='.img' % added by Heather

%% start. comment out, Heather
% try AslType;
%    ;
% catch
%     pos=pos+1;
%     AslType = spm_input('Select ASL Type:0 for PASL,1 for CASL', pos, 'e', 1);
% end
%%end, comment out, Heather

AslType =1; %% added, Heather

A=1.19;     %1.06 in Wong 97. 1.19 in Cavosuglu 09, Proton density ratio between blood and WM;
                  % needed only for AslType=0 (PASL) with QuantFlag=1 (unique M0 based quantification)
if CBFFlag==1,
   %T2wm and T2b are 55 msec and 100 for 1.5T, 40 80 for 3T, 30 60 for 4T;
   
%% start, comment out, Heather
%    if nargin<9
%       pos=pos+1;
%       MagType = spm_input('Magnetic field:0 for 1.5T,1 for 3T, 2 for 4T', pos, 'e', 1);
%    end
%% end, comment out, Heather

MagType=1; % added, Heather

%% start, comment out, Heather
%    if nargin<10
%    	  if AslType==1   % labeling time is only required for CASL or pCASL
%         pos=pos+1;
%         Labeltime = spm_input('Label time:sec', pos, 'e', 1.5);%%Heather
%       else
%         Labeltime=0.001;
%       end
%    end
%% end, comment out, Heather

Labeltime =1.5 % added, Heather
Labeltime=Labeltime*1000;

%% start, comment out, Heather
%    if nargin<11
%       pos=pos+1;
%       Delaytime = spm_input('Post-labeling delay:sec', pos, 'e', 1.2);
%    end
%% end, comment out, Heather

Delaytime=1.2 %% added, Heather
Delaytime=Delaytime*1000;

%% start, comment out, Heather
%    if nargin<12
%       pos=pos+1;
%       Slicetime = spm_input('Slice acquisition time:msec', pos, 'e', 21);
%    end
%% end, comment out, Heather

Slicetime =21; %% added, Heather
   
   if MagType==0  %1.5 T
      T2wm=55;
      T2b=100;
      BloodT1=1200;
   elseif MagType==1   % 3T
      T2wm=44.7;   % used to be 40;
      T2b=43.6;    % used to be 80;   
      %% BloodT1=1664;    % was 1490 in Wang 03;  %% Heather, comment out
     % these changes were made according to Lu 04 and Cavusoglu 09 MRI
       %BloodT1=1000/((0.52*HCT_Sub)+0.38); %% Heather, added, HCT=0.4249, T1b=1664msec
       if age_sub<=17
        BloodT1=2115.6-21.5*age_sub-73.3*gender_sub; %% Heather, added, age 7-17
       else
        BloodT1=1985.4-6.4*age_sub-148.6*gender_sub; %% age 19-39
       end

   else
      T2wm=30;
      T2b=60;
      BloodT1=1810;  % You may need to update this value from the literature.
   end;
   
   if AslType==0
      try TE;
        ;
      catch
          pos=pos+1;
          TE=spm_input('TE:msec', pos, 'e', 20);
      end
      Aprim=A*exp( (1/T2wm-1/T2b)*TE);
    elseif AslType==1 
      ;

    end   % end if AslType==0  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    useM0=0;
    if AslType==0, useM0=1;
    elseif AslType==1    %
      if ~exist('M0img','var')     % give a chance to use M0 or not (for CASL)
%           pos=pos+1; %% comment out, Heather
%           useM0= spm_input('Use additionally acquired M0 image for CASL?', pos, 'm',...
%                        'yes|*no',...
%                        [1 0], 0); %% comment out, Heather
           useM0=0; %% added, Heather
      end
    end;
  
    try M0img;
      if ~exist(M0img,'file') 
         if useM0==1   % you have to specify a M0 image.
            if modernSPM
                M0img = spm_select(1,'image','Select M0 image','',pwd,'.img$');
            else
                M0img = spm_get(1,'*.img','Select M0 image');
            end
         end
      else  % M0 is specified, implying M0 will be used for CBF calculation no matter which AslType it is.
          useM0=1;
      end;
    catch
        
     if useM0==1
       pos=pos+1;
       if modernSPM
            M0img = spm_select(1,'image','Select M0 image');
       else
            M0img = spm_get(1,'*.img','Select M0 image');
       end
     end  
    end     %end try M0img
    
    if useM0==1
      if QuantFlag==1    % a unique M0 value for all voxels
      try M0seg;
          if ~exist(M0seg,'file')
              fprintf('The gray matter mask file does not exist!');
              if modernSPM
                M0seg = spm_select(1,'image','Select segmented WM M0 image file','',pwd,'.seg.img$');
              else
                M0seg = spm_get(1,'*.img','Select segmented WM M0 image file');
              end              
          end
          M0auto=1;
      catch
          
          pos=pos+1;
          M0auto= spm_input('Draw roi for calculating CBF?', pos, 'm',...
                       'yes|*no',...
                       [0 1], 0);
          if M0auto==1
              if modernSPM
                M0seg = spm_select(1,'image','Select segmented WM M0 image file','',pwd,'.seg.img$*');
              else
                M0seg = spm_get(1,'*seg*.img','Select segmented WM M0 image file');
              end             
          end
          
      end  % end try M0seg
     end  % end if QuantFlag==1
  end      %end if useM0==1
  %%%%%%%
  
  r1a=1/BloodT1; %0.601 sec for 3T was set to 0.67  sec in Wang 03
end;    % end if CBFFlag==1

try labeff;
          ;
catch
    pos=pos+1;
    if AslType==0
        labeff=spm_input('Enter the labele fficiency', pos, 'e', 0.95);
    elseif AslType==1
              %% Heather
        %%labeff=spm_input('Enter the labele fficiency', pos, 'e', 0.68);
        %%labeff=spm_input('Enter the labele fficiency', pos, 'e',0.85);%%comment out, Heather
        labeff=0.85; %% added, Heather
    else
        labeff=spm_input('Enter the labele fficiency', pos, 'e', 0.82);
    end
end

lambda=0.9; %*100*60;   %0.9 mL/g

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The selected images must have the same dimensions.
Vall=spm_vol(deblank(Filename));
Is4D=size(Filename,1)<2;
alldat=spm_read_vols(Vall);
alldat(find(isnan(alldat)))=0;
tlen=size(alldat,4);
if tlen<2, fprintf('You should select at least a pair of ASL raw images!\n');return;end;
perfno=fix(tlen/2);
imno=perfno*2;

% MEANSCALE=mean(alldat(find(alldat>0.1*max(alldat(:)))));  % a scale for removing outliers
try maskimg;
   vmm=spm_vol(deblank( maskimg ) );
   maskdat=spm_read_vols(vmm);
   glmask=maskdat>0.75;
catch
   malldat=squeeze(mean(alldat,4));
   malldat(find(isnan(malldat(:))))=0;
   thresh=relthresh*max(malldat(:)); % a global threshhold
   glmask=malldat>thresh;
end
brain_ind=find(glmask>0);            % within brain voxels

MEANSCALE=mean(alldat(glmask));  % a scale for removing outliers
if MeanFlag==1
   meanBOLDimg=zeros(Vall(1).dim(1),Vall(1).dim(2),Vall(1).dim(3));2
   meanPERFimg=zeros(Vall(1).dim(1),Vall(1).dim(2),Vall(1).dim(3));
   if CBFFlag==1 meanCBFimg =zeros(Vall(1).dim(1),Vall(1).dim(2),Vall(1).dim(3)); end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Log file
%logfid=fopen('perfsubtract.log','w');
%fprintf(logfid,'Log file for generating perfusion images. %s\n',date);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get the uniform white matter region for calculating cbf
if CBFFlag==1
  if useM0==1  
 
    if isempty(M0img) fprintf('For PASL, this code needs a M0 image to calculate the cbf\n No cbf images created.'); return; end;
    VM0=spm_vol(deblank( M0img ) );
    if sum(VM0.dim(1:3)==Vall(1).dim(1:3))~=3
        sprintf('\n The M0 image size is different from the functional images!')
    end
    M0=spm_read_vols(VM0);
    M0(find(isnan(M0)))=0;
    if QuantFlag==1
        if M0auto==0
           disp('A mask in a homogeneous white matter area is required');
           sl=8;
           tmp=sl;
           disp('Input 0 to end the selection loop.');
           roiplane=zeros(VM0.dim(1),VM0.dim(2));
           [xi,yi] = meshgrid(linspace(1,VM0.dim(1),VM0.dim(1)*2),linspace(1,VM0.dim(2),VM0.dim(2)*2));
           scale = 6;
           r = VM0.dim(2)*scale;
           c = VM0.dim(1)*scale;
           h=figure;
           w = get(h, 'Position');
           set(h, 'Unit', 'Pixels', 'Position', [w(1), w(2), c, r]);
           set(gca, 'Position', [0, 0, 1, 1]);
           plane=reshape(M0(:,:,tmp),VM0.dim(1),VM0.dim(2));
           plane=rot90(plane);
           roiplane=interp2(plane,xi,yi);
           imagesc(roiplane*255);
           colormap(gray(256));
           axis off
           while tmp
              tmp=input('please enter the slice number:  ');
              sl=tmp;
              if tmp>0
                plane=reshape(M0(:,:,tmp),VM0.dim(1),VM0.dim(2));
                plane=rot90(plane);
                roiplane=interp2(plane,xi,yi);
                imagesc(roiplane*255);
              end
            end
            BW=roipoly;
            roiplane=roiplane.*BW;
            roiavg=mean(mean(roiplane(find(roiplane>0))));
       else   % get the mean value of the M0 in the white matter area automatically

            VM0seg=spm_vol(deblank( M0seg ) );
            if sum(VM0seg.dim(1:3)==VM0.dim(1:3))~=3
              sprintf('\n The segmented M0 image size is different from the M0 image!')
              sprintf('\n Please choose another segmented WM M0 file!')
              pos=pos+1;
              if modernSPM
                M0seg = spm_select(1,'image','Select segmented WM M0 image file','',pwd,'.seg.img$*');
              else
                M0seg = spm_get(1,'*seg*.img','Select segmented WM M0 image file');
              end
              %M0seg = spm_get(1,'*seg*.img','Select WM M0 image file');
              VM0seg=spm_vol(deblank( M0seg ) );
              if sum(VM0seg.dim(1:3)==Vall(1).(1:3))~=3
                 sprintf('\n The WM M0 image is still not the right one')
                 sprintf('\n Please go back and check it carefully')
               return;
             end
           end

           M0segdata=spm_read_vols(VM0seg);
           sln=size(M0segdata,3);
           M0segdata(find(isnan(M0segdata)))=0;
           if sln>7
           		M0segdata(:,:,[1:3 (sln-1):sln])=0;
           elseif sln>4
              M0segdata(:,:,[1 sln])=0;
           end
           msk=M0segdata>0.8*max(M0segdata(:));
           msk(:,:,[1:fix(VM0seg.dim(3)/4) VM0seg.dim(3)-min(3,fix(VM0seg.dim(3)/4)):VM0seg.dim(3)] )=0;
           m0=M0.*msk;
           roiavg=mean(mean(m0(find(m0>0))));
       end    % end if useM0==1
     sprintf('\nThe mean value of the roi is:%03f',roiavg)
     %fprintf(logfid,'\nThe mean value of the roi is:%03f',roiavg);

   end %if QuantFlag==1 
 end   %if useM0==1
end

%%% Heather
% The main loop
if FirstimageType  % 1 control first
    %confiles=Filename(1:2:end,:);
    conidx = 1:2:2*perfno;
    labidx = 2:2:2*perfno;
    %labfiles=Filename(2:2:end,:);
else   % 0 label first
    conidx = 2:2:2*perfno;
    labidx = 1:2:2*perfno;
    %confiles=Filename(2:2:end,:);
    %labfiles=Filename(1:2:end,:);
end
[pth,nm,xt] = fileparts(deblank(Filename(1,:)));
prevpth=pth;
fseq=0;
fprintf('\n\rCBF quantification for L/C pair: %35s',' ');
midname4D='';
for p=1:perfno
    str   = sprintf('#%3d /%3d: ',p,perfno );
    fprintf('%s%15s%20s',repmat(sprintf('\b'),1,35),str,'...calculating');
   if Is4D>0, 
      midname=strtok(Filename,',');
      midname=spm_str_manip(midname,'dts');
   else
      [pth,nm,xt] = fileparts(deblank(Filename( (2*(p-1)+1+FirstimageType),:)));
      xt=strtok(xt,',');  % removing the training ','
      midname=spm_str_manip(Filename(2*(p-1)+1,:),'dts');
   end
   midname=strtok(midname,',');  % this could be redundant
   midname=spm_str_manip(midname,'dts');
   if p==1, midname4D=midname; end;
   if strcmp(prevpth,pth)==0   fseq=0;    end
   fseq=fseq+1;
   prevpth=pth;
   %prefix  = [pth filesep 'Perf_' num2str(SubtractionType)]; %% Heather,comment out, AgeGendercorr
   %cbfprefix=[pth filesep 'cbf_' num2str(SubtractionType)]; %% Heather,comment out, AgeGendercorr
   
   prefix  = [pth filesep 'Perf_AgeGendercorr_' num2str(SubtractionType)]; %% Heather, added, AgeGendercorr
   cbfprefix=[pth filesep 'cbf_AgeGendercorr_' num2str(SubtractionType)]; %% Heather, added, AgeGendercorr
   
   BOLDprefix=[pth filesep 'PseuBold'];

   %Vlab=spm_vol(deblank(labfiles(p,:)));
   %[Vlabimg,cor]=spm_read_vols(Vlab);
   Vlabimg = alldat(:,:,:,labidx(p));
       % Here we assumed that the image values are modest, so no overflow will occur.
       switch SubtractionType
           case 1   % The linear interpolation method "surround average"
               %Vcon=spm_vol(deblank(confiles(p,:)));
               %[Vconimg,cor]=spm_read_vols(Vcon);
               Vconimg = alldat(:,:,:,conidx(p));
               if p>1&p<perfno

                   if FirstimageType
                        %Vcon2=spm_vol(deblank(confiles(p+1,:)));
                        Vconimg = (Vconimg+squeeze(alldat(:,:,:,conidx(p+1))))/2;
                    else
                        %Vcon2=spm_vol(deblank(confiles(p-1,:))); 
                        Vconimg = (Vconimg+squeeze(alldat(:,:,:,conidx(p-1))))/2;   
                    end
                   %[Vconimg2,cor]=spm_read_vols(Vcon2);
                   %Vconimg=(Vconimg+Vconimg2)/2.0; clear Vconimg2 Vcon2;
               end
           case 2   % sinc-subtraction
               % 6 point sinc interpolation
               if FirstimageType==0
                   idx=p+[-3 -2 -1 0 1 2];
                   normloc=3-Timeshift;
               else
                   idx=p+[-2 -1 0 1 2 3];
                   normloc=2+Timeshift;
               end
               idx(find(idx<1))=1;
               idx(find(idx>perfno))=perfno;
               %v=spm_vol(confiles(idx,:));
               %Vcon=v(1);
               %nimg=spm_read_vols(v);
               nimg = alldat(:,:,:,conidx(idx));
               nimg=reshape(nimg,size(nimg,1)*size(nimg,2)*size(nimg,3),size(nimg,4));
               clear tmpimg;
               [pn,tn]=size(nimg);
               tmpimg=sinc_interpVec(nimg(brain_ind,:),normloc);
               Vconimg=zeros(size(nimg,1),1);
               Vconimg(brain_ind)=tmpimg;
               Vconimg=reshape(Vconimg,Vall(1).dim(1),Vall(1).dim(2),Vall(1).dim(3));
               clear tmpimg pn tn;
           otherwise
               %disp('The default is the simple pair wise subtraction\n');
               %Vcon=spm_vol(deblank( Filename( (2*p-FirstimageType),:) ) );
               %[Vconimg,cor]=spm_read_vols(Vcon);
               Vconimg = alldat(:,:,:,conidx(p));
       end
 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % perform subtraction
   perfimg=Vconimg-Vlabimg;
   if SubtractionOrder==0  %label-control
       perfimg=-1.0*perfimg; % Heather
   end
   if MaskFlag==1
       %mask=Vconimg>relthresh*max(Vconimg(:));
       perfimg=perfimg.*glmask;
   end
 
   slicetimearray=ones(Vall(1).dim(1)*Vall(1).dim(2),Vall(1).dim(3));
   if ~exist('Slicetime','var') Slicetime=0; end
   for sss=1:Vall(1).dim(3)
        slicetimearray(:,sss)=slicetimearray(:,sss).*(sss-1)*Slicetime;    
   end
   slicetimearray=reshape(slicetimearray,Vall(1).dim(1),Vall(1).dim(2),Vall(1).dim(3));
   slicetimearray=slicetimearray(brain_ind);
   BOLDimg=(Vconimg+Vlabimg)/2.;
%    BOLDimg=Vconimg;
   if BOLDFlag
       Vbold=Vall(1);
       if D4Flag
       		Vbold.fname=[BOLDprefix '_' midname4D '_4D' imgaffix];
       		Vbold.n = [fseq 1];
       		if modernSPM
             Vbold.dt=[16 0];
          else
             Vbold.dim(4)=16;
          end
          Vbold=spm_write_vol(Vbold,BOLDimg);
       else
       	  Vbold.fname=[BOLDprefix '_' midname '_' num2str(fseq,'%0.3d') imgaffix];
          if modernSPM
            Vbold.dt=[16 0];
          else
            Vbold.dim(4)=16;
          end
          Vbold=spm_write_vol(Vbold,BOLDimg);
       end
   end
   if MeanFlag==1
       meanPERFimg=meanPERFimg+perfimg;
       if BOLDFlag==1 meanBOLDimg=meanBOLDimg+Vconimg;  end;
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % CBF quantification
   cbfimg=zeros(size(perfimg));
   if CBFFlag==1
      if AslType==0  % PASL
             clear tcbf;
             TI=TI1+Delaytime+slicetimearray;
             tperf=perfimg(brain_ind);
             
             eM0=M0(brain_ind);
             tcbf=zeros(size(eM0));
             effidx=find(abs(eM0)>1e-3*mean(eM0(:)));
             efftperf=tperf(effidx);
             TI=TI(effidx);
             if QuantFlag==1                   % using a single M0 value (should be M0b)
                tcbf(effidx)=efftperf*6000*1000./(2*Aprim*roiavg.*exp(-TI/BloodT1)*TI1*labeff*qTI);
             else                              % using voxelwise M0 value for different voxel
                effM0=eM0(effidx); 
                %tcbf(effidx)=lambda*efftperf*6000*1000./(2*Aprim*effM0)./exp(-TI/BloodT1)/TI1/labeff;
                tcbf(effidx)=lambda*efftperf*6000*1000./(2*effM0.*exp(-TI/BloodT1)*TI1*labeff*qTI);
             end
             cbfimg(brain_ind)=tcbf;
         else  %CASL
          if useM0==1
             omega=Delaytime+slicetimearray;
             clear tcbf;
             locMask=Vconimg(brain_ind);
             tperf=perfimg(brain_ind);
             tcbf=zeros(size(locMask));
             effidx=find(abs(locMask)>1e-3*mean(locMask(:)));
             omega=omega(effidx);
             efftperf=tperf(effidx);
             if QuantFlag==1
                efftcbf=efftperf./roiavg;
             else                              % using different M0 value for different voxel
                eM0=M0(brain_ind); 
                effM0=eM0(effidx); 
                efftcbf=efftperf./effM0;
             end
             efftcbf=6000*1000*lambda*efftcbf*r1a./(2*labeff* (exp(-omega*r1a)-exp( -1*(Labeltime+omega)*r1a) ) );
             tcbf(effidx)=efftcbf;
             cbfimg(brain_ind)=tcbf; 
          else
             omega=Delaytime+slicetimearray;
             clear tcbf;
             M0=Vconimg(brain_ind);
             tperf=perfimg(brain_ind);
             tcbf=zeros(size(M0));
             effidx=find(abs(M0)>1e-3*mean(M0(:)));
             omega=omega(effidx);
             effM0=M0(effidx);
             efftperf=tperf(effidx);
             
             efftcbf=efftperf./effM0;
             efftcbf=6000*1000*lambda*efftcbf*r1a./(2*labeff* (exp(-omega*r1a)-exp( -1*(Labeltime+omega)*r1a) ) );
             tcbf(effidx)=efftcbf;
             cbfimg(brain_ind)=tcbf;
         end
         %gs(p,2)=mean(cbfimg(find( abs(cbfimg)>0)));
      end
      if MeanFlag==1
           meanCBFimg=meanCBFimg+cbfimg;
      end
      % Getting a mask for outliers
      % mean+3std has problem in some cases
      nanmask=isnan(cbfimg);
      outliermask=((cbfimg<-40)+(cbfimg>150))>0;
      sigmask=glmask-outliermask-nanmask;
      wholemask=glmask-nanmask;
      whole_ind=find(wholemask>0);
      outliercleaned_maskind=find(sigmask>0);

%        cbfimg(find(outliermask>0))=nan;
      gs(p,2)=mean(cbfimg(outliercleaned_maskind));
      gs(p,4)=mean(cbfimg(whole_ind));

      if OutCBFFlag
           VCBF=Vall(1);
           if D4Flag
              VCBF.fname=[cbfprefix '_' midname4D '_4D' imgaffix];
              if modernSPM
                 VCBF.dt=[16,0];
              else
                 VCBF.dim(4)=16; %'float' type
              end
              VCBF.n = [fseq 1];
              VCBF=spm_write_vol(VCBF,cbfimg);
           else
           
           	  VCBF.fname=[cbfprefix '_' midname '_' num2str(fseq,'%0.3d') imgaffix];
              if modernSPM
                VCBF.dt=[16,0];
              else
                VCBF.dim(4)=16; %'float' type
              end
              VCBF=spm_write_vol(VCBF,cbfimg);
            end
       end
      %cbfimg=cbfimg;
      %VCBF=spm_write_vol(VCBF,cbfimg);
   else
          %getting sigmask and wholemask
      nanmask=isnan(perfimg);
      outliermask=((perfimg<-15)+(perfimg>30))>0;
      sigmask=glmask-outliermask-nanmask;
      wholemask=glmask-nanmask;
      whole_ind=find(wholemask>0);
      outliercleaned_maskind=find(sigmask>0);
  end
  gs(p,1)=mean(perfimg(outliercleaned_maskind));
  gs(p,3)=mean(perfimg(whole_ind));

%     perfimg(find(outliermask>0))=nan;
   if OutPerfFlag
       Vdiff=Vall(1);
       if D4Flag
          Vdiff.fname=[prefix '_' midname4D '_4D' imgaffix];
          if modernSPM
             Vdiff.dt=[16 0];
          else
             Vdiff.dim(4)=16;
          end
          Vdiff.n=[fseq 1];
          Vdiff=spm_write_vol(Vdiff,perfimg);
       else
          Vdiff.fname=[prefix '_' midname '_' num2str(fseq,'%0.3d') imgaffix];
          if modernSPM
             Vdiff.dt=[16 0];
          else
             Vdiff.dim(4)=16;
          end
          Vdiff=spm_write_vol(Vdiff,perfimg);
       end
   end
end  %end the main loop
fprintf('%s%20s',repmat(sprintf('\b'),1,20),'...done');
if MeanFlag==1
  meanPERFimg=meanPERFimg./perfno;
  if BOLDFlag==1, meanBOLDimg=meanBOLDimg./perfno;end;
  if CBFFlag==1   meanCBFimg=meanCBFimg./perfno; end;
  %% output the mean images
  Vmean=Vall(1);
  if modernSPM
    Vmean.n = [1 1];
  end
%   nm=strtok(midname,'_0123456789');
  nm=midname;
  %% Vmean.fname=[pth '/meanPERF_' num2str(SubtractionType) '_' nm imgaffix]; %% Heather, commnet out, AgeGendercorr
  Vmean.fname=[pth '/meanPERF_AgeGendercorr_' num2str(SubtractionType) '_' nm imgaffix]; %% Heather, added, AgeGendercorr
  if modernSPM
     Vmean.dt=[16 0]; 
  else %
     Vmean.dim(4)=16; %'float' type 
  end
  
  Vmean=spm_write_vol(Vmean,meanPERFimg);
  if BOLDFlag==1,  
      Vmean.fname=[pth '/meanBOLD_' num2str(SubtractionType) '_' nm imgaffix];
      Vmean=spm_write_vol(Vmean,meanBOLDimg);
  end
  if CBFFlag==1
     %% Vmean.fname=[pth '/meanCBF_' num2str(SubtractionType) '_' nm imgaffix]; %% Heather, comment out, AgeGendercorr
     Vmean.fname=[pth '/meanCBF_AgeGendercorr_' num2str(SubtractionType) '_' nm imgaffix]; %% Heather, added, AgeGendercorr
     Vmean=spm_write_vol(Vmean,meanCBFimg);
     cbf_mean=mean(meanCBFimg(outliercleaned_maskind));
     glcbf=cbf_mean;
     fprintf('\nThe mean CBF is %03f (%03f).\n',cbf_mean, mean(meanCBFimg(whole_ind)));
     %fprintf(logfid,'\nThe mean CBF is %03f',cbf_mean);
 else
     glcbf=[];
 end
  
end
% gsfile=[pth '/globalsg_' num2str(SubtractionType) '.txt']; %% Heather, comment out, AgeGendercorr
gsfile=[pth '/globalsg_AgeGendercorr_' num2str(SubtractionType) '.txt']; %% Heather, added, AgeGendercorr
save(gsfile,'gs','-ascii');
%fclose(logfid);
perfnum=perfno;
close%% Heather
return;



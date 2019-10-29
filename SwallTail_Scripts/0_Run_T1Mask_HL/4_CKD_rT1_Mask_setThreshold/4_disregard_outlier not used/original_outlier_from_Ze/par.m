% Batch mode scripts for running spm5 in TRC
% Created by Ze Wang, 08-05-2004
% zewang@mail.med.upenn.edu


fprintf('\r%s\n',repmat(sprintf('-'),1,30))
fprintf('%-40s\n','Set PAR')


clear
global PAR
PAR=[];


PAR.SPM_path=spm('Dir');
addpath(PAR.SPM_path);
addpath /jet/zwang/workshop/spm/
addpath /jet/zwang/workshop/sigtbx

% This file sets up various things specific to this
% analysis, and stores them in the global variable PAR,
% which is used by the other batch files.
% You don't have to do it this way of course, I just
% found it easier



%%%%%%%%%%%%%%%%%%%%%
%                   %
%   GENERAL PREFS   %
%                   %
%%%%%%%%%%%%%%%%%%%%%%
% Where the subjects' data directories are stored

PAR.batchcode_which= mfilename('fullpath');
PAR.batchcode_which=fileparts(PAR.batchcode_which);
addpath(PAR.batchcode_which);
old_pwd=pwd;
cd(PAR.batchcode_which);
cd ../
data_root=pwd;
cd(old_pwd);


%PAR.root=data_root;
PAR.root= '/jet/husiyuan/Migraine';

% Subjects' directories
% PAR.subjects = {...
% '07D11AB'...
% '63L31AB'...
% '67F18OR'...
% '67K26NN'...
% '71R07AN'
% };
% PAR.subjects={'07D11AB'};
% 22 July 2010: 14 subjects have 2 more sessions (totally 4 sessions)
% 13 august 2010: 15 subjects have 2 more sessions (totally 4 sessions)
PAR.subjects={...
	's001' 
	's002' 
	's003' 
	's004' 
	's005' 
	's006' 
	's007' 
	's008' 
	's009' 
	's010' 
	's011' 
	's012' 
	's013' 
	's014' 
	's015' 
	's016' 
	's017' 
	's018' 
	's019' 
	's020' 
	's021' 
	's022' 
	's023' 
	's024' 
	's025' 
	's026' 
	's027' 
	's028' 
	's029' 
	's030' 
	's031' 
	's032' 
	's033' 
	's034' 
	's035' 
	's036' 
	's037' 
	's038' 
	's039' 
	's040' 
	's041' 
	's042' 
	's043' 
	's044' 
	's045' 
	's046' 
	's047' 
	's048' 
	's049' 
	's050' 
	's051' 
	's052' 
	's053' 
	's054' 
	's055' 
	's056' 
	's057' 
	's058' 
	's059' 
	's060' 
	's061' 
	's062' 
	's063' 
	's064' 
	's065' 
	's066' 
	's067' 
	's068' 
	's069' 
	's070' 
	's071' 
	's072' 
	's073' 
	's074' 
	's075' 
	's076' 
	's077' 
	's078' 
	's079' 
	's080' 
	's081' 
	's082' 
	's083' 
	's084' 
	's085' 
	's086' 
	's087' 
	's088' 
	's089' 
	's090' 
	's091' 
	's092' 
	's093' 
	's094' 
	's095' 
	's096' 
	's097' 
	's098' 
	's099' 
	's100' 
	's101' 
	's102' 
	's103' 
	's104' 
	's105' 
	's106' 
	's107' 
	's108' 
	's109' 
	's110' 
	's111' 
	's112' 
	's113' 
	's114' 
	's115' 
	's116' 
	's117' 
	's118' 
	's119' 
	's120' 
	's121' 
	's122' 
	's123' 
	's124' 
	's125' 
	's126' 
	's127' 
%	's128' 
	's129' 
	's130' 
	's131' 
	's132' 
	's133' 
	's134' 
	's135' 
	's136' 
	's137' 
	's138' 
	's139' 
	's140' 
	's141' 
	's142' 
	's143' 
	's144' 
	's145' 
	's146' 
	's147' 
	's148' 
};

PAR.nsubs = length(PAR.subjects);


% Anatomical directory name
PAR.structfilter='anat_anlz';
PAR.structprefs = 'anat_anlz';
%PAR.stimuli={'tdcs' 'sham'};
%PAR.nsti   =length(PAR.stimuli);
%PAR.SMcond={'smoke' 'nonsmoke'};
%PAR.nSMc   =length(PAR.SMcond);
PAR.sesses = {'pcasl_rest'};
PAR.nsessions = length(PAR.sesses);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%PAR.imgfilters={'func_anlz' 'func_anlz'};

% Getting condition directories
PAR.confilters={'pcasl_rest'}; %filter for folder name and filenames of functional images
PAR.ncond=length(PAR.confilters);
PAR.imgfilters={'pcasl_rest'};
PAR.structfilter = 'anat_anlz';
PAR.structprefs = 'anat_anlz';
ncond=length(PAR.confilters);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the anatomical image directories automatically

for sb=1:PAR.nsubs
    % Although we kno
    tmp=dir(fullfile(PAR.root, PAR.subjects{sb}, ['pcasl_rest']));
    if size(tmp,1)>=PAR.nsessions
        PAR.nsess(sb)=PAR.nsessions;
    else
        PAR.nsess(sb)=size(tmp,1);
    end
  
    for j=1:PAR.nsess(sb)
        %PAR.subs(sb).ses(j).name=fullfile(PAR.root, PAR.subjects{sb}, spm_str_manip(char(tmp(j).name),'d'));
        PAR.subs(sb).ses(j).name=fullfile(PAR.root, PAR.subjects{sb});
        ttmp=dir(fullfile(PAR.subs(sb).ses(j).name, ['*' PAR.structfilter '*']));
        fprintf(' subject %s: \n', PAR.subs(sb).ses(j).name, PAR.structfilter);
        if size(ttmp,1)==0
          fprintf('Can not find the anatomical directory for session%s: \n', PAR.subs(sb).ses(j).name); 
           return;
        end
        if size(ttmp,1)>1
           fprintf('More than 1 anatomical directories are found for session%s: \n', PAR.subs(sb).ses(j).name);
        end
        PAR.subs(sb).ses(j).structdir=fullfile(PAR.subs(sb).ses(j).name, spm_str_manip(char(ttmp(1).name),'d'));
        
        % get locations for functional images
        for jj=1:PAR.ncond
            ttmp=dir(fullfile(PAR.subs(sb).ses(j).name,['*' PAR.confilters{jj} ]));
        fprintf(' subject %s: \n', PAR.subs(sb).ses(j).name, PAR.confilters{jj});
            if size(ttmp,1)>1
                PAR.subs(sb).ses(j).condirs{jj}=fullfile(PAR.subs(sb).ses(j).name,spm_str_manip(char(ttmp(2).name),'d'));
            else
                PAR.subs(sb).ses(j).condirs{jj}=fullfile(PAR.subs(sb).ses(j).name,spm_str_manip(char(ttmp(1).name),'d'));
            end
        end
        
    end
end

% Smoothing kernel size
PAR.FWHM = [6];
PAR.FWHMcbf = [9];
% % TR for each subject.  As one experiment was carried out in one Hospital (with one machine)
% % and the other in another hospital (different machine), TRs are slightly different
% %PAR.TRs = [2.4696 2];
PAR.TRs = ones(1,PAR.nsubs)*3.830;
% PAR.mp='no';

% % Model stuff
% % Condition namesfiles
% PAR.cond_names = {'10','12','21','23'};
%PAR.cond_names = {'shamP2P1','tdcsP2P1','tdc};
%PAR.condnum=length(PAR.cond_names);
%PAR.Onsets={[0],[30],[60],[90]};

%PAR.Durations={[30],[30],[30],[30]};
%PAR.nconds4glmanalysis=2;

%
%PAR.mp='no';
%
%PAR.groupdir = ['groupGLM'];


%contrast names
%PAR.con_names={'12_10','10_21','10_12','23_21','21_10','12_23','23_12',};
%PAR.con_names={'10_21'};
%PAR.con_names={'12_10'};

PAR.subtractiontype=0;
%PAR.glcbffile=['globalsg_' num2str(PAR.subtractiontype) '.txt'];
%PAR.img4analysis='cbf'; % or 'Perf'
%PAR.ana_dir = ['glm_' PAR.img4analysis];
%PAR.Filter='cbf_0_sr';




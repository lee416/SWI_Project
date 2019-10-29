%batch script for cleaning outliers and spikes based on mean CBF images and
%the cleaned global signals.

%%% start, comment out, Heather
% global PAR
% par;
% fprintf('Outliers and spikes cleaning based on global CBF time course and realignment time course!\n');
%%% end, comment out, Heather

function batch_outlier_clean_Heather(pathname,Sub_num)

%%% start, comment out, Heather
% for sb = 1:length(PAR.subjects) % for each subject 
%     fprintf('Subject: %s ... outlier cleaning...\n',PAR.subjects{sb});
%     clear rP;
%     for b = 1:length(PAR.sesses) % for each session %% Heather, PAR.sesses = {'pcasl_rest'};
%        rP=[];
%%% end, comment out, Heather
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %% getting realignment time course
%       nsca=0; % comment out, Heather
%        for ii=1:ncond
%          nsca=nsca+Durations{ii};
%        end

%%% start, comment out Heather
%        for c=1:ncond
%           file_dir_pref = PAR.subs(sb).ses(b).condirs{c};
%           Ptmp=spm_select('FPList', file_dir_pref, ['^rp_\w*\.txt$']);
%            rP=strvcat(rP,Ptmp);
%         end
%%% end, comment out, Heather
        rP=strcat(pathname,'rp_pcasl_rest000.txt');% added, Heather
        % getting realignment parameters
        %if isempty(rP), fprintf('No realignment parameters found for
        %%s.\n',PAR.subjects{sb});continue;end %% comment out, Heather
        Params =[];
        for ii=1:size(rP)
            Params=[Params; textread(deblank(rP(ii,:)))];
        end
        Params(:,4:6)=Params(:,4:6)*180/pi;
        Params=Params(:,1:6);
        mpara=(Params(1:2:end,:)+Params(2:2:end,:))/2;
        diffpara=abs(Params(1:2:end,:)-Params(2:2:end,:));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% If the average head motion of one pair is greater than 8 or the difference is
        %% greater than 2, we will treat the pair as a spike.
        %% Note: the thresholds are still in decision here. 
        filter=abs(mpara)>2;
        filter=sum(filter,2);
        filter=filter>0;
        dfilter=diffpara>1;
        dfilter=sum(dfilter,2);
        dfilter=dfilter>0;
        fil=(filter+dfilter)>0;
        offset=0;
%       for c=1:ncond  %% comment out, Heather 
         % assuming the CBF images are already thresholded
%          file=spm_get('files', PAR.condirs{sb,c}, ['meanCBF_' num2str(PAR.subtractiontype) '_s*img']);
%          if size(file,1)<1, fprintf('No mean CBF image found for %s.\n',PAR.subjects{sb});continue;end
%          v=spm_vol(file);
%          siz=v.dim(1:3);
%          mdat=spm_read_vols(v);
%          mask=mdat>0;     % background mask
%          wholemask=abs(mdat)>0;
%          % using absolute cbf range to mask out the outliers
%          bmask=(mdat>=20).*(mdat<=180);
%          mask=bmask.*mask;
%          files=spm_get('files',PAR.subs(sb).ses(b).condirs{c}, ['cbf_' num2str(PAR.subtractiontype) '_s*img']);
         %files=spm_select('FPList',PAR.subs(sb).ses(b).condirs{c}, ['^cbf_' num2str(PAR.subtractiontype) '_\w*.img']);%% Heather,comment out
          files =strcat(pathname,'cbf_0_rpcasl_rest000_4D.img'); %% added, Heather
          
         %if size(files,1)<2, fprintf('Not enough images found for
         %%s.\n',PAR.subjects{sb});continue;end % comment out, Heather
         v=spm_vol(files);
         dat=spm_read_vols(v);
         siz=size(dat);
         %dat=reshape(dat,siz(1)*siz(2)*siz(3),size(files,1)); %% comment out, Heather
         dat=reshape(dat,siz(1)*siz(2)*siz(3)*siz(4),size(files,1)); %% added, Heather
         clear gcbf;
%          for i=1:size(files,1)
%             dati=squeeze(dat(:,i));
%             nmask=mask(:)-isnan(dati);
%             gcbf(i)=mean(dati(find(nmask>0)));
%             nmask=wholemask(:)-isnan(dati);
%             wholegs(i)=mean(dati(find(nmask>0)));
%          end
%         gcbf=gcbf';
%          gsfile=fullfile(char(PAR.condirs{sb,c}),PAR.glcbffile);
%          gsdat=load(gsfile);
%          gsbuf=zeros(size(files,1),6);
%          if size(gsdat,2)<4
%              gsbuf(:,1:3)=gsdat(:,1:3);
%          else
%             gsbuf(:,1:4)=gsdat(:,1:4);
%          end
%          gsbuf(:,5)=gcbf;
%          % spike identifying
%          mgs=mean(gcbf);
%          stdgs=std(gcbf);
%          indicator=(gcbf>(mgs-2*stdgs)).*(gcbf<(mgs+3*stdgs));
%          % second cleaning
%          mgs=mean(gcbf(find(indicator)));
%          stdgs=std(gcbf(find(indicator)));
%          fmgs=gcbf;
%          fmgs(find(indicator==0))=mgs;
%          indicator=indicator.*(fmgs>(mgs-2*stdgs)).*(fmgs<(mgs+2*stdgs));
%          gsbuf(:,6)=1-indicator;
%          gsbuf(:,7)=fil(offset+(1:size(gsbuf,1)));             % spike indicator calculated from realignment time course
%          gsbuf(:,6)=(gsbuf(:,6)+(wholegs'>160)+(wholegs'<15))>0;
%          save(gsfile,'gsbuf','-ascii');
%          idx=gsbuf(:,6)+gsbuf(:,7)>0;
% only use the head motion information

         idx=fil(offset+(1:size(files,1)))>0;
         vo=v(1);
         cmean=mean(dat(:,find(idx==0)),2);
         %cmean=reshape(cmean,siz(1),siz(2),siz(3)); %% comment out,Heather
         cmean=reshape(cmean,siz(1),siz(2),siz(3),siz(4)); %% added,Heather
         cmean=mean(cmean,4); % added, Heather
%          nanmsk=(mdat<=-20)+(mdat>=140);
         
%          cmean(find(nanmsk>0))=nan;
         [fpath,name,ext]=fileparts(files(1,:));
         %vo.fname=fullfile(fpath,['cmeanCBF_' num2str(PAR.subtractiontype) '_' name '.img']); % comment out, Heather
         vo.fname=fullfile(fpath,['cmeanCBF_simple_outlier.img']);
         vo=spm_write_vol(vo,cmean);
 
%         %% start, comment out, Heather
%          files=spm_select('FPList', PAR.subs(sb).ses(b).condirs{c}, ['^fltraw.*.nii']);
%          %if size(files,1)<2, fprintf('Not enough images found for
%          %%s.\n',PAR.subjects{sb});continue;end % comment out, Heather
%          v=spm_vol(files(find(idx==0),:));
%          dat=spm_read_vols(v);
%          dat=squeeze(mean(dat,4));
%          vo.fname=fullfile(fpath,['cmeanEPI_simple_outlier' PAR.subjects{sb} '.img']);
%          vo=spm_write_vol(vo,dat);
%     %%end, comment out, Heather
         
 %     end % end for c % comment out, Heather
 %  end % comment out, Heather
%end% comment out, Heather

addpath /big1/zwang/Ze_scripts/
qmf = MakeONFilter('Symmlet',8);
type='Symmlet';
no=4;
par;
level=3;
addpath /big1/zwang/workshop/Wavelab850/WavDen/codes
addpath /big1/zwang/workshop/
for sb =1:length(PAR.subjects) % for each subject 
    fprintf('Deep cleaning for sub No: %d, %s, %d left !\n',sb, PAR.subjects{sb}, nsubs-sb);
    for ses=1
        
            if ~isempty(PAR.asldirses{sb,ses})
            movefil = spm_select('FPList', PAR.asldirses{sb,ses} , ['^rp_' '\w*.*_split.txt']);
            if strcmp(movefil,'/')||strcmp(movefil,'\')||isempty(movefil)
              fprintf('!!!!!! No motion time course file found for %s \n',PAR.subjects{sb});
              continue;
            end
            movefil=movefil(1,:);
            moves = spm_load(movefil);
%             moves=moves(1:nsca,:);
            moves(:,10:12)=moves(:,10:12)*180/pi;
            datsum=0;
            PP=spm_select('FPList', PAR.asldirses{sb,ses}, ['^cbf_0_sCompcorr_r\w*.*M0CSF\.nii$']);
            if strcmp(PP,'/')||strcmp(PP,'\')||isempty(PP)
              fprintf('!!!!!! No cbf series found for %s \n',PAR.subjects{sb});
              continue;
            end
            v=spm_vol(PP);
            dat=spm_read_vols(v);
            dat(isnan(dat(:)))=0;
            Xdim=size(dat,1);
            Ydim=size(dat,2);
            Zdim=size(dat,3);
            Tdim=size(dat,4);
            nsca=Tdim;
            
            avgmov=((moves(2:2:nsca*2,7:12)+moves(1:2:nsca*2,7:12))/2);
            relmov=(moves(2:2:nsca*2,7:12)-moves(1:2:nsca*2,7:12));
            crelmov=mean(abs(relmov),2);
            cavgmov=mean(abs(avgmov),2);
            th1=mean(crelmov)+std(crelmov);
            th2=mean(cavgmov)+2*std(cavgmov);
%             th1=mean(crelmov)+std(crelmov);
%             loc=(crelmov>th1)+(cavgmov>th2);
            loc=(crelmov>th1);
            dat=reshape(dat,Xdim*Ydim*Zdim,Tdim);
            maskimg = spm_select('FPList', PAR.asldirses{sb,ses},'^mask_bet.nii$');
%             maskfile=fullfile(PAR.condirs{sb,nse,jj},'EPI_mask.nii');
            
            vm=spm_vol(maskimg);
            mask=spm_read_vols(vm);
            idx=find(mask>0);
            dat=dat(idx,:);
            gs=mean(dat,1);
            gs=gs';
            loc=loc+ (gs<5);%+(gs< mean(gs)-1.2*std(gs));  % removing lower than 0 gs points and lower than 1.2 std points
            loc=loc>0;
            tl=ones(Tdim,1);
            tl(loc)=0;
%             [mgs, ml]=max(gs);
%             % removing the extremely high gs point
%             if mgs> (mean(gs)+2*std(gs)) && mgs>120
%                 tl(ml)=0;
%             end
            tl=tl>0;
            orgmcbf=mean(dat,2);
            mdifg=mean(orgmcbf(:));
            stddifg=std(orgmcbf(:));
            roiidx= (orgmcbf>0)&(orgmcbf<120);
%             roiidx= 1:length(orgmcbf);
            idx2=gs > mean(gs)-1.5*std(gs) & gs > 0;
            idx3=(tl&idx2)>0;
            fprintf('%d images left before ada and ', sum(idx3));
            th=0.17;
            aidx=idx3;
            nidx=0;
            for it=1%:2
                aidx=(idx3-nidx')>0;
                 mcbf=mean(dat(:,aidx),2);     % initial guess

                 for t=1:Tdim
                     c2m(t)=corr(mcbf,dat(:,t));
                     nc2m(t)=corr(mcbf(roiidx),dat(roiidx,t));
                 end

                 nidx=c2m<th;
                 nidx=nc2m<th;
                 
                 if sum(nidx)<1, break; end
                 th=th-0.01;
            end
            aidx=(idx3-nidx')>0;
            fprintf('%d images left after ada.\n ', sum(aidx));
            ndat=dat(:,aidx);
            mcbf=mean(dat(:,aidx),2);
                        
            imgbuf=zeros(Xdim,Ydim,Zdim);
            
            % wavelet transform denoising
            
            imgnum=size(ndat,2);
            len=ceil(log2(imgnum));
            len=2^len;
%             for xn=1:length(idx)
%                 sig= [ndat(xn,:) zeros(1,len-imgnum)];
%                 sig= recsure(sig,qmf);
%                 ndat(xn,:)=sig(1:imgnum);
%             end
%             for im=1:imgnum
%                 imgbuf(idx)=ndat(:,im);
%                 for sl=1:Zdim
%                     cimg=squeeze(imgbuf(:,:,sl));
%                     cimg=denoiseBayes2D(cimg,type,no,level);
%                     imgbuf(:,:,sl)=cimg;
%                 end
%                 ndat(:,im)=imgbuf(idx);
%             end
%             mcbf=mean(ndat,2);
            imgbuf(idx)=mcbf;
            imgbuf(imgbuf<0)=0.001;
%             imgbuf(imgbuf>100)=100;
            vo=v(1);
            vo.fname=fullfile(spm_str_manip(vo.fname,'H'),['cmeanCBF_ada.nii']);
            vo=spm_write_vol(vo,imgbuf);
            
        end
        
     end
end

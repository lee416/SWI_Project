function [ high_pass_phase_Mask]=fun_positive_mask_Heather(high_pass_phase1,matrix_size)

% positive mask
high_pass_phase_Mask=zeros(matrix_size(1),matrix_size(2),matrix_size(3),matrix_size(4));

for ess=1:matrix_size(4)
for sss=1:matrix_size(3)
 for jj=1:matrix_size(2)
    for ii=1:matrix_size(1)
     if high_pass_phase1(ii,jj,sss,ess)<=0
        high_pass_phase_Mask(ii,jj,sss,ess)=1;
     elseif high_pass_phase1(ii,jj,sss,ess)>0
        high_pass_phase_Mask(ii,jj,sss,ess)=(-high_pass_phase1(ii,jj,sss,ess)+(pi))/((pi));
     end
    end
 end
end
end


% for ess=1:matrix_size(4)
% for sss=1:matrix_size(3)
%  for jj=1:matrix_size(2)
%     for ii=1:matrix_size(1)
%      if high_pass_phase1(ii,jj,sss,ess)<=0
%         high_pass_phase_Mask(ii,jj,sss,ess)=1;
%      elseif high_pass_phase1(ii,jj,sss,ess)>0&high_pass_phase1(ii,jj,sss,ess)<(3.14)
%         high_pass_phase_Mask(ii,jj,sss,ess)=(-high_pass_phase1(ii,jj,sss,ess)+(3.14))/((3.14));
%      elseif high_pass_phase1(ii,jj,sss,ess)>(3.14)
%         high_pass_phase_Mask(ii,jj,sss,ess)=0;
%      end
%     end
%  end
% end
% end

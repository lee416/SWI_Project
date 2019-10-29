%clear all, clc
Title='Please input number of average,slicenumber';
Prompt={'Number of averagex2','slicenumber'};
LineNo=1;
DefAns={'80','20'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
Average_2N=str2num(answer{1});
slicenumber=str2num(answer{2});

[tmp_data, pathname]=fun_read_spm_dyn_All(Average_2N,slicenumber);
rpCASL_map=tmp_data;

size_vol=size(rpCASL_map);

% tmp_montage = [];
% for ss=1:slicenumber
%    tmp_montage(:,:,1,ss) = rot90(rpCASL_map(:,:,ss,1));
% end
% figure, montage(tmp_montage),colormap(gray(2000));caxis([0 2000]);axis off;

%%-------------check motion correction--------%%
for kk=1:Average_2N
    imagesc(rot90(rpCASL_map(:,:,10,kk)));axis image;colormap gray;title(strcat('dynamic phase ', int2str(kk)));
    m(kk)=getframe;
    movie(m(kk),2);
end



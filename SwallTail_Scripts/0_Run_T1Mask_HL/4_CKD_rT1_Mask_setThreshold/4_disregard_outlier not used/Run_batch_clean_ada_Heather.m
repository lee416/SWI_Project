clear all
close all

%scan1
%Subjects=[7 142 146 154 177 179	188	194	195	198	202	218	225	242	243	244	258	264	320	329	330 112 118 153 204 216 217 227 331]; 

%scan1
%Subjects=[335 341 343 345 346 347 349 350 352 353 355 356 357 358 360 361 363 364];

%% scan 1, 
%Subjects=[23 99 207 335 370 373 376 380 389 125 374 379 381 382 383 386 395 397 400];

% %% scan2
% Subjects=[7 99 142 146 154 177 179 188 194 195 ...
%     198 202 207 218 225 227 242 243 244 258 264 320 ...
%     329 330 335 112 118 125 153 204 216 217 227 ...
%     331 341 343 345 346 355 358 360 361 363 364 ...
%     374 379 381 382 383 386 395 397 400];
%Subjects=[23 349 350 353 356 357 370 373 376 380 ];


% % %% scan2
% Subjects=[7 142 146 154 177 179 188 194 195 ...
%     198 202 218 225 227 242 243 244 258 264 320 ...
%     329 330 112 118 125 153 204 216 217 227 ...
%     331 341 343 345 346 355 358 360 361 363 364];

Title='Please input the System type';
Prompt={'0 for Mac, 1 for PC'};
LineNo=1;
DefAns={'0'};
answer=inputdlg(Prompt,Title,LineNo,DefAns);
System_Flag=str2num(answer{1});

if System_Flag==0
 pathname_1='/Volumes/LA-PUBLIC/Autism_Data/Subjects';
else
 pathname_1='G:\Autism_Data\Subjects';
end

for ss=1:size(Subjects,2)
  h=waitbar(ss/(size(Subjects,2)),strcat('subject',(int2str(Subjects(ss)))));
  Sub_num=int2str(Subjects(ss));
   if System_Flag==0       
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'/','R0','00',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'/','R0','0',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
     else 
     pathname=strcat(pathname_1,'/','R0',int2str(Subjects(ss)),'/scan2/pcasl_rest/');
     end
   else         
     if Subjects(ss)<10
     pathname=strcat(pathname_1,'\','R0','00',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
     elseif Subjects(ss)<=99&Subjects(ss)>=10
     pathname=strcat(pathname_1,'\','R0','0',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
     else 
     pathname=strcat(pathname_1,'\','R0',int2str(Subjects(ss)),'\scan2\pcasl_rest\');
    end
   end    
    %[Filename]=fun_read_spm_rpcasl_Autism(Average_2N,slicenumber,pathname,Matrix_size);
     [image_pair_left]=batch_clean_ada_Heather(pathname,Sub_num)
     image_pair_left_all(ss)=image_pair_left;
   close(h)
end



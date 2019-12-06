clear
load('pstnp.mat');
[length_seq,dimension]=size(pstnp);
label=[ones(length_seq/2,1);zeros(length_seq/2,1)];
[fea, score] = mRMR_test(pstnp, label, 100);
weight=fea';
save weight weight

%% mRMR
function [fea, score] = mRMR_test(X_train, Y_train, K)
% K is the number of feature selections
bdisp=0;
nun_dimen = size(X_train,2);
nc = size(X_train,1);
t1=cputime;
% Calculate mutual information between each dimension feature and label
for i=1:nun_dimen
   t(i) = mutualinfo(X_train(:,i), Y_train);
end
[tmp, idxs]=sort(-t); % sort£®£©…˝–Ú≈≈–Ú

fea_base = idxs(1:K);
fea(1) = idxs(1);
KMAX = min(1000,nun_dimen); %500
idxleft = idxs(2:KMAX);
k=1;
% if bdisp==1,
% % fprintf('k=1 cost_time=(N/A) cur_fea=%X_train #left_cand=%X_train\n', ...
% %       fea(k), length(idxleft));
% end;

% Add features step by step
for k=2:K
   t1=cputime;
   ncand = length(idxleft);
   curlastfea = length(fea);
   for i=1:ncand
      D_max(i) = mutualinfo(X_train(:,idxleft(i)), Y_train); 
      mi_array(idxleft(i),curlastfea) = getmultimi(X_train(:,fea(curlastfea)), X_train(:,idxleft(i)));
      R_min(i) = mean(mi_array(idxleft(i), :)); 
   end
 
   [score(k), fea(k)] = max(D_max(1:ncand) - R_min(1:ncand));
 
   tmpidx = fea(k);
   fea(k) = idxleft(tmpidx);
   idxleft(tmpidx) = [];
%    if bdisp==1,
% %    fprintf('k=%X_train cost_time=%5.4f cur_fea=%X_train #left_cand=%X_train\n', ...
%       k, cputime-t1, fea(k), length(idxleft));
%    end;
end 
end
%% get mutual information vector between features
function c = getmultimi(da, dt) 
for i=1:size(da,2)
   c(i) = mutualinfo(da(:,i), dt);
end
end


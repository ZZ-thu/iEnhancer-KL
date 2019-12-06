clear
load('pstnp.mat');
data=zscore(pstnp);
lasso_beta(data);

%% Generate regression coefficient beta (weight)
% 1.data needs zscore standardization in advance
% 2. As a result, a beta.mat weight file is generated, 
% and the absolute value needs to be taken and sorted in descending order.
function lasso_beta(data)
length=size(data,1);
label=[ones(length/2,1);zeros(length/2,1)];
[b fitinfo]=lasso(data,label,'CV',5);
lam =fitinfo.Index1SE;       % find index of suggested lambda
beta=b(:,lam);
save beta beta
end

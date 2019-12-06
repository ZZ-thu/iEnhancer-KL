clear
load('Z1.mat');
load('Z2.mat');
Z_diff=abs(Z1-Z2);
save Z_diff Z_diff
Z_mean=mean(Z_diff,1);
save Z_mean Z_mean
Z_std=std(Z_diff,0,1);
save Z_std Z_std

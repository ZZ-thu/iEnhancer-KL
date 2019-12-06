function fold_5(length)
%% 五折分包（全部实验中仅执行一次！）
label=[ones(length/2,1);zeros(length/2,1)];
% 5折分包
indices = crossvalind('Kfold',label,5) %5为交叉验证折数
save indices indices
end
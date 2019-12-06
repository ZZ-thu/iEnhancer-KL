function   crete_indices(length)
label=[ones(length/2,1);zeros(length/2,1)];
indices = crossvalind('Kfold',label,5); 
save indices indices; 
end
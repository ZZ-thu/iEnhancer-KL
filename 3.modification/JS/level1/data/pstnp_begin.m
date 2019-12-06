clear all
data=read_data("data.txt");
length_whole=size(data,1);
data=data(1:length_whole/2,:);
length_seq=size(data,1);
%% positive and negative labels
datap=data(1:1/2*length_seq,:);     
datan=data(1/2*length_seq+1:length_seq,:); 
%% Count matrix
F1=zeros(64,length(char(datap(1,1)))-2); % positive count matrix
F0=zeros(64,length(char(datap(1,1)))-2); % negative count matrix

%% 
% positive
for i=1:size(datap,1) 
    for j=1:(length(char(datap(i,1)))-2) 
        q1=char(datap(i,1));
        sq1=q1(j:j+2);    
        t1=sw(sq1);  
        F1(t1,j)=F1(t1,j)+1; 
    end
end
% negative
for i=1:size(datan,1)
    for j=1:(length(char(datan(i,1)))-2)
        q0=char(datan(i,1));
        sq0=q0(j:j+2);    %¸ºFµÄ3mer
        t0=sw(sq0);
        F0(t0,j)=F0(t0,j)+1;
    end
end
%% 
p1=line_map(F1);
p0=line_map(F0);
KL1=p1.*log(p1./((p1+p0)/2));
KL0=p0.*log(p0./((p1+p0)/2));
Z=1/2*(KL1+KL0);
Z(find(isnan(Z)==1)) = 0;

% -----save Z.mat-----
Z2=Z;
save Z2 Z2
% ---------end--------
%% 
pstnp=zeros(size(data,1),(length(char(data(1,1)))-2)); 
for i=1:size(data,1) 
    for j=1:(length(char(data(i,1)))-2) 
        q=char(data(i,1));
        sq=q(j:j+2);
        t=sw(sq); 
        pstnp(i,j)=Z(t,j); 
    end
end

save pstnp pstnp 



clear all
data=read_data("data.txt");
datap=data(1:size(data,1)/2,:); 
datan=data(size(data,1)/2+1:size(data,1),:);   
F1=zeros(64,length(char(datap(1,1)))-2); 
F0=zeros(64,length(char(datap(1,1)))-2); 

for i=1:size(datap,1) 
    for j=1:(length(char(datap(i,1)))-2) 
        q1=char(datap(i,1));
        sq1=q1(j:j+2);    
        t1=sw(sq1);   
        F1(t1,j)=F1(t1,j)+1; 
    end
end
for i=1:size(datan,1)
    for j=1:(length(char(datan(i,1)))-2)
        q0=char(datan(i,1));
        sq0=q0(j:j+2);    
        t0=sw(sq0);
        F0(t0,j)=F0(t0,j)+1;
    end
end

Z=F1-F0;
S=zeros(size(data,1),(length(char(data(1,1)))-2)); 
for i=1:size(data,1) 
    for j=1:(length(char(data(i,1)))-2) 
        q=char(data(i,1));
        sq=q(j:j+2);
        t=sw(sq); 
        S(i,j)=Z(t,j); 
    end
end



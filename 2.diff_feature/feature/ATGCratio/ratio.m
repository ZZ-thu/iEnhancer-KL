function X = ratio( data )
X=zeros(size(data,1),4); 
for i=1:size(data,1)
    a=char(data(i,1)); 
    A=length(find(a=='A')); 
    C=length(find(a=='C'));
    G=length(find(a=='G'));
    T=length(find(a=='T'));
    X(i,1)=(G+C)/size(data,1); 
    X(i,2)=(G-C)/(G+C);
    X(i,3)=(A-T)/(A+T);
    X(i,4)=(A+T)/(G+C);
end
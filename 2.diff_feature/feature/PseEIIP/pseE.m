function A = pseE( data )
ea=0.126;
et=0.1335;
eg=0.0806;
ec=0.134;
eACGT=[ea ec eg et];
%% pseE 
t=1;
emer=zeros(1,64); 
for i=1:4
    first=eACGT(1,i);
    for j=1:4
        second=eACGT(1,j);
        for k=1:4
            third=eACGT(1,k);
            emer(1,t)=first+second+third;
            t=t+1;
        end
    end
end
emer=ones(size(data,1),1)*emer; 
f=three_mer(data);
A=f.*emer;
end


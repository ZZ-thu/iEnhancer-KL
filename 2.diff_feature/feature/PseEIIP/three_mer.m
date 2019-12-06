function A = three_mer( data )
%% 3-mer
ACGT=['A' 'C' 'G' 'T'];
t=1;
count=zeros(size(data,1),64);
for i=1:4
    first=ACGT(1,i);
    for j=1:4
        second=ACGT(1,j);
        for k=1:4
            third=ACGT(1,k);
            mer{t,:}=[first, second, third];
            t=t+1;
        end
    end
end
for m=1:size(data,1)
    data1=char(data(m,1)); 
    for n=1:(size(data1,2)-2) 
        sq=data1(n:n+2); 
        num=find(strcmp(mer,sq)); 
        count(m,num)=count(m,num)+1;
    end
end
A=count./(size(data1,2)-2);
end


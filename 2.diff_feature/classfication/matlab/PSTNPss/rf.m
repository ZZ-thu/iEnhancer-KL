function [ result_class,score ] = rf( N,m,M,data,label,test_data )
t=cell(1,N);
for i=1:N
    for j=1:m
        r(j)=randi(m,1);
        if j==1
            train=data(r(j),:);
            train_label=label(r(j));
        else
            train=[train;data(r(j),:)];
            train_label=[train_label;label(r(j))];
        end
    end
    t{i} = classregtree(train,train_label);
end

for i=1:M-m
    for j=1:N
        result(i,j)=eval(t{j},test_data(i,:));
    end
end

for i=1:M-m
    sum(i,1:2)=0;
    for j=1:N
        if result(i,j)>=0.8;
            sum(i,1)=sum(i,1)+1;
        else
            sum(i,2)=sum(i,2)+1;
        end
    end
end

result_class=[];
score=[];
for i=1:M-m
    index=find(sum(i,:)==max(sum(i,:)));
    if index(1)==1
        result_class=[result_class;1];
    else if index(1)==2
            result_class=[result_class;0];
        end
    end
    
end


end


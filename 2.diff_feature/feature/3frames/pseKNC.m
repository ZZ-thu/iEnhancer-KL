function A = pseKNC( data ,lambda,w)
Pg=xlsread('P.xlsx');
f=tri_mer(data);
len=length(data);
theta=[];
for str=1:len
    datai=char(data(str)); 
    lens=length(datai);

    D=zeros(lens-1,1);
    di=1;
    
    for char_i=1:lens-1
        m=datai(char_i);
        n=datai(char_i+1);
        switch m
            case 'A'
                switch n;
                    case 'A'
                        D(di)=1;
                    case 'C'
                        D(di)=2;
                    case 'G'
                        D(di)=3;
                    case 'T'
                        D(di)=4;
                end
            case 'C'
                switch n;
                    case 'A'
                        D(di)=5;
                    case 'C'
                        D(di)=6;
                    case 'G'
                        D(di)=7;
                    case 'T'
                        D(di)=8;
                end
            case 'G'
                switch n;
                    case 'A'
                        D(di)=9;
                    case 'C'
                        D(di)=10;
                    case 'G'
                        D(di)=11;
                    case 'T'
                        D(di)=12;
                end
            case 'T'
                switch n
                    case 'A'
                        D(di)=13;
                    case'C'
                        D(di)=14;
                    case 'G'
                        D(di)=15;
                    case 'T'
                        D(di)=16;
                end
                
        end
        di=di+1;
    end
    theta_tem=[];
    for j=1:lambda
        sum_t=0;
        for char_i=1:lens-j-1
            sum_c=0;
            for pg=1:6
                sum_c=sum_c+(Pg(D(char_i),pg)-Pg(D(char_i+j),pg))^2;
            end
            C=sum_c/6;
            sum_t=sum_t+C; 
        end
        theta_j=sum_t/(lens-j-1);
        theta_tem=[theta_tem,theta_j];
    end
    theta=[theta;theta_tem];
end
sum_denomimator_1=w*sum(theta,2)+1; 
A=[f,w*theta]./sum_denomimator_1; 
end
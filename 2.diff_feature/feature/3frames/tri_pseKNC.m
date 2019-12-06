function A=tri_pseKNC(data,a,b,lambda,w)
D=char(data);
len=length(D(1,:));
D1=D(:,1:ceil(a*len)); 
D2=D(:,ceil(a*len:b*len));
D3=D(:,ceil(b*len:len));
A=[pseKNC( D1 ,lambda,w),pseKNC( D2 ,lambda,w),pseKNC( D3 ,lambda,w)];
end




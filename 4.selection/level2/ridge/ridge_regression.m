clear
% Ridge Regression
load('pstnp.mat');
data = pstnp; 
[m,n] = size(data);
label = [ones(m/2,1);zeros(m/2,1)];
 
% standardization
yMeans = mean(label);
for i = 1:m
    yMat(i,:) = label(i,:)-yMeans;
end
 
xMeans = mean(data);
xVars = var(data);
for i = 1:m
    xMat(i,:) = (data(i,:) - xMeans)./xVars;
end
 
testNum = 30;
weights = zeros(testNum, n);
lam = zeros(testNum, 1);
for i = 1:testNum
    w = ridgeRegression(xMat, yMat, exp(i-10));
    lam(i,:)=exp(i-10);
    weights(i,:) = w';
end


% Choose the most suitable lam value
weight=weights(30,:)';  
save weight weight

% Draw the weights as the parameter lam changes
hold on
axis([-9 20 -0.0001 0.00015]);
xlabel log(lam);
ylabel weights;
for i = 1:n
    x = -9:20;
    y(1,:) = weights(:,i)';
    plot(x,y);  
    hold on
end


function [ w ] = ridgeRegression( x, y, lam )
    xTx = x'*x;
    [m,n] = size(xTx);
    temp = xTx + eye(m,n)*lam;
    if det(temp) == 0
        disp('This matrix is singular, cannot do inverse');
    end
    w = temp^(-1)*x'*y;
end



function Main2_rj133()
wholetrain=importdata('LargeData.mat');
wholetest=importdata('TestData.mat');
xtrain=wholetrain(1,:);
ytrain=wholetrain(2,:);
xtest=wholetest(1,:);
ytest=wholetest(2,:);
figure(1);
scatter(xtrain,ytrain,'g')
hold on;
scatter(xtest, ytest,'r')
legend('train','test')
xlabel('x');
ylabel('y');
title('All the data');
grid on;
hold off;
datatrain=zeros(1,9);
datatest=zeros(1,9);
for n=1:9 
    alpha=LSR_rj133(xtrain,ytrain,n,0);
    p=fliplr(alpha');
    yget=polyval(p,xtrain);
    ygett=polyval(p,xtest);
    trainerror=mean((yget-ytrain).^2);
    testerror=mean((ygett-ytest).^2);
    fprintf('%2i  \t %f \t  %f   \n', n, trainerror,testerror);fprintf('\n');
    datatrain(n)=trainerror;
    datatest(n)=testerror;
end
indtrain=find(datatrain==min(min(datatrain)));
indtest=find(datatest==min(min(datatest)));
figure(2);
if indtrain==indtest
    alpha=LSR_rj133(xtrain,ytrain,indtrain,0);
    fprintf('coeffecient (from high exponential to low)\n')
    fprintf('%f  \t',fliplr(alpha'));fprintf('\n');
    p=fliplr(alpha');
    y=polyval(p,xtrain);
    plot(xtrain,y)
    title('The fitted model')
    grid on;
end
if indtrain~=indtest
    alpha=LSR_rj133(xtrain,ytrain,indtrain,0);
    p=fliplr(alpha')
    y=polyval(p,xtrain);
    plot(xtrain,y)
    hold on;
    alpha1=LSR_rj133(xtrain,ytrain,indtest,0);
    p1=fliplr(alpha1')
    y1=polyval(p1,xtrain);
    plot(xtrain,y1)
    legend('train','test')
    xlabel('x');
    ylabel('y');
    title('The fitted model')
    grid on;
    hold off;
    fprintf('coeffecient with smallest train error (from high exponential to low)\n')
    fprintf('%f  \t',fliplr(alpha'));fprintf('\n');
    fprintf('coeffecient with smallest test error (from high exponential to low)\n')
    fprintf('%f  \t',fliplr(alpha1'));fprintf('\n');

end

    
    




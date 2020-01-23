
function Main3_rj133()
wholetrain=importdata('SmallData.mat');
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
datatrain=zeros(1,5);
datatest=zeros(1,5);
lamlist=[10^-6 10^-3 1 10^3 10^6];
for i=1:5
    lam=lamlist(i);
    alpha=LSR_rj133(xtrain,ytrain,9,lam);
    p=fliplr(alpha');
    yget=polyval(p,xtrain);
    ygett=polyval(p,xtest);
    trainerror=mean((yget-ytrain).^2);
    testerror=mean((ygett-ytest).^2);
    fprintf('%f  \t %f \t  %f   \n', lam, trainerror,testerror);fprintf('\n');
    datatrain(i)=trainerror;
    datatest(i)=testerror;
end
indtrain=find(datatrain==min(min(datatrain)));
indtest=find(datatest==min(min(datatest)));
figure(2);
if indtrain==indtest
    alpha=LSR_rj133(xtrain,ytrain,9,lamlist(indtrain));
    fprintf('coeffecient (from high exponential to low)\n')
    fprintf('%f  \t',fliplr(alpha'));fprintf('\n');fprintf('lambda   ');fprintf('%f  \t  ',lamlist(indtrain));fprintf('\n');
    p=fliplr(alpha');
    y=polyval(p,xtrain);
    plot(xtrain,y)
    title('The fitted model')
    grid on;
end
if indtrain~=indtest
    alpha=LSR_rj133(xtrain,ytrain,9,lamlist(indtrain));
    p=fliplr(alpha')
    y=polyval(p,xtrain);
    plot(xtrain,y)
    hold on;
    alpha1=LSR_rj133(xtrain,ytrain,9,lamlist(indtest));
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
    fprintf('%f  \t  ',fliplr(alpha'));fprintf('\n');fprintf('lambda   ');fprintf('%f  \t  ',lamlist(indtrain));fprintf('\n');
    fprintf('coeffecient with smallest test error (from high exponential to low)\n')
    fprintf('%f  \t',fliplr(alpha1'));fprintf('\n');fprintf('lambda   ');fprintf('%f  \t  ',lamlist(indtest));fprintf('\n');

end

    
    




%Ran Ju(rj133) ran.ju@dukekunshan.edu.cn
%2020.3.11
close all
warning off;
%set basic parameters
load('DataFeaImg.mat');
left=class{1};%204*120
right=class{2};
setPara.t=1;
%setPara.t=0.0001;
setPara.Tmax=100000; 
%setPara.Tmax=100;
setPara.tol=0.000001; 
setPara.C=0; 
setPara.W =ones([204,1]);  
accuracy=zeros(6,1);%record the accuracy
%cross validation
for i=0:5
    %train data
    X1=left;
    X2=right;
    X1(:,1+20*i:20*(i+1))=[];%delete the test data
    X2(:,1+20*i:20*(i+1))=[];
    X=[X1,X2];%204*200
    Y=[ones(100,1);(-1)*ones(100,1)];%200*1
    %test data
    Xtest=[left(:,1+20*i:20*(i+1)),right(:,1+20*i:20*(i+1))];%204*40
    Ytest=[ones(20,1);(-1)*ones(20,1)];
    %initial Z in each round
    setPara.zeta=max(1-Y'.*(setPara.W'*X+setPara.C),0)+0.001;%1*200
    [optSol, optLamda]=solver_interior_rj133(X,Y,setPara);%optimal Z
    result=optSol(1:204)*Xtest+optSol(205);%caculate result
    comparasion=result.*Ytest';%if correct this value should be positive
    accuracy(i+1)=1-length(comparasion(comparasion<0))/length(comparasion);%accuracy for each round
end
show_weights(abs(optSol(1:204)));%show figure of weights
[b,i]=sort(abs(optSol(1:204)));
disp('Place of five dominant value of weights');
disp(i(end-4:end));
disp('five dominant value of weights');
for j=i(end-4:end)
    disp(optSol(j));
end

disp('C');
disp(optSol(205));
disp('Accuracy');
disp(accuracy);
disp('Mean accuracy');
disp(mean(accuracy));
disp('Standard deviation of accuracy');
disp(std(accuracy));


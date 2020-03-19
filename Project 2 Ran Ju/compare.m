close all;
warning off;
%set basic parameters
load('DataFeaImg.mat');
left=class{1};
right=class{2};
accuracy=zeros(6,1);%record the accuracy
%cross validation
for i=0:5
    %train data
    X1=left;
    X2=right;
    X1(:,1+20*i:20*(i+1))=[];%delete the test data
    X2(:,1+20*i:20*(i+1))=[];
    X=[X1';X2'];
    Y=[ones(100,1);(-1)*ones(100,1)];%200*1
    %test data
    Xtest=[left(:,1+20*i:20*(i+1))';right(:,1+20*i:20*(i+1))'];%204*40
    Ytest=[ones(20,1);(-1)*ones(20,1)];
    train_data=X;
    train_label=Y;
    test_data=Xtest;
    test_label=Ytest;
    mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',2);%you can change the model here
    predict_label= predict(mdl, test_data);
    accuracy(i+1)=length(find(predict_label == test_label))/length(test_label)*100;
end
mean(accuracy)
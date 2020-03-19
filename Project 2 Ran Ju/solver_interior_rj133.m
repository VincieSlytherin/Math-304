function [optSol, optLamda] = solver_interior_rj133(X, Y, setPara)
% Get the optimal solution using interior point algorithm and get the
% optimal lamda using five fold cross-validation from the given lamda set
%
% INPUTS:
%   X(MxN) : trData(i,j) is the i-th feature from the j-th trial
%   Y(Nx1): trData(j) is the label of the j-th trial (1 or -1)
%   setPara : Initialized parameters
%            setPara.t      
%            setPara.zeta   
%            setPara.Tmax   
%            setPara.tol    
%            setPara.W      
%            setPara.C      
%
% OUTPUTS:
%   optLamda: Optimal lamda value 
%   optSol: the optimal solution     
%
% @Your Name: Ran Ju, Your email: ran.ju@dukekunshan.edu.cn
% @date; 2020-03-07


%set basic parameters
W=setPara.W;
C=setPara.C;
zeta=setPara.zeta;%the ebsolon in the cost function
t=setPara.t;
tol=setPara.tol;
Tmax=setPara.Tmax;
Lamda=0;
init_Z=[W',C,zeta];
best=0;
optional_lambda=[0.01,1,100,10000];
Xleft=X(:,1:100);
Xright=X(:,101:end);
Yleft=Y(1:100);
Yright=Y(101:end);
%get the optimal lamda
for j=1:4%four choice of lambda
    lambda=optional_lambda(j);
    accuracy=zeros(1,5);

    for i=1:5 %five fold cross validation (second level)
        traindata=X;
        trainlabel=Y;
        testindex=(1:20)+(i-1)*20;
        testdata=[Xleft(:,testindex),Xright(:,testindex)];
        testlabel=[Yleft(testindex);Yright(testindex)];
        traindata(:,testindex)=[];
        traindata(:,testindex+80)=[];
        trainlabel(testindex)=[];
        trainlabel(testindex+80)=[];
        to=setPara.t;
        zetao=max(1-trainlabel'.*(W'*traindata+C),0)+0.001;
        init_Zo=[W',C,zetao];%1*405       
        while(to<=Tmax)%stopping criteria
            [Sol,err]=solver_Newton_rj133(@function_cost_rj133,init_Zo,lambda,to,traindata,trainlabel,tol);% unconstrained nonlinear optimization
            init_Zo=Sol;
            to=to*15; 
        end
        result=Sol(1:204)*testdata+Sol(205);
        comparasion=result.*testlabel';
        accuracy(i)=1-length(comparasion(comparasion<0))/length(comparasion);
    end
    if mean(accuracy)>best%best lambda is with the highest accuracy
        best=mean(accuracy);
        Lamda=lambda;
    end
end
optLamda=Lamda
%get optSol
while(t<=Tmax)
    [optSol,err]=solver_Newton_rj133(@function_cost_rj133,init_Z,optLamda,t,X,Y,tol);
    init_Z=optSol;
    t=15*t;
end

    


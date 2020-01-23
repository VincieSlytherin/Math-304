function [alpha]= LSR_rj133(x,y,n,lam)
len=length(x);
A=zeros(len,n+1);
for j=1:len
    for k=0:n
        A(j,k+1)=x(j)^k;
    end
end
dia=eye(n+1)*sqrt(lam);
A=[A;dia];
ze=zeros(n+1,1);
B=[y';ze];
alpha=(A'*A)\(A'*B);


    
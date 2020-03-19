function [F, G, H] = function_cost_rj133(Z, X, Y, Lambda, t)
% Compute the cost function F(Z)
%
% INPUTS: 
%   Z: Parameter values
%   X: Features
%   Y: Labels
%   Lambda and t: hyper-parameter in the object function
% OUTPUTS
%   F: Function value
%   G: Gradient value
%   H: Hessian value
%
% @Your Name:rj133, Email:ran.ju@dukekunshan.edu.cn
% Data: 2020-03-07

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To improve the excution speed, please program your code with matrix
% format. It is 3much faster than the code using the for-loop.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set basic parameters
num_data=size(X,2);%160
num_feature=204;
W=Z(1:num_feature);
C=Z(205);%1*1
ebsolon=Z(206:end);%1*160
W=W';%204*1
%size(Y)=160*1
%size(X)=204*160
%pay attention to the difference between '.' and without it
%calculate function value
complexpart=W'*X.*Y'+C.*Y'+ebsolon-1;%1*160
part2=-(1/t)*sum(log10(complexpart));
part3=-(1/t)*sum(log10(ebsolon));
part1=sum(ebsolon)+Lambda*(W'*W);
F=part1+part2+part3;%1*1

%calculate gradient
%W part
complex=log(10)*(W'*X.*Y'+C*Y'+ebsolon-1);%1*160
gradient_W=2*Lambda*W-(1/t)*sum((X.*Y')./complex,2);%204*1


%C part
gradient_C=(-1/t)*sum(Y'./complex);%1*1

%ebsolon part
gradient_ebsolon=1-(1/t)*1./complex-(1/t)*(1./(ebsolon*log(10)));
G=[gradient_W',gradient_C,gradient_ebsolon];%1*365

%calculate Hessian value
H=zeros(num_feature+1+num_data,num_feature+1+num_data);%365*365
%WW
HWWo=zeros(204,204);
for i=1:num_data
    Xcol=X(:,i);
    Ycol=Y(i);
    ebs=ebsolon(i);
    complexi=W'*Xcol*Ycol+C*Ycol+ebs-1;
    HWWo=HWWo+Ycol^2*(Xcol*Xcol')/(complexi^2);%204*204
end
HWW=2*Lambda*eye(204)+(1/t)*(1/log(10))*HWWo;%diagonal is special (204*204)
H(1:num_feature,1:num_feature)=HWW;
%WC (204*1)
HWC=(1/t)*log(10)*sum((X.*(Y'.^2))./complex.^2,2);
H(1:num_feature,num_feature+1)=HWC;
H(num_feature+1,1:num_feature)=HWC';%HCW is symmetric with HWC
HCC=(1/t)*log(10)*sum(Y'.^2./complex.^2);%CC(1*1)
H(num_feature+1,num_feature+1)=HCC;
HWE=(1/t)*log(10)*(X.*Y')./complex.^2;%WE(204*160)
H(1:num_feature,num_feature+2:end)=HWE;
H(num_feature+2:end,1:num_feature)=HWE';%HEW is symmetric with HWE
HEE=eye(num_data)*(1/t).*(log(10)./complex.^2+(1/log(10)./ebsolon.^2));%diagonal
H(num_feature+2:end,num_feature+2:end)=HEE;
HCE=(1/t)*log(10)*Y'./complex.^2;%(1*160)CE
H(num_feature+1,num_feature+2:end)=HCE;
H(num_feature+2:end,num_feature+1)=HCE';%HEC is symmetric with HCE
end
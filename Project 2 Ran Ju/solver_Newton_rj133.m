function [optSol, err] = solver_Newton_rj133(function_cost_rj133,init_Z,Lambda,t,X,Y,tol)
% Solve the optimization problem using Newton method
%
% INPUTS:
%   function_cost: Function handle of F(Z)
%   init_Z: Initial value of Z
%   tol: Tolerance
%
% OUTPUTS:
%   optSol: Optimal soultion
%   err: Error
%
% @your Name:Ran Ju, Email:ran.ju@dukekunshan.edu.cn
% Date: 2020-03-07

%set parameter
Z=init_Z;
err=1;
% Set the error 2*tol to make sure the loop runs at least once
while (err/2)>tol
    % Execute the cost function at the current iteration
    % F : function value, G : gradient, H, hessian
    [F,G,H] = function_cost_rj133(Z, X, Y, Lambda,t);
    deltaZ=(-1)*H\G';%pay attention to the '/' and '\'
    err=G/H*G';
    Zo=Z;% avoid misunderstanding
    s=linesearch(Zo,X,Y,deltaZ);%line search to get step size
    Z=Z+s*deltaZ';%update Z
end
optSol=Z;%get optSol
end

    
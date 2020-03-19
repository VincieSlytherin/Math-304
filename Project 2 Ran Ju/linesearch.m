function s=linesearch(Zo,X,Y,deltaZ)
%Use line search to get each optimal step size s;
%input: Z
%       X
%       Y
%       deltaZ:gradient of Z
%output: Znew: updated Z
%        s: optimal step size of each round

% @your Name:Ran Ju, Email:ran.ju@dukekunshan.edu.cn
% Date: 2020-03-07
        
s=1;%start
while true
    Znew=Zo+s*deltaZ';
    ebsolon=Znew(206:end);
    W=Znew(1:204);
    C=Znew(205);
    criteria=W*X.*Y'+C.*Y'+ebsolon-1;% it is a matrix not a value
    if isempty(criteria(criteria<=0))%stopping criteria
        if isempty(ebsolon(ebsolon<=0))
            break
        end
    end
    s=0.5*s;%update step size
end
end


% Inputs: p1,p2,p3,p4 are 2D points
% Check if a quadrilateral defined by p1, p2, p3 and p4 is convex or
% concave. If the abs(sum(sign(c))) is equal 4, then the quadrilateral is
% convex and non self-intersected. If the abs(sum(sign(c))) is equal 2, 
% then the quadrilateral is concave and non intersected. Else if the
% abs(sum(sign(c))) is equal 0, then the quadrilateral is convex and self-
% intersected.
% --------------------------------------------------------------------------
% Author: Nousias G., 2023
% --------------------------------------------------------------------------

function [an,c]=checkConvexOrConcave(varargin)

if nargin==4
    P = [varargin(1);varargin(2);varargin(3);varargin(4)];
    P = cell2mat(P);
elseif nargin==1
    ptsSet = cell2mat(varargin(1));
    P = [ptsSet(:,1)';ptsSet(:,2)';ptsSet(:,3)';ptsSet(:,4)'];
end
for i=1:size(P,1)
    if i==1
        k = size(P,1);
    else
        k = i-1;
    end
    if i==4
        m = 1;
    else
        m = i+1;
    end
    a = [P(i,:)-P(k,:),0];
    b = [P(m,:)-P(i,:),0];
    c(i,:) = asind(cross(a/norm(a),b/norm(b)));
end
c = c(:,3);
an = abs(sum(sign(c)));
end

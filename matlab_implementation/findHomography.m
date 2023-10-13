% Call H-RANSAC knowing if two sets of points are lebeled or not
function H = findHomography(varargin)
    if nargin==8
        coef.minPtNum = 4;
        coef.iterNum = varargin{5};
        d1 = distfcm([varargin{1} varargin{2}]',[varargin{1} varargin{2}]');
        maxD1 = max(max(d1));
        coef.thDist = maxD1/100;
        coef.thInlrRatio = .1;
        H = H_RANSAC(varargin{3},varargin{4},varargin{1},varargin{2},coef,@solveHomo,@calcDist,varargin{6},varargin{7},varargin{8});
    elseif nargin==6
        coef.minPtNum = 4;
        coef.iterNum = varargin{3};
        d1 = distfcm(varargin{1}',varargin{1}');
        maxD1 = max(max(d1));
        coef.thDist = maxD1/100;
        coef.thInlrRatio = .1;
        H = H_RANSAC(varargin{1},varargin{2},coef,@solveHomo,@calcDist,varargin{4},varargin{5},varargin{6});
    else
        fprintf('Invalid number of input arguments')
    end
end
function [f_final] = H_RANSAC(varargin)
% ,fLib,inlierIdx,pairs,dist,idx,cConv,timesAccepted,bestIterConv,countEqualQ,selected_transfQ
%[f inlierIdx] = ransac1( x,y,ransacCoef,funcFindF,funcDist )
%	Use RANdom SAmple Consensus to find a fit from X to Y.
%	X is M*n matrix including n points with dim M, Y is N*n;
%	The fit, f, and the indices of inliers, are returned.
%
%	RANSACCOEF is a struct with following fields:
%	minPtNum,iterNum,thDist,thInlrRatio
%	MINPTNUM is the minimum number of points with whom can we
%	find a fit. For line fitting, it's 2. For homography, it's 4.
%	ITERNUM is the number of iteration, THDIST is the inlier
%	distance threshold and ROUND(THINLRRATIO*n) is the inlier number threshold.
%
%	FUNCFINDF is a func handle, f1 = funcFindF(x1,y1)
%	x1 is M*n1 and y1 is N*n1, n1 >= ransacCoef.minPtNum
%	f1 can be of any type.
%	FUNCDIST is a func handle, d = funcDist(f,x1,y1)
%	It uses f returned by FUNCFINDF, and return the distance
%	between f and the points, d is 1*n1.
%	For line fitting, it should calculate the dist between the line and the
%	points [x1;y1]; for homography, it should project x1 to y2 then
%	calculate the dist between y1 and y2.
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com
if nargin==10
    funcFindF = varargin{6};
    funcDist = varargin{7};
    im1 = varargin{10};
    iterNum = varargin{5}.iterNum;
    thDist = varargin{5}.thDist;
    pts1T1 = varargin{3}; pts1T2 = varargin{4}; %refered to points of candidate frame
    pts2T1 = varargin{1}; pts2T2 = varargin{2}; %refered to points of reference frame
    nA = varargin{8}; nB = varargin{9};
    x = [pts1T1 pts1T2];
    y = [pts2T1 pts2T2];
    inlrNum = zeros(1,iterNum);
    error=zeros(1,iterNum)+1e5;
    fLib = cell(1,iterNum);
    Pairs={};
    cConv=0;
    timesAccepted=0;
    bestIterConv = 0;
    countEqualQ = 0;
    selected_transfQ = -1;
    for p = 1:iterNum
        % 1. fit using  random points
        [nA1,nB1,nA2,nB2] = getRandIndex(nA,nB);
        if ~isempty(nB1) && ~isempty(nB2)
            ptsSet1 = [pts1T1(:,nB1) pts1T2(:,nB2)];
        elseif ~isempty(nB2) && isempty(nB1)
            ptsSet1 = pts1T2(:,nB2);
        elseif ~isempty(nB1) && isempty(nB2)
            ptsSet1 = pts1T1(:,nB1);
        end
        if ~isempty(nA1) && ~isempty(nA2)
            ptsSet2 = [pts2T1(:,nA1) pts2T2(:,nA2)];
        elseif ~isempty(nA2) && isempty(nA1)
            ptsSet2 = pts2T2(:,nA2);
        elseif ~isempty(nA1) && isempty(nA2)
            ptsSet2 = pts2T1(:,nA1);
        end

        % Check using checkConvexOrConcave and either continue if both ans are
        % equal or continue and select new 4 points 
        [an1,~]=checkConvexOrConcave(ptsSet1);

        [an2,~]=checkConvexOrConcave(ptsSet2);

        bestIterConv = bestIterConv+1;

        if an1~=an2
            continue;
        end

        f1 = funcFindF([pts1T1(:,nB1) pts1T2(:,nB2)],[pts2T1(:,nA1) pts2T2(:,nA2)]);

        if ~isempty(f1)
            dist1=[]; pairs1=[];
            dist2=[]; pairs2=[];
            % 2. count the inliers, if more than thInlr, refit; else iterate
            if ~isempty(pts1T1) && ~isempty(pts2T1)
                [dist1,pairs1] = funcDist(f1,x(:,1:length(pts1T1)),y(:,1:length(pts2T1)));
            end
            if ~isempty(pts1T2) && ~isempty(pts2T2) && length(x)>length(pts1T1) && length(y)>length(pts2T1)
                [dist2,pairs2] = funcDist(f1,x(:,length(pts1T1)+1:end),y(:,length(pts2T1)+1:end));
            end
            if ~isempty(pts1T1) && ~isempty(pts2T1) && ~isempty(pairs2)
                pairs2 = [length(pts1T1)+pairs2(:,1) length(pts2T1)+pairs2(:,2)];
            end
            dist = [dist1 dist2];
            pairs = [pairs1;pairs2];
            inlier1 = find(dist < thDist);
            timesAccepted = timesAccepted+1;

            if length(inlier1)>= 6

                [~,~,~,transformed1]=checkConvHull(im1,f1);
                transfQ = checkConvexOrConcave(transformed1(1:2,:));
                if transfQ~=4
                   countEqualQ = countEqualQ+1;
                   continue;
                else
                    fprintf('iter: %i, Found %i inliers \n',p,length(inlier1));
                    Pairs{p}=pairs;
                    inlrNum(p) = length(inlier1);
                    error(p) = sum(dist(inlier1));
                    fLib{p} =f1;

                end
            end

        end
    end

    % Choose the coef with the most inliers and least error
    idx_all=find(inlrNum==max(inlrNum));
    [~,idx1] = min(error(idx_all));
    idx=idx_all(idx1);
    f = fLib{idx};
    if isempty(f)
        fprintf('No valid homography matrix has been estimated\n');
        f_final = [];
    %     fLib = [];
    %     inlierIdx = [];
    %     pairs = [];
    %     dist = [];
    %     idx = [];
    %     timesAccepted = -1;
        return;
    end
    % dist = funcDist(f,x,y);
    dist1=[];dist2=[];
    pairs1=[];pairs2=[];
    if ~isempty(pts1T1) && ~isempty(pts2T1)
        [dist1,pairs1] = funcDist(f,x(:,1:length(pts1T1)),y(:,1:length(pts2T1)));
    end
    [dist2,pairs2] = funcDist(f,x(:,length(pts1T1)+1:end),y(:,length(pts2T1)+1:end));
    pairs2 = [length(pts1T1)+pairs2(:,1) length(pts2T1)+pairs2(:,2)];
    dist = [dist1 dist2];
    pp1 = [pairs1;pairs2];

    inlierIdx = find(dist < thDist);
    pairs=pp1(inlierIdx,:);
    f_final = funcFindF(x(:,pairs(:,1)),y(:,pairs(:,2)));
    dist = funcDist(f_final,x,y);
    inlierIdx = find(dist < thDist);
    dist=dist(inlierIdx);
    % Calculate Q value for transformed image using f_final
    [~,~,~,transformed1]=checkConvHull(im1,f_final);
    selected_transfQ = checkConvexOrConcave(transformed1(1:2,:));

    if length(inlierIdx)<4 || isempty(f_final)
        fprintf('Not enough inliers\n');
        f_final = [];
    %     fLib = [];
    %     inlierIdx = [];
    %     pairs = [];
    %     dist = [];
    %     idx = [];
    %     timesAccepted = -1;
        return;
    end
    
else
    funcFindF = varargin{4};
    funcDist = varargin{5};
    im1 = varargin{8};
    iterNum = varargin{3}.iterNum;
    thDist = varargin{3}.thDist;
    nA = varargin{6}; nB = varargin{7};
    x = varargin{1};
    y = varargin{2};
    inlrNum = zeros(1,iterNum);
    error=zeros(1,iterNum)+1e5;
    fLib = cell(1,iterNum);
    Pairs={};
    cConv=0;
    timesAccepted=0;
    bestIterConv = 0;
    countEqualQ = 0;
    selected_transfQ = -1;
    for p = 1:iterNum
        % 1. fit using  random points
        [nA1,nB1,~,~] = getRandIndex(nA,nB);
        ptsSet1 = x(:,nB1);
        ptsSet2 = y(:,nA1);
        
        % Check using checkConvexOrConcave and either continue if both ans are
        % equal or continue and select new 4 points 
        [an1,~]=checkConvexOrConcave(ptsSet1);

        [an2,~]=checkConvexOrConcave(ptsSet2);

        bestIterConv = bestIterConv+1;

        if an1~=an2
            continue;
        end

        f1 = funcFindF(ptsSet1,ptsSet2);

        if ~isempty(f1)
            dist=[]; pairs=[];
            % 2. count the inliers, if more than thInlr, refit; else iterate
            if ~isempty(x) && ~isempty(y)
                [dist,pairs] = funcDist(f1,x,y);
            end
            
            inlier1 = find(dist < thDist);
            timesAccepted = timesAccepted+1;

            if length(inlier1)>= 6

                [~,~,~,transformed1]=checkConvHull(im1,f1);
                transfQ = checkConvexOrConcave(transformed1(1:2,:));
                if transfQ~=4
                   countEqualQ = countEqualQ+1;
                   continue;
                else
                    fprintf('iter: %i, Found %i inliers \n',p,length(inlier1));
                    Pairs{p}=pairs;
                    inlrNum(p) = length(inlier1);
                    error(p) = sum(dist(inlier1));
                    fLib{p} =f1;

                end
            end

        end
    end

    % Choose the coef with the most inliers and least error
    idx_all=find(inlrNum==max(inlrNum));
    [~,idx1] = min(error(idx_all));
    idx=idx_all(idx1);
    f = fLib{idx};
    if isempty(f)
        fprintf('No valid homography matrix has been estimated\n');
        f_final = [];
    %     fLib = [];
    %     inlierIdx = [];
    %     pairs = [];
    %     dist = [];
    %     idx = [];
    %     timesAccepted = -1;
        return;
    end
    % dist = funcDist(f,x,y);
    dist=[];
    pairs=[];
    if ~isempty(x) && ~isempty(y)
        [dist,pairs] = funcDist(f,x,y);
    end
    pp1 = pairs;

    inlierIdx = find(dist < thDist);
    pairs=pp1(inlierIdx,:);
    f_final = funcFindF(x(:,pairs(:,1)),y(:,pairs(:,2)));
    dist = funcDist(f_final,x,y);
    inlierIdx = find(dist < thDist);
    dist=dist(inlierIdx);
    % Calculate Q value for transformed image using f_final
    [~,~,~,transformed1]=checkConvHull(im1,f_final);
    selected_transfQ = checkConvexOrConcave(transformed1(1:2,:));

    if length(inlierIdx)<4 || isempty(f_final)
        fprintf('Not enough inliers\n');
        f_final = [];
    %     fLib = [];
    %     inlierIdx = [];
    %     pairs = [];
    %     dist = [];
    %     idx = [];
    %     timesAccepted = -1;
        return;
    end
    
    return;
end
end
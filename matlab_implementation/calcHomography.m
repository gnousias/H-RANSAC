% Varargin: 10 input arguments (for labeled data) or 8 input arguments 
%           (for unlabeled data)
function [H,C] = calcHomography(varargin)
    close all;
    pr = 0.95;
    C=[];
    if nargin==8
        
        niter = calcIterations(varargin{5},varargin{6},pr,1);
        im1 = imread(varargin{7}); % Candidate image
        im2 = imread(varargin{8}); % Master or reference image 

        H = findHomography(varargin{3},varargin{4},varargin{1},varargin{2},niter,varargin{5},varargin{6},im2);
        if isempty(H)
            fprintf('No valid homography or not enough iterations');
            return;
        else
            t = projective2d(H');

            rf = imref2d(size(im2,1:2));

            outIm = imwarp(im1,t,'OutputView',rf);
            C = imfuse(im2,outIm);
            figure; imshow(C);
        end
        
    elseif nargin==6
        niter = calcIterations(varargin{3},varargin{4},pr,0);
        im1 = imread(varargin{5}); % Candidate image
        im2 = imread(varargin{6}); % Master or reference image
        
        H = findHomography(varargin{2},varargin{1},niter,varargin{3},varargin{4},im2);
        if isempty(H)
            fprintf('No valid homography or not enough iterations\n');
            return;
        else
            t = projective2d(H');

            rf = imref2d(size(im2,1:2));

            outIm = imwarp(im2,t,'OutputView',rf);
            C = imfuse(im1,outIm);
            figure; imshow(C);
        end
    else
        fprintf('Invalid number of input arguments');
        return;
    end
end
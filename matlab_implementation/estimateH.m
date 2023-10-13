% Estimate homography matrix using H-RANSAC
% input: two txt filenames containing points and optionally labels,
%        (first file is the points of candidate frame and second one 
%         is the reference frame)
%        two image filenames of corresponding images 
% output: estimated homography matrix and transformed image
% ----------------------------------------- %
% Authors: Nousias G.(gnousias@uth.gr), Delibasis K.
% October 2023
% Implemented using MATLAB R2021a
% ----------------------------------------- %

function [H, tImage]=estimateH(txtFileA, txtFileB, imageFileA, imageFileB)
    t1 = readtable(txtFileA);
    t2 = readtable(txtFileB);
    if size(t1,2)>2 & size(t2,2)>2
        [team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,labelTeam1F1,labelTeam1F2,labelTeam2F1,labelTeam2F2] = decodeTxtFiles(t1,t2);
        % Two sets of points with corresponding label
        if sum(min(nA,nB))>4
            [H,tImage] = calcHomography(team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,imageFileB,imageFileA);
        else
            fprintf('Not enough points to find homography');
            return;
        end    
        
    % Two sets of points unlabeled
    else
        t1 = cell2mat(table2cell(t1)); t1=t1';
        t2 = cell2mat(table2cell(t2)); t2=t2';
        nA = length(t1);
        nB = length(t2);
        if nA<4 | nB<4
            fprintf('Homography matrix can not be estimated.\n Few points on one set');
            return;
        end
        
        % Calculate homography matrix H
        x = t1;
        y = t2;
        [H,tImage] = calcHomography(x,y,nA,nB,imageFileA,imageFileB);
    end
end
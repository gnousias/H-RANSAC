% Estimate homography matrix using H-RANSAC
% input: two JSON files containing points and optionally labels in
%        specific format, (first file is the reference frame and second 
%        one is the candidate frame)
%        two image filenames of corresponding images 
% output: estimated homography matrix and transformed image
% ----------------------------------------- %
% Authors: Nousias G.(gnousias@uth.gr), Delibasis K.
% October 2023
% Implemented using MATLAB R2021a
% ----------------------------------------- %

function [H, tImage]=estimateH_json(jsonFileA, jsonFileB, imageFileA, imageFileB)
    n1 = decodeJson(jsonFileA);
    n2 = decodeJson(jsonFileB);
    game = 'AEK_VS_OFI';
    if sum(n2)>4 & ~contains(jsonFileA,jsonFileB)
        if sum(min(n1,n2))>4
            [team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,allPoints,labelTeam1F1,labelTeam1F2,labelTeam2F1,labelTeam2F2] = decodeJsonFiles(jsonFileA,jsonFileB,game);
            % Two sets of points with corresponding label
            [H,tImage] = calcHomography(team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,imageFileB,imageFileA);
        else
            fprintf('Not enough points to find homography');
            return;
        end    
    else
        fprintf('Not enough points or implausible pair of images..\n');
        fprintf('Check the format of the JSON files and if the images can be paired\n');
    end
end
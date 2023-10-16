% Script using H_RANSAC implementation for homography estimation

% Example with labeled data, using the corresponding txt file and image
% pairs
[H_1, tImage_1]=estimateH('pointsA_1.2.txt', 'pointsB_1.3.txt','0_00_41.260000_AEK_VS_OFI-FIRST_HALF-1.2_MASTER-Preferred.jpg', '0_00_41.260000_AEK_VS_OFI-FIRST_HALF-1.3_CLOSE_UP-.jpg');

% Example with unlabeled data, using the corresponding txt file and image
% pairs
[H_2, tImage_2]=estimateH('pointsA_unlabeled.txt', 'pointsB_unlabeled.txt','0_00_41.260000_AEK_VS_OFI-FIRST_HALF-1.2_MASTER-Preferred.jpg', '0_00_41.260000_AEK_VS_OFI-FIRST_HALF-1.3_CLOSE_UP-.jpg');
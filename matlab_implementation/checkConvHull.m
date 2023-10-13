function [a,a2,k,transformed1]=checkConvHull(im1,H)

cornersMin = [1,1;1,size(im1,1);size(im1,2),size(im1,1);size(im1,2),1];

transformed1 = H*[cornersMin';1 1 1 1];
transformed1(1,:) = transformed1(1,:)./transformed1(3,:);
transformed1(2,:) = transformed1(2,:)./transformed1(3,:);

a = polyarea(transformed1(1,:),transformed1(2,:));

k = convhull(transformed1(1,:),transformed1(2,:));
a2 = polyarea(transformed1(1,k),transformed1(2,k));

% figure;
% imshow(im1); hold on;
% plot(transformed1(1,:),transformed1(2,:),LineWidth=3);
% plot(transformed1(1,k),transformed1(2,k),'r',LineWidth=3);
% figure;
% plot(transformed1(1,:),transformed1(2,:),LineWidth=3);hold on;
% plot(transformed1(1,k),transformed1(2,k),'r',LineWidth=3);

end
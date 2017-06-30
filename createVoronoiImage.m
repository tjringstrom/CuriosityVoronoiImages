function [ imageSet ] = createVoronoiImage( image, cellData )
%CREATEVORONOIIMAGESET Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames(cellData);
% I = imread(filename);
I = image;
I = imresize(I,1);
I = double(I);

[m,n,r] = size(I);

imageSet = cell(1,length(fields)); % Set of images at each resolution 
vorI = zeros(size(I));
% tic;
for s=1:length(fields)
    cellPixels = cellData.(fields{s}).cellPixels;
    keys = cell2mat(cellPixels.keys);
    for k=keys
        linpnts = cellPixels(k);
        lindex = bsxfun(@plus,linpnts,(m*n*(0:r-1)));
        rgb = mean(I(lindex));
        vorI(lindex) = repmat(rgb,[size(linpnts,1),1]);
    end
    imageSet{s} = vorI;
end

% toc
% vorI = uint8(imageSet{1});
% figure
% imshow(uint8(imageSet{1}));
% imwrite(vorI,'vorImg.jpg');
% save('imageSet','imageSet');
% disp('Image Set Created');


end


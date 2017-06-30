function [imageData] = vorify( I, spacing, fieldName, sigma )

% fieldName is the name of the field given for the data structure
% containing the voronoi image.  The purpose of this field is to
% distinguish varying degrees of resolution for the same image.
% For clarity, the field name should specify the level of resolution.

% resolution is the number of times we divide the image axis when dropping
% down voronoi centroids
% sigma is the variance of the noise that is added over each voronoi
% centroid

% I = importdata(filename); % Choose File
imSize = size(I);
cellData = getVoronoiTemplates(spacing, fieldName, imSize(1:2), sigma);
imageData = createVoronoiImage(I,cellData);
imageData = imageData{1};
% imwrite(imageSet{1},'Phase1Out/vorImg.jpg');

end


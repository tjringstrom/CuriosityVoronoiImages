function cellData = getVoronoiTemplates(spacing, fieldName, imSize, sigma)
% This function generates n Voronoi Templates for each size specified in
% the input array. The size associated template is the number of divisions
% points along the x and y axis over the grid.

% spacing is the number of divisions along each of the image axis for
% creating spaced vornoi centroids
% sigma is the variance of the noise

cellData = struct(fieldName,[]);
fields = fieldnames(cellData);

map = containers.Map('KeyType', 'double', 'ValueType', 'any'); % Map of centroid linear ind to linear indicies of pixels in vor cell
[nY,nX] = deal(imSize(1),imSize(2));
% sigma = 40; % Variance Used in normrnd, might want to decrease with bigger div

% Grid Without Noise
[gX,gY] = meshgrid(1:(nX-1)/(spacing+1):nX,1:(nY-1)/(spacing+1):nY);

% Add Noise
xNoise = round(min(max(normrnd(gX,sigma),1),nX));
% The purpose of the -10000 and the *100 below is so that the grid extends off the domain of the image and allows the outer voronoi cells to extend outward.  Otherwise the voronoi cells won't cover the edges.
xNoise = [zeros(size(xNoise,1),1)-10000,xNoise,zeros(size(xNoise,1),1)+imSize(2)*100]; 
yNoise = round(min(max(normrnd(gY,sigma),1),nY));
yNoise = [zeros(size(yNoise,1),1)'-10000;yNoise;zeros(size(xNoise,1),1)'+imSize(1)*100];
vorPoints = [xNoise(:),yNoise(:)]; %(x,y)
vorPoints = unique(vorPoints,'rows');
% scatter(xNoise(:),yNoise(:))
% xlim([0,32])
% ylim([0,32])
% scatter(gX(:),gY(:))
% xlim([0,32])
% ylim([0,32])

% V = voronoi(xNoise,yNoise);
% V = number of voronoi vertacies (where lines meet, not centroids)
% C = list of centroid
[V,C] = voronoin(vorPoints);
r1 = intersect(find(vorPoints(:,1)>0),find(vorPoints(:,2)>0));
r2 = intersect(find(vorPoints(:,1)<max(imSize)),find(vorPoints(:,2)<max(imSize)));
r = intersect(r2,r1); % This is the indicies of valid vor centroids
validCentroids = vorPoints(r,:);
validCentroids = validCentroids(:,[2,1]); % put in (y,x) form
cellData.(fieldName).centroids = validCentroids;
cellData.(fieldName).centroidIndicies = r;


% Iterate over each voronoi cell in C, and get set points inside    
for i=1:length(C)
%     disp(['Cell: ',num2str(i),'/',num2str(length(C))]);
    polyPnts = V(C{i},:);
    centroid = vorPoints(i,[2,1]); % (y,x)
    if(~any(any(isinf(polyPnts)))) && ~(any(centroid < 1) || any(centroid > imSize))

        % Bounding Box that the Vor polygon fits into
        % Points in the box are kept if they are in polygon
        xmin = max(1,floor(min(polyPnts(:,1))));
        xmax = min(ceil(max(polyPnts(:,1))),imSize(2));
        ymin = max(1,floor(min(polyPnts(:,2))));
        ymax = min(ceil(max(polyPnts(:,2))),imSize(1));
        [xb,yb] = meshgrid(xmin:xmax,ymin:ymax);
        testPixels = [xb(:),yb(:)];
%             inPoints = testPixels(inpolygon(xb(:),yb(:),polyPnts(:,1),polyPnts(:,2)),:);
        inPoints = testPixels(inpoly(testPixels,polyPnts),:);
        linpnts = sub2ind(imSize,inPoints(:,2),inPoints(:,1));
        map(sub2ind(imSize,centroid(1),centroid(2))) = linpnts;
    end
end
cellData.(fieldName).cellPixels = map;


% save('cellData','cellData');
% disp('Done Forming Templates');

end

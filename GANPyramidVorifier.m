saveFile = 'GANpyramidOut';
fileID = fopen('GANpyramid.txt','w');
formatSpec = '%s\n';
imageList = {};

str = {'cifar-10-batches-mat/*.jpg'};
filebatchNum = 1;
cifarData = load(strcat('cifar-10-batches-mat/data_batch_',num2str(filebatchNum),'.mat'));

resolution = [8,16]; % The levels of resolution for each image.  The number specifies how many voronoi centroids fall along each axis.
fields = {'A','B','C','D'};

VorGANData = zeros(size(cifarData.data,1)*3,size(cifarData.data,2));
% Vorifiy Images
count = 1;
for i = 1:size(cifarData.data,1)
    disp(['Image: ',num2str(i),'/',num2str(size(cifarData.data,1))]);
    filename = strcat('batch',num2str(filebatchNum),'_img',num2str(i));
    img = reshape(cifarData.data(i,:),[32,32,3]);   
    for j = 1:length(resolution)
        vorImage = uint8(vorify(img, resolution(j),fields{j}, 0.3)); 
%         imwrite(uint8(vorImage),strcat(saveFile,'/',num2str(filename),'_',num2str(resolution(j)),'.jpg'),'jpg'); 
        VorGANData(count,:) = vorImage(:);
        count = count+1;
    end
%     imwrite(img,strcat(saveFile,'/',num2str(filename),'_','Full','.jpg'),'jpg'); 
    VorGANData(count,:) = vorImage(:);
    count = count+1;
end
save('VorGANData','VorGANData');
% csvwrite('imageIdStrings.txt',imageList);
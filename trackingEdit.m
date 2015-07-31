%trackingFaster(hopefully)

vid= VideoReader('Cells_Exposed_Real_Time_10fps_UVSpotlight.avi');

height= vid.Height;
width= vid.Width;
numFrames= 2;

%3-D matrix of frames grayscale
frames= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frames(:,:,k)= read(vid,k);
end

%initializations
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
cc= struct('Connectivity',zeros(1,numFrames),'ImageSize', ...
    zeros(1,numFrames),'NumObjects',zeros(1,numFrames),'PixelIdxList', ...
    zeros(1,numFrames));
cellData= cell(1,numFrames);
track= cell(1,numFrames);

%Creating binary bw video one frame at a time
background(:,:,:)= imopen(frames(:,:,:),strel('disk',10));
vid2(:,:,:)= frames(:,:,:) - background(:,:,:);
for k=1:numFrames    
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
    bw(:,:,k)= bwareaopen(bw(:,:,k),90);
    cc(k) = bwconncomp(bw(:,:,k), 8);
    y(k)= cc(k).NumObjects;
end

x= 1:numFrames;
cellData(:)= {regionprops(cc(:),'basic')};

for k=1:numFrames
    if k==1
        track{k}= cellData{k};
    else
        [numTracks,~]= size(track{k-1});
        for a=1:y(k)
            dist= inf;
            for b=1:numTracks
                newDist= sqrt((track{k-1}(b).Centroid(1)- ...
                    cellData{k}(a).Centroid(1))^2+ ...
                    (track{k-1}(b).Centroid(2)- ...
                    cellData{k}(a).Centroid(2))^2);
                if newDist<dist
                    if track{k-1}(b).Area== 0;
                        dist= newDist;
                        bact= a;
                    end
                end
            end
        end
    end
end

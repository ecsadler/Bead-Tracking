%trackingSimple

vid= VideoReader('Cells_Exposed_Real_Time_10fps_UVSpotlight.avi');

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;
%numFrames= 56;

%3-D matrix of frames grayscale
frames= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frames(:,:,k)= read(vid,k);
end
%frames= beforeLight;

%initializations
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
cc= struct('Connectivity',zeros(1,numFrames),'ImageSize', ...
    zeros(1,numFrames),'NumObjects',zeros(1,numFrames),'PixelIdxList', ...
    zeros(1,numFrames));
x= zeros(1,numFrames);
y= zeros(1,numFrames);
cellData= cell(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);
lines= cell(1,numFrames);
draw= zeros(height,width,3,numFrames,'uint8');
draw(:,:,:,1)= repmat(frames(:,:,1),[1 1 3]);
ended= zeros(1,100);

for k=1:numFrames %Loop that goes through each frame
    
    %Creating binary bw video one frame at a time
    background(:,:,k)= imopen(frames(:,:,k),strel('disk',10));
    vid2(:,:,k)= frames(:,:,k) - background(:,:,k);
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
    bw(:,:,k)= bwareaopen(bw(:,:,k),90);
    cc(k) = bwconncomp(bw(:,:,k), 8);
    
    %x is a vector of each frame number (represents time on graph)
    x(k)= k;
    
    %y is a vector with the number of cells in each frame
    y(k)= cc(k).NumObjects;
    
    %cellData is a cell array of structure arrays for the cells in each
    %frame
    cellData(k)= {regionprops(cc(k),'basic')};
end

%setting up the first points in track and lines
track{1}= cellData{1};
[numTracks,~]= size(track{1});
for k=1:numFrames
    lines{k}=cell(1,numTracks);
end

for a=1:y(1)
    for b=1:numFrames
        lines{b}{a}= track{1}(a).Centroid;
    end
end

for k=2:numFrames
        
    [numTracks,~]= size(track{k-1});
        
    %Setting up the initial track
        
    %Loop goes from 1 to the number of tracks present in the previous 
    %frame
    for a=1:numTracks
            
        if ended(a)~=1
            %initializing distance
            dist= inf;
            
            %Loop goes from 1 to the number of cells in the current frame
            for b=1:y(k)
                
                %finding distance between two centroids
                newDist= sqrt((track{k-1}(a).Centroid(1)- ...
                    cellData{k}(b).Centroid(1))^2+ ...
                    (track{k-1}(a).Centroid(2)- ...
                    cellData{k}(b).Centroid(2))^2);
                
                %if the cell is closer than the previously tested cells 
                if newDist<dist
                    %closest distance so far is the one just calculated
                    dist= newDist;
                    bact= b;
                end
            end
          
            %setting track so that track{k}(a) is the cell closest to that 
            %in track{k-1}(a,1)
            track{k}(a,1)= cellData{k}(bact);
            distCell{k}(a)= dist;
        end
    end
        
    [numTracks,~]= size(track{k});
        
    for a=1:numTracks
        if distCell{k}(a)<50 && ended(a)~=1
            for b=k:numFrames
                lines{b}{a}(k*2-1)= track{k}(a).Centroid(1);
                lines{b}{a}(k*2)= track{k}(a).Centroid(2);
            end
        else
            ended(a)=1;
            if k==2
                for b=k:numFrames
                    lines{b}{a}= [0,0,0,0];
                end
            end
        end
    end
        
    draw(:,:,:,k)= insertShape(frames(:,:,k),'Line',lines{k});
end

implay(draw);
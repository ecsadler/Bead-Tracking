%trackingAndPickUpNew

vid= VideoReader('SM_Cells_Exposed_Halfway_20s_Take2.avi');

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;
%numFrames= 105;

%3-D matrix of frames grayscale
frames= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frames(:,:,k)= read(vid,k);
end

frames= frames(:,:,106:200);
[~,~,numFrames]= size(frames);

%initializations
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
cc= struct('Connectivity',zeros(1,numFrames),'ImageSize', ...
    zeros(1,numFrames),'NumObjects',zeros(1,numFrames),'PixelIdxList', ...
    zeros(1,numFrames));
y= zeros(1,numFrames);
cellData= cell(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);
lines= cell(1,numFrames);
draw= zeros(height,width,3,numFrames,'uint8');
draw(:,:,:,1)= repmat(frames(:,:,1),[1 1 3]);
ended= zeros(1,3000);

%Creating binary bw video
background(:,:,:)= imopen(frames(:,:,:),strel('disk',10));
vid2(:,:,:)= frames(:,:,:)-background(:,:,:);
for k=1:numFrames
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
end
bw(:,:,:)= bwareaopen(bw(:,:,:),90);
for k=1:numFrames
    cc(k)= bwconncomp(bw(:,:,k),8);
end

%x is a vector of each frame number (represents time on graph)
x= (1:1:numFrames);

for k=1:numFrames %Loop that goes through each frame
    
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

[numTracks,~]= size(track{1});

for k=2:numFrames
        
    %[numTracks,~]= size(track{k-1});
        
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
        [~,numCoord]= size(lines{k}{a});
        if distCell{k}(a)<50 && ended(a)~=1
            for b=k:numFrames
                lines{b}{a}(numCoord+1)= track{k}(a).Centroid(1);
                lines{b}{a}(numCoord+2)= track{k}(a).Centroid(2);
            end
        elseif ended(a)~=1
            ended(a)=1;
            if numCoord==2
                for b=k:numFrames
                    lines{b}{a}= [0,0,0,0];
                end
            end
        end
    end
    
    %Creating a new track if a cell was not matched to a previous one
    
    [numTracks,~]= size(track{k});
    z= numTracks;
    
    %Loop from 1 to number of objects in current frame
    for a= 1:y(k)
        
        
        %Loop from 1 to number of tracks as of previous frame
        for b= 1:numTracks
            
            [~,numCoord]= size(lines{k}{b});
            %If the cell is already set in a track
            if cellData{k}(a).Area==track{k}(b).Area
                break
            %If the cell is not found in any of the tracks
            elseif b==numTracks
                %Create a new track starting with this cell
                track{k}(z+1)= cellData{k}(a);
                for c=k+1:numFrames    
                    lines{c}{z+1}= ...
                        [track{k}(z+1).Centroid(1), ...
                        track{k}(z+1).Centroid(2)];
                end
                z= z+1;
            end
        end
    end
    
    [numTracks,~]= size(track{k});
    
    
    draw(:,:,:,k)= insertShape(frames(:,:,k),'Line',lines{k});
end

implay(draw);
%tracking

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
x= zeros(1,numFrames);
y= zeros(1,numFrames);
cellData= cell(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);

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
    
    %if it is the first frame
    if k==1
        track{k}= cellData{k};
    
    %if it is not the first frame
    else
        
        [numTracks,~]= size(track{k-1});
            
        %Setting up the initial track
        
        %Loop goes from 1 to the number of tracks present in the previous 
        %frame
        for a=1:numTracks
            %initializing distance
            dist= inf;
            
            %Loop goes from 1 to the number of cells in the current frame
            for b=1:y(k)
                
                %if the track is not one that has already ended
                if track{k-1}(a).Area~= 0;
                    %finding distance between two centroids
                    newDist= sqrt((track{k-1}(a).Centroid(1)- ...
                        cellData{k}(b).Centroid(1))^2+ ...
                        (track{k-1}(a).Centroid(2)- ...
                        cellData{k}(b).Centroid(2))^2);
                end
                
                %if the cell is closer than the previously tested cells 
                if newDist<dist
                    %closest distance so far is the one just calculated
                    dist= newDist;
                    bact= b;
                end
            end
            
            %setting track so that track{k}(a) is the cell closest to that 
            %in track{k-1}(a)
            track{k}(a)= cellData{k}(bact);
            distCell{k}(a)= dist;
        end
        
        %In case a cell gets placed in track more than once
        
        %initializing z
        z=1;
        
        %so that the loop will run through and check again if any new
        %tracks get set
        while z>0
            %initializing z again
            z= 0;
            
            %Loop goes from 1 to the number of tracks as of previous frame
            for a=1:numTracks-1
            
                %Loop goes from 1 to the number of tracks as of previous
                %frame
                for b=a+1:numTracks
                
                    %If a cell in the current frame was the closest to two 
                    %cells in the previous frame
                    if track{k}(a).Area~=0 && ... 
                            track{k}(a).Area== ...
                            track{k}(b).Area 
                        
                        %setting z so while loop will repeat
                        z= 1;
                        %Deleting the cell from the track of the cell it's
                        %farther away from
                        %If the cell was closer to the first of the two
                        %tracks
                        if distCell{k}(a)<distCell{k}(b)
                            %remove the cell from the second track
                            track{k}(b)= struct('Area',0,'Centroid', ...
                                zeros(1,2),'BoundingBox',zeros(1,4));
                            %initialize dist
                            dist= inf;
                            
                            %Loop from 1 to the number of cells in the
                            %current frame
                            for c=1:y(k)
                                %finding distance between two centroids
                                newDist= sqrt((track{k-1}(b).Centroid(1)- ...
                                    cellData{k}(c).Centroid(1))^2+ ...
                                    (track{k-1}(b).Centroid(2)- ...
                                    cellData{k}(c).Centroid(2))^2);
                                
                                %If the distance just found is shorter than
                                %the previous one found and greater than
                                %the distance the track was from original
                                %cell chosen
                                if newDist<dist && newDist>dist2
                                    %closest cell (other than the cell(s)
                                    %that are closer to a different track
                                    %is the one just checked
                                    dist= newDist;
                                    bact= c;
                                end
                            end
                            %setting the new closest cell in the track
                            track{k}(b)= cellData{k}(c);
                            distCell{k}(b)= dist;
                            %setting z to 1 so the loop will be repeated to
                            %check that the new cell isn't actually closer
                            %to a different track as well
                        else %same as the above if but in the case where
                             %second track was closer to the cell
                            track{k}(a)= struct('Area',0,'Centroid', ...
                                zeros(1,2),'BoundingBox',zeros(1,4));
                            dist= inf;
                            for c=1:y(k)
                                if track{k-1}(a).Area~=0
                                    newDist= sqrt((track{k-1}(a).Centroid(1)- ...
                                        cellData{k}(c).Centroid(1))^2+ ...
                                        (track{k-1}(a).Centroid(2)- ...
                                        cellData{k}(c).Centroid(2))^2);
                                end
                                if newDist<dist && newDist>dist2
                                    dist= newDist;
                                    bact= c;
                                end
                            end
                            track{k}(a)= cellData{k}(c);
                            distCell{k}(a)= dist;
                        end
                    end
                end
            end
        end
        
        %Creating a new track if a cell was not matched to a previous one
        
        %Loop from 1 to number of objects in current frame
        for a= 1:y(k)
            %initializing z
            z= 1;
            
            %while z is greater than 0
            while z>0
            
                %Loop from 1 to number of tracks as of previous frame
                for b= 1:numTracks
                    
                    %If the cell is already set in a track
                    if cellData{k}(a)==track{k}(b)
                        %set z=0
                        z= 0;
                    %If the cell is not found in any of the tracks
                    elseif a==y(k) && b==y(k-1)
                        %Create a new track starting with this cell
                        [newNumTracks,~]= size(track{k});
                        track{k}(newNumTracks+1)= cellData{k}(a);
                        %set z=0
                        z= 0;
                    end
                end
            end
        end
    end
end
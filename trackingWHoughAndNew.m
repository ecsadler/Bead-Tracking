%trackingWHoughAndNew

%initializations
y= zeros(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);
ended= zeros(1,100000);
draw= zeros(height,width,3,numFrames,'uint8');
[numTracks,~]= size(centersCell{1});
lines= cell(1,numFrames);
draw(:,:,:,1)= repmat(im(:,:,1),[1 1 3]);

for k=1:numFrames
    lines{k}=cell(1,numTracks);
    [y(k),~]= size(centersCell{k});
end

track{1}= centersCell{1};
for a=1:y(1)
    for b=1:numFrames
        lines{b}{a}= track{1}(a,:);
    end
end

[numTracks,~]= size(track{1});

for k=2:numFrames
        
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
                newDist= sqrt((track{k-1}(a,1)-centersCell{k}(b,1))^2+ ...
                    (track{k-1}(a,2)-centersCell{k}(b,2))^2);
                    
                %if the cell is closer than the previously tested cells 
                if newDist<dist
                    %closest distance so far is the one just calculated
                    dist= newDist;
                    bact= b;
                end
            end
                
            %setting track so that track{k}(a) is the cell closest to that 
            %in track{k-1}(a)
                track{k}(a,:)= centersCell{k}(bact,:);
                distCell{k}(a)= dist;
        else
            track{k}(a,:)= [0,0];
        end
    end
        
    [numTracks,~]= size(track{k});
        
    for a=1:numTracks
        [~,numCoord]= size(lines{k}{a});
        if ended(a)~=1 && distCell{k}(a)<10 
            for b=k:numFrames
                lines{b}{a}(numCoord+1)= track{k}(a,1);
                lines{b}{a}(numCoord+2)= track{k}(a,2);
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
        
        %[numTracks,~]= size(track{k});
        
        %Loop from 1 to number of tracks as of previous frame
        for b= 1:numTracks
            
            [~,numCoord]= size(lines{k}{b});
            %If the cell is already set in a line
            if centersCell{k}(a,1)==lines{k}{b}(numCoord-1) && ...
                    centersCell{k}(a,2)==lines{k}{b}(numCoord)
                break
            %If the cell is not found in any of the lines
            elseif b==numTracks
                %Create a new track starting with this cell
                track{1,k}(z+1,:)= centersCell{1,k}(a,:);
                for c=k+1:numFrames    
                    lines{c}{z+1}= [track{k}(z+1,1), ...
                        track{k}(z+1,2)];
                end
                z= z+1;
            end
        end
    end
    
    [numTracks,~]= size(track{k});
    
    draw(:,:,:,k)= insertShape(im(:,:,k),'Line',lines{k});
end

implay(draw);

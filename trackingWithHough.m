
%initializations
y= zeros(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);
ended= zeros(1,100);
draw= zeros(height,width,3,numFrames,'uint8');
[numTracks,~]= size(centersCell{1});
lines= cell(1,numFrames);
draw(:,:,:,1)= repmat(im(:,:,1),[1 1 3]);

for k=1:numFrames
    lines{k}=cell(1,numTracks);
end

for k=1:numFrames
    [y(k),~]= size(centersCell{k});
    
    %if it is the first frame
    if k==1
        track{k}= centersCell{k};
        for a=1:y(k)
            for b=1:numFrames
                lines{b}{a}= track{1}(a,:);
            end
        end
    %if it is not the first frame
    else
        
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
            end
        end
        
        [numTracks,~]= size(track{k});
        
        for a=1:numTracks
            if distCell{k}(a)<50 && ended(a)~=1
                for b=k:numFrames
                    lines{b}{a}(k*2-1)= track{k}(a,1);
                    lines{b}{a}(k*2)= track{k}(a,2);
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
        
        draw(:,:,:,k)= insertShape(im(:,:,k),'Line',lines{k});
    end
end

implay(draw);
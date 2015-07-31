%Next step: Split script up so that it looks at band 2 before light and
%after light separately (UPDATE: done, as long as they are separated first. 
%Also, look at how the number of cells entering or leaving each band 
%changes over time (done, figure out how to keep each figure up together). 
%Also, turn this into a function with variables (still need to do that, try
%to make it so that this can be run immediately after makingBands instead 
%of justBand2).

%Note that this script is currently edited assuming justBand2 is run
%immediately before it. Parameters may be placed so that it will be used
%with other bands, but that has not been done yet.

%initializations
[height,width,numFrames]= size(cropVid);
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
x= zeros(1,numFrames);
y= zeros(1,numFrames);
cellAreas= {};
innerBound= zeros(1,numFrames);
outerBound= zeros(1,numFrames);
entering1From2Tot= 0;
entering2From1Tot= 0;
entering3From2Tot= 0;
entering2From3Tot= 0;
entering1From2= zeros(1,numFrames);
entering2From1= zeros(1,numFrames);
entering3From2= zeros(1,numFrames);
entering2From3= zeros(1,numFrames);
cellOnInnerEdge= cell(1,numFrames);
cellOnOuterEdge= cell(1,numFrames);

for k=1:numFrames %Loop that goes through each frame
   
    %Creating binary bw video one frame at a time
    background(:,:,k)= imopen(cropVid(:,:,k),strel('disk',10));
    vid2(:,:,k)= cropVid(:,:,k) - background(:,:,k);
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
    
    %c and d are used as counters for the cells on the inner and outer
    %edges
    c= 1;
    d= 1;
    
    %Loop has a go from 1 to the number of objects in the current frame
    for a=1:y(k)
        
        %if any corner of the bounding box of a cell is within the inner
        %circle that was cut out of the band, it is considered on the inner
        %edge
        if sqrt((201-cellData{k}(a).BoundingBox(1))^2+ ...
                (201-cellData{k}(a).BoundingBox(2))^2)<=r/2 ... 
                || sqrt((201-cellData{k}(a).BoundingBox(1))^2+ ...
                (201-cellData{k}(a).BoundingBox(2)+ ...
                cellData{k}(a).BoundingBox(4))^2)<=r/2 ...
                || sqrt((201-cellData{k}(a).BoundingBox(1)- ...
                cellData{k}(a).BoundingBox(3))^2+ ... 
                (201-cellData{k}(a).BoundingBox(2))^2)<=r/2 ...
                || sqrt((201-cellData{k}(a).BoundingBox(1)- ...
                cellData{k}(a).BoundingBox(3))^2+ ...
                (201-cellData{k}(a).BoundingBox(2)+ ...
                cellData{k}(a).BoundingBox(4))^2)<=r/2
            %vector showing how many cells are on the inner edge for each 
            %frame
            innerBound(k)= innerBound(k)+1; 
            %cell array of the cells on the inner edge in the current frame
            cellOnInnerEdge{k}(c)= {cellData{k}(a)}; 
            %counter
            c= c+1;
        
        %if any corner of the cell's bounding box is outside the circle
        %that makes up the band, it's considered on the outer edge
        elseif sqrt((201-cellData{k}(a).BoundingBox(1))^2+ ... 
                (201-cellData{k}(a).BoundingBox(2))^2)>=r ...
                || sqrt((201-cellData{k}(a).BoundingBox(1))^2+ ...
                (201-cellData{k}(a).BoundingBox(2)+ ...
                cellData{k}(a).BoundingBox(4))^2)>=r ...
                || sqrt((201-cellData{k}(a).BoundingBox(1)- ...
                cellData{k}(a).BoundingBox(3))^2+ ... 
                (201-cellData{k}(a).BoundingBox(2))^2)>=r ...
                || sqrt((201-cellData{k}(a).BoundingBox(1)- ...
                cellData{k}(a).BoundingBox(3))^2+ ...
                (201-cellData{k}(a).BoundingBox(2)+ ...
                cellData{k}(a).BoundingBox(4))^2)>=r
            %vector counting how many cells are on the outer edge in each
            %frame
            outerBound(k)= outerBound(k)+1;
            %cell array of the cells on the outer edge in the current frame
            cellOnOuterEdge{k}(d)= {cellData{k}(a)};
            %counter
            d= d+1;
        end
    end
    
    %if you are at least on frame 2 and there is at least 1 cell on the
    %inner edge
    if k>1 && innerBound(k)>1
        %initializing distance measurements
        dist= inf; 
        newDist= inf;
        
        %loop through the number of cells on the inner edge in frame
        for b=1:innerBound(k)
            
            %loop through the number of cells found in the previous frame
            for a=1:y(k-1)
                %finding distance between two centroids
                newDist= sqrt((cellOnInnerEdge{k}{b}.Centroid(1)- ...
                    cellData{k-1}(a).Centroid(1))^2+ ...
                    (cellOnInnerEdge{k}{b}.Centroid(2)- ...
                    cellData{k-1}(a).Centroid(2))^2);
                
                %if the new distance is smaller
                if newDist<dist
                    %numbers set assuming the object with the smaller
                    %distance was most likely the current object in the
                    %previous frame
                    dist= newDist;
                    cell= a;
                end
            end
            
            %if the object on the edge is closer to the center than it
            %was in the previous frame
            if sqrt((201-cellOnInnerEdge{k}{b}.Centroid(1))^2 ...
                    +(201-cellOnInnerEdge{k}{b}.Centroid(2))^2)< ...
                    sqrt((201-cellData{k-1}(cell).Centroid(1))^2+ ...
                    (201-cellData{k-1}(cell).Centroid(2))^2)
                %the object is considered to be entering band 1
                entering1From2Tot= entering1From2Tot+1;
                entering1From2(k)= entering1From2(k)+1;
            end
        end
    end
    %creates a cell array of the areas of the cells in each frame
    cellAreas(k)= {[cellData{k}.Area]};
end

%loop through the number of frames
for k= 1:numFrames
    
    %if the current frame is not the final frame, and there was at least
    %one cell on the inner boundary in this frame
    if k<numFrames && innerBound(k)>1
        %initializing distances
        dist= inf;
        newDist= inf;
        
        %loop through the number of cells found on the inner boundary in
        %the current frame
        for b=1:innerBound(k)
            
            %loop through the number of cells found in the next frame
            for a=1:y(k+1)
                %finding distance between two centroids
                newDist= sqrt((cellOnInnerEdge{k}{b}.Centroid(1)- ...
                    cellData{k+1}(a).Centroid(1))^2+ ...
                    (cellOnInnerEdge{k}{b}.Centroid(2)- ...
                    cellData{k+1}(a).Centroid(2))^2);
                
                %if the new distance is less than the previous min distance
                if newDist<dist
                    %numbers set assuming object with the smallest distance
                    %is most likely to be the current object in the next
                    %frame
                    dist= newDist;
                    cell= a;
                end
            end
            
            %if the cell in the current frame is closer to the center
            %than it is in the next frame
            if sqrt((201-cellOnInnerEdge{k}{b}.Centroid(1))^2 ...
                    +(201-cellOnInnerEdge{k}{b}.Centroid(2))^2)< ...
                    sqrt((201-cellData{k+1}(cell).Centroid(1))^2+ ...
                    (201-cellData{k+1}(cell).Centroid(2))^2)
                %cell is considered to be entering band 2 from band 1
                entering2From1Tot= entering2From1Tot+1;
                entering2From1(k)= entering2From1(k)+1;
            end
        end
    end  
    
    %if the current frame is not the first and there was at least one cell
    %found on the outer boundary in the current frame
    if k>1 && outerBound(k)>1
        %initializing distances
        dist= inf;
        newDist= inf;
        
        %loop through the number of cells found on the outer boundary in
        %the current frame
        for b= 1:outerBound(k)
            
            %loop through the total number of cells found in the previous 
            %frame
            for a=1:y(k-1)
                %finding distance between two centroids
                newDist= sqrt((cellOnOuterEdge{k}{b}.Centroid(1)- ...
                    cellData{k-1}(a).Centroid(1))^2+ ...
                    (cellOnOuterEdge{k}{b}.Centroid(2)- ...
                    cellData{k-1}(a).Centroid(2))^2);
                
                %if the new distance is less than the previous min distance
                if newDist<dist
                    %variables set assuming cell in previous frame with the
                    %min distance from current cell is most likely the same
                    %cell
                    dist= newDist;
                    cell= a;
                end   
            end
            
            %if the current cell is further from the center than the
            %previous cell
            if sqrt((201-cellOnOuterEdge{k}{b}.Centroid(1))^2 ...
                    +(201-cellOnOuterEdge{k}{b}.Centroid(2))^2)> ...
                    sqrt((201-cellData{k-1}(cell).Centroid(1))^2+ ...
                    (201-cellData{k-1}(cell).Centroid(2))^2)
                %cell is considered to be entering band 3 from band 2
                entering3From2Tot= entering3From2Tot+1;
                entering3From2(k)= entering3From2(k)+1;
            end
        end
    end
    
    %if the current frame is not the final frame and at least one cell was
    %found on the outer boundary in the current frame
    if k<numFrames && outerBound(k)>1
        %initializing distances
        dist= inf;
        newDist= inf;
        
        %loop through the number of cells found on the outer boundary in
        %this frame
        for b=1:outerBound(k)
            
            %loop through the total number of cells found in the next frame
            for a=1:y(k+1)
                %finding distance between two centroids
                newDist= sqrt((cellOnOuterEdge{k}{b}.Centroid(1)- ...
                    cellData{k+1}(a).Centroid(1))^2+ ...
                    (cellOnOuterEdge{k}{b}.Centroid(2)- ...
                    cellData{k+1}(a).Centroid(2))^2);
                
                %if the new distance is less than the previous min distance
                if newDist<dist
                    %set variable assuming cell in the next frame closest
                    %to the cell in this frame is most likely the same cell
                    dist= newDist;
                    cell= a;
                end 
            end
            %if the current cell is further from the center than it is
            %in the next frame
            if sqrt((201-cellOnOuterEdge{k}{b}.Centroid(1))^2 ...
                    +(201-cellOnOuterEdge{k}{b}.Centroid(2))^2)> ...
                    sqrt((201-cellData{k+1}(cell).Centroid(1))^2+ ...
                    (201-cellData{k+1}(cell).Centroid(2))^2)
                %cell considered to be entering band 2 from band 3
                entering2From3Tot= entering2From3Tot+1;
                entering2From3(k)= entering2From3(k)+1;
            end
        end
    end    
end

%plotting the number of cells in each frame over time
plot(x,y)
pause
%plotting the number of cells on the inner boundary over time
plot(x,innerBound)
pause
%plotting the number of cells on the outer boundary over time
plot(x,outerBound)
pause

%displays the binary video
implay(bw)
%displays the original video (cropped to be just band 2)
implay(cropVid)

%displays the number of cells entering and leaving specific bands
disp(entering1From2Tot)
disp(entering2From1Tot)
disp(entering3From2Tot)
disp(entering2From3Tot)

%plotting number of cells entering/leaving over time
plot(x,entering1From2)
pause
plot(x,entering2From1)
pause
plot(x,entering3From2)
pause
plot(x,entering2From3)

%NOTE: in the first trial of this code, there were more objects entering 
%than leaving band 1. This could potentially be because cells enter band 1
%slower than they leave and therefore get counted more times when they
%enter.

%Another possible source of error: strong glares are sometimes counted as
%objects and therefore cells.

%Yet another possible source of error: the closest cell may not have
%actually been the same cell in a previous or future frame. This could
%cause cells to be listed as moving in the wrong direction. The likelihood
%of this occurring in both directions seems fairly equal, so my hope is
%that it approximately cancels out with so many frames.

   
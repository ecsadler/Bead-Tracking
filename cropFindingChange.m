function cropFindingChange(filename) 
%Allows findingChange to be performed on a specific area of the video.

vid= VideoReader(filename);

[I rect] = imcrop(read(vid,1));

xmin= round(rect(1));
ymin= round(rect(2));
xmax= round(rect(1)+rect(3));
ymax= round(rect(2)+rect(4));
cropWidth= xmax-xmin+1;
cropHeight= ymax-ymin+1;

numFrames= vid.NumberOfFrames;

frame= fileToMatrix(filename);

%Cropping Matrices
frame = frame(ymin:ymax,xmin:xmax,:);

%3-D matrix representing the change in color between each frame
change= zeros(cropHeight,cropWidth,numFrames-1,'uint8');
for k=1:numFrames-1
    change(:,:,k)= frame(:,:,k+1) - frame(:,:,k);
end

%Adding all differences in order to estimate total color change throughout
%video (and therefore movement)
totalChange = 0;
for row=1:cropHeight
    for col=1:cropWidth
        for k=1:numFrames-1
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
end
disp(totalChange)

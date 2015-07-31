function resizeFindingChange(xmin, ymin, cropWidth, cropHeight, filename)
%crops and determines change
%(x,y) - minimum x and y values of desired focus area
%cropWidth and cropHeight are dimensions of desired focus area
%filename - video filename

vid= VideoReader(filename);

xmax= xmin+cropWidth-1;
ymax= ymin+cropHeight-1;

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
frame= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frame(:,:,k)= read(vid,k);
end

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


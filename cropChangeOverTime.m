function cropChangeOverTime(filename, timeInterval)

vid= VideoReader(filename);

[I rect] = imcrop(read(vid,1));

xmin= round(rect(1));
ymin= round(rect(2));
xmax= round(rect(1)+rect(3));
ymax= round(rect(2)+rect(4));
cropWidth= xmax-xmin+1;
cropHeight= ymax-ymin+1;

frame= fileToMatrix(filename);

numFrames= vid.NumberOfFrames;

%Cropping Matrices
frame = frame(ymin:ymax,xmin:xmax,:);

%3-D matrix representing the change in color between each frame
change= zeros(cropHeight,cropWidth,numFrames-1,'uint8');
for k=1:numFrames-1
    change(:,:,k)= frame(:,:,k+1) - frame(:,:,k);
end

%Creating x and y vectors
x= [0:timeInterval:timeInterval*(numFrames-1)];
y= [0];
totalChange= 0;
for k=1:numFrames-1
    for row=1:cropHeight
        for col=1:cropWidth
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
    y= [y totalChange];
    totalChange=0;
end

plot(x,y)
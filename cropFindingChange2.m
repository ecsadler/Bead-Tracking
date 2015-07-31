function cropFindingChange2(filename)
%Performs findingChange2 on a specific, smaller area of the video

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

%3-D matrix representing the pixels that change between each frame
change= zeros(cropHeight,cropWidth,numFrames-1,'uint8');
for row=1:cropHeight
    for col=1:cropWidth
        for k=1:numFrames-1
            if frame(row,col,k+1)-frame(row,col,k) == 0
                change(row,col,k)= 0;
            else
                change(row,col,k)= 1;
            end
        end
    end
end

%Adding all differences in order to estimate total color change throughout
%video (and therefore movement)
totalChange = 0;
for row=1:cropHeight
    for col=1:cropWidth
        for k=1:numFrames-1
            if change(row,col,k) ~= 0
                totalChange= totalChange + 1;
            end
        end
    end
end
disp(totalChange)
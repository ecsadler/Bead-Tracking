xmin= round(rect(1));
ymin= round(rect(2));
cropWidth= round(rect(3));
cropHeight= round(rect(4));

height= vid1.Height;
width= vid1.Width;
numFrames= vid1.NumberOfFrames;

%3-D matrix of frames grayscale
frame= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frame(:,:,k)= read(vid1,k);
end

%Cropping Matrices
frame = frame(ymin:ymin+cropHeight,xmin:xmin+cropWidth,:);

%3-D matrix representing the change in color between each frame
change= zeros(cropHeight+1,cropWidth+1,numFrames-1,'uint8');
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

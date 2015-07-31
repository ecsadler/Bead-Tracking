function findingChange2(vid)
%acts as findingChange does, but does not take into consideration HOW MUCH
%the color of each pixel changes, only IF it changes

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
frame= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frame(:,:,k)= read(vid,k);
end

%3-D matrix representing the pixels that change between each frame
change= zeros(height,width,numFrames-1,'uint8');
for row=1:height
    for col=1:width
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
for row=1:height
    for col=1:width
        for k=1:numFrames-1
            if change(row,col,k) ~= 0
                totalChange= totalChange + 1;
            end
        end
    end
end
disp(totalChange)
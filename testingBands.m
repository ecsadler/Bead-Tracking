vid= VideoReader('Cells_Exposed_Real_Time_10fps_UVSpotlight.avi');

cropVid= circleCrop(vid,518,680,100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[height,width,numFrames]= size(cropVid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% insert from changeOverTime %%%%

%3-D matrix representing the change in color between each frame
change= zeros(height,width,numFrames-1,'uint8');
for k=1:numFrames-1
    change(:,:,k)= cropVid(:,:,k+1) - cropVid(:,:,k);
end

%%%%%%%%%%%%%%%%

timeInterval= .1;

%%%%%%%%%%%%%%%%

%Creating x and y vectors
x= [0:timeInterval:timeInterval*(numFrames-1)];
y= [0];
totalChange= 0;
for k=1:numFrames-1
    for row=1:height
        for col=1:width
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
    y= [y totalChange];
    totalChange=0;
end

plot(x,y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% insert from findingChange %%%%

%3-D matrix representing the change in color between each frame
change= zeros(height,width,numFrames-1,'uint8');
for k=1:numFrames-1
    change(:,:,k)= cropVid(:,:,k+1) - cropVid(:,:,k);
end

%Adding all differences in order to estimate total color change throughout
%video (and therefore movement)
centerChange = 0;
for row=1:height
    for col=1:width
        for k=1:numFrames-1
            centerChange= centerChange + abs(change(row,col,k));
        end
    end
end
disp(centerChange)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%band1TotChange

cropCenter= circleCrop('Cells_Exposed_Real_Time_10fps_UVSpotlight.avi',...
    680,518,100);

[height,width,numFrames]= size(cropCenter);

%3-D matrix representing the change in color between each frame
change= zeros(height,width,numFrames-1);
for k=1:numFrames-1
    change(:,:,k)= cropCenter(:,:,k+1) - cropCenter(:,:,k);
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
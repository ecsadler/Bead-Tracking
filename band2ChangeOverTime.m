%band2ChangeOverTime

vid= VideoReader('Cells_Exposed_Real_Time_10fps_UVSpotlight.avi');

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
cropVid= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    cropVid(:,:,k)= read(vid,k);
end

xc=680;
yc=518;
r=200;

%Cropping to Square
cropVid(1:yc-r-1,:,:)= [];
[row,~,~]= size(cropVid);
cropVid(2*r+2:row,:,:)= [];
cropVid(:,1:xc-r-1,:)= [];
[row,col,k]= size(cropVid);
cropVid(:,2*r+2:col,:)= [];

%Forming a Circle
for a=1:2*r+1
    for b=1:2*r+1
        if sqrt((1+r-a)^2+(1+r-b)^2)>r
            cropVid(a,b,:)= 0;
        end
    end
end

%Clearing inner circle
for a=r/2:1.5*r+1
    for b=r/2:1.5*r+1
        if sqrt((1+r-a)^2+(1+r-b)^2)<=r/2
            cropVid(a,b,:)=0;
        end
    end
end

[height,width,numFrames]= size(cropVid);

%3-D matrix representing the change in color between each frame
change= zeros(height,width,numFrames-1);
for k=1:numFrames-1
    change(:,:,k)= cropVid(:,:,k+1) - cropVid(:,:,k);
end

%Creating x and y vectors
x= [1:numFrames-1];
y= [];
totalChange= 0;
spike= 0;
for k=1:numFrames-1
    for row=1:height
        for col=1:width
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
    if totalChange>spike
        spike= totalChange;
        spikeFrame= k;
    end
    y= [y totalChange];
    totalChange=0;
end

plot(x,y)

%before light: 1-56, after light:57-200


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


%%%% above created band using pieces of circleCrop %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[height,width,numFrames]= size(cropVid);
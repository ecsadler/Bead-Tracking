vid= VideoReader('SMlogphaseculture_10ms_10s_UVon.avi');

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
frames= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    frames(:,:,k)= read(vid,k);
end

%initializations
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
cc= struct('Connectivity',zeros(1,numFrames),'ImageSize', ...
    zeros(1,numFrames),'NumObjects',zeros(1,numFrames),'PixelIdxList', ...
    zeros(1,numFrames));
x= zeros(1,numFrames);
y= zeros(1,numFrames);
cellData= cell(1,numFrames);
track= cell(1,numFrames);
distCell= cell(1,numFrames);
lines= cell(1,numFrames);
draw= zeros(height,width,3,numFrames,'uint8');

for k=1:numFrames %Loop that goes through each frame
    
    %Creating binary bw video one frame at a time
    background(:,:,k)= imopen(frames(:,:,k),strel('disk',10));
    vid2(:,:,k)= frames(:,:,k) - background(:,:,k);
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
    bw(:,:,k)= bwareaopen(bw(:,:,k),90);
    cc(k) = bwconncomp(bw(:,:,k), 8);
end

implay(bw);
implay(frames);
vid= VideoReader('3um_ref_fluor_beads+swimmingSM.avi');

%initializations based on video being used
height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
cropVid= zeros(height,width,numFrames,'uint8');
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames);
for k=1:numFrames
    cropVid(:,:,k)= read(vid,k);
    background(:,:,k)= imopen(cropVid(:,:,k),strel('disk',10));
    vid2(:,:,k)= cropVid(:,:,k) - background(:,:,k);
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
    bw(:,:,k)= bwareaopen(bw(:,:,k),90);
end

implay(cropVid);
pause
implay(bw);
pause 


theBand= cropVid;

[height,width,numFrames]= size(theBand);
background= zeros(height,width,numFrames,'uint8');
vid2= background;
vid3= background;
bw= false(height,width,numFrames); 

for k=1:numFrames %Loop that goes through each frame
   
    %Creating binary bw video one frame at a time
    background(:,:,k)= imopen(theBand(:,:,k),strel('disk',10));
    vid2(:,:,k)= theBand(:,:,k) - background(:,:,k);
    vid3(:,:,k)= imadjust(vid2(:,:,k));
    bw(:,:,k)= im2bw(vid3(:,:,k),.99);
    bw(:,:,k)= bwareaopen(bw(:,:,k),90);
end    

implay(bw)
A= VideoReader('3um_ref_fluor_beads+swimmingSM_DAPI_gradient.avi');

%initializations based on video being used
height= A.Height;
width= A.Width;
numFrames= A.NumberOfFrames;

%3-D matrix of frames grayscale
im= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    im(:,:,k)= read(A,k);
end

imshow(im)

[centers, radii, metric] = imfindcircles(im,[9 20],'Sensitivity',.99);

viscircles(centers, radii,'EdgeColor','b');
A= VideoReader('5SM_2RBeads_3Percoll_DAPI_10x_3s_10min_FBL12Halfway.avi');

%initializations based on video being used
height= A.Height;
width= A.Width;
numFrames= A.NumberOfFrames;

%3-D matrix of frames grayscale
im= zeros(height,width,'uint8');
im(:,:)= read(A,1);


imshow(im)

[centers, radii, metric] = imfindcircles(im,[1 2],'ObjectPolarity','dark');

viscircles(centers, radii,'EdgeColor','b');
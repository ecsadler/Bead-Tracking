aviobj = avifile('example.avi','compression','None');

for frame = 1:size(cropVid, 3)
    aviobj = addframe(aviobj, cropVid(:,:,frame)); %// This is assuming your image is a vector of RGB images. If it's a vector of indexed images then drop one : and make the loop go to size(M,3)
end

aviobj = close(aviobj);
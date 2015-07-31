frame1 = read(vid1,1);
frame2 = read(vid2,2);

frameChange = zeros(1024,1024,'uint8');
frameChange(:,:) = frame2(:,:) - frame1(:,:);


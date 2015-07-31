frame1 = read(vid1,1);
frame2 = read(vid1,2);

frameChange = zeros(1024,1024,'uint8');
frameChange(:,:) = frame2(:,:) - frame1(:,:);

totalChange = 0;
for row=1:1024
    for col=1:1024
        totalChange = totalChange + abs(frameChange(row,col));
    end    
end

disp(totalChange)
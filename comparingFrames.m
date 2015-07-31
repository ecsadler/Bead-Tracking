frame= zeros(1024,1024,100);

for k=1:100
    frame(:,:,k)= read(vid1,k);
end

change= zeros(1024,1024,99);

for k=1:99
    change(:,:,k)= frame(:,:,k+1) - frame(:,:,k);
end

totalChange = 0;
for row=1:1024
    for col=1:1024
        for k=1:99
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
end

disp(totalChange)
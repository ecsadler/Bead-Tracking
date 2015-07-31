function [cropVid] = circleCrop(filename, xc, yc, r)

cropVid= fileToMatrix(filename);

[height,width,numFrames]= size(cropVid);

%Cropping to Square
cropVid(1:yc-r-1,:,:)= [];
[row,col,k]= size(cropVid);
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

imshow(cropVid(:,:,1));

        

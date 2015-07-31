vid= VideoReader('3um_ref_fluor_beads+swimmingSM.avi');

%creating one function to make all bands

%initializations based on video being used
height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
cropVid= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    cropVid(:,:,k)= read(vid,k);
end

%Determining which side will be limiting
if height>width
    shortSide= width;
else
    shortSide= height;
end

%initialization
r=0;

%determining number of bands that will be made
band= cell(1,floor(shortSide/200));

%loop through number of bands
for k=1:floor(shortSide/200)
    
    %setting the band equal to the original video
    band{k}= cropVid;
    
    %xc and yc initializations; r increases by 100 for each band
    xc=width/2;
    yc=height/2;
    r=r+100;

    %Cropping to Square
    band{k}(1:yc-r-1,:,:)= [];
    [row,~,~]= size(band{k});
    band{k}(2*r+2:row,:,:)= [];
    band{k}(:,1:xc-r-1,:)= [];
    [~,col,~]= size(band{k});
    band{k}(:,2*r+2:col,:)= [];
    
    %Forming a Circle
    for a=1:2*r+1
        for b=1:2*r+1
            if sqrt((1+r-a)^2+(1+r-b)^2)>r
                band{k}(a,b,:)= 0;
            end
        end
    end
    
    %Clearing inner circle (for every band except the first)
    if k>1
        for a=r/k:(2*r)-(r/k)+1
            for b=r/k:(2*r)-(r/k)+1
                if sqrt((1+r-a)^2+(1+r-b)^2)<=r-100
                    band{k}(a,b,:)=0;
                end
            end
        end 
    end
end



%beadsPerBand

x= 1:numFrames;

%Determining which side will be limiting
if height>width
    shortSide= width;
else
    shortSide= height;
end

%determining number of tracks
%[~,numTracks]= size(lines{numFrames});

xc=width/2;
yc=height/2;
bandTot= cell(1,floor(shortSide/200));
for f= 1:floor(shortSide/200)
    bandTot{f}= zeros(1,numFrames);
end

lastNumData= zeros(1,200);

for k= 1:numFrames
    [~,numTracks]= size(lines{k});
    numData= 0;
    for a= 1:numTracks
        [~,numData]= size(lines{k}{a});
        if numData>lastNumData(a)
            dist= sqrt((lines{k}{a}(numData-1)-xc)^2+ ...
                (lines{k}{a}(numData)-yc)^2);
            r= 100;
            for c= 1:floor(shortSide/200)
                if dist<r
                    bandTot{1,c}(1,k)= bandTot{1,c}(1,k)+1;
                    break
                else
                    r= r+100;
                end
            end            
        end    
        lastNumData(a)= numData;
    end 
    lastNumTracks= numTracks;
end

for d= 1:floor(shortSide/200)
    plot(x,bandTot{1,d})
    pause
end

%for a= 1:numTracks
%    [~,numData]= size(lines{numFrames}{a});
%    for b= 2:2:numData
%        dist= sqrt((lines{numFrames}{a}(b-1)-xc)^2+ ...
%            (lines{numFrames}{a}(b)-yc)^2);
%        r= 100;
%        for c= 1:floor(shortSide/200)
%            if dist<r
%                bandTot(c)= bandTot(c)+1;
%                break
%            else
%                r= r+100;
%            end
%        end
%    end
%end
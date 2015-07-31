%Mean Square Displacement

[~,numTracks]= size(lines{1,numFrames});

for i= 1:numTracks
    [~,trackLength]= size(lines{1,numFrames}{1,i});
    tot= 0; %total
    for t= 4:2:trackLength
        disp= (lines{1,numFrames}{1,i}(1,t)- ...    %displacement
            lines{1,numFrames}{1,i}(1,t-2))^2+ ...
            (lines{1,numFrames}{1,i}(1,t-1)- ...
            lines{1,numFrames}{1,i}(1,t-3))^2;
        tot= tot+disp;
    end
    msd(i)= tot/trackLength;    %mean square displacement
end
        
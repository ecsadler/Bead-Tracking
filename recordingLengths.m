%recordingLengths

[~,numFrames]= size(lines);
[~,numTracks]= size(lines{1});
lengths= cell(1,numTracks);
xc= width/2;
yc= height/2;
distToward= 0;
distAway= 0;

for a=1:numTracks
    [~,twiceNumCoords]= size(lines{numFrames}{a});
    c= 1;
    for b=1:2:twiceNumCoords-3
        lengths{a}(c)= sqrt((lines{numFrames}{a}(b+2)- ...
            lines{numFrames}{a}(b))^2+(lines{numFrames}{a}(b+3)- ...
            lines{numFrames}{a}(b+1))^2);
        dist1= sqrt((xc-lines{numFrames}{a}(b))^2+ ...
            (yc-lines{numFrames}{a}(b+1))^2);
        dist2= sqrt((xc-lines{numFrames}{a}(b+2))^2+ ...
            (yc-lines{numFrames}{a}(b+3))^2);
        if dist1>dist2
            distToward= distToward+lengths{a}(c);
        elseif dist1<dist2
            distAway= distAway+lengths{a}(c);
        end
        c= c+1;
    end
end


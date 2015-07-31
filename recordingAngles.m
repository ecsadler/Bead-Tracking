%recordingAngles

[~,numFrames]= size(lines);
[~,numTracks]= size(lines{1});
thetaInDegrees= cell(1,numTracks);


for a=1:numTracks
    [~,twiceNumCoords]= size(lines{numFrames}{a});
    c= 1;
    for b=1:2:twiceNumCoords-5
        u= [lines{numFrames}{a}(b+2)-lines{numFrames}{a}(b), ...
            lines{numFrames}{a}(b+3)-lines{numFrames}{a}(b+1)];
        v= [lines{numFrames}{a}(b+4)-lines{numFrames}{a}(b+2), ...
            lines{numFrames}{a}(b+5)-lines{numFrames}{a}(b+3)];
        cosTheta= dot(u,v)/(norm(u)*norm(v));
        thetaInDegrees{a}(c)= acos(cosTheta)*180/pi;
        c= c+1;
    end
end

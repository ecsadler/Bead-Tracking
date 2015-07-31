%overallMovement

[~,numFrames]= size(lines);
[~,numTracks]= size(lines{1});
totalDist= cell(1,numTracks);
towardvAway= cell(1,numTracks);

for a=1:numTracks
    [~,twiceNumCoords]= size(lines{numFrames}{a});
    totalDist{a}= sqrt((lines{numFrames}{a}(twiceNumCoords-1)- ...
        lines{numFrames}{a}(1))^2+(lines{numFrames}{a}(twiceNumCoords)- ...
        lines{numFrames}{a}(2))^2);
    dist1= sqrt((lines{numFrames}{a}(1)-width/2)^2+ ...
        (lines{numFrames}{a}(2)-height/2)^2);
    dist2= sqrt((lines{numFrames}{a}(twiceNumCoords-1)-width/2)^2+ ...
        (lines{numFrames}{a}(twiceNumCoords)-height/2)^2);
    if dist1>dist2
        towardvAway{a}= 'toward';
    elseif dist2>dist1
        towardvAway{a}= 'away  ';
    else
        towardvAway{a}= '      ';
    end
end
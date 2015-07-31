%combining overallMovement with recordingLengths (both of these scripts 
%should be run before this one)

[~,numTracks]= size(lengths);
towardTotal= 0;
awayTotal= 0;

for a= 1:numTracks
    if towardvAway{a}=='toward'
        towardTotal= towardTotal+totalDist{a};
    elseif towardvAway{a}=='away  '
        awayTotal= awayTotal+totalDist{a};
    end
end
%determining if the cells/beads are moving toward or away from the center
%(where the blue light is strongest)

[~,numFrames]= size(lines);
[~,numTracks]= size(lines{1});
toward= zeros(1,numTracks);
away= zeros(1,numTracks);
same= zeros(1,numTracks);

for a=1:numTracks
    [~,twiceNumCoords]= size(lines{numFrames}{a});
    for b=1:2:twiceNumCoords-3
        dist1= sqrt((lines{numFrames}{a}(b)-width/2)^2+ ...
            (lines{numFrames}{a}(b+1)-height/2)^2);
        dist2= sqrt((lines{numFrames}{a}(b+2)-width/2)^2+ ...
            (lines{numFrames}{a}(b+3)-height/2)^2);
        if dist1>dist2
            toward(a)= toward(a)+1;
        elseif dist2>dist1
            away(a)= away(a)+1;
        end
    end
end
spikeFrame= 56;

%Adding all differences in order to estimate total color change throughout
%video (and therefore movement)
beforeSpike = 0;
for row=1:height
    for col=1:width
        for k=1:spikeFrame-1
            beforeSpike= beforeSpike + abs(change(row,col,k));
        end
    end
end
disp(beforeSpike)

afterSpike = 0;
for row=1:height
    for col=1:width
        for k=spikeFrame+1:numFrames-1
            afterSpike= afterSpike + abs(change(row,col,k));
        end
    end
end
disp(afterSpike)
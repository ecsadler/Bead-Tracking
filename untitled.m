x= [0:.1:.1*(199)];
y= [0];
totalChange= 0;
for k=1:199
    for row=1:201
        for col=1:201
            totalChange= totalChange + abs(change(row,col,k));
        end
    end
    y= [y totalChange];
    totalChange=0;
end
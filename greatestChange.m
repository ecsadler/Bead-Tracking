function greatestChange(changeMatrix)
%changeMatrix is 3D matrix of the grayscale colormap of each frame

[d1, d2, d3]= size(changeMatrix);
changeVec= zeros(1,d3);

for a= 1:d3
    totChange= 0;
    for b= 1:d1
        for c= 1:d2
            totChange= totChange + changeMatrix(b,c,a);
        end
    end
    changeVec(a)= totChange;
end

GCF= 0;
GC= 0;
for k= 1:d3
    if changeVec(k)>GC
        GCF= k;             %greatest change frame
        GC= changeVec(k);   %greatest change    
    end
end

fprintf('Greatest change is %d occurs at frame %d\n',GC,GCF) 

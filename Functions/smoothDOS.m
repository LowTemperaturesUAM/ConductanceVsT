function [DOSSmooth] = smoothDOS(Voltaje, DOS, Threshold, Window, Iterations)

[~,NCurves] = size(DOS);

DOSSmooth = DOS;

for k =1:NCurves
    V = Voltaje(:,k);
    D = DOS(:,k);

    Mask = find(V>Threshold);
    Mask2 = find(V<-Threshold);

    DOSSmooth(Mask,k) =  smooth(D(Mask),Window);
    DOSSmooth(Mask2,k) =  smooth(D(Mask2),Window);
    
    i = 1;
    while i<Iterations
        DOSSmooth(Mask,k) =  smooth(DOSSmooth(Mask,k),Window);
        DOSSmooth(Mask2,k) =  smooth(DOSSmooth(Mask2,k),Window);
        i = i+1;
    end

end
end

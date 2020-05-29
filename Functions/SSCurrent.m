% Función que calcula la corriente para una unión S-S dadas una densidad de
% estados (normalizada a 1) y la función de Fermi a una determinada temperatura para un
% vector de voltaje V (OJO!! V tiene orden descendente)
function [Current,DOSAUX,FermiAUX] = SSCurrent(V, DOS, Fermi)

% Para este caso da igual utilizar dE porque luego se va a normalizar el
% resultado

% dE = abs(V(2)-V(1));

%Creo un vector DOSAUX con el doble de puntos añadiendo unos a izda y dcha.
DOSAUX = [ones(floor(length(DOS)/2),1); DOS; ones(floor(length(DOS)/2),1)];
% DOSAUX = ones(2*length(V),1);

%Creo un vector FermiAUX con el doble de puntos añadiendo unos a la izda .
FermiAUX = [zeros(floor(length(Fermi)/2),1); Fermi; ones(floor(length(Fermi)/2),1)];

Current = zeros(length(V),1);

for j=1:length(V)
    I = 0;
    for i=1:length(V)
%         N1 = DOSAUX(j+1-1);
        N1 = DOSAUX(length(V)+i+1-j);
        N2 = DOS(i);
%         f1 = FermiAUX(j+i-1);
        f1 = FermiAUX(length(V)+i+1-j);
        f2 = Fermi(i);
        
        A = N1*N2*(f1-f2);
        I = I + A;
    end
    Current(j) = I;
end
% Current = flipud(Current);
end
% Curva tiene que estar normalizada a 1
function [Curva] = stretchVertical(Curva,factorPos,factorNeg)

Curva = Curva-1;
for i = 1: length(Curva)
    if Curva(i)>0
        Curva(i) = Curva(i)*factorPos;
    else
        Curva(i) = Curva(i)*factorNeg;
    end
end
    Curva = Curva + 1;
end
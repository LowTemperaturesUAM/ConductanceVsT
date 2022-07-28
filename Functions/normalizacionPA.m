% NORMALIZACI�N
% ------------------------------------
% Pepe  06/07/2015
% Ant�n 13/07/2015 - Modificaci�n
% Ant�n 28/07/2015 - Modificaci�n
% Ant�n 31/03/2016 - Modificaci�n
% Ant�n 06/04/2016 - Modificaci�n: retoques en visualizaci�n
% ------------------------------------
%
% Esta funci�n toma la derivada de una "matrizConductancia" y la normaliza
% a los valores correspondientes al promedio de los valores de la
% conductancia entre dos valores de voltaje dados: "voltajeSuperior" y
% "voltajeInferior".
%
% ENTRADA:
%   voltajeSuperior:    l�mite inferior de voltaje para el promedio de la
%                       normalizaci�n
%   voltajeInferior:    l�mite superior de voltaje para el promedio de la
%                       normalizaci�n
%   matrizVoltaje:      matriz con los voltajes
%   matrizConductancia: matriz con la conductancia
%
% SALIDA:
%   matrizNormalizada: matriz con los valores normalizados
%
% NOTA: se utilizan las variables globales lineas e iV
 
function [MatrizNormalizada] = normalizacionPA(VoltajeSuperior,VoltajeInferior,Voltaje,MatrizConductancia)

[IV, ~] = size(MatrizConductancia);

% Tomamos los valores entre los voltajes elegidos y hacemos la media como:
% NormaTotal = (norma1 + norma2)/2;

%     Indices1 = find(VoltajeSuperior > Voltaje(1:IV) & VoltajeInferior < Voltaje(1:IV));
%     Indices2 = find(-VoltajeSuperior < Voltaje(1:IV) & -VoltajeInferior > Voltaje(1:IV));
%
% % La normalizaci�n total de la imagen ser� el promedio de las
% % normalizaciones para valores de voltaje positivos y negativos
%
%     Norma1 = mean(MatrizConductancia(Indices1,:),1);
%     Norma2 = mean(MatrizConductancia(Indices2,:),1);
%     Norma = (Norma1(:,:) + Norma2(:,:))/2;

%Lo hacemos de una vez porque es mas rapido segun Matlab, pero la
%diferencia es minima incluso para imagenes grandes
Norma1 = mean(MatrizConductancia(VoltajeSuperior > Voltaje(1:IV) & VoltajeInferior < Voltaje(1:IV),:),1);
Norma2 = mean(MatrizConductancia(-VoltajeSuperior < Voltaje(1:IV) & -VoltajeInferior > Voltaje(1:IV),:),1);
Norma = (Norma1(:,:) + Norma2(:,:))/2;

MatrizNormalizada= bsxfun(@rdivide,MatrizConductancia,Norma);

end

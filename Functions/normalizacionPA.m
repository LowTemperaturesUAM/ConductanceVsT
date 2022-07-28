% NORMALIZACIÓN
% ------------------------------------
% Pepe  06/07/2015
% Antón 13/07/2015 - Modificación
% Antón 28/07/2015 - Modificación
% Antón 31/03/2016 - Modificación
% Antón 06/04/2016 - Modificación: retoques en visualización
% ------------------------------------
%
% Esta función toma la derivada de una "matrizConductancia" y la normaliza
% a los valores correspondientes al promedio de los valores de la
% conductancia entre dos valores de voltaje dados: "voltajeSuperior" y
% "voltajeInferior".
%
% ENTRADA:
%   voltajeSuperior:    límite inferior de voltaje para el promedio de la
%                       normalización
%   voltajeInferior:    límite superior de voltaje para el promedio de la
%                       normalización
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
% % La normalización total de la imagen será el promedio de las
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

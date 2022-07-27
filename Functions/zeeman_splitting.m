% Función que calcula la convolución con la temperatura de una densidad de
% estados a la que se le aplica un desdoblamiento zeeman.
%-------------------------------------------------------------------------
% INPUTS:   Voltage - Vector con los valores de voltaje
%           DOS - Vector con los valores de la densidad de estados
%           VZeeman - Desplazamiento zeeman en mV
%           Temperature - Temperatura
%           NormSup - Voltage de normalización superior
%           NormInf - Voltage de normalización inferior
%-------------------------------------------------------------------------

function [Conductance] = zeeman_splitting(Voltage,DOS,VZeeman,Temperature,NormSup,NormInf)

NPoints = length(Voltage);

VoltageStep = abs(Voltage(1)-Voltage(2));
Pixel_Zeeman = round(VZeeman/VoltageStep); %Calculo el número de píxeles a desplazar

DOSPlus = [ones(NPoints+Pixel_Zeeman,1);DOS;ones(NPoints-Pixel_Zeeman,1)];
DOSMinus = [ones(NPoints-Pixel_Zeeman,1);DOS;ones(NPoints+Pixel_Zeeman,1)];

DOSAUX = DOSPlus+DOSMinus;
DOSAUX = DOSAUX(NPoints+1:2*NPoints);
% fig=figure;
% plot(Voltage,DOSAUX)

%Función de Fermi
kB = 8.617e-2; %meV/K
Beta = 1/(kB*Temperature);
%dFermiDist = (Beta*exp(Beta*Voltage))./((1+exp(Voltage*Beta)).^2);
dFermiDist = FermiDeriv(Temperature,Voltage);

%Convolucionamos
Conductance = conv(dFermiDist,DOSAUX,'same');
% fig=figure;
% plot(Voltage,Conductance)
%Normalizamos
Conductance = normalizacionPA(NormSup,NormInf,Voltage,Conductance);

end
function [VoltageNuevo,MatrizCorrienteNuevo,TemperatureNuevo,MagneticFieldNuevo] =...
    addCurve(Voltage,VoltageCurva,MatrizCorriente,CorrienteCurva,...
    Temperature,MagneticField,TemperaturaCurva,MagneticFieldCurva,Index)
A=size(Voltage);

if A(2) == 0
    VoltageNuevo = VoltageCurva;
    MatrizCorrienteNuevo = CorrienteCurva;
    TemperatureNuevo = TemperaturaCurva;
    MagneticFieldNuevo = MagneticFieldCurva;
elseif A(2) >= Index(1) %replace existing curves
    VoltageNuevo = Voltage;
    VoltageNuevo(:,Index) = VoltageCurva;
        
    MatrizCorrienteNuevo = MatrizCorriente;
    MatrizCorrienteNuevo(:,Index) = CorrienteCurva;
        
    TemperatureNuevo = Temperature;
    TemperatureNuevo(Index) = TemperaturaCurva;
    
    MagneticFieldNuevo = MagneticField;
    MagneticFieldNuevo(Index) = MagneticFieldCurva;
else %append new curves at the end
%     VoltageNuevo = zeros(length(VoltageCurva),Index(1));
%     VoltageNuevo(:,1:Index(1)-1) = Voltage;
%     VoltageNuevo(:,Index) = VoltageCurva;
    %Bastaria con hacer esto
    VoltageNuevo = [Voltage, VoltageCurva];
        
%     MatrizCorrienteNuevo = zeros(length(CorrienteCurva),Index(1));
%     MatrizCorrienteNuevo(:,1:Index(1)-1) = MatrizCorriente;
%     MatrizCorrienteNuevo(:,Index) = CorrienteCurva;
    MatrizCorrienteNuevo = [MatrizCorriente, CorrienteCurva];

%     TemperatureNuevo = zeros(length(Temperature),1);
%     TemperatureNuevo(1:Index(1)-1) = Temperature;
%     TemperatureNuevo(Index) = TemperaturaCurva;
    TemperatureNuevo = [Temperature; TemperaturaCurva];
    
%     MagneticFieldNuevo = zeros(length(MagneticField),1);
%     MagneticFieldNuevo(1:Index(1)-1) = MagneticField;
%     MagneticFieldNuevo(Index) = MagneticFieldCurva;
    MagneticFieldNuevo = [MagneticField; MagneticFieldCurva];
end
end
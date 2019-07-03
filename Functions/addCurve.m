function [VoltageNuevo,MatrizCorrienteNuevo,TemperatureNuevo,MagneticFieldNuevo] =...
    addCurve(Voltage,VoltageCurva,MatrizCorriente,CorrienteCurva,...
    Temperature,MagneticField,TemperaturaCurva,MagneticFieldCurva,Index)
A=size(Voltage);

if A(2) == 0
    VoltageNuevo = VoltageCurva;
    MatrizCorrienteNuevo = CorrienteCurva;
    TemperatureNuevo = TemperaturaCurva;
    MagneticFieldNuevo = MagneticFieldCurva;
elseif A(2) >= Index
    VoltageNuevo = Voltage;
    VoltageNuevo(:,Index) = VoltageCurva;
        
    MatrizCorrienteNuevo = MatrizCorriente;
    MatrizCorrienteNuevo(:,Index) = CorrienteCurva;
        
    TemperatureNuevo = Temperature;
    TemperatureNuevo(Index) = TemperaturaCurva;
    
    MagneticFieldNuevo = MagneticField;
    MagneticFieldNuevo(Index) = MagneticFieldCurva;
else
    VoltageNuevo = zeros(length(VoltageCurva),Index);
    VoltageNuevo(:,1:Index-1) = Voltage;
    VoltageNuevo(:,Index) = VoltageCurva;
        
    MatrizCorrienteNuevo = zeros(length(CorrienteCurva),Index);
    MatrizCorrienteNuevo(:,1:Index-1) = MatrizCorriente;
    MatrizCorrienteNuevo(:,Index) = CorrienteCurva;
        
    TemperatureNuevo = zeros(length(Temperature),1);
    TemperatureNuevo(1:Index-1) = Temperature;
    TemperatureNuevo(Index) = TemperaturaCurva;
    
    MagneticFieldNuevo = zeros(length(MagneticField),1);
    MagneticFieldNuevo(1:Index-1) = MagneticField;
    MagneticFieldNuevo(Index) = MagneticFieldCurva;
end
end
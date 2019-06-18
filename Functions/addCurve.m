function [VoltageNuevo,MatrizCorrienteNuevo,TemperatureNuevo] =...
    addCurve(Voltage,VoltageCurva,MatrizCorriente,CorrienteCurva,...
    Temperature,TemperaturaCurva,Index)
A=size(Voltage);
% disp(A(2))
% which A

if A(2) == 0
    VoltageNuevo = VoltageCurva;
    MatrizCorrienteNuevo = CorrienteCurva;
    TemperatureNuevo = TemperaturaCurva;
elseif A(2) >= Index
    VoltageNuevo = Voltage;
    VoltageNuevo(:,Index) = VoltageCurva;
        
    MatrizCorrienteNuevo = MatrizCorriente;
    MatrizCorrienteNuevo(:,Index) = CorrienteCurva;
        
    TemperatureNuevo = Temperature;
    TemperatureNuevo(Index) = TemperaturaCurva;
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

end
end
function [Conductancia] = derivadorLeastSquaresCurva(NPuntosDerValor,Curva,Voltaje)

IV = length(Curva);                         % Número de puntos de la curva a derivar
PasoVoltaje = abs(Voltaje(2) - Voltaje(1)); % Definimos el paso en voltaje
NPuntosDer = abs(NPuntosDerValor);          % Por si un boludo lo escribe en negativo

Conductancia = zeros(IV-2*NPuntosDer,1);      % Definimos la matriz de salida

% -----------------------------------------------------------------
% INFO:
% -----------------------------------------------------------------
% Para hacer esta derivada se usa una GENERALIZACIÓN DE MÍNIMOS CUADRADOS
% para hacer diferencias finitas. Puede consultarse en:
%
% Real Anal. Exchange
% Volume 35, Number 1 (2009), 205-228.
% A Least Squares Approach to Differentiation
% Russell A. Gordon
% 
% http://projecteuclid.org/euclid.rae/1272376232
% http://projecteuclid.org/download/pdf_1/euclid.rae/1272376232
% -----------------------------------------------------------------

	for c = 1+NPuntosDer:IV-NPuntosDer
                
        Numerador = 0;
        Ajuste = 0;
        Denominador = 0;
                
        for k = -NPuntosDer:NPuntosDer
        	Numerador = Numerador + Curva(c+k)*(Voltaje(c+k)-Voltaje(c));
            Denominador = Denominador + (Voltaje(c+k)-Voltaje(c))*(Voltaje(c+k)-Voltaje(c));
        end
                
        Ajuste = Numerador./Denominador;
        Conductancia(c-NPuntosDer) = Ajuste;
                
	end

clear c k Numerador Denominador Ajuste PasoVoltaje;

% Amplio el vector Conductancia para que tenga las dimensiones originales.
% Simplemente los primeros y ultimos puntos de la derivada son iguales que
% el ultimo y primer punto de la matriz. Por comodidad en la visualización
% y el tratamiento de los datos

ConductanciaAUX = Conductancia;
Conductancia = zeros(IV,1);
Conductancia(1+NPuntosDer:IV-NPuntosDer,:) = ConductanciaAUX;

for i = 1:NPuntosDer
    Conductancia(i) = ConductanciaAUX(2*NPuntosDer);
    Conductancia(IV-(i-1)) = ConductanciaAUX(IV-2*NPuntosDer);
end

clear i MatrizConductanciaAUX


end
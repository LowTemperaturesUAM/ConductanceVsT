%% Fermi distribution
% Cálculo de la derivada de la función de Fermi para todas las temperaturas
% dentro del Struct. Usamos la expresión analítica. Para la energía se usan
% los vectores VoltageOffset

kB      = 8.617e-2; %meV/K
for i=1:length(Struct.Temperature)
    Beta	= 1/(kB*Struct.Temperature(i));
    Struct.FermiDist(:,i)	= 1./(1+exp(Struct.VoltageOffset(:,i)*1000*Beta));
    Struct.dFermiDist(:,i)	= (Beta*exp(Beta*Struct.VoltageOffset(:,i)*1000))./((1+exp(Struct.VoltageOffset(:,i)*1000*Beta)).^2);
end

%% Visualize Fermi distribution
k=8;
plot(Struct.VoltageOffset(:,k),Struct.dFermiDist(:,k))

%% Initial guess for DOS
DOSGuess = Struct.MatrizConductancia(:,1);
% DOSGuess = shrink(DOSGuess,0.95);
Conductancia = conv(Struct.dFermiDist(:,1),DOSGuess,'same');

Conductancia = normalizacionPA(1.7e-3, 1.5e-3, Struct.VoltageOffset(:,1),Conductancia,2048,2048);
% Conductancia = shrink(Conductancia,0.5);

plot(Struct.VoltageOffset(:,1),Struct.MatrizConductancia(:,1))
hold on
Offset = 3.2e-5;
plot(Struct.VoltageOffset(:,1)-Offset,Conductancia)

%% Save initial guess
k = 1;
DOS(:,k) = DOSGuess;
MatrizConvolution(:,k) = Conductancia;
VoltageOffsetConvolution(:,k) = Struct.VoltageOffset(:,k)-Offset;
%% Keep on
k = 6;
factor = .94;
% factorVertical = 1.2;
% factorVerticalLeft = 0.6;
% factorVerticalRight = 0.6;
factorNeg1 = 1;
factorPos = 1;

factorNeg = 0.89;

factorPosRight = 0.7;
factorPosLeft =1;

Offset = 3.2e-5;

VerticalOffsetThreshold = 10e-4;
VerticalOffset = 0.06;

DOSGuess = Struct.MatrizConductancia(:,1);
% DOSGuess = DOS(:,1);
[~,I] = min(DOSGuess);

DOSGuess = shrink(DOSGuess,factor);
% DOSGuess = stretchVertical(DOSGuess,factorPos,factorNeg);

%Right
DOSGuess(1:I) = stretchVertical(DOSGuess(1:I),factorPosRight,factorNeg1);
%Left
DOSGuess(I+1:end) = stretchVertical(DOSGuess(I+1:end),factorPosLeft,factorNeg1);

Mask = find(abs(Struct.VoltageOffset(:,1))<VerticalOffsetThreshold);
DOSGuess(Mask) = DOSGuess(Mask)-VerticalOffset;


DOSGuess = stretchVertical(DOSGuess,factorPos,factorNeg);

fig = figure;
plot(Struct.VoltageOffset(:,k),DOSGuess)
hold on


Conductancia = conv(Struct.dFermiDist(:,k),DOSGuess,'same');

Conductancia = normalizacionPA(1.7e-3, 1.5e-3, Struct.VoltageOffset(:,k),Conductancia,2048,2048);

% VerticalOffset = 0;

fig = figure;
plot(Struct.VoltageOffset(:,k),Struct.MatrizConductancia(:,k))
hold on

% plot(Struct.VoltageOffset(:,k)-Offset,Conductancia-VerticalOffset)
plot(Struct.VoltageOffset(:,k)-Offset,Conductancia)

%% Save
Analisis.DOS(:,k) = DOSGuess;
Analisis.MatrizConvolution(:,k) = Conductancia;
Analisis.VoltageOffsetConvolution(:,k) = Struct.VoltageOffset(:,k)-Offset;
Analisis.factor(k) = factor;
% Analisis.factorPos(k) = factorNeg;
Analisis.factorNeg(k) = factorNeg;
% Analisis.factorVertical = factorVertical;
Analisis.factorPosLeft(k) = factorPosLeft;
Analisis.factorPosRight(k) = factorPosRight;
Analisis.Offset(k) = Offset;
Analisis.VerticalOffset(k) = VerticalOffset;
Analisis.VerticalOffsetThreshold(k) = VerticalOffsetThreshold;
%%
Struct.Analisis2 = Analisis;
%% Keep on (repetido para el caso grande)
k = 6;
factor = .94;

factorPos = 0.89;
factorNeg = 0.89;

Offset = 3.2e-5;

DOSGuess = Struct.MatrizConductancia(:,1);
% DOSGuess = DOS(:,1);
[~,I] = min(DOSGuess);

DOSGuess = shrink(DOSGuess,factor);
% DOSGuess = stretchVertical(DOSGuess,factorPos,factorNeg);

DOSGuess = stretchVertical(DOSGuess,factorPos,factorNeg);

fig = figure;
plot(Struct.VoltageOffset(:,k),DOSGuess)
hold on


Conductancia = conv(Struct.dFermiDist(:,k),DOSGuess,'same');

Conductancia = normalizacionPA(1.7e-3, 1.5e-3, Struct.VoltageOffset(:,k),Conductancia,2048,2048);

% VerticalOffset = 0;

fig = figure;
plot(Struct.VoltageOffset(:,k),Struct.MatrizConductancia(:,k))
hold on

% plot(Struct.VoltageOffset(:,k)-Offset,Conductancia-VerticalOffset)
plot(Struct.VoltageOffset(:,k)-Offset,Conductancia)
%% Keep on S-S
k = 1;
factor = .61;
factorVertical = 0.8;
% factorVerticalLeft = 0.6;
% factorVerticalRight = 0.6;

% DOSGuess = shrink(Struct.MatrizConductancia(:,1),0.5);
DOSGuess = Struct.MatrizConductancia(:,1);
% DOSGuess = DOS(:,1);
[~,I] = min(DOSGuess);

DOSGuess = shrink(DOSGuess,factor);
DOSGuess = stretchVertical(DOSGuess,factorVertical);

fig = figure;
plot(Struct.VoltageOffset(:,k),DOSGuess)
hold on

Current = SSCurrent(Struct.VoltageOffset,DOSGuess,Struct.FermiDist(:,k));

% fig = figure;
% plot(Struct.VoltageOffset(:,k),Current)

Conductancia = derivadorLeastSquaresCurva(32,Current,Struct.VoltageOffset);
Conductancia = normalizacionPA(1.1e-3, 1e-3, Struct.VoltageOffset(:,k),Conductancia,2048,2048);

fig = figure;
plot(Struct.VoltageOffset(:,k),Struct.MatrizConductancia(:,k))
hold on
Offset = -6.4e-5;
plot(Struct.VoltageOffset(:,k)-Offset,Conductancia)

%% Save
Analisis1.DOS(:,k) = DOSGuess;
Analisis1.MatrizConvolution(:,k) = Conductancia;
Analisis1.VoltageOffsetConvolution(:,k) = Struct.VoltageOffset(:,k)-Offset;
Analisis1.factor(k) = factor;
Analisis1.factorVertical(k) = factorVertical;
% Analisis1.factorVerticalLeft(k) = factorVerticalLeft;
% Analisis1.factorVerticalRight(k) = factorVerticalRight;
Analisis1.Offset(k) = Offset;
%%
DOSGuess = shrink(DOSGuess,factor);
DOSGuess = stretchVertical(DOSGuess,factorVertical);
% 
% %Right
% DOSGuess(1:I) = stretchVertical(DOSGuess(1:I),factorVerticalRight);
% %Left
% DOSGuess(I+1:end) = stretchVertical(DOSGuess(I+1:end),factorVerticalLeft);

Conductancia = conv(Struct.dFermiDist(:,k),DOSGuess,'same');

Conductancia = normalizacionPA(1.7e-3, 1.5e-3, Struct.VoltageOffset(:,k),Conductancia,2048,2048);

verticalOffset = 0;

fig = figure;
plot(Struct.VoltageOffset(:,k),Struct.MatrizConductancia(:,k))
hold on

Offset = 6.5e-5;

plot(Struct.VoltageOffset(:,k)-Offset,Conductancia-verticalOffset)

%% Save
Analisis1.DOS(:,k) = DOSGuess;
Analisis1.MatrizConvolution(:,k) = Conductancia;
Analisis1.VoltageOffsetConvolution(:,k) = Struct.VoltageOffset(:,k)-Offset;
Analisis1.factor(k) = factor;
% Analisis1.factorVertical = factorVertical;
Analisis1.factorVerticalLeft(k) = factorVerticalLeft;
Analisis1.factorVerticalRight(k) = factorVerticalRight;
Analisis1.Offset(k) = Offset;
%%
for i=1:length(Struct.Temperature)
    [~,I] = min(Struct.Analisis2.DOS(:,i));
    
    VoltageOffsetConvolution(:,i) = Struct.VoltageOffset(:,i)-Struct.VoltageOffset(I,i);
end
plotCurvesOffset(VoltageOffsetConvolution,Struct.Analisis2.DOS,Struct.Temperature,0.2,'\fontsize{15} DOS (arb. units)',1)
Struct.Analisis2.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1.8 1.8];
b.YLim = [0 3];
b.Layer = 'Top';
%%
plotCurvesOffset(Struct.VoltageOffset,Struct.Analisis1.DOS,Struct.Temperature,0.2,'\fontsize{15} DOS',1)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1.8 1.8];
b.YLim = [0.2 3.7];
b.Layer = 'Top';
%%
plotCurvesOffset(Struct.VoltageOffset,Struct.MatrizConductancia,Struct.Temperature,0.2,'\fontsize{15} Normalized conductance (arb. units)',1)
fig = gcf;
b = fig.Children(end);
b.XLim = [-1.8 1.8];
b.YLim = [0 3.6];
b.Layer = 'Top';

%% DOS smoothing
k = 1;

Voltaje = Struct.Analisis2.VoltageConvolution(:,k);
DOS = Struct.Analisis2.DOS(:,k);

Threshold = 5e-4;
Mask = find(Voltaje>Threshold);
Mask2 = find(Voltaje<-Threshold);

ConductanciaSmooth = DOS;
% DOSSmooth(Mask) =  smoothdata(DOS(Mask),'gaussian',1000);
ConductanciaSmooth(Mask) =  smooth(DOS(Mask),100);
ConductanciaSmooth(Mask2) =  smooth(DOS(Mask2),100);

ConductanciaSmooth(Mask) =  smooth(ConductanciaSmooth(Mask),100);
ConductanciaSmooth(Mask2) =  smooth(ConductanciaSmooth(Mask2),100);

ConductanciaSmooth(Mask) =  smooth(ConductanciaSmooth(Mask),100);
ConductanciaSmooth(Mask2) =  smooth(ConductanciaSmooth(Mask2),100);

ConductanciaSmooth(Mask) =  smooth(ConductanciaSmooth(Mask),100);
ConductanciaSmooth(Mask2) =  smooth(ConductanciaSmooth(Mask2),100);
% DOSSmooth = smooth(DOS,200);

fig = figure;
plot(Voltaje,DOS)
hold on
plot(Voltaje,ConductanciaSmooth)

%% DOS smoothing - all
Threshold = 5e-4;
Window = 150;
Iterations = 4;

ConductanciaSmooth = smoothDOS(Struct.Analisis2.VoltageConvolution,Struct.Analisis2.DOS,Threshold, Window, Iterations);

%%
Struct.Analisis2.DOSSmooth = ConductanciaSmooth;
%% Plotting DOSSmooth
plotCurvesOffset(Struct.Analisis2.VoltageConvolution,Struct.Analisis2.DOSSmoothExtra,Struct.Temperature,0.2,'\fontsize{15} DOS (arb. units)',1)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1 1];
b.YLim = [0 3];
b.Layer = 'Top';
b.ColorOrder = flipud(AzulRojo);
%% Crear colormap
NPuntos = 10;
Vector = linspace(0,1,NPuntos)';
AzulRojo = zeros(NPuntos,3);

AzulRojo(:,1) = Vector;
AzulRojo(:,2) = flipud(Vector);
AzulRojo(:,3) = flipud(Vector);

%%
MatrizConductanciaSmooth = Struct.Analisis2.DOS;
%% Smooth manual

k = 1;

Voltaje = Struct.Analisis2.VoltageConvolution(:,k);
Conductancia = Struct.Analisis2.DOS(:,k);

fig = figure;
plot(Voltaje,Conductancia)
hold on
Conductancia = smooth(Conductancia,10);

Threshold = 1.8e-4;
Window = 100;
Iterations = 4;

ConductanciaSmooth = smoothDOS(Voltaje,Conductancia,Threshold,Window,Iterations);

Threshold = 5e-4;
Window = 20;
Iterations = 50;

ConductanciaSmooth = smoothDOS(Voltaje,ConductanciaSmooth,Threshold,Window,Iterations);

plot(Voltaje,ConductanciaSmooth)

%% Save
MatrizConductanciaSmooth(:,k) = ConductanciaSmooth;

%%
% Struct.MatrizConductanciaSmooth = MatrizConductanciaSmooth;
Struct.Analisis2.DOSSmooth = MatrizConductanciaSmooth;
%%
plotCurvesOffset(Struct.VoltageOffset,Struct.MatrizConductanciaSmooth,Struct.Temperature,0.2,'\fontsize{15} Normalized conductance (arb. units)',1)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1.5 1.5];
b.YLim = [0 3];
b.Layer = 'Top';
b.ColorOrder = flipud(AzulRojo);

%% Calcular convolución de DOS smoothed
MatrizConvolutionSmooth = Struct.Analisis2.DOSSmooth;

[~,NCurves] = size(MatrizConvolutionSmooth);

for k=1:NCurves
    MatrizConvolutionSmooth(:,k) = conv(Struct.dFermiDist(:,k),MatrizConvolutionSmooth(:,k),'same');
    MatrizConvolutionSmooth(:,k) = normalizacionPA(1.7e-3, 1.5e-3, Struct.Analisis2.VoltageConvolution(:,k),MatrizConvolutionSmooth(:,k),2048,2048);
end
%%
Struct.Analisis2.MatrizConvolutionSmooth = MatrizConvolutionSmooth;
%% Primer offset plot (measured conductance)
plotCurvesOffset(Struct.VoltageOffset,Struct.MatrizConductanciaSmoothExtra,Struct.Temperature,0.2,'\fontsize{15} DOS (arb. units)',1)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1 1];
b.YLim = [0 3];
b.Layer = 'Top';
b.ColorOrder = flipud(AzulRojo);

%%
Offset = Struct.Analisis2.Offset;
plotCurvesOffsetOver(Struct.Analisis2.VoltageConvolution,Struct.Analisis2.MatrizConvolutionSmoothExtraMirror,Struct.Temperature,0.2,'\fontsize{15} DOS (arb. units)',1,Offset)

%% Primer offset plot (measured conductance)
plotCurvesOffset(StructNew.VoltageOffset,StructNew.MatrizConductancia,StructNew.MagneticField,0,'\fontsize{15} DOS (arb. units)',0)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1 1];
b.YLim = [0 3];
b.Layer = 'Top';
% b.ColorOrder = flipud(AzulRojo);


%% Test mirror DOS
DOS = Struct.Analisis2.DOSSmoothExtra(:,1);

[~,I] = min(DOS);
DOSMirror = DOS;
for i=1:900
    DOSMirror(I+i) = DOS(I-i);
end

figure
plot(Struct.Analisis2.VoltageConvolution(:,1),DOSMirror)

%% MIRRORING DOS
MatrizDOSMirror = Struct.Analisis2.DOSSmoothExtra;

[~,NCurves] = size(MatrizDOSMirror);

for k=1:NCurves
    DOS = MatrizDOSMirror(:,k);
    [~,I] = min(DOS);
    DOSMirror = DOS;
    
    for i=1:900
        DOSMirror(I+i) = DOS(I-i);
    end
    
    MatrizDOSMirror(:,k) = DOSMirror;
end
%% SAVE
Struct.Analisis2.DOSSmoothExtraMirror = MatrizDOSMirror;

%% Plotting DOSSmoothMirror
plotCurvesOffset(Struct.Analisis2.VoltageConvolution,Struct.Analisis2.DOSSmoothExtraMirror,Struct.Temperature,0.2,'\fontsize{15} DOS (arb. units)',1)
% Struct.Analisis1.VoltageConvolution = VoltageOffsetConvolution;

fig = gcf;
b = fig.Children(end);
b.XLim = [-1 1];
b.YLim = [0 3];
b.Layer = 'Top';
b.ColorOrder = flipud(AzulRojo);

%% Convolucionar
MatrizConvolutionSmooth = Struct.Analisis2.DOSSmoothExtraMirror;

[~,NCurves] = size(MatrizConvolutionSmooth);

for k=1:NCurves
    MatrizConvolutionSmooth(:,k) = conv(Struct.dFermiDist(:,k),MatrizConvolutionSmooth(:,k),'same');
    MatrizConvolutionSmooth(:,k) = normalizacionPA(1.7e-3, 1.5e-3, Struct.Analisis2.VoltageConvolution(:,k),MatrizConvolutionSmooth(:,k),2048,2048);
end
%% SAVE
Struct.Analisis2.MatrizConvolutionSmoothExtraMirror = MatrizConvolutionSmooth;
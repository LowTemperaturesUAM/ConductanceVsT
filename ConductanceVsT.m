%%
genpath('Functions');
addpath(genpath('Functions'));

[FileName, FilePath] = uigetfile('*.blq','Cargar blq');
load([FilePath 'Temperature.mat']);
%%
NCurv = length(dir([FilePath, '*.blq']));
PuntosDerivada = 32;
curvas = ReducedblqreaderV6([FilePath, FileName]);
% NPoints = length(curvas(1).data);

Voltage = curvas(1).data(:,1);
MatrizCorriente = curvas(1).data(:,2);
for i=2:NCurv
    FileName = [int2str(i) '.blq'];
    curvas = ReducedblqreaderV6([FilePath, FileName]);
    MatrizCorriente = [MatrizCorriente curvas(1).data(:,2)];
end
% MatrizConductancia=zeros(2048);
for i=1:NCurv
    MatrizConductancia(:,i)=derivadorLeastSquaresCurva(PuntosDerivada,...
        MatrizCorriente(:,i),Voltage);
end
MatrizNormalizada = normalizacionPA(0.008,0.0075,Voltage,MatrizConductancia,2048,2048);
% Temp2048 = zeros(2048,1);
% for i=1:40
%     Temp2048(i)=Temperature(i);    
% end
for i=1:NCurv
    Matriz2Deriv(:,i)=derivadorLeastSquaresCurva(PuntosDerivada,...
        MatrizConductancia(:,i),Voltage);
end 

kB      = 8.617e-2;
VmV = Voltage*1000;%Voltaje en mV
TK = Temperature;%Temperatura en K
for j=1:NCurv

    Beta	= 1/(kB*TK(j));
    
%     FermiDist	= 1./(1+exp(VmV*Beta));
    dFermiDist	= (Beta*exp(Beta*VmV))./((1+exp(VmV*Beta)).^2); % Analítica
%    dFermiDist	= -diff(FermiDist); % Numérica
    
    MatrizDOS(:,j) = deconvlucy(MatrizConductancia(:,j),dFermiDist);
    MatrizDOS(:,j) = normalizacionPA(0.008,0.0075,Voltage,MatrizDOS(:,j),2048,2048);
end
% figure
% plot(Voltage,dFermiDist)

%%
figure(172)
for i=1:NCurv
    T = ones(length(Voltage),1);
    T = T*Temperature(i);
    fact = i/NCurv;
    plot3(Voltage*1000,T,MatrizDOS(:,i),'Color',[fact 0 1-fact],'LineWidth',1.5)
    grid on
    hold on
end
Children=gca;
% b.Colormap = parula;
% b.YDir='normal';
Children.YLabel.String = '\fontsize{15} Temperature (K)';
Children.XLabel.String = '\fontsize{15} Bias Voltage (mV)';
Children.ZLabel.String = '\fontsize{15} Normalized Conductance';
Children.LineWidth = 2;
Children.XColor = [0 0 0];
Children.YColor = [0 0 0];
Children.ZColor = [0 0 0];
Children.Box = 'On';
Children.FontWeight = 'bold';

%%
fig=figure(190);
Offset = 0.1;
for i=1:NCurv
    if i==14
    plot(Voltage*1000,MatrizDOS(:,i)./B+i*Offset,'r')
    hold on
    else
    plot(Voltage*1000,MatrizDOS(:,i)./B+i*Offset,'k')
    hold on    
    end
end
fig.Children.YLabel.String = '\fontsize{15} Normalized DOS';
fig.Children.XLabel.String = '\fontsize{15} Energy (meV)';

fig.Children.LineWidth = 2;
fig.Children.XColor = [0 0 0];
fig.Children.YColor = [0 0 0];

fig.Children.Box = 'On';
fig.Children.FontWeight = 'bold';
%% Mínimo vs T
Bottom = zeros(size(Temperature));
for i=1:NCurv
    Bottom(i) = min(MatrizDOS(:,i)./MatrizDOS(:,NCurv));
end
figure
plot(Temperature,Bottom,'o')
%% Conv
j = 1; %Número de curva
% TK = Temperature/1000;
kB      = 8.617e-2;%meV/K
Beta	= 1/(kB*TK(j));
VmV = Voltage*1000;

% FermiDist	= 1./(1+exp(VmV*Beta));
dFermiDist	= (Beta*exp(Beta*VmV))./((1+exp(VmV*Beta)).^2); % Analítica
%    dFermiDist	= -diff(FermiDist); % Numérica

% figure
% plot(Voltage,FermiDist)

q = deconvlucy(MatrizNormalizada(:,j),dFermiDist);
q = normalizacionPA(0.008,0.0075,Voltage,q,2048,2048);
r = conv(q,dFermiDist,'same');
r = normalizacionPA(0.008,0.0075,Voltage,r,2048,2048);
% [q,r] = deconv(MatrizConductancia(:,j),dFermiDist);
% DOS = conv(MatrizConductancia(:,j),dFermiDist,'same');
figure
plot(Voltage,q,'b')
hold on
plot(Voltage,MatrizNormalizada(:,j),'k')
plot(Voltage,r,'r')
%%
A = MatrizDOS(:,NCurv);
B = smooth(A,200);
figure
hold on
plot(Voltage,A,'k')
plot(Voltage,B,'r')

%% Conv con FFT
j = 20; %Número de curva
% TK = Temperature/1000;
kB      = 8.617e-2;%meV/K
Beta	= 1/(kB*TK(j));
VmV = Voltage*1000;

% FermiDist	= 1./(1+exp(VmV*Beta));
dFermiDist	= (Beta*exp(Beta*VmV))./((1+exp(VmV*Beta)).^2); % Analítica
%    dFermiDist	= -diff(FermiDist); % Numérica

% figure
% plot(Voltage, dFermiDist)

FermiFFT = abs(fft(dFermiDist));
CurvaFFT = abs(fft(MatrizNormalizada(:,j)));

% DOSFFT = CurvaFFT./FermiFFT;
DOS = ifft(CurvaFFT./FermiFFT);
% figure
% plot(Voltage,abs(FermiFFT))
% hold on
% plot(Voltage,abs(CurvaFFT))
% % plot(Voltage,abs(DOSFFT))

% J = edgetaper(MatrizNormalizada(:,j),dFermiDist);

Curva = MatrizNormalizada(:,j);
CurvaAmp = [flipud(Curva); Curva; flipud(Curva)];
figure
plot(Curva)
% q = deconvlucy(MatrizNormalizada(:,j),dFermiDist);
q = deconvlucy(CurvaAmp,dFermiDist);
% q = deconvwnr(MatrizNormalizada(:,j),dFermiDist,100);
% q = deconvwnr(CurvaAmp,dFermiDist,100);
q = q(length(Curva)+1:length(Curva)*2);
q = normalizacionPA(0.008,0.0075,Voltage,q,2048,2048);


% DOS = normalizacionPA(0.008,0.0075,Voltage,DOS,2048,2048);

r = conv(q,dFermiDist,'same');
r = normalizacionPA(0.008,0.0075,Voltage,r,2048,2048);
% [q,r] = deconv(MatrizConductancia(:,j),dFermiDist);
% DOS = conv(MatrizConductancia(:,j),dFermiDist,'same');
figure
plot(Voltage,q,'b')
hold on
plot(Voltage,MatrizNormalizada(:,j),'k')
plot(Voltage,r,'r')
%   plot(Voltage,DOS,'g')
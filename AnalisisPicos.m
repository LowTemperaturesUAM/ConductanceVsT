A = size(Struct.MatrizConductancia);

MatrizConductanciaPlana = zeros(A);
PicoVectorTop = zeros(A(2),1);
PicoVectorBottom = zeros(A(2),1);
for i=1:A(2)
    Voltaje = Struct.Analisis2.VoltageConvolution(:,i);
%     Voltaje = Struct.VoltageOffset(:,1);
    curva = Struct.Analisis2.DOS(:,i);
%     curva = detrend(curva,1);
    curva = smoothdata(curva,'gaussian',10);    
    
    [peaks,locs] = findpeaks(flipud(curva),flipud(Voltaje));
    
    PicoTop = find(locs>0);
    PicoTop = PicoTop(1);
    PicoVectorTop(i) = locs(PicoTop);
    
%     [~,PicoBottom] = min(curva);
%     PicoVectorBottom(i) = Voltaje(PicoBottom);
%     MatrizConductanciaPlana(:,i) = smoothdata(curva,'gaussian',50);    
end

PicosPlot = figure;
plot(Struct.Temperature, PicoVectorTop*1000,'bo-')
hold on
% plot(Struct.Temperature, PicoVectorBottom*1000,'ro-')
% plot([2.5 2.5],PicosPlot.Children.YLim,'k--')
% plot([5.5 5.5],PicosPlot.Children.YLim,'k--')
xlabel('Temperature (K)')
ylabel('\Delta (mV)')

Struct.Analisis2.Gap = PicoVectorTop*1000;
%%
plotCurvesOffset(Struct.VoltageOffset,MatrizConductanciaPlana,Struct.Temperature,0.15,'\fontsize{15} Normalized Conductance',0)
%%

fig = figure;
% plot(Struct.Temperature, Struct.Gap, 'ko','MarkerSize',8,'LineWidth',2)
% plot(Struct1.Temperature, Struct1.Gap/2, 'ko','MarkerSize',8,'LineWidth',2)
% plot(Struct.Temperature, Struct.Analisis2.Gap, 'ko','MarkerSize',8,'LineWidth',2)
hold on
for i=1:length(Struct.Temperature)
    plot(Struct.Temperature(i), Struct.Analisis2.Gap(i), 'o','MarkerSize',10,'LineWidth',2)
end

b = fig.Children;
b.LineWidth = 2;
b.FontWeight = 'bold';
b.FontName = 'Arial';
b.FontSize = 11;
b.XColor = [0 0 0];
b.YColor = [0 0 0];
b.ColorOrder = AzulRojo;
b.Box = 'on';
xlabel('\fontsize{15} Temperature (K)')
ylabel('\fontsize{15} \Delta (meV)')
hold on
% plot(Struct1.Temperature, Struct1.Gap/2, 'ro-','MarkerSize',8,'LineWidth',2)
Tc = 2.45;
kB      = 8.617e-2;
Delta0 = 1.765*kB*Tc;
plot(DeltaTemp(:,1)*Tc,DeltaTemp(:,2)*Delta0,'k-','LineWidth',2)
% plot(BCS_GAP(:,1)*Tc,BCS_GAP(:,2)*Delta0,'r-','LineWidth',2)
b.XLim = [0 3];
b.YLim = [0 0.5];

set(gca,'children',flipud(get(gca,'children'))) %Fit al fondo
%%
DeltaTemp = [
            0       1
            0.02    1
            0.1004	1
            0.19919	1
            0.29935	0.99087
            0.39814	0.97015
            0.49854	0.93893
            0.59733	0.89132
            0.65292	0.85793
            0.69612	0.82052
            0.7485	0.77074
            0.7949	0.71478
            0.8397	0.6545
            0.87508	0.59019
            0.90748	0.52372
            0.93528	0.45107
            0.95848	0.36172
            0.97709	0.28288
            0.98789	0.20003
            1       0
                ];

fig = figure;
plot(DeltaTemp(:,1)*Tc,DeltaTemp(:,2)*0.1473)
%%
C = Struct.MatrizConductancia(:,1);
Voltaje = 1000*Struct.VoltageOffset(:,1);
% curva = detrend(curva,1);
C = smoothdata(C,'gaussian',30);
[peaksPixel,locsPixel] = findpeaks(C);
[peaks,locs] = findpeaks(flipud(C),flipud(Voltaje));
PicoTop = find(locs>0.0001);
figure(1)
% plot(Voltaje,curva)
hold on
plot(Voltaje,C)
plot(Voltaje(locsPixel),peaksPixel,'ko')
%%
C = Struct.Matriz2Deriv(:,7);
Voltaje = 1000*Struct.VoltageOffset(:,1);
% curva = detrend(curva,1);
C = smoothdata(C,'gaussian',30);
[peaksPixel,locsPixel] = findpeaks(C);
[peaks,locs] = findpeaks(flipud(C),flipud(Voltaje));
PicoTop = find(locs>0.0001);
figure(1)
% plot(Voltaje,curva)
hold on
plot(Voltaje,C)
plot(Voltaje(locsPixel),peaksPixel,'ko')
%%
C = Struct.Analisis2.DOS(:,1);
Voltaje = 1000*Struct.Analisis2.VoltageConvolution(:,1);
% Voltaje = Struct.VoltageOffset(:,1);
% curva = detrend(curva,1);
C = smoothdata(C,'gaussian',10);
[peaksPixel,locsPixel] = findpeaks(C);
[peaks,locs] = findpeaks(flipud(C),flipud(Voltaje));
PicoTop = find(locs>0.0001);
figure(1)
% plot(Voltaje,curva)
hold on
plot(Voltaje,C)
plot(Voltaje(locsPixel),peaksPixel,'ko')
%%
figure(2)

findpeaks(flipud(C),flipud(Voltaje));
%%
y = detrend(curva,1);
figure
plot(Voltaje,curva)
hold on
plot(Voltaje,y)
plot(Voltaje,y2)

%%
fig = figure;
plot(Struct.VoltageOffset(:,1)*1000,MatrizConductanciaPlana(:,1) + 0.4,'k','LineWidth',1.5);
b = fig.Children;
b.XLabel.String = '\fontsize{15} Voltage (mV)';
b.YLabel.String = '\fontsize{15} Normalized conductance (arb. units)';
% b.XLabel.String = '\fontsize{15} k_{x} (nm^-^1)';
b.LineWidth = 2;
b.XColor = [0 0 0];
b.YColor = [0 0 0];
b.FontWeight = 'bold';
% b.YDir = 'normal';
b.XLim = [-10 10];
b.YLim = [0.07 0.52];
colormap hot
% b.DataAspectRatio = [ratioXY 1 1];
% axis square
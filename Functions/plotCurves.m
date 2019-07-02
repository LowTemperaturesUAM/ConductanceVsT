function [] = plotCurves(Voltage,Temperature,Matriz,ylabel,zlabel)
A = size(Matriz);
NCurv = A(2);
figure
for i=1:NCurv
    T = ones(length(Voltage),1);
    T = T*Temperature(i);
    fact = i/NCurv;
    plot3(Voltage(:,i)*1000,T,Matriz(:,i),'Color',[fact 0 1-fact],'LineWidth',1.5)
    grid on
    hold on
end
b=gca;
% b.Colormap = parula;
% b.YDir='normal';
b.YLabel.String = ylabel;
b.XLabel.String = '\fontsize{15} Bias Voltage (mV)';
b.ZLabel.String = zlabel;%'\fontsize{15} Normalized Conductance';
b.LineWidth = 2;
b.XColor = [0 0 0];
b.YColor = [0 0 0];
b.ZColor = [0 0 0];
b.Box = 'On';
b.FontWeight = 'bold';
end
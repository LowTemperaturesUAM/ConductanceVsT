function [] = plotCurvesOffset(Voltage,Matriz,Offset,zlabel)

fig=figure;
A = size(Matriz);
NCurv = A(2);
for i=1:NCurv
    if i==14
    plot(Voltage(:,i)*1000,Matriz(:,i)+i*Offset,'r')
    hold on
    else
    plot(Voltage(:,i)*1000,Matriz(:,i)+i*Offset,'k')
    hold on    
    end
end

fig.Children.YLabel.String = zlabel; %'\fontsize{15} DOS';
fig.Children.XLabel.String = '\fontsize{15} Energy (meV)';

fig.Children.LineWidth = 2;
fig.Children.XColor = [0 0 0];
fig.Children.YColor = [0 0 0];

fig.Children.Box = 'On';
fig.Children.FontWeight = 'bold';

fig.Position = [711 159 298 704];
end
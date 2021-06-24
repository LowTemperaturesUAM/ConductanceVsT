function [] = plotCurvesOffset(Voltage,Matriz,Temperature,Offset,zlabel,flag)

fig=figure;
A = size(Matriz);
NCurv = A(2);
Leyenda = cell(1,NCurv);
for i=NCurv:-1:1 %Orden descendente para que la leyenda quede bien ordenada (de abajo a arriba, siguiendo el orden de las curvas)
% for i=1:NCurv
    if flag
        Leyenda{i} = [num2str(Temperature(i)),' K'];
    else
        Leyenda{i} = [num2str(Temperature(i)),' T'];
    end
%     if i==14
%     plot(Voltage(:,i)*1000,Matriz(:,i)+i*Offset,'r')
%     hold on
%     else
    plot(Voltage(:,i)*1000,Matriz(:,i)+(i-1)*Offset,'LineWidth',3)
    hold on    
%     end
end
legend(fliplr(Leyenda),'Location','bestoutside')
% legend(Leyenda,'Location','bestoutside')
% fig.Children(end).ColorOrder = flipud(winter(NCurv));

fig.Children(end).YLabel.String = zlabel; %'\fontsize{15} DOS';
fig.Children(end).XLabel.String = '\fontsize{18} Voltage (mV)';

fig.Children(end).LineWidth = 2;
fig.Children(end).XColor = [0 0 0];
fig.Children(end).YColor = [0 0 0];

fig.Children(end).Box = 'On';
fig.Children(end).FontWeight = 'bold';
fig.Children(end).FontName = 'Arial';
fig.Children(end).FontSize = 14;

fig.Position = [711 159 398 704];
end
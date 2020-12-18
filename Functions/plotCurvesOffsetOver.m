%Función creada simplemente para pintar encima de un offset plot otro set
%de curvas. Offsetvoltage es un vector con el offset individual de cada
%curva.

function [] = plotCurvesOffsetOver(Voltage,Matriz,Temperature,Offset,zlabel,flag, OffsetVoltage)

fig=gcf;
A = size(Matriz);
NCurv = A(2);
Leyenda = cell(1,NCurv);
for i=NCurv:-1:1 %Orden descendente para que la leyenda quede bien ordenada (de abajo a arriba, siguiendo el orden de las curvas)
    if flag
        Leyenda{i} = [num2str(Temperature(i)),' K'];
    else
        Leyenda{i} = [num2str(Temperature(i)),' T'];
    end
%     if i==14
%     plot(Voltage(:,i)*1000,Matriz(:,i)+i*Offset,'r')
%     hold on
%     else
    plot((Voltage(:,i)-OffsetVoltage(i))*1000,Matriz(:,i)+(i-1)*Offset,'-','Color',[0.2 0.2 0.2],'LineWidth',1.5)
    hold on    
%     end
end
legend(fliplr(Leyenda),'Location','bestoutside')
% fig.Children(end).ColorOrder = flipud(winter(NCurv));

% fig.Children(end).YLabel.String = zlabel; %'\fontsize{15} DOS';
% fig.Children(end).XLabel.String = '\fontsize{15} Energy (meV)';
% 
% fig.Children(end).LineWidth = 2;
% fig.Children(end).XColor = [0 0 0];
% fig.Children(end).YColor = [0 0 0];
% 
% fig.Children(end).Box = 'On';
% fig.Children(end).FontWeight = 'bold';
% fig.Children(end).FontName = 'Arial';
% fig.Children(end).FontSize = 11;
% 
% fig.Position = [711 159 398 704];
end
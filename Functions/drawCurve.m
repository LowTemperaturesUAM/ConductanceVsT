function [VoltageCurva,CorrienteCurva,ConductanciaCurva] = drawCurve(curvas,Index,PuntosDerivada,NormInf,NormSup,Offset,flag)
VoltageCurva = curvas(Index).data(:,1)-Offset;
CorrienteCurva = curvas(Index).data(:,2);

% if ~rem(Index,2)
%     VoltageCurva = flipud(VoltageCurva);
%     CorrienteCurva = flipud(CorrienteCurva);
% end

ConductanciaCurva = derivadorLeastSquaresCurva(PuntosDerivada,CorrienteCurva,VoltageCurva);

if flag
    ConductanciaCurva = normalizacionPA(NormSup,NormInf,VoltageCurva,ConductanciaCurva,2048,2048);
end


fig=figure(73838);
fig.Position(2:4) = [100 1000 420];
hold on
ax1 = subplot(1,2,1);
cla(ax1)
plot(VoltageCurva*1000,CorrienteCurva,'k-','LineWidth',2)
grid on
ax2 = subplot(1,2,2);
cla(ax2)
plot(VoltageCurva*1000,ConductanciaCurva,'k-','LineWidth',2)
grid on
%axis limits slighly outside the curve limits
xlim([ax1,ax2],1001*[min(VoltageCurva), max(VoltageCurva)])

fig.Children(1).YLabel.String = '\fontsize{15} Conductance';
fig.Children(1).XLabel.String = '\fontsize{15} Bias Voltage (mV)';

fig.Children(2).YLabel.String = '\fontsize{15} Intensity (A)';
fig.Children(2).XLabel.String = '\fontsize{15} Bias Voltage (mV)';

fig.Children(1).LineWidth = 2;
fig.Children(1).XColor = [0 0 0];
fig.Children(1).YColor = [0 0 0];

fig.Children(1).Box = 'On';
fig.Children(1).FontWeight = 'bold';

fig.Children(2).LineWidth = 2;
fig.Children(2).XColor = [0 0 0];
fig.Children(2).YColor = [0 0 0];

fig.Children(2).Box = 'On';
fig.Children(2).FontWeight = 'bold';
end
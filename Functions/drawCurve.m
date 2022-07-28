function [VoltageCurva,CorrienteCurva,ConductanciaCurva] = drawCurve(curvas,Index,PuntosDerivada,NormInf,NormSup,Offset,Normalized,blqCol)
VoltageCurva = curvas(Index).data(:,1)+Offset;
CorrienteCurva = curvas(Index).data(:,blqCol);

ConductanciaCurva = derivadorLeastSquaresCurva(PuntosDerivada,CorrienteCurva,VoltageCurva);

if Normalized
    ConductanciaCurva = normalizacionPA(NormSup,NormInf,VoltageCurva,ConductanciaCurva);
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
%plot vertical lines to show normalization limits
if Normalized
    xline(ax2,NormInf*1000,'b-',HandleVisibility='off')
    xline(ax2,-NormInf*1000,'b-',HandleVisibility='off')
    xline(ax2,NormSup*1000,'r-',HandleVisibility='off')
    xline(ax2,-NormSup*1000,'r-',HandleVisibility='off')
end


ax1.YLabel.String = '\fontsize{15} Intensity (A)';
ax1.XLabel.String = '\fontsize{15} Bias Voltage (mV)';

ax2.YLabel.String = '\fontsize{15} Conductance';
ax2.XLabel.String = '\fontsize{15} Bias Voltage (mV)';


ax1.LineWidth = 2;
ax1.XColor = [0 0 0];
ax1.YColor = [0 0 0];

ax1.Box = 'On';
ax1.FontWeight = 'bold';

ax2.LineWidth = 2;
ax2.XColor = [0 0 0];
ax2.YColor = [0 0 0];

ax2.Box = 'On';
ax2.FontWeight = 'bold';

hold off
end
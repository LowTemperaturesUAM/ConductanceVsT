function [VoltageCurva,CorrienteCurva,ConductanciaCurva] = drawForthBack(curvas,Index,PuntosDerivada,NormInf,NormSup,Offset,Normalized,blqCol,retChoice)
VoltageCurvaIda = curvas(Index).data(:,1)+Offset;
CorrienteCurvaIda = curvas(Index).data(:,blqCol);

VoltageCurvaVuelta = curvas(Index+1).data(:,1)+Offset;
CorrienteCurvaVuelta = curvas(Index+1).data(:,blqCol);

ConductanciaCurvaIda = derivadorLeastSquaresCurva(PuntosDerivada,CorrienteCurvaIda,VoltageCurvaIda);
ConductanciaCurvaVuelta = derivadorLeastSquaresCurva(PuntosDerivada,CorrienteCurvaVuelta,VoltageCurvaVuelta);

if Normalized
    ConductanciaCurvaIda = normalizacionPA(NormSup,NormInf,VoltageCurvaIda,ConductanciaCurvaIda);
    ConductanciaCurvaVuelta = normalizacionPA(NormSup,NormInf,VoltageCurvaVuelta,ConductanciaCurvaVuelta);
end


fig=figure(73838);
fig.Position(2:4) = [100 1000 420];
%hold on
ax1 = subplot(1,2,1);
cla(ax1)
plot(ax1,VoltageCurvaIda*1000,CorrienteCurvaIda,'k-','LineWidth',2,'DisplayName','Forth')
hold(ax1,'on')
plot(ax1,VoltageCurvaVuelta*1000,CorrienteCurvaVuelta,'r-','LineWidth',2,'DisplayName','Back')
grid on
ax2 = subplot(1,2,2);
cla(ax2)
plot(ax2,VoltageCurvaIda*1000,ConductanciaCurvaIda,'k-','LineWidth',2,'DisplayName','Forth')
hold(ax2,'on')
plot(ax2,VoltageCurvaVuelta*1000,ConductanciaCurvaVuelta,'r-','LineWidth',2,'DisplayName','Back')
grid on

%axis limits slighly outside the curve limits
xlim([ax1,ax2],1001*[min(VoltageCurvaIda), max(VoltageCurvaIda)])
%plot vertical lines to show normalization limits
if Normalized
    NormLine(1)=xline(ax2,NormInf*1000,'b-',HandleVisibility='off');
    NormLine(2)=xline(ax2,-NormInf*1000,'b-',HandleVisibility='off'); 
    NormLine(3)=xline(ax2,NormSup*1000,'r-',HandleVisibility='off');
    NormLine(4)=xline(ax2,-NormSup*1000,'r-',HandleVisibility='off');
    %Remove the lines from the legend. It can also be done with:
    %NormLine(2).Annotation.LegendInformation.IconDisplayStyle = 'off';
end


ax1.YLabel.String = '\fontsize{15} Conductance';
ax1.XLabel.String = '\fontsize{15} Bias Voltage (mV)';

ax2.YLabel.String = '\fontsize{15} Intensity (A)';
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

hold([ax1,ax2],'off')

%now we return a curve depending on the choice
switch retChoice
    case 'Forth'
        % por ahora devolvemos solo la vuelta
        VoltageCurva = VoltageCurvaIda;
        CorrienteCurva = CorrienteCurvaIda;
        ConductanciaCurva = ConductanciaCurvaIda;
    case 'Back'
        VoltageCurva = VoltageCurvaVuelta;
        CorrienteCurva = CorrienteCurvaVuelta;
        ConductanciaCurva = ConductanciaCurvaVuelta;
    case 'Avg'
        VoltageCurva = (VoltageCurvaIda + VoltageCurvaVuelta)/2; %not completely accurate
        CorrienteCurva = (CorrienteCurvaIda + CorrienteCurvaVuelta)/2;
        ConductanciaCurva = derivadorLeastSquaresCurva(PuntosDerivada,CorrienteCurva,VoltageCurva);
        if Normalized
            ConductanciaCurva = normalizacionPA(NormSup,NormInf,VoltageCurva,ConductanciaCurva);
        end
    case 'Both'
        VoltageCurva = [VoltageCurvaIda, VoltageCurvaVuelta];
        CorrienteCurva = [CorrienteCurvaIda, CorrienteCurvaVuelta];
        ConductanciaCurva = [ConductanciaCurvaIda, ConductanciaCurvaVuelta];
end


end
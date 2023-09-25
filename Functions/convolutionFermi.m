function [Conductance, DOSGuess] = convolutionFermi(Fermi, DOS, HorzFact, VertFactSup, VertFactInf)
% Uses an expanded array for DOS and Fermi distribution in
% order to avoid curvature at the extremes. After convoluting,
% we should keep only the original part, which should be the
% center.

%INPUTS
% Fermi         Derivative of Fermi distribution
% DOS           Density of States
% HorzFact      Parameter for shrink function. Decreasing it resizes DOS to
%               smaller size horizontally.
% VertFactSup   Parameter for stretchVertical. Resizes DOS values above 1.
% VertFactInf   Parameter for stretchVertical. Resizes DOS values below 1.



%--------------------------------------------------------------------------
% Place 0s around Fermi distribution
addExtra = zeros(size(Fermi,1)*2, size(Fermi,2));
fermiExtended = [addExtra; Fermi; addExtra];

addExtra = addExtra + 1;
% Place 1s around DOS
DOSExtended = [addExtra(:,1); DOS; addExtra(:,1)];
% Better to use the actual extremes (mean) instead of strictly 1.
% range = 100;
% DOSExtended = [addExtra(:,1).*mean(DOS(1:range)); DOS; addExtra(:,1).*mean(DOS(end-range:end))];

% Distort DOS so that convolution fits the data

try % Check errors in shrink when HFactor is 0
DOSExtended = shrink(DOSExtended, HorzFact);
catch ME
    if (strcmp(ME.identifier,'MATLAB:resizeParseInputs:expectedPositive'))
        %causeException = MException('MATLAB:deconvolution:nonPositive','Try again');
        disp('Shrink factor is 0, using straight line as DOS');
        VertFactInf = 0;
        VertFactSup = 0;
    %ME = addCause(ME, causeException);

    end
    %rethrow(ME)
end

% Distort vertically
DOSExtended = stretchVertical(DOSExtended,VertFactSup,VertFactInf);
% Convolute Fermi distribution with DOS
Conductance = conv(fermiExtended, DOSExtended, 'same');

% Extract original section, without extended bounds
extraSize = length(addExtra); 
oldSize = length(DOS);
selectIdx = [(extraSize + 1):(extraSize + oldSize)];

Conductance = Conductance(selectIdx,:);
DOSGuess = DOSExtended(selectIdx,:);
            
end
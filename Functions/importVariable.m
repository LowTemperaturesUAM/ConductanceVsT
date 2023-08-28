function [varOut] = importVariable(text) %varIn es un string
[FileName, FilePath] = uigetfile('*.mat',text);

% Prevent error if no file is selected/ action is cancelled
if isequal(FileName,0)
    varOut=struct([]);
    return
end

% Load struct with variables in file
dataIn = load([FilePath FileName]);
% There should be only a variable named Struct. We take it as our output.
if isfield(dataIn,'Struct')
    varOut = dataIn.Struct;
else %return an empy struct
    varOut = struct([]);
end

end
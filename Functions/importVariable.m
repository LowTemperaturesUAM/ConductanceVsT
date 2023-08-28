function [varOut] = importVariable(text) %varIn es un string
[FileName, FilePath] = uigetfile('*.mat',text);

% Prevent error if no file is selected/ action is cancelled
if isequal(FileName,0)
    varOut=0;
    return
end

% Load struct with variables in file
varOut = load([FilePath FileName]);
% There should be only a variable named Struct. We take it as our output.
varOut = varOut.Struct;
end
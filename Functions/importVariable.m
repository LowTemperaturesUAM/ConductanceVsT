function [varOut] = importVariable(text) %varIn es un string
[FileName, FilePath] = uigetfile('*.mat',text);
varOut = load([FilePath FileName]);
varOut = varOut.Struct;
end
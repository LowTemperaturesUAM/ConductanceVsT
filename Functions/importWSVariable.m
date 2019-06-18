function [varOut] = importWSVariable(varIn) %varIn es un string
varOut = evalin('base',varIn);
end
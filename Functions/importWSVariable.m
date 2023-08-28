function [varOut] = importWSVariable(varIn) %varIn es un string
try %Look for the data in the workspace. Else return and empty struct
    varOut = evalin('base',varIn);
catch
    varOut = struct([]);
end
end
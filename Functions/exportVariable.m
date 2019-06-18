function [] = exportVariable(Struct,FilePath)
save([FilePath, '\', inputname(1)],'Struct');
end
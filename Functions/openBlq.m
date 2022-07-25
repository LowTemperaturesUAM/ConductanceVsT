function [FileName,FilePath,curvas] = openBlq(startPath)
[FileName, FilePath] = uigetfile('*.blq','Cargar blq',startPath);

if ~isequal(FileName,0)
    curvas = Newblqreader([FilePath, FileName]);
    
    for i=1:length(curvas)
        if ~rem(i,2)
            curvas(i).data = flipud(curvas(i).data);
        end
    end
else
    curvas = [];
end


end
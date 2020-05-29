%factor < 1
function [CurvaShrink] = shrink(Curva,factor)

NPoints = length(Curva);
CurvaShrink = ones(NPoints,1);

NPointsShrink = floor(NPoints*factor);
CurvaResized = imresize(Curva,[NPointsShrink,1]);

CurvaShrink(floor((NPoints-NPointsShrink)/2):floor((NPoints-NPointsShrink)/2)+NPointsShrink-1) = CurvaResized;

end
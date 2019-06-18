function [] = exportWSVariable(var)

Name = inputname(1);
assignin('base',Name,var);

end
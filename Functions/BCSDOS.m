% BCS density of states : Ns/N0
function [DOS] = BCSDOS(E,Delta)

DOS = zeros(length(E),1);

for i = 1:length(E)
    if abs(E(i))>Delta
        DOS(i) = abs(E(i))/sqrt(E(i)^2-Delta^2);
    end
end
end
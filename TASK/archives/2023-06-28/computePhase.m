function [phase] = computePhase(X,Y,amplitude)
% phase = phase in rad, between 0 and 2*pi
% X, Y:coordinate w.r.t center of the screen (0,0) of the position for which one wants to compute the phase. Y is positive downward and X is positive rightward
% amplitude = distance of the position from the center of the screen

    if and(Y(end)>=0, X(end)>=0)
        phase = acos(-Y(end)/amplitude);
    elseif and(Y(end)<=0, X(end)>=0)
        phase = asin(X(end)/amplitude);
    elseif and(Y(end)>=0,X(end)<=0)
        phase = acos(Y(end)/amplitude)+pi;
    elseif and(Y(end)<=0,X(end)<=0)
        phase = 2*pi - asin(-X(end)/amplitude);
    end
end


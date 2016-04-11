function stepCount = countSteps(data)
% STEPCOUTNER
    % Estimates the number of steps taken in 'data' vector
    % Sample rate of 'data' is assumed to be around 200Hz (min peak 
    % distance is dependent on it)
    % mea must be subtracted out of the data for this to work properly
    dataMatrix = frameSegment(data,8);
    power = sum(dataMatrix.^2)./size(dataMatrix,2);
    pks = findpeaks(power,'MinPeakDistance',6,'MinPeakProminence',...
        0.03); % 0.03 worked pretty well for running
    % the peak prominence should be a function of ambient power
    stepCount = length(pks);
end
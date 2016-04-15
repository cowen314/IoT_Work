function stepCount = countSteps(data)
% STEPCOUTNER
    % Estimates the number of steps taken in 'data' vector
    % Sample rate of 'data' is assumed to be around 200Hz (min peak 
    % distance is dependent on it)
    % mean must be subtracted out of the data for this to work properly
    
    % subtract mean out just in case
    data = data-mean(data);
    
    dataMatrix = frameSegment(data,8);
    % power = sum(dataMatrix.^2)./size(dataMatrix,2);
    power = sum(dataMatrix.^2);
    
    % diregard anything under 10% of the max peak
    power_filt = power; power_filt(power_filt<1.5*mean(power)) = 0;
    % instead of defining the threshold as a function of the maximum, do it
    % as a function of the averge power over time
    
    pks = findpeaks(power_filt,'MinPeakDistance',6,'MinPeakProminence',...
        0.03); % 0.03 worked pretty well for running
    % the peak prominence should be a function of ambient power
    plot(power_filt);
    stepCount = length(pks);
end
function stepCount = countSteps(data)
% STEPCOUTNER
    % Estimates the number of steps taken in 'data' vector
    % Sample rate of 'data' is assumed to be around 200Hz (min peak 
    % distance is dependent on it)
    % mean must be subtracted out of the data for this to work properly
    
    % subtract mean out just in case
    data = data-mean(data);
    
    dataMatrix = frameSegment(data,8);
    % energy = sum(dataMatrix.^2)./size(dataMatrix,2);
    energy = sum(dataMatrix.^2);
    
    % diregard anything under 1.5 times the mean energy in the data
    energy_filt = energy;
    energy_filt(energy_filt<1.5*mean(energy)) = 0;
    
    pks = findpeaks(energy_filt,'MinPeakDistance',6,'MinPeakProminence',...
        0.03); % 0.03 worked pretty well for running
    % the peak prominence should be a function of ambient energy
    plot(energy_filt);
    stepCount = length(pks);
end
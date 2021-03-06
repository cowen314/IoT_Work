%% initialize names
filenames = {...
    'Treadmill1B_E887.csv'...
    'Treadmill1F_E8E3.csv'...
    'Treadmill2B_E91B.csv'...
    'Treadmill3B_E913.csv'...
    'Treadmill4B_E833.csv'...
    'Treadmill5F_E84F.csv'};

colnames = {...
    'Timestamps',...
    'Accel X',...
    'Accel Y',...
    'Accel Z',...
    'Battery',...
    'Gyro X',...
    'Gyro Y',...
    'Gyro Z',...
    'Mag X',...
    'Mag Y',...
    'Mag Z',...
    };


%% Some initial stuff
TM4b = 'Second_Deplo_Session1_Shimmer_E833_Calibrated_SD.csv';
TM4f = 'Second_Deplo_Session1_Shimmer_E863_Calibrated_SD.csv';
DataExaminer.compareData(TM4f,TM4b,2)
figure
DataExaminer.compareData(TM4f,TM4b,2,[])

%% Simple information calculation using the DataExaminer class
WINDOW_SIZE = 256;
for i = 1:length(filenames)
    figure
    Fs = DataExaminer.sampleInfo(filenames{i});
    powerSpectra = DataExaminer.powerSpectrum(filenames{i},2,...
        WINDOW_SIZE);
    subplot(3,1,1)
    f_axis = linspace(0,Fs/2,WINDOW_SIZE/2+1);
    plot(f_axis,10*log10(powerSpectra))
    title('Power Spectral Density')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/(rad/sample))')

    fftSignal = DataExaminer.frequencySpectrum(filenames{i},2,...
        WINDOW_SIZE);
    subplot(3,1,2)
    f_axis = length(fftSignal)/2*linspace(-1,1,length(fftSignal));
    plot(f_axis,abs(fftSignal))
    title('Frequency Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    
    zcr = DataExaminer.zcr(filenames{i},2,256);
    subplot(3,1,3)
    plot(zcr)
    title('Zero Crossing Rate')
    xlabel('Window index number')
    ylabel('ZCR')
end

%% Time plots
for i = 1:length(filenames)
    figure
    DataExaminer.plotTime(filenames{i},2);
end

%% plots the examine specific things
% someone getting on a treadmill
DataExaminer.plotTime(filenames{2},2);
ends = [8625 23760];
eventInd = 1.507e4;
for i = 2:2
    figure
    DataExaminer.plots(filenames{2},i,256,ends(1),ends(2),eventInd);
    hTextBox(i) = uicontrol('style','text');
    set(hTextBox(i),'String',colnames{i});
    set(hTextBox(i),'Position',[0 30 300 25])
end

% This shows that 

%% Spectrogram
for i = 1:length(filenames)
    figure
    DataExaminer.plots(filenames{i},2,256,1,1000);
end

%% Autocorrelation
for i = 1:length(filenames)
    DataExaminer.harmonicity(filenames{i},2,-1,[3,2,1])
end

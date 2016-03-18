%% Some initial stuff
TM4b = 'Second_Deplo_Session1_Shimmer_E833_Calibrated_SD.csv';
TM4f = 'Second_Deplo_Session1_Shimmer_E863_Calibrated_SD.csv';
DataExaminer.compareData(TM4f,TM4b,2)
figure
DataExaminer.compareData(TM4f,TM4b,2,[])

%% Simple feature calculation
WINDOW_SIZE = 256;
Fs = DataExaminer.sampleInfo('Treadmill1B_E887.csv');
powerSpectra = DataExaminer.powerSpectrum('Treadmill1B_E887.csv',2,...
    WINDOW_SIZE);
subplot(2,1,1)
f_axis = linspace(0,Fs/2,WINDOW_SIZE/2+1);
plot(f_axis,10*log10(powerSpectra))
title('Power Spectral Density')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/(rad/sample))')

zcr = DataExaminer.zcr('Treadmill1B_E887.csv',2,256);
subplot(2,1,2)
plot(zcr)
title('Zero Crossing Rate')
xlabel('Window index number')
ylabel('ZCR')
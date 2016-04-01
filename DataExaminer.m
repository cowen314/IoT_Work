classdef DataExaminer
% A class to help with data examination

    methods (Static)
        function Fs = sampleInfo(filename)
            dataMatrix = csvread(filename,3,0);
            sampleTimes_ms = dataMatrix(:,1);
            sampleSpacing = filter2([-1; 1],sampleTimes_ms);
            sampleSpacing = sampleSpacing(1:(length(sampleSpacing)-1));
            disp(['Standard sample time deviation (ms): ', ...
                num2str(std(sampleSpacing))]);
            disp(['Sample period (ms): ', num2str(mean(sampleSpacing))]);
            Fs = 1/median(sampleSpacing)*1000;
            disp(['Sample frequency (Hz): ', num2str(Fs)]);
        end
        
        function pxx = powerSpectrum(filename,colNumber,windowSize)
            dataMatrix = csvread(filename,3,0);
            data = dataMatrix(:,colNumber);
            windowsMatrix = frameSegment(data,windowSize);
            pxx = pwelch(windowsMatrix);
        end
        
        function pxx = frequencySpectrum(filename,colNumber,windowSize)
            dataMatrix = csvread(filename,3,0);
            data = dataMatrix(:,colNumber);
            windowsMatrix = frameSegment(data,windowSize);
            pxx = fftshift(fft(windowsMatrix));
        end
        
        function [ zcr ] = zcr(filename,colNumber,windowSize)
        %ZCR zero crossing rate
            dataMatrix = csvread(filename,3,0);
            data = dataMatrix(:,colNumber);
            % below, data becomes a matrix
            data = frameSegment(data,windowSize);
            data_shifted = data(2:end,:);
            data = data(1:(end-1),:);
            zcr = sum(abs(sign(data)-sign(data_shifted))) / ...
                (2*(size(data,1)+1));
        end
        
        function features = plots(filename, colNumber, window, sInd, eInd, eventInd)
            % data extraction
            dataMatrix = csvread(filename,3,0);
            time = dataMatrix(sInd:eInd,1)/(1000);
            time = time-time(1);
            Fs = 1/((time(2)-time(1)));
            data = dataMatrix(sInd:eInd,colNumber);
            data = data - mean(data);
            
            % spectrogram
            subplot(3,2,1)
            [S,F,T] = spectrogram(data,window);
            F = linspace(0,Fs/2,length(F));
            T = linspace(time(1),time(length(time)),length(T))/60;
            hSurf1 = surf(T,F,10*log10(abs(S)),'EdgeColor','none');
            view(2);
            a = gca;
            a.XLim = [min(T) max(T)];
            a.YLim = [min(F) max(F)];
            title(['Spectrogram, window length: ' num2str(window)]);
            xlabel('Time (minutes)')
            ylabel('Frequency (Hz)')
            
            % time domain plot
            subplot(3,2,3)
            plot(time/60,data);
            a = gca;
            a.XLim = [min(time/60) max(time/60)];
            xlabel('Time (minutes)')
            
            % data split
            dataMatrix = frameSegment(data,window);
            
            % zcr
            subplot(3,2,2)
            title('ZCR')
            dataMatrix_shifted = dataMatrix(2:end,:);
            dataMatrix_o = dataMatrix(1:(end-1),:);
            zcr = sum(abs(sign(dataMatrix_o)-sign(dataMatrix_shifted)))/...
                (2*(size(dataMatrix_o,1)+1));
            plot(zcr)
            title('ZCR')
            
            % energy
            subplot(3,2,4)
            energy = sum(dataMatrix.^2);
            plot(energy)
            title('Signal energy')
            
            % harmonic ratio
            % FeatureCalculator(dataMatrix,10,)
            
            % feature space plot
            subplot(3,2,5)
            eventInd_window = floor((eventInd-sInd)/window);
            zcr_pre = zcr(1:eventInd_window);
            zcr_post = zcr(eventInd_window+1:end);
            energy_pre = energy(1:eventInd_window);
            energy_post = energy(eventInd_window+1:end);
            plot(zcr_pre,energy_pre,'o',zcr_post,energy_post,'x');
            xlabel('zcr')
            ylabel('energy')
            
            % features = [zcr, energy];
            
            % power plot (of post section)
            subplot(3,2,6)
            pwelch(data((eventInd-sInd):end));
            
        end
        
        function plotTime(filename, colNumber)
            colOffset = colNumber-1;
            N = countLines(filename);
            time = csvread(filename,3,0,[3 0 N-2 0]);
            dataMatrix = csvread(filename,3,0);
            time = time/(1000*60);
            time = time-time(1);
            data = csvread(filename,3,colOffset,[3 colOffset N-2 colOffset]);
            plot(time,data);
            xlabel('Time stamps (min)')
            % plot(data)
        end
            
        function compareData(filename1,filename2,colNumber,removeOffset)
            dataMatrix1 = csvread(filename1,3,0);
            dataMatrix2 = csvread(filename2,3,0);
            if(nargin == 3)
                plot(dataMatrix1(:,1)/(1000*60),...
                    dataMatrix1(:,colNumber),dataMatrix2(:,1)/(1000*60),...
                    dataMatrix2(:,colNumber));
            end
            if(nargin == 4)
                plot((dataMatrix1(:,1)-min(dataMatrix1(:,1)))/(1000*60),...
                    dataMatrix1(:,colNumber),...
                    (dataMatrix2(:,1)-min(dataMatrix2(:,1)))/...
                    (1000*60),dataMatrix2(:,colNumber));
            end
            xlabel('Time (minutes)');
        end
        
        
        
        function [fpeak, amplitude] = largestPeaks(filename, window)
            dataMatrix = csvread(filename,3,0);
            time = dataMatrix(:,1)/(1000);
            time = time-time(1);
            Fs = 1/((time(2)-time(1)));
            data = dataMatrix(:,colNumber);
            [S,F,T] = spectrogram(data,window);
            % keep working here
        end
        
        function [lag, HR] = harmonicity(filename,colNumber,minlag,subplotArgs)
        %HARMONICITY Calculates lag and normalized harmonic ratio
            % lag - number of lag samples that maximize the autocorellation
            % HR - largest value above minlag in the normalized
            % autocorellation
            % Stick a third argument in to plot the autocorellation
            N = countLines(filename);
            data = csvread(filename,3,colNumber,[3 colNumber N-2 colNumber]);
            r = xcorr(data,'coeff');
            r = r(floor(length(r)/2):length(r));
            r(1:minlag) = 0;
            if(nargin==4)
                figure
                plot(r)
                axis([0 100 min(r(1:100)) max(r(1:100))])
                title('Autocorrelation')
            end
            HR = max(r);
            lag = find(r==max(r));
        end
        
        function [data,filename] = snip(filename,sInd,eInd)
            colOffset = colNumber-1;
            data = csvread(filename,3,colOffset,...
                [sInd+2 colOffset eInd-2 colOffset]);
        end
        
        function featuresVector = plotFeatures(filename,colNumber,...
                window,startI,endI)
            data = csvread(filename,2+startI,colNumber,[2+startI ...
                colNumber endI-2 colNumber]);
            
        end
        
    end
end


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
            Fs = 1/mean(sampleSpacing)*1000;
            disp(['Sample frequency (Hz): ', num2str(Fs)]);
        end
        
        function pxx = powerSpectrum(filename,colNumber,windowSize)
            dataMatrix = csvread(filename,3,0);
            data = dataMatrix(:,colNumber);
            windowsMatrix = frameSegment(data,windowSize);
            pxx = pwelch(windowsMatrix);
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
        
        function plots(filename, colNumber, window)
            dataMatrix = csvread(filename,3,0);
            time = dataMatrix(:,1)/(1000);
            time = time-time(1);
            Fs = 1/((time(2)-time(1)));
            data = dataMatrix(:,colNumber);
            subplot(2,1,1)
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
            
            subplot(2,1,2)
            plot(time/60,data);
            a = gca;
            a.XLim = [min(time/60) max(time/60)];
            xlabel('Time (minutes)')
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
        
    end
end


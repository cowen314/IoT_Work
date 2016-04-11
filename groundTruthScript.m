%% Bring everything in
names = {...
    'Ground_Truth_Treadmill1.csv'...
    'Ground_Truth_Treadmill2.csv'...
    'Ground_Truth_Treadmill3.csv'...
    'Ground_Truth_Treadmill5.csv'...
    };

%% Time Plots
figure
for i = 2:2
    %subplot(2,2,i)
    DataExaminer.plotTime(names{i},4,[]);
    title(names{i})
end

%% Full plots
DataExaminer.plots(names{2},4,8,cursor_info_entire_segment(2).DataIndex-200,...
    cursor_info_entire_segment(1).DataIndex+400,cursor_info(1).DataIndex)

%% accelerometer and stuff
load('workingDataPoints.mat')
figure
DataExaminer.plots(names{1},4,8,CO_T1StartAndEnd(2).DataIndex,...
    CO_T1StartAndEnd(1).DataIndex,2)

figure
DataExaminer.plots(names{2},4,8,CO_T2StartAndEnd(1).DataIndex,...
    CO_T2StartAndEnd(2).DataIndex,2)

figure
DataExaminer.plots(names{3},4,8,CO_T3StartAndEnd(2).DataIndex,...
    CO_T3StartAndEnd(1).DataIndex,2)

%% Step counting
data = DataExaminer.getRange(names{2},4,sRow,eRow);
steps = stepCounter(data);

%% magnetometer(s)

figure
DataExaminer.plots(names{1},13,8,CO_T2StartAndEnd(1).DataIndex,...
    CO_T2StartAndEnd(2).DataIndex,2)

figure
DataExaminer.plots(names{2},13,8,CO_T2StartAndEnd(1).DataIndex,...
    CO_T2StartAndEnd(2).DataIndex,2)

figure
DataExaminer.plots(names{3},13,8,CO_T2StartAndEnd(1).DataIndex,...
    CO_T2StartAndEnd(2).DataIndex,2)

%% Notes
% first, establish a threshold for determining if someone is on the
% treadmill or not

% see if we can just use an energy threshold: if the max on an off
% treadmill is less than the min on the on treadmill, we should be good to
% go

% ok, so it looks like the minimum energy that I generated was about 0.05
% (signal power on my walking steps).  This is less than what the other
% treadmills see when I am running.  For this reason, we need another
% feature to determine if someone is on the treadmill or not. We might be
% able to use the rate of steps. With a high rate of steps, we
% expect to see a high signal power.  Also, we can look into using the
% magnetometers.

% the magnetometers have some weird looking data.

% we can rip incline information off of the acceleration means

% maybe do a magnitude of acceleration calculation, and use that to extract
% all of the features for determining if someone is on the treadmill and
% step counting
% take a look at doing testing for 

% peakfinding in the sime domain power signal [sum(data.^2)/windowlength]
% works pretty well, although the problem of steps bleeding from an
% adjacent treadmill could be a problem.  Also, step detection using this
% method for a person walking is very difficult --> the power signal looks
% pretty ugly

% Instead of windowing, consider finding peaks on the data as is


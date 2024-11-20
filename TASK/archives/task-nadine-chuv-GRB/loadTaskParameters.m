%%Text
% text to draw in the beginning depending on block
Text_b = {'Training for the task \n \n \n Press spacebar to continue'...
    'First part of the task \n \n \n Press spacebar to continue'...
    'Second part of the task \n \n \n  Press spacebar to continue'};

%% Path
% circular path parameters
rhoIn = 0.15;
rhoOut = 0.2; 
rhoReduct = [0, 0, 0.02]; % the outer circle can be reduced depending on the block of trial
                          % thus reducing the circle with, e.g. for the
                          % dysregulation block (3) to increase difficulty

% rectangular learning path parameters
rectH = 0.5;
rectV = 0.4;

%% dot
% dot's parameters
dotSizes = 7; % dot sizes in pixels
dotspeed = 90; % max dot speed (in px/s)
dotspeedinc = [1, 1, 5]; %increase in dot speed for the dysreg; uses as multiplier 1=> normal speed 

%% sound
% Define the parameters of the sound
frequency = 1000; % Hz
duration = 5; % seconds
amplitude = 1; % 0-1

% Generate the time vector for the sound waveform
sampling_rate = 44100; % Hz
t = 0:1/sampling_rate:duration;

% Generate the sound waveform as a sine wave
y = amplitude*sin(2*pi*frequency*t);
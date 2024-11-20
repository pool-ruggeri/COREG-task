%% Path
% circular path parameters
rhoIn = 0.15;
rhoOut = 0.2; 

%% dot
% dot's parameters
dotSizes = 7; % dot sizes in pixels
dotspeed = 90; % max dot speed (in px/s)

%% sound
% Define the parameters of the sound
frequency = 1000; % Hz
duration = 1.5; % seconds
amplitude = 1; % 0-1

% Generate the time vector for the sound waveform
sampling_rate = 44100; % Hz
t = 0:1/sampling_rate:duration;

% Generate the sound waveform as a sine wave
y = amplitude*sin(2*pi*frequency*t);
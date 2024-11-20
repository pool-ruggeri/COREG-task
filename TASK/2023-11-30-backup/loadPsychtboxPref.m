% skip syncTest at the beginning
Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black, white and gray
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = GrayIndex(screenNumber);

% Unify the keyboard names for mac and pc
KbName('UnifyKeyNames');

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('N');
rightKey = KbName('M');

% Open the audio device
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], [], 0, sampling_rate, 1);




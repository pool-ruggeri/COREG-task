% Clear the workspace
close all;
clear;

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = Screen('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Unify the keyboard names for mac and pc
KbName('UnifyKeyNames');

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect
dimY = round(screenYpixels / 6);
dimX = round(screenYpixels / 6);
baseRect = [0 0 dimX dimY];

% Set the color of the rect to red
rectColor = [255 0 0];

% Set the intial dimension of the rectangle
Xdim = dimX;
Ydim = dimY;

% Set the amount we want our square to move on each button press
pixelsPerPress = 10;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% This is the cue which determines whether we exit the demo
exitDemo = false;

% Stop the key presses vomiting out into the script or command window
ListenChar(-1);

% Loop the animation until the escape key is pressed
while exitDemo == false

    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;

    % Depending on the button press, either move ths position of the square
    % or exit the demo
    if keyCode(escapeKey)
        exitDemo = true;
    elseif keyCode(leftKey)
        Xdim = Xdim + pixelsPerPress;
    elseif keyCode(rightKey)
        Xdim = Xdim - pixelsPerPress;
    elseif keyCode(upKey)
        Ydim = Ydim + pixelsPerPress;
    elseif keyCode(downKey)
        Ydim = Ydim - pixelsPerPress;
    end

%     % We set bounds to make sure our square doesn't go completely off of
%     % the screen
%     if squareX < 0
%         squareX = 0;
%     elseif squareX > screenXpixels
%         squareX = screenXpixels;
%     end
% 
%     if squareY < 0
%         squareY = 0;
%     elseif squareY > screenYpixels
%         squareY = screenYpixels;
%     end

    % Center the rectangle on the centre of the screen
    baseRect = [0 0 Xdim Ydim];
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

    % Draw the rect to the screen
    Screen('FillRect', window, rectColor, centeredRect);

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

% Renable listening to the keys
ListenChar(1);

% Clear the screen
sca;
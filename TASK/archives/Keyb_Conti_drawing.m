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


% Set the color of the dot to red
dotColors = [255 0 0];

% dot sizes in pixels
dotSizes = 10;

% We can define a center for the dot coordinates to be relaitive to. Here
% we set the centre to be the centre of the screen
dotCenter = [xCenter yCenter];

% Set initial position of the drawing
Xdim(1) = xCenter;
Ydim(1) = yCenter;
Xdim = Xdim - dotCenter(1);
Ydim = Ydim - dotCenter(2);

% set initial intensity of the vertical and horizontal scale (in pixels)
intY = 0;
intX = 0;

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
    end
    
    if keyCode(leftKey)
        intX = intX - 0.1;
    end
    
    if keyCode(rightKey)
        intX = intX + 0.1;
    end
    
    if keyCode(upKey)
        intY = intY + 0.1;
    end
    
    if keyCode(downKey)
        intY = intY - 0.1;
    end
    
    % Set current position of the drawing
    
        Xdim = [Xdim, round(Xdim(end)+intX)];
        Ydim = [Ydim, round(Ydim(end)-intY)];

    
    % Draw all of our dots to the screen in a single line of code 
    Screen('DrawDots', window, [Xdim; Ydim],...
        dotSizes, dotColors, dotCenter, 2);
    
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
    
    
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
end

% Renable listening to the keys
ListenChar(1);

% Clear the screen
sca;


















% Clear the workspace
close all;
clear;


Screen('Preference', 'SkipSyncTests', 1);
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = GrayIndex(screenNumber);

% Open an on screen window
[window, windowRect] = Screen('OpenWindow', screenNumber, gray);

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
dotColors = [0 0 0];

% dot sizes in pixels
dotSizes = 7;

% max dot speed (in px/s)
dotspeed = 100;

% We can define a center for the dot coordinates to be relaitive to. Here
% we set the centre to be the centre of the screen
dotCenter = [xCenter yCenter];

% Set initial position of the drawing
Xdim(1) = xCenter;
Ydim(1) = yCenter;
Xdim = Xdim - dotCenter(1);
Ydim = Ydim - dotCenter(2);

% set initial speed (px/s) of the vertical and horizontal scale (in pixels)
intY = 0;
intX = 0;

% Make a base Rect for the contours
dimContours(1) = screenXpixels - 2*50; % define X dim
dimContours(2) = screenYpixels - 2*50; % define Y dim
baseRectContours = [0 0 dimContours(1) dimContours(2)];
centeredRectContours = CenterRectOnPointd(baseRectContours, xCenter, yCenter-40); % Center the contour on the centre of the screen

% Make two base Rects for the speed feedback (FV = feedback vertical, FH =
% feedback horizontal)
dimFH(1) = 70; % define X dim
dimFH(2) = 30; % define Y dim
baseRectFH = [0 0 dimFH(1) dimFH(2)];
centeredRectFH = CenterRectOnPointd(baseRectFH, 1600, screenYpixels - 40); 

dimFHr(1) = 70/2; % define X dim
dimFHr(2) = 30; % define Y dim
baseRectFHr = [0 0 dimFHr(1) dimFHr(2)];
centeredRectFHr = CenterRectOnPointd(baseRectFHr, 1600 + 70/4, screenYpixels - 40); 

dimFHb(1) = 70/2; % define X dim
dimFHb(2) = 30; % define Y dim
baseRectFHb = [0 0 dimFHb(1) dimFHb(2)];
centeredRectFHb = CenterRectOnPointd(baseRectFHb, 1600 - 70/4, screenYpixels - 40); 

dimFV(1) = 30; % define X dim
dimFV(2) = 70; % define Y dim
baseRectFV = [0 0 dimFV(1) dimFV(2)];
centeredRectFV = CenterRectOnPointd(baseRectFV, 320, screenYpixels - 40); 

dimFVr(1) = 30; % define X dim
dimFVr(2) = 70/2; % define Y dim
baseRectFVr = [0 0 dimFVr(1) dimFVr(2)];
centeredRectFVr = CenterRectOnPointd(baseRectFVr, 320, screenYpixels - 70/4 - 40); 

dimFVb(1) = 30; % define X dim
dimFVb(2) = 70/2; % define Y dim
baseRectFVb = [0 0 dimFVb(1) dimFVb(2)];
centeredRectFVb = CenterRectOnPointd(baseRectFVb, 320, screenYpixels + 70/4 - 40); 

% Draw the contour to the screen
Screen('FrameRect', window, [0 0 0], centeredRectContours);

% Draw FH to the screen
Screen('FillRect', window, [255 0 0], centeredRectFHr,2);
Screen('FillRect', window, [0 0 255], centeredRectFHb,2);
Screen('FrameRect', window, [0 0 0], centeredRectFH,2);
Screen('DrawLine', window, [0 0 0],(centeredRectFH(1) + centeredRectFH(3))/2,centeredRectFH(2),(centeredRectFH(1) + centeredRectFH(3))/2,...
    centeredRectFH(4),2);

% Draw FV to the screen
Screen('FillRect', window, [255 0 0], centeredRectFVr,2);
Screen('FillRect', window, [0 0 255], centeredRectFVb,2);
Screen('FrameRect', window, [0 0 0], centeredRectFV,2);
Screen('DrawLine', window, [0 0 0],centeredRectFV(1), (centeredRectFV(4) + centeredRectFV(2))/2, centeredRectFV(3),...
    (centeredRectFV(4) + centeredRectFV(2))/2,2);

% draw one polygon
Screen('FramePoly', window, [255 0 0], [dotCenter; 1000,800; 1100,500 ;1460,700;1345,245;1210,500;1000,100;1000,500; 700,500],3);


% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;


% This is the cue which determines whether we exit the demo
exitDemo = false;

% Stop the key presses vomiting out into the script or command window
ListenChar(-1);

% Loop the animation until the escape key is pressed
while exitDemo == false
    t0 = GetSecs;
    
    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;
    
    % Depending on the button press, either move ths position of the square
    % or exit the demo
    if keyCode(escapeKey)
        exitDemo = true;
    end
    
    if keyCode(leftKey)
        intX = intX - 1;
    end
    
    if keyCode(rightKey)
        intX = intX + 1;
    end
    
    if keyCode(upKey)
        intY = intY + 1;
    end
    
    if keyCode(downKey)
        intY = intY - 1;
    end
    
    if intY < -dotspeed
        intY = -dotspeed;
    end
    if intY > dotspeed
        intY = dotspeed;
    end
    if intX > dotspeed
        intX = dotspeed;
    end
    if intX < -dotspeed
        intX = -dotspeed;
    end
    
    intXdraw = (intX*ifi);
    intYdraw = (intY*ifi);
    
    newXdim = (Xdim(end)+intXdraw);
    newYdim = (Ydim(end)-intYdraw);
    
    
    % We set bounds to make sure our dot doesn't go completely off of the
    % contour square
    if newXdim > (dimContours(1)+50)-dotCenter(1)
        newXdim = (dimContours(1)+50)-dotCenter(1);
    elseif newXdim < -((dimContours(1)+50)-dotCenter(1))
        newXdim = -((dimContours(1)+50)-dotCenter(1));
    end
    
    if newYdim > (dimContours(2)+50)-(dotCenter(2)+40)
        newYdim = (dimContours(2)+50)-(dotCenter(2)+40);
    elseif newYdim < -((dimContours(2)+50)-(dotCenter(2)-40))
        newYdim = -((dimContours(2)+50)-(dotCenter(2)-40));
    end
    
    % Set current position of the drawing
    Xdim = [Xdim, newXdim];
    Ydim = [Ydim, newYdim];
    
    
    % get horizontal feedback
    intX_range = -dotspeed:1:dotspeed;
    intX_range_px_step = (centeredRectFH(3)-centeredRectFH(1))/(length(intX_range)-1);
    intX_range_px = centeredRectFH(1):intX_range_px_step:centeredRectFH(3);
    intXq = interp1(intX_range,intX_range_px,intX);
    
    intY_range = -dotspeed:1:dotspeed;
    intY_range_px_step = (centeredRectFV(4)-centeredRectFV(2))/(length(intY_range)-1);
    intY_range_px = centeredRectFV(4):-intY_range_px_step:centeredRectFV(2);
    intYq = interp1(intY_range,intY_range_px,intY); 
    
    % Draw the contours 
    Screen('FrameRect', window, [0 0 0], centeredRectContours,2);
    
    % draw one triangle
    Screen('FramePoly', window, [255 0 0],[dotCenter; 1000,800; 1100,500;1460,840;1345,245;1210,500;1000,100;1000,500; 700,500],3); 

    % Draw FH and FV to the screen
    Screen('FillRect', window, [255 0 0], centeredRectFHr,2);
    Screen('FillRect', window, [0 0 255], centeredRectFHb,2);
    Screen('FrameRect', window, [0 0 0], centeredRectFH,2);
    Screen('DrawLine', window, [0 0 0],intXq,centeredRectFH(2),intXq,centeredRectFH(4),2);

    Screen('FillRect', window, [255 0 0], centeredRectFVr);
    Screen('FillRect', window, [0 0 255], centeredRectFVb);
    Screen('FrameRect', window, [0 0 0], centeredRectFV,2);
    Screen('DrawLine', window, [0 0 0],centeredRectFV(1), intYq, centeredRectFV(3),intYq,2);

    % Draw all of our dots to the screen in a single line of code
    Screen('DrawDots', window, [Xdim; Ydim],...
        dotSizes, dotColors, dotCenter, 2);
    
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    t1=GetSecs;
    

end


% Renable listening to the keys
ListenChar(1);

% Clear the screen
sca;



















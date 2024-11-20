%% Interaction TASK %%
% Provide a description of the task here
%
%

% Copyright (UNIL-2023)
% Authors:
% 1 - Dr. Paolo Ruggeri (Faculty-SSP, LERB, BEAM LAB)
% 2 - Xxxx
% 3 - Xxxx


% Clear the workspace
close all;
clear;

% load task parameters (e.g., radious inner and outer circle, dot size, max dot speed, etc etc)
loadTaskParameters

% load psychtoolbox preferences
loadPsychtboxPref

% Open an on screen window
[window, windowRect] = Screen('OpenWindow', screenNumber, gray);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% load all task components (shapes, feedback images, etc...)
loadTaskFeatures

% load task design
loadTaskDesign





% set initial speed (px/s) of the dot (vertical and horizontal vectorial field) (in pixels)
intY = 0;
intX = 0;

% Draw the path to the screen
Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);

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

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Stop the key presses vomiting out into the script or command window
ListenChar(-1);

% initialize these two vectors to phase 0 (onset of dot's position)
last_phase = 0;
phase_dot = last_phase;

% This is the cue which determines whether we finished the trial
exitTrial = false;

% Loop the animation until the escape key is pressed
while exitTrial == false
    
    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;
    
    
    % Depending on the button press, either move ths position of the square
    % or exit the demo
    %     if keyCode(escapeKey)
    %         exitTrial = true;
    %     end
    
    
    % increase or decrease the intensity of speed in either directions
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
    
    % do not exceed the boundaries chosen for either speed directions
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
    
    % compute the pixels done in the unit time "ifi" (e.g., screen refresh) at the current speed intensity.
    intXdraw = (intX*ifi);
    intYdraw = (intY*ifi);
    
    % Set current position of the drawing by adding the pixels done in theunit time, as computed above. this position is what is shown to the participant at the next screen refresh occurring at ifi intervals
    newXdim = (Xdim(end)+intXdraw);
    newYdim = (Ydim(end)-intYdraw);
    Xdim = [Xdim, newXdim];
    Ydim = [Ydim, newYdim];
    
    % compute distance from the center
    dist_dot_center = sqrt(Xdim(end)^2 + Ydim(end)^2);
    
    % compute the last seen phase of the dot
    [phase_dot] = computePhase(Xdim(end),Ydim(end),dist_dot_center);
    
    % update last_phase with an increased phase (i.e., this means we are proceiding in the circular path)
    if phase_dot > last_phase(end)
        last_phase = [last_phase,phase_dot];
        % if we have jumped of 2*pi (i.e., from the starting position we decided to go leftward), bring us at the onset, right in betweeninner and outer circles
        if (last_phase(end)-last_phase(end-1)) > 1
            last_phase(end) = 0;
            phase_dot = 0;
            
            % put pointer to center of the path after the sound ends
            Xdim(end) = (screenXpixels * (rhoOut+rhoIn))/2 * sin(phase_dot);
            Ydim(end) = -(screenXpixels *(rhoOut+rhoIn))/2 * cos(phase_dot);
            
            % and set speed to 0 px/s
            intX = 0;
            intY = 0;
        end
    end
    
    
    % if we touch the boundaries of the path, highlight dot in red, play a sound for a specific duration, and place the dot at the same phase, but at the center of the path
    if or(dist_dot_center >= (screenXpixels * rhoOut), dist_dot_center <= (screenXpixels * rhoIn ))
        % Draw the path to the screen
        Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
        Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
        
        % Draw FH and FV to the screen
        Screen('FillRect', window, [255 0 0], centeredRectFHr,2);
        Screen('FillRect', window, [0 0 255], centeredRectFHb,2);
        Screen('FrameRect', window, [0 0 0], centeredRectFH,2);
        Screen('DrawLine', window, [0 0 0],intXq,centeredRectFH(2),intXq,centeredRectFH(4),2);
        
        Screen('FillRect', window, [255 0 0], centeredRectFVr);
        Screen('FillRect', window, [0 0 255], centeredRectFVb);
        Screen('FrameRect', window, [0 0 0], centeredRectFV,2);
        Screen('DrawLine', window, [0 0 0],centeredRectFV(1), intYq, centeredRectFV(3),intYq,2);
        
        % Draw the last position of the dots to the screen in red (remove (end) if you want to show the trajectory in a single line of code)
        Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
            15, [255 0 0], dotCenter,2);
        
        % Flip to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        
        % Play the sound signaling the error and keep the screen frozen until the end of the sound
        PsychPortAudio('FillBuffer', pahandle, y); % Fill the audio buffer with the sound waveform
        PsychPortAudio('Start', pahandle, 1, 0, 1); % Start playing the sound and wait until it is done
        PsychPortAudio('Stop', pahandle, 1);
        PsychPortAudio('Close', pahandle); % Close the audio device
        pahandle = PsychPortAudio('Open', [], [], 0, sampling_rate, 1);
        
        % put pointer to center of the path after the sound ends
        Xdim(end) = (screenXpixels * (rhoOut+rhoIn))/2 * sin(phase_dot);
        Ydim(end) = -(screenXpixels *(rhoOut+rhoIn))/2 * cos(phase_dot);
        
        % and set speed to 0 px/s
        intX = 0;
        intY = 0;
        
    end
    
    % get horizontal feedback
    intX_range = -dotspeed:1:dotspeed;
    intX_range_px_step = (centeredRectFH(3)-centeredRectFH(1))/(length(intX_range)-1);
    intX_range_px = centeredRectFH(1):intX_range_px_step:centeredRectFH(3);
    intXq = interp1(intX_range,intX_range_px,intX);
    
    % get vertical feedback
    intY_range = -dotspeed:1:dotspeed;
    intY_range_px_step = (centeredRectFV(4)-centeredRectFV(2))/(length(intY_range)-1);
    intY_range_px = centeredRectFV(4):-intY_range_px_step:centeredRectFV(2);
    intYq = interp1(intY_range,intY_range_px,intY);
    
    % Draw the path to the screen
    Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
    Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
    
    % Draw FH and FV to the screen
    Screen('FillRect', window, [255 0 0], centeredRectFHr,2);
    Screen('FillRect', window, [0 0 255], centeredRectFHb,2);
    Screen('FrameRect', window, [0 0 0], centeredRectFH,2);
    Screen('DrawLine', window, [0 0 0],intXq,centeredRectFH(2),intXq,centeredRectFH(4),2);
    
    Screen('FillRect', window, [255 0 0], centeredRectFVr);
    Screen('FillRect', window, [0 0 255], centeredRectFVb);
    Screen('FrameRect', window, [0 0 0], centeredRectFV,2);
    Screen('DrawLine', window, [0 0 0],centeredRectFV(1), intYq, centeredRectFV(3),intYq,2);
    
    % Draw the last position of the dots to the screen (remove (end) if you want to show the trajectory in a single line of code)
    Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
        dotSizes, dotColors, dotCenter,2);
    
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    % trial ends when a complete path is done
    if (2*pi-last_phase(end) < 10e-3)
        exitTrial = true;
    end
    
end


% Renable listening to the keys
ListenChar(1);

% Clear the screen
sca;


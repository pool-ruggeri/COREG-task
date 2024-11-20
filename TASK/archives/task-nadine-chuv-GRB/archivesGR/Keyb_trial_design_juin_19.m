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

% load task design
loadTaskDesign

% loop across blocks of trials
for nblocks = 1:length(blocks)
    if strcmp(blocks{nblocks},'learn')
        duration_block = duration_learn;
        learn = 1; % we are in learn mode -> simple rectangle
        % load all task components (shapes, feedback images, etc...)
        loadTaskFeatures
        % draw text on screen
        Text = ['Training for the task \n \n \n Press spacebar to continue'];
    else
        if strcmp(blocks{nblocks},'coreg')
            duration_block = duration_coreg;
            learn = 0; % not learn mode
            % load all task components (shapes, feedback images, etc...)
            loadTaskFeatures
            % draw text on screen
            Text = ['First part of the task \n \n \n Press spacebar to continue'];
        else
            duration_block = duration_dysreg;
            rhoReduct = 0.02; %reduce the path's width
            dotspeedinc = 5 ; % increase dot's acceleration and deceleration
            learn = 0; % not  learning mode
            % load again all task components (shapes, feedback images, etc...)
            loadTaskFeatures
            % draw text on screen
            Text = ['Second part of the task \n \n \n  Press spacebar to continue'];
        end
      
    end
    
    Screen('TextFont', window, 'Arial'); Screen('TextSize', window, 48); Screen('TextColor',window,white);
    DrawFormattedText(window, Text,'center','center');
    
    % flip the screen
    Screen('Flip',window);
    
    %wait for spacebar press
    while 1
        [~, ~, keyCode] = KbCheck;
        if keyCode(KbName('space'))
            break;
        end
    end
    
    exitBlock = false;
    trial_counter = 0;
    time_block_onset = GetSecs;
    while exitBlock == false
        
        if learn == 1
            % Draw the path to the screen
            Screen('FrameRect',window,learnColor,centeredLearnRect,Learn_width);
        else
            % Draw the path to the screen
            Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
            Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
        end
        
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
        
        % set initial speed (px/s) of the dot (vertical and horizontal vectorial field) (in pixels)
        intY = 0;
        intX = 0;
        
        % set initial position
        if learn == 1
            Xdim = 0;
            Ydim = 0;
        else
            Xdim = Xdim_init;
            Ydim = Ydim_init;
        end
        
        % initialize these two vectors to phase 0 (onset of dot's position)
        last_phase = 0; % in rad
        phase_dot = last_phase;
        % Draw the path to the screen
        
        % This is the cue which determines whether we finished the trial
        exitTrial = false;
        
        % Loop the animation until the time elapse
        while exitTrial == false
            
            % get current time to see whether is time to exit trial and current block
            current_time = GetSecs;
            duration_current_block = current_time - time_block_onset;
            
            % check whether is time to stop current trial and block
            if duration_current_block >=  duration_block
                exitTrial = true;
                exitBlock = true;
            end
            
            % Check the keyboard to see if a button has been pressed
            [keyIsDown,secs, keyCode] = KbCheck;
                        
            
            % Depending on the button press, either move ths position of the square
            % or exit the demo
            if keyCode(escapeKey)
                 exitTrial = true;
            end
            
            
            % increase or decrease the intensity of speed in either directions
            % delta of speed increase/decrease depend on the test condition,
            % the change is more steep in the dysregulation block than in the regulation one
            if keyCode(leftKey)
                intX = intX - 1*dotspeedinc;
            end
            
            if keyCode(rightKey)
                intX = intX + 1*dotspeedinc;
            end
            
            if keyCode(upKey)
                intY = intY + 1*dotspeedinc;
            end
            
            if keyCode(downKey)
                intY = intY - 1*dotspeedinc;
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
            
            % Set current position of the drawing by adding the pixels done in theunit time, as computed above. 
            % This position is what is shown to the participant at the next screen refresh occurring at ifi intervals
            newXdim = (Xdim(end)+intXdraw);
            newYdim = (Ydim(end)-intYdraw);
            Xdim = [Xdim, newXdim];
            Ydim = [Ydim, newYdim];
            
            % compute distance from the center
            dist_dot_center = sqrt(Xdim(end)^2 + Ydim(end)^2);
            
            % if we're not in learning mode we do the task
            if learn == 0 
        
                % compute the last seen phase of the dot
                [phase_dot] = computePhase(Xdim(end),Ydim(end),dist_dot_center);
            
                % update last_phase with an increased phase (i.e., this means we are proceiding in the circular path)
                if phase_dot > last_phase(end)
                    last_phase = [last_phase,phase_dot];
                    % if we have jumped of 2*pi (i.e., from the starting position we decided to go leftward), 
                    % bring us at the onset, right in between inner and outer circles
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
            
                % Draw the last position of the dots to the screen 
                %(remove (end) if you want to show the trajectory in a single line of code)
                Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
                    dotSizes, dotColors, dotCenter,2);
            
                % Flip to the screen
                vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
                % trial ends when a complete path is done
                if (2*pi-last_phase(end) < 10e-3)
                
                    exitTrial = true;              
                
                    trial_counter = trial_counter + 1; % count completed trial
                
                
                    % now highlight the end of trial with a green dot 
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
                
                    % Draw the last position of the dots to the screen in green (remove (end) if you want to show the trajectory in a single line of code)
                    Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
                        15, [0 255 0], dotCenter,2);
                
                    % Flip to the screen
                    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
                    WaitSecs(2)
                end
                
            else %learning mode
                % we draw only a big square to learn how to use the
                % commands
                
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
                Screen('FrameRect',window,learnColor,centeredLearnRect,Learn_width);
            
                % Draw FH and FV to the screen
                Screen('FillRect', window, [255 0 0], centeredRectFHr,2);
                Screen('FillRect', window, [0 0 255], centeredRectFHb,2);
                Screen('FrameRect', window, [0 0 0], centeredRectFH,2);
                Screen('DrawLine', window, [0 0 0],intXq,centeredRectFH(2),intXq,centeredRectFH(4),2);
            
                Screen('FillRect', window, [255 0 0], centeredRectFVr);
                Screen('FillRect', window, [0 0 255], centeredRectFVb);
                Screen('FrameRect', window, [0 0 0], centeredRectFV,2);
                Screen('DrawLine', window, [0 0 0],centeredRectFV(1), intYq, centeredRectFV(3),intYq,2);
            
                % Draw the last position of the dots to the screen 
                %(remove (end) if you want to show the trajectory in a single line of code)
                Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
                    dotSizes, dotColors, dotCenter,2);
            
                % Flip to the screen
                vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
                
                % if we touch the boundaries of the path, highlight dot in red, play a 
                %sound for a specific duration, and place the dot at the
                %initial position
 
                if (Xdim(end)<= -screenXpixels * (rectH/2))|| (Xdim(end)>= screenXpixels * (rectH/2))...
                        || (Ydim(end)<= -screenXpixels * (rectV/2)) ||( Ydim(end)>= screenXpixels * (rectV/2))
                  
                    % Draw the path to the screen
                    Screen('FrameRect',window,learnColor,centeredLearnRect,Learn_width);

                
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
                
                    % put pointer to center 
                    Xdim(end) = 0;
                    Ydim(end) = 0;
                
                    % and set speed to 0 px/s
                    intX = 0;
                    intY = 0;
                
                end
                                                           
            end
        end
        
        % Renable listening to the keys
        ListenChar(1);
        
        
    end
    completed_trials{nblocks} = trial_counter;
    
end


% Clear the screen
sca;



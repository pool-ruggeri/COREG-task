
%% Interaction TASK %%
% Provide a description of the task here
%
%

% Copyright (UNIL-2023)
% Authors:
% 1 - Dr. Paolo Ruggeri (Faculty-SSP, LERB, BEAM LAB)
% 2 - Giuliana Riva Berger



% Clear the workspace
close all;
clear;

% load task design
loadTaskDesign

% load task parameters (e.g., radious inner and outer circle, dot size, max dot speed, etc etc)
loadTaskParameters

% load psychtoolbox preferences
loadPsychtboxPref

% enter participant
prompt = {'Please enter participant ID'};
title_prompt = 'Participant ID';
defaultanswer = {'Test'};
userID = inputdlg(prompt,title_prompt,1,defaultanswer,'on');

% ask whether we record BIOPAC or not
answer = questdlg('Are you recording BIOPAC ? ',...
    'BIOPAC Device',...
    'Yes','No','No');
switch answer
    case 'Yes'
        BIOPAC = 1;
        prompt = {'Please enter the COM port number'};
        title_prompt = 'Select COM port number (e.g., 3)';
        defaultanswer = {'3'};
        portnumber = str2double(inputdlg(prompt,title_prompt,1,defaultanswer,'on'));
        % open COM port
        port = open_ns_port(portnumber);
    case 'No'
        BIOPAC = 0;
end

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

%% Instructions
Text = Text_instructions;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
Screen('Flip',window);

while 1
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break;
    end
end

Screen(window,'FillRect', gray);
vbl = Screen('Flip',window);
Screen('Flip',window, vbl + 0.5 + 0.5*ifi);

%% We show the participants a short movie
% send trigger for movie start
if BIOPAC
    send_ns_trigger(trigger_VID_1,port)
end

movieFile = [moviepath filesep moviename_1];
movie  = Screen('OpenMovie',window,movieFile);

Screen('PlayMovie',movie,1) % Start playing the movie

movieEndTime = GetSecs + durationMovieSecs;
while GetSecs < movieEndTime
    tex = Screen('GetMovieImage',window,movie);
    if tex <= 0
        break;
    end
    Screen('DrawTexture',window,tex,[],windowRect);
    Screen('Flip',window);
    Screen('Close',tex);
end

Screen('PlayMovie',movie,0); % Stop playing the movie
Screen('CloseMovie',movie); % Close the movie file

%% text telling the participants that they need to fill in the PANAS nr. 2
% send trigger for panas 2
if BIOPAC
    send_ns_trigger(trigger_P_2,port)
end

Text = Text_panas_2;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
Screen('Flip',window);

while 1
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break;
    end
end
Screen(window,'FillRect', gray);
vbl = Screen('Flip',window);
Screen('Flip',window, vbl + 0.5 + 0.5*ifi);


%% loop across blocks of trials
for nblocks = 1:length(blocks)
    if strcmp(blocks{nblocks},'learn')
        duration_block = duration_learn;
        block = learn_block; % we are in learn mode -> simple rectangle
    elseif strcmp(blocks{nblocks},'coreg')
        duration_block = duration_coreg;
        block = coreg_block; % co-regulation block
    else
        duration_block = duration_dysreg;
        block = dysreg_block; % dysreg block
    end
    
    %initialisation of the outer radius depending on the block (smaller for dysreg)
    rhoOut = rhoOut - rhoReduct(block);
    
    % load all task components (shapes, feedback images, etc...)
    loadTaskFeatures;
    
    if strcmp(blocks{nblocks},'dysreg')
        % send trigger for panas 3
        if BIOPAC
            send_ns_trigger(trigger_P_3,port)
        end
        
        % if we have just finished the coreg block we want the participants to fill the PANAS for the 3rd time
        Text = Text_panas_3;
        Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
        DrawFormattedText(window, Text,'center','center');
        Screen('Flip',window);
        
        while 1
            [~, ~, keyCode] = KbCheck;
            if keyCode(KbName('space'))
                break;
            end
        end
        
        Screen(window,'FillRect', gray);
        vbl = Screen('Flip',window);
        Screen('Flip',window, vbl + 0.5 + 0.5*ifi);
        
    end
    
    % we choose the text depending on the block & we put the text on screen
    Text = Text_b{block};
    Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
    DrawFormattedText(window, Text,'center','center');
    Screen('Flip',window);
    
    %wait for spacebar press to start
    while 1
        [~, ~, keyCode] = KbCheck;
        if keyCode(KbName('space'))
            break;
        end
    end
    
    exitBlock = false;
    trial_counter = 0; %nb completed tours
    touch_counter = 0; %nb touched bounduaries
    XYpath = {};
    durationTrial = [];
    cumErrorTrial = [];
    time_block_onset = GetSecs;
    
    if BIOPAC
        if strcmp(blocks{nblocks},'learn')
            send_ns_trigger(trigger_APP,port)
        elseif strcmp(blocks{nblocks},'coreg')
            send_ns_trigger(trigger_COREG,port)
        else
            send_ns_trigger(trigger_DYSREG,port)
        end
    end
    
    
    while exitBlock == false
        
        if block == learn_block
            % Draw the path to the screen
            Screen('FrameRect',window,learnColor,centeredLearnRect,Learn_width);
        else
            % Draw the path to the screen
            Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
            Screen('FrameOval' ,window,recColorOut,centeredRectOut,Out_width);
        end
        
        % Sync us and get a time stamp
        vbl = Screen('Flip', window);
        waitframes = 1;
        
        % Stop the key presses vomiting out into the script or command window
        ListenChar(-1);
        
        % set initial speed (px/s) of the dot (vertical and horizontal vectorial field) (in pixels)
        intY = 0;
        intX = 0;
        
        % set initial position
        if block == learn_block
            Xdim = 0;
            Ydim = 0;
        else
            Xdim = Xdim_init;
            Ydim = Ydim_init;
        end
        
        % initialize these two vectors to phase 0 (onset of dot's position)
        last_phase = 0; % in rad
        phase_dot = last_phase;
        
        % This is the cue which determines whether we finished the trial
        exitTrial = false;
        
        % Loop the animation until the time elapse
        time_trial_onset = GetSecs;
        while exitTrial == false
            
            % Check the keyboard to see if a button has been pressed
            [keyIsDown,secs, keyCode] = KbCheck;
            
            % increase or decrease the intensity of speed in either directions
            % delta of speed increase/decrease depend on the test condition,
            % the change is more steep in the dysregulation block than in the regulation one
            if keyCode(leftKey)
                intX = intX - 1*dotspeedinc(block);
            end
            
            if keyCode(rightKey)
                intX = intX + 1*dotspeedinc(block);
            end
            
            if keyCode(upKey)
                intY = intY + 1*dotspeedinc(block);
            end
            
            if keyCode(downKey)
                intY = intY - 1*dotspeedinc(block);
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
            
            % if we're in co-regulation or dyregulation we do the task
            if block == coreg_block || block == dysreg_block
                
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
                    
                    touch_counter = touch_counter+1; %increase the counter of nb bounduaries touched
                    
                    % Draw the path to the screen
                    Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
                    Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
                    
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
                
                % Draw the path to the screen
                Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
                Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
                
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
                    
                    
                    XYpath{trial_counter} = [Xdim;Ydim];
                    durationTrial(trial_counter) = GetSecs - time_trial_onset;
                    cumErrorTrial(trial_counter) = touch_counter; % cumulative error, saved across trials. e.g., if you want to get the errors of the completed trial number N, you need to do cumErrorTrial(N)-cumErrorTrial(N-1)
                    
                    % now highlight the end of trial with a green dot
                    % Draw the path to the screen
                    Screen('FrameOval',window,recColorIn,centeredRectIn,In_width);
                    Screen('FrameOval',window,recColorOut,centeredRectOut,Out_width);
                    
                    % Draw the last position of the dots to the screen in green (remove (end) if you want to show the trajectory in a single line of code)
                    Screen('DrawDots', window, [Xdim(end); Ydim(end)],...
                        15, [0 255 0], dotCenter,2);
                    
                    % Flip to the screen
                    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                    
                    WaitSecs(0.1)
                end
                
            else %learning mode
                % we draw only a big square to learn how to use the
                % commands
                
                %if esc is pressed exit the learning block
                if keyCode(escapeKey)
                    exitBlock = true;
                    exitTrial = true;
                end
                
                % Draw the path to the screen
                Screen('FrameRect',window,learnColor,centeredLearnRect,Learn_width);
                
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
            
            % get current time to see whether is time to exit trial and current block
            current_time = GetSecs;
            duration_current_block = current_time - time_block_onset;
            
            % check whether is time to stop current trial and block
            if duration_current_block >=  duration_block
                exitTrial = true;
                exitBlock = true;
                
                XY_uncomplPath = [Xdim;Ydim];
            end
            
        end
        
        % Renable listening to the keys
        ListenChar(1);
        
    end
    
    %Saving the parameters for the block
    if block == coreg_block
        data.posTrialCoreg = XYpath;
        data.posUncompTrialCoreg = XY_uncomplPath;
        data.durationTrialCoreg = durationTrial;
        data.completeTrialCoreg = trial_counter;
        data.overalltouchedCoreg = touch_counter;
        data.cumtouchedTrialCoreg = cumErrorTrial;
        clear XYpath XY_uncomplPath durationTrial cumErrorTrial
        
    elseif block == dysreg_block
        data.posTrialDysreg = XYpath;
        data.posUncompTrialDysreg = XY_uncomplPath;
        data.durationTrialDysreg = durationTrial;
        data.completeTrialDysreg = trial_counter;
        data.overalltouchedDysreg = touch_counter;
        data.cumtouchedTrialDysreg = cumErrorTrial;
        clear XYpath XY_uncomplPath durationTrial cumErrorTrial
    end
end

%% when the DYSREG block is over, participants fill in the panas for the 4th time
% send trigger for panas 4
if BIOPAC
    send_ns_trigger(trigger_P_4,port)
end

% if we have just finished the coreg block we want the participants to fill the PANAS for the 3rd time
Text = Text_panas_4;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
Screen('Flip',window);

while 1
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break;
    end
end

Screen(window,'FillRect', gray);  
vbl = Screen('Flip',window); 
Screen('Flip',window, vbl + 0.5 + 0.5*ifi); 

%% After filling in the panas, they visualize a video for 5 minutes
Text = Text_video_end;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
Screen('Flip',window);

while 1
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break;
    end
end

Screen(window,'FillRect', gray);  
vbl = Screen('Flip',window); 
Screen('Flip',window, vbl + 0.5 + 0.5*ifi); 

% send trigger for movie start
if BIOPAC
    send_ns_trigger(trigger_VID_2,port)
end

movieFile = [moviepath filesep moviename_2];
movie  = Screen('OpenMovie',window,movieFile);

Screen('PlayMovie',movie,1) % Start playing the movie

movieEndTime = GetSecs + durationMovieSecs;
while GetSecs < movieEndTime
    tex = Screen('GetMovieImage',window,movie);
    if tex <= 0
        break;
    end
    Screen('DrawTexture',window,tex,[],windowRect);
    Screen('Flip',window);
    Screen('Close',tex);
end

Screen('PlayMovie',movie,0); % Stop playing the movie
Screen('CloseMovie',movie); % Close the movie file

%% when the VIDEO is over, participants fill in the panas for the 5th time
% send trigger for panas 5
if BIOPAC
    send_ns_trigger(trigger_P_5,port)
end

% if we have just finished the coreg block we want the participants to fill the PANAS for the 5th time
Text = Text_panas_5;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
Screen('Flip',window);

while 1
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break;
    end
end

Screen(window,'FillRect', gray);  
vbl = Screen('Flip',window); 
Screen('Flip',window, vbl + 0.5 + 0.5*ifi); 
 
%% recovery period of 20 mins
% if we have just finished the coreg block and we are ready to start the dysreg block; we present a 3 mins rest before
if BIOPAC
    send_ns_trigger(trigger_QB,port)
end

Text = Text_recovery;
Screen('TextFont', window, 'Arial'); Screen('TextSize', window, Text_size); Screen('TextColor',window,white);
DrawFormattedText(window, Text,'center','center');
vbl = Screen('Flip',window); % flip the screen
Screen('Flip',window, vbl + durationRecoverySecs + 0.5*ifi);

%% save file with results
filename = strcat(userID{1}, '_Data.mat');
save(filename, '-struct', 'data');

%% close the com port
if BIOPAC
    % close port
    close_ns_port(port)
end

%% Clear the screen
sca;




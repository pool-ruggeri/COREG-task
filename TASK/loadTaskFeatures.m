%-------------------------------------------------------------------------- 
% TRIAL FEATURES 
%--------------------------------------------------------------------------

%% inner circle
% Make a base rectangle that contains the inner circle
baseRectIn = [0 0 screenXpixels * (rhoIn*2) screenXpixels * (rhoIn*2)];
recColorIn = [0 0 0];
centeredRectIn = CenterRectOnPointd(baseRectIn,xCenter,yCenter);
In_width = 2;

%% outer circle
% Make a base rectangle that contains the inner circle
baseRectOut = [0 0 screenXpixels * (rhoOut*2) screenXpixels * (rhoOut*2)];
recColorOut = [0 0 0];
centeredRectOut = CenterRectOnPointd(baseRectOut,xCenter,yCenter);
Out_width = 2;

%% learning rectangle
% Make a rectangle for learning the task
learnRect = [0 0 screenXpixels * rectH screenXpixels * rectV];
learnColor = [0 0 0];
centeredLearnRect = CenterRectOnPointd(learnRect,xCenter,yCenter);
Learn_width = 2;

%% moving dot
dotColors = [0 0 0]; % Set the color of the dot to black
dotCenter = [xCenter yCenter]; % We can define a center for the dot coordinates to be relaitive to. Here we set the centre to be the centre of the screen
% Set initial position of the drawing (between the inner and outer circle of the path)
Xdim_init = xCenter-dotCenter(1);
Ydim_init = (centeredRectIn(2) + centeredRectOut(2))/2 - dotCenter(2);

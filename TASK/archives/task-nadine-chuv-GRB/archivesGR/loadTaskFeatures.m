%-------------------------------------------------------------------------- 
% TRIAL FEATURES 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%initialise again the outer radius depending of desired reduction
rhoOut = rhoOut - rhoReduct;
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

%% moving dot
dotColors = [0 0 0]; % Set the color of the dot to black
dotCenter = [xCenter yCenter]; % We can define a center for the dot coordinates to be relaitive to. Here we set the centre to be the centre of the screen
% Set initial position of the drawing (between the inner and outer circle of the path)
Xdim_init = xCenter-dotCenter(1);
Ydim_init = (centeredRectIn(2) + centeredRectOut(2))/2 - dotCenter(2);


%% feedback 
% Make two base Rects for the speed feedback (FV = feedback vertical, FH = feedback horizontal)
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
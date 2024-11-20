%% ----- Texts -----
% Text instructions et vid�o 1
Text_instructions = 'Bienvenue et merci de participer � cette exp�rience! \n \n \n \n  Nous allons commencer avec la visualisation d''une video qui va \n \n durer 5 minutes. Pendant cette p�riode, vous pouvez simplement \n \n vous relaxer. \n \n \n \n \n \n Appuyer sur "espace" et regarder attentivement cette vid�o';

% Text Panas
Text_panas_2 = 'Avant de passer � la phase suivante, vous allez remplir un \n \n questionnaire court, sur papier. \n \n \n \n Lorsque vous termin�, vous pouvez appuyer sur "espace" pour \n \n continuer';
Text_panas_3 = 'Avant de passer � la phase suivante, vous allez remplir � \n \n nouveau le questionnaire sur vos �motions.\n \n \n \n Lorsque vous avez termin�, vous pouvez appuyer sur "espace" pour \n \n continuer';
Text_panas_4 = Text_panas_3;
Text_panas_5 = Text_panas_4;

% text to draw in the beginning depending on block
Text_b = {'Votre t�che consiste � d�placer un curseur dans l''espace � l''aide \n \n des touches sur le clavier \n \n \n \n La personne � gauche de l''�cran contr�le les d�placements de haut en bas du curseur avec \n \n les fleches de haut et du bas, et celle � droite de l''�cran contr�le les d�placements de gauche \n \n � droite avec les touches "N" et "M". \n \n \n \n Vous allez commencer avec une phase d''entrainement ou le curseur \n \n peut se d�placer � l''int�rieur d`un carr�. Chaque fois que le curseur \n \n touche le bord, vous allez entendre un son et vous serez bloqu� pendant 5 secondes \n \n \n \n Appuyer sur "espace" pour commencer'...
    'La prochaine t�che consiste � deplacer le curseur dans le sens des \n \n aiguilles (en commencent vers la droite) d''une montre � l''int�rieur d''un parcours circulaire \n \n \n \n Le but est d''effectuer le plus rapid�ment possible un maximum \n \n de tours \n \n \n \n La personne � gauche de l''�cran contr�le les d�placements de haut en bas \n \n du curseur, et celle � droite de l''�cran contr�le les deplacements de gauche \n \n � droite. Chaque fois que le curseur touche le bord, vous entendrez \n \n un son et vous serez bloqu� 5 secondes \n \n \n \n Appuyer sur "espace" pour commencer'...
    'Nous allons refaire le m�me excercise \n \n \n \n Il s''agit � nouveau de d�placer le curseur dans le sens des \n \n aiguilles d''une montre (en d�marrant vers la droite) � l''int�rieur \n \n d''un parcours circulaire \n \n \n \n A nouveau, le but est d''effectuer le plus rapidement possible un maximum de tours. \n \n \n \n Appuyer sur "espace" pour commencer'};

% text vid�o 2
Text_video_end = 'Bravo! Merci d''avoir particip�. \n \n \n \n Vous allez maintenant regarder une vid�o qui va durer 5 minutes. \n \n Pendant cette p�riode, vous pouvez simplement vous relaxer et regarder \n \n attentivement la vid�o \n \n \n \n Appuyer sur "espace" pour visualiser la vid�o';

% Text for recovery period
Text_recovery = 'Pour terminer, vous allez remplir une autre s�rie des questionnaires \n \n sur tablette. \n \n \n \n La personne en charge de l''exp�rience viendra configurer l''interface web. \n \n \n \n Merci pour votre pr�cieuse participation!';

Text_size = 30;

%% Path
% circular path parameters
rhoIn = 0.15;
rhoOut = 0.2; 
rhoReduct = [0, 0, 0.02]; % the outer circle can be reduced depending on the block of trial
                          % thus reducing the circle with, e.g. for the
                          % dysregulation block (3) to increase difficulty

% rectangular learning path parameters
rectH = 0.5;
rectV = 0.4;
%% dot
% dot's parameters
dotSizes = 7; % dot sizes in pixels
dotspeed = 90; % max dot speed (in px/s)
dotspeedinc = [1, 1, 5]; %increase in dot speed for the dysreg; uses as multiplier 1=> normal speed 

%% sound
% Define the parameters of the sound
frequency = 1000; % Hz
duration = 5; % seconds
amplitude = 1; % 0-1

% Generate the time vector for the sound waveform
sampling_rate = 44100; % Hz
t = 0:1/sampling_rate:duration;

% Generate the sound waveform as a sine wave
y = amplitude*sin(2*pi*frequency*t);

%% movie
moviepath = 'C:\Users\LERB\Documents\EXPERIMENTS\COREG\TASK\movie';
durationMovieSecs = 5*60;
moviename_1 = 'movie_2.mp4';
moviename_2 = 'movie_2.mp4';
%% recovery period at the end of the task
durationRecoverySecs = 15*60;

%% TRIGGERS to BIOPAC
addpath('C:\Users\LERB\Documents\EXPERIMENTS\COREG\NeurospecTriggerBox-master')
trigger_VID_1 = 1;
trigger_P_2 = 2;
trigger_APP = 3;
trigger_COREG = 4;
trigger_P_3 = 5;
trigger_DYSREG = 6;
trigger_P_4 = 7;
trigger_VID_2 = 8;
trigger_P_5 = 9;
trigger_QB = 10;

%% blocks
% the idea is to have a : 
% 1 - baseline recording (before or after a time to learn the task);
% 2 - then proceed to one block of trials (low level of stress: co-regulation)
% 3 - then proceed with another block of trials (igh level of stress: dysregulation)
% 4 - recovery recording;

blocks = {'learn','coreg','dysreg'};
duration_learn = 2*60;  % duration of learning block in seconds
duration_coreg = 5*60;  % duration of coreg block in seconds
duration_dysreg = 5*60; % duration of dysreg block in seconds

%integers to identify the different block types
%used in vectors containing parameters that varies depending on block
%used in code to remember in wich block we are
learn_block = 1;
coreg_block = 2;
dysreg_block = 3;
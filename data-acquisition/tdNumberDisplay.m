% This script displays the data required to perform
% the tactile discrimination test, collects and saves participant's
% responses.

subjCode='SF18-pre-TD'; % change that for every subject

% Generate randomised order of stimuli
load('assets/TD-stimuli.mat');
stimuli=sideWristNumbers;
Reps= zeros(7,5);
for  i=1:15
Reps(:,i) = stimuli(randperm(length(stimuli)));
end

blocks=reshape(Reps,[35,3]);

% Set up PsychToolbox
AssertOpenGL;
% Detect hardware
LoadPsychHID;
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
% Cache KbCheck
KbCheck;
% Cache Mouse
[~,~,buttons]=GetMouse;
% Disable output of keypresses to Matlab.
ListenChar(2);
% Set higher DebugLevel,
olddebuglevel=Screen('Preference', 'VisualDebuglevel', 3);
% Choose the display
screens=Screen('Screens');
screenNumber=max(screens);
% Open Screen
[expWin,rect]=Screen('OpenWindow',screenNumber,[],[10 20 1200 700]);
% Set Colour Range
Screen('ColorRange', expWin,[1]);
% Get the midpoint (mx, my) of this window, x and y
[mx, my] = RectCenter(rect);
% Find Keyboard
[Keyz]= GetKeyboardIndices;
KbQueueCreate(Keyz);
KbQueueStart();

% Create matrix to store mouse clicks
PressedButton=[];

%% Block 1
for i = 1:35
tdNumber = blocks(i,1);
myText = num2str(tdNumber);
blockText=['BN: 1, TN: ', num2str(i) '  '];

Screen('TextSize', expWin, 200);
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('TextSize', expWin, 70);
DrawFormattedText(expWin, blockText, 'right');

Screen('Flip', expWin);
while ~any(buttons)
[~,~,buttons]=GetMouse;
end
PressedButton(i,:,1)=buttons;
while any(buttons)
[~,~,buttons]=GetMouse;
end
end

%% Break
Screen('TextSize', expWin, 200);
myText ='Break';
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('Flip', expWin);
KbWait(Keyz, 3);

%% Block 2
for i = 1:35
tdNumber = blocks(i,2);
myText = num2str(tdNumber);
blockText=['BN: 2, TN: ', num2str(i) '  '];

Screen('TextSize', expWin, 200);
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('TextSize', expWin, 70);
DrawFormattedText(expWin, blockText, 'right');

Screen('Flip', expWin);
while ~any(buttons)
[~,~,buttons]=GetMouse;
end
PressedButton(i,:,2)=buttons;
while any(buttons)
[~,~,buttons]=GetMouse;
end
end

%% Break
Screen('TextSize', expWin, 200);
myText ='Break';
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('Flip', expWin);
KbWait(Keyz, 3);

%% Block 3
for i = 1:35
tdNumber = blocks(i,3);
myText = num2str(tdNumber);
blockText=['BN: 3, TN: ', num2str(i) '  '];

Screen('TextSize', expWin, 200);
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('TextSize', expWin, 70);
DrawFormattedText(expWin, blockText, 'right');
Screen('Flip', expWin);
while ~any(buttons)
[~,~,buttons]=GetMouse;
end
PressedButton(i,:,3)=buttons;
while any(buttons)
[~,~,buttons]=GetMouse;
end
end

%% The End
Screen('TextSize', expWin, 200);
myText='End';
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('Flip', expWin);
KbWait(Keyz, 3);

%% Close screen and save the results
sca; % Screen Close All
ListenChar(0);
%return to olddebuglevel
resp=reshape(PressedButton(:,2,:),[35,3]);
Screen('Preference', 'VisualDebuglevel', olddebuglevel);
save([subjCode, '.mat'],'blocks','resp');

% This scripts runs the finger opposition data acquisition
% It displays randomly chosen finger name to the user and waits for
% the experimenter's input. The experimenter has to classify subject's movement
% as either valid or invalid, using mouse buttons to pass teh input to the script.
% After every ten trials (each trial lasting 1 minute), the script gives the subject
% an option of having a short break. At the end the data related to the task is stored
% as a .mat file named after subject's code.

subjCode='SF6_D5';

%% Generate randomised order of stimuli
stimuli = {"Thumb","Index","Middle","Ring","Little"};
targ = {};
for  i=1:300
    targ = [targ,stimuli(randperm(numel(stimuli)))];
end
targ = targ(randperm(numel(targ)));

%% Set up the PsychToolbox display and interface
AssertOpenGL;
LoadPsychHID;
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
%Cache KbCheck 
KbCheck;
% Cache Mouse
[~,~,buttons] = GetMouse;
%Disable output of keypresses to Matlab.
ListenChar(2);
%Set higher DebugLevel, 
olddebuglevel = Screen('Preference', 'VisualDebuglevel', 3);
%Choosing the display 
screens = Screen('Screens');
screenNumber = max(screens);
%Open Screen
[expWin,rect] = Screen('OpenWindow',screenNumber,[]);
%[expWin,rect] = Screen('OpenWindow',screenNumber,[],[10 20 600 300]);
%Set Colour Range 
Screen('ColorRange', expWin,[1]);
Screen('TextSize', expWin, 120);
%get the midpoint (mx, my) of this window, x and y
[mx, my] = RectCenter(rect);
%Find Keyboard
[Keyz]= GetKeyboardIndices; 
KbQueueCreate(Keyz);
KbQueueStart(Keyz);

%% Start the experiment
Hits = zeros(1,10);
Finger = [];

h = 0;
for trial=1:10
    tic
    while toc<=60
        text = targ{h+1}{1};
        Screen('TextSize', expWin, 200);
        DrawFormattedText(expWin, text, 'center', 'center',[0 0 0]);
        blockText = [num2str(trial) '  '];
        Screen('TextSize', expWin, 70);
        DrawFormattedText(expWin, blockText, 'right');

        Screen('Flip', expWin);
         while ~any(buttons)
             [~,~,buttons] = GetMouse;
         end
         if buttons(1)==1
            Hits(trial) = Hits(trial)+1;
            if Hits(trial)==1
                Finger{trial} = text
            else
                Finger{trial} = [Finger{trial} {text}]
            end
         end
         while any(buttons)
             [~,~,buttons] = GetMouse;
         end
         h = h+1;
        DrawFormattedText(expWin, '+', 'center', 'center', [0 0 0]);
        Screen('Flip', expWin);
        WaitSecs(0.2);
    end

    if trial~=10
        myText='Break';
        DrawFormattedText(expWin, myText, 'center', 'center', [0 1 0]);
        Screen('Flip', expWin);
        while ~any(buttons)
            [~,~,buttons] = GetMouse;
        end       
        while any(buttons)
            [~,~,buttons] = GetMouse;
        end
    end
    save([subjCode, '.mat'],'Hits','Finger');
end

%% The End
myText = 'The End';
DrawFormattedText(expWin, myText, 'center', 'center', [1 0 0]);
Screen('Flip', expWin);
KbWait(Keyz, 3);

%% Close screen and save the results
sca;
ListenChar(0);
%return to olddebuglevel
Screen('Preference', 'VisualDebuglevel', olddebuglevel);
save([subjCode, '.mat'],'Hits','Finger');

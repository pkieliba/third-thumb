function MotorConfusionRH(subID,sess)

%% WRITTEN BY AINSLIE JOHNSTONE 03.01.2016
%% ADAPTED 01.03.2017 for SRTT-TMS-tDCS Experiment
%% ADAPTED BY DOMINIC STIRLING 16.02.2018 for MOTOR CONFUSION 

% To run this script type MotorConfusionRH(participant ID, session)
% This script references RandomSRTTRight.m

%Ensure that the script is running on Psychtoolbox
AssertOpenGL;

%Set the number of random trials. This also needs to be changed after the
%code for the trial run
no_rand = 300;
 
%Script Test? (this skips the instruction phase for testing) 0=no 1=yes 
ScriptTest = 0;

%% Define the key presses and begin program
try 
    %Detects hardware 
    LoadPsychHID;
    %devices = PsychHID('Devices' ,[2])
    Screen('Preference', 'SkipSyncTests', 1);
    KbName('UnifyKeyNames');
    KbCheck;
    ListenChar(2);

    %Set higher DebugLevel, 
    olddebuglevel = Screen('Preference', 'VisualDebuglevel', 3);

    %Choosing the display 
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    %Open Full Screen 
    [expWin,rect] = Screen('OpenWindow',0);
    %Alternative: replace the above with smaller window for testing
    %[expWin,rect] = Screen('OpenWindow',screenNumber,[],[10 20 800 500]);
  
    %Set Colour Range 
    Screen('ColorRange', expWin,[1]);
    
    %get the midpoint (mx, my) of this window, x and y
    [mx, my] = RectCenter(rect);

    %get rid of the mouse cursor, 
    %HideCursor;
    
    %Find Keyboard
    [Keyz]= GetKeyboardIndices; 
    
%% Instructions

 %Preparing and displaying the welcome screen
    % Choosing text size
    Screen('TextSize', expWin, 20);
    
    %Skip instructions if experiment is in test mode 
   if ScriptTest==0 
       
    % Instructions presented in middle of screen 
    myText = ['Welcome to the experiment!\n' ...
              ' \n' ...
              'This experiment aims to measure your reaction time \n' ...
              'and accuracy on random button presses.\n' ...
              '\n' ...
              'Press space to continue.\n' ];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz, 3);

    myText = ['Place your right hand on the keyboard, with your\n'...
            ' index finger on the H key, middle finger on the J,\n '...
             'ring finger on the K and little finger on the L.\n'...
             'Place your thumb on the space bar. \n'...
             '\n'...
             'Press space to continue'];
         
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz, 3);
                        
     myText =  ['You will see five dashes superimposed over the outline of a hand \n' ...
              'Each dash corresponds to one of your 4 fingers or your thumb. \n' ...            
              '\n'...
    'On the next screen you will see an example of these dashes and a flashing digit\n'...
              'Press space to continue.\n' ];
   
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz,3);
    IM1 = imread('assets/RHand.png', 'png');
    Hand = Screen('makeTexture', expWin, IM1);
    
    Screen('DrawTexture', expWin,Hand, [],[0.45*mx, my-0.5*mx, 1.55*mx, my+0.5*mx],[],0, 1,[],[],[], []);
    Screen('FillOval', expWin, [0,128,0],  [0.85*mx, my-0.095*mx, 0.87*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [0.99*mx, my-0.095*mx, 1.01*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [1.13*mx, my-0.095*mx, 1.15*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [1.27*mx, my-0.095*mx, 1.29*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [0.71*mx, my-0.005*mx, 0.73*mx, my+0.005*mx] );
    Screen('Flip', expWin);
    WaitSecs(2);
      
    Screen('DrawTexture', expWin,Hand, [],[0.45*mx, my-0.5*mx, 1.55*mx, my+0.5*mx],[],0, 1,[],[],[], []);
    Screen('FillOval', expWin, [0,128,0],  [0.85*mx, my-0.095*mx, 0.87*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [ 0.95*mx, my-0.45*mx, 1.05*mx, my-0.35*mx] );
    Screen('FillRect', expWin, [0,128,0],  [ 0.95*mx, my-0.40*mx, 1.05*mx, my-0.035*mx] );
    Screen('FillOval', expWin, [0,128,0],  [1.13*mx, my-0.095*mx, 1.15*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [1.27*mx, my-0.095*mx, 1.29*mx, my-0.085*mx] );
    Screen('FillOval', expWin, [0,128,0],  [0.71*mx, my-0.005*mx, 0.73*mx, my+0.005*mx] );
    Screen('Flip', expWin);
    WaitSecs(3);
    
    myText = ['In a random order, the 5 digits will light up one at a time. \n' ...
              'You have to press the button that corresponds to the lit up digit. \n' ...
              '\n'...
              'Press space to continue' ];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz,3);
   
    myText = ['You will now complete a short trial run.\n' ...
        '\n'...
        'Press space to start.'];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz, 3);
    
   
%% Trial Run

RandomSRTTRight(10, expWin, mx, my, Keyz); % 10 trials

%%
     myText = ['Thank you for reading the instructions.\n' ...
              'During the experiment try to be as fast and  \n' ...
              'accurate as possible. There will be breaks throughout,\n'...
              'so try to stay focussed.\n'...
              '\n'...
              'If you have any questions please ask the experimenter now!\n'...
              'If not, you may begin the experiment.  \n' ...
              'Press space to begin.\n' ];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    
    KbWait(Keyz, 3); %Press space to begin trial
    
   end
   
%% Block 1
RResultMat1 = RandomSRTTRight(no_rand, expWin, mx, my, Keyz);
save([char(subID) '-' char(sess) '-MC-block1.mat'],'RResultMat1');
%% Short Break
   myText = ['You can now have a short break \n' ... 
           ' \n'...
     'Please press space when you are ready to continue\n' ];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    WaitSecs(3);
    KbWait(Keyz, 3);   
    
%% Block 2
RResultMat2 = RandomSRTTRight(no_rand, expWin, mx, my, Keyz);
save([char(subID) '-' char(sess) '-MC-block2.mat'],'RResultMat2');
 %% Short Break #2
 myText = ['You can now have a short break \n' ... 
           ' \n'...
     'Please press space when you are ready to continue\n' ];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait(Keyz, 3);   

 %% Block 3
RResultMat3 = RandomSRTTRight(no_rand, expWin, mx, my, Keyz);
save([char(subID) '-' char(sess) '-MC-block3.mat'],'RResultMat3');
%% Save Results
MCResultMat = [RResultMat1; RResultMat2; RResultMat3];
save([char(subID) '-' char(sess) '-MC.mat'],'MCResultMat');

%%End of Experiment

 myText = ['You have completed the experiment. \n' ... 
           'Thank you for taking part.\n' ...
           'If you have any questions please ask the experimenter now.\n'];
       
 DrawFormattedText(expWin, myText, 'center', 'center');
 Screen('Flip', expWin);
 WaitSecs(10);
  
sca;
ListenChar(0);
Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    
catch
    ShowCursor;
    Screen('CloseAll'); %or sca
    ListenChar(0);
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    %output the error message
    psychrethrow(psychlasterror);

end

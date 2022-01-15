function [randresultsR] = RandomSRTTRight(no_rand,expWin,mx, my, Keyz)
%% Ainslie Johnstone 03.01.16
%% ADAPTED BY DOMINIC STIRLING 16.02.2018 for a motor confusion task
%% MODIFIED BY PAULINA KIELIBA

clear r
clear randresults
DisableKeysForKbCheck([1:10,12,16:43,45:256]); 

Keyz = Keyz(1);

KbQueueCreate(Keyz);
KbQueueStart();

IM1 = imread('assets/RHand.png', 'png');
Hand = Screen('makeTexture', expWin, IM1); 

tag=0; % left or right hand
randresultsR = zeros(no_rand,7);

% Create a random vector of integers 1-5 of length rn with equal occurances
% of each integer and no immediate repeats
  
n1 = 5;
n2 = (no_rand/5);

a = nchoosek(1:5, 1);
b = horzcat(a(:,1));
c = vertcat(a, b);
d = repmat(c, n2, 1);
d = d(randperm(n1*n2), :);

% Perform an "insertion shuffle"
for k=2:n1*n2
    m = 1;
    while (any(d(k,:) == d(m,:)) || any(d(k,:) == d(m+1,:)))
        m = m + 1;
    end
    if (m < k)
        ind = [ 1: m  k  m+1: k-1   k+1: n1 * n2 ];
    else
        ind = [ 1: k-1   k+1: m  k  m+1: n1 * n2 ];
    end
    d = d(ind,:);
end

reNumbers = d;
indexN=1;

%% Graphics
 
 for r=1:no_rand
     rn = reNumbers(indexN,1);
     indexN=indexN+1;

    % Show empty circles for 0.6 secs
    Screen('DrawTexture', expWin,Hand, [],[0.45*mx, my-0.5*mx, 1.55*mx, my+0.5*mx],[],0, 1,[],[],[], []);
    Screen('FillOval', expWin, [0,128,0],  [0.71*mx, my-0.005*mx, 0.73*mx, my+0.005*mx] ); %thumb
    Screen('FillOval', expWin, [0,128,0],  [0.85*mx, my-0.22*mx, 0.87*mx, my-0.21*mx] );%index
    Screen('FillOval', expWin, [0,128,0],  [0.99*mx, my-0.22*mx, 1.01*mx, my-0.21*mx] );%middle
    Screen('FillOval', expWin, [0,128,0],  [1.13*mx, my-0.22*mx, 1.15*mx, my-0.21*mx] );%ring
    Screen('FillOval', expWin, [0,128,0],  [1.27*mx, my-0.22*mx, 1.29*mx, my-0.21*mx] );%little
        
    Screen('Flip', expWin);
    % CHANGE THIS TO CHANGE RESPONSE-STIMULUS INTERVAL
    WaitSecs(0.6);
     
    Rectangles = [0.68*mx, my-0.05*mx, 0.78*mx, my+0.15*mx, 44; %thumb
        0.81*mx, my-0.29*mx, 0.91*mx, my+0.005*mx, 11;... %index
        0.95*mx, my-0.40*mx, 1.05*mx, my-0.035*mx, 13; ...    %middle
        1.09*mx, my-0.35*mx, 1.19*mx, my-0.035*mx, 14; ...     %ring
        1.23*mx, my-0.22*mx, 1.33*mx, my+0.005*mx, 15;];      %little
                
    % Identify the position parameters for each of the stimuli
    rpos = Rectangles(rn, 1);
    tpos = Rectangles(rn, 2);
    lpos = Rectangles(rn, 3);
    bpos = Rectangles(rn, 4);
    
    Circles = [0.68*mx, my-0.1*mx, 0.78*mx, my+0.00*mx, 44; %thumb
        0.81*mx, my-0.33*mx, 0.91*mx, my-0.23*mx, 11;... %index
        0.95*mx, my-0.45*mx, 1.05*mx, my-0.35*mx, 13; ...    %middle
        1.09*mx, my-0.4*mx, 1.19*mx, my-0.3*mx, 14; ...     %ring
        1.23*mx, my-0.27*mx, 1.33*mx, my-0.17*mx, 15;];      %little
                 
    % Identify the position parameters for each of the stimuli
    rpos2 = Circles(rn, 1);
    tpos2 = Circles(rn, 2);
    lpos2 = Circles(rn, 3);
    bpos2 = Circles(rn, 4);
   
    % Present the empty ovals and one filled oval.
    Screen('DrawTexture', expWin,Hand, [],[0.45*mx, my-0.5*mx, 1.55*mx, my+0.5*mx],[],0, 1,[],[],[], []);
    Screen('FillOval', expWin, [0,128,0],  [0.71*mx, my-0.005*mx, 0.73*mx, my+0.005*mx] );%thumb
    Screen('FillOval', expWin, [0,128,0],  [0.85*mx, my-0.22*mx, 0.87*mx, my-0.21*mx] );%index
    Screen('FillOval', expWin, [0,128,0],  [0.99*mx, my-0.22*mx, 1.01*mx, my-0.21*mx] );%middle
    Screen('FillOval', expWin, [0,128,0],  [1.13*mx, my-0.22*mx, 1.15*mx, my-0.21*mx] );%ring
    Screen('FillOval', expWin, [0,128,0],  [1.27*mx, my-0.22*mx, 1.29*mx, my-0.21*mx] );%little
    
    Screen('FillRect', expWin, [0,128,0], [rpos, tpos, lpos, bpos]);
    Screen('FillOval',expWin, [0,128,0], [rpos2, tpos2, lpos2, bpos2]);
    
      % Record the reaction time of the press
       secs0 = GetSecs;
       Screen('Flip', expWin);
       KbQueueReserve(2,1,Keyz);
       KbQueueReserve(1,2,Keyz);
       KbQueueFlush(Keyz);
       pressed = 0;
       while pressed==0
        [pressed, firstPress, ~,~,~] = KbQueueCheck(Keyz);
       end
        
    if pressed==1   
        keyCol = find(firstPress>0);
        firstsecs = firstPress(keyCol);
        rt = firstsecs(1)-secs0;
        firstKey = keyCol(1);
        KbQueueFlush;
        
        % Calculate performance (correct/incorrect) or detect forced exit
        if keyCol == 27 %esc key
            break;
        elseif keyCol == Rectangles(rn,5)
            anscorrect = 1;
        else
            anscorrect = 0;
        end
        
        rt_correct = rt;
        
       % Wait for the correct key press
       if anscorrect == 0
           nextPress = zeros(1,256);
           secondPressed = 0;
           while nextPress(:,Rectangles(rn,5))==0 || secondPressed==0
               [secondPressed, nextPress, ~,~,~] = KbQueueCheck(Keyz);
           end
           secondsecs = nextPress(nextPress>0);
           rt_correct = secondsecs(1)-secs0;
           KbQueueFlush;
       end
       
   
heapTotalMemory = java.lang.Runtime.getRuntime.totalMemory;
heapFreeMemory = java.lang.Runtime.getRuntime.freeMemory;
if(heapFreeMemory < (heapTotalMemory*0.01))
    java.lang.Runtime.getRuntime.gc;
end
          
        keysR=[44 11 13 14 15];  
      
        randresultsR(r,:) = [ tag, r, rn, find(keysR==firstKey), anscorrect, rt, rt_correct]; 
    
        clear rn rt rt_correct
    end
 end
end 

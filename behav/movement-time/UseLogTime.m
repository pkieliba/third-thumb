% This script calculates total time the Third Thumb was ON and total time
% the Thumb was being used (receiving pressure data) on a given day,
% according to the data logged on the SD card.

path = '/Volumes/ritd-ag-project-rd00k9-tmaki67/';
subj = 'SF11';
day = '5';
subjPath = [path subj '/Usage Logs/'];

%% Import Logs Data %%
Abd = importUseLog([subjPath 'D' day '/' subj '-D' day '-DATALOG-L.txt']);
Flex = importUseLog([subjPath 'D' day '/' subj '-D' day '-DATALOG-R.txt']);

%% Find the timepoints when the Third Thumb was restarted %%
cutL = islocalmin(Abd(:,2));
cutR = islocalmin(Flex(:,2));
blocksL = find(cutL==1);
blocksR = find(cutR==1);

%% Create a 3D array with all data blocks %%
dataAbd{1} = Abd(1:blocksL(1)-1,:);
dataFlex{1} = Flex(1:blocksR(1)-1,:);

for b=2:length(blocksL)
    dataAbd{b} = Abd(blocksL(b-1):blocksL(b)-1,:);
end
for b=2:length(blocksR)
    dataFlex{b} = Flex(blocksR(b-1):blocksR(b)-1,:);
end

dataAbd{length(blocksL)+1} = Abd(blocksL(end):end,:);
dataFlex{length(blocksR)+1} = Flex(blocksR(end):end,:);

totalON_L = sum([Abd(blocksL-1,2);Abd(end,2)])/3600000
totalON_R = sum([Flex(blocksR-1,2);Flex(end,2)])/3600000

%% Calculate movement time per block and then sum it all up %%
for i = 1:max(length(dataFlex), length(dataAbd))
    if i <= length(dataFlex) && i <= length(dataAbd)
        mov(i) = movementTime(dataFlex{i}, dataAbd{i});
    elseif i <= length(dataFlex) && i > length(dataAbd)
        mov(i) = movementTime(dataFlex{i}, []);
    elseif i > length(dataFlex) && i <= length(dataAbd)
        mov(i)=movementTime([], dataAbd{i});
    end
end

mov_total = sum(mov);
mov_hours = mov_total/3600000;

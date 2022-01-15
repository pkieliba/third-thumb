function userOptions = projectOptions(subj, side, mask)
%
% Roni Maimon 9-2017
%__________________________________________________________________________
% Copyright (C)

%%%%%%%%%%%%%%%%%%%%%
%% PROJECT DETAILS %%
%%%%%%%%%%%%%%%%%%%%%

subSess = strsplit(subj,'/');
subID = subSess{1};
sess = subSess{2};
maskType = strsplit(mask, 'mask');
maskType = maskType{1};

curFolder ='/vols/Data/soma/6Finger/';
userOptions.rootPath = [curFolder subj '/RSA'];
mkdir(userOptions.rootPath)
userOptions.outputFile = [curFolder subj '/RSA/RDMs_' maskType '_' sess '.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENTAL SETUP %%
%%%%%%%%%%%%%%%%%%%%%%%%

userOptions.subjectNames = subj;

userOptions.featsPrefix = 'run-';
userOptions.featsSuffix = '';
userOptions.run_names = {};

% Find out which runs are present for this subject ans session
temp = dir([curFolder, subj, filesep, 'func', filesep, '*block*_ref_to_midsp.nii.gz']);

for num = 1:length(temp)
   userOptions.run_names{end+1} = temp(num).name(end-20);
end

userOptions.featsPath = [curFolder, '[[subjectName]]',...
                        filesep, 'model', ...
                        filesep, 'rsa', filesep, '[[featPrefix]]', '[[runName]]', '[[featSuffix]]', '.feat'];

if side == 1
    userOptions.copes = {6,7,8,9,10,11,12};
elseif side == 2
    userOptions.copes = {1,2,3,4,5,11,12};
elseif side == 3
    userOptions.copes = {1,2,3,4,5,6,7,8,9,10,11,12};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ANALYSIS PREFERENCES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

userOptions.conditionLabels = { ...
	'Thumb', ...
	'Index', ...
    'Middle', ...
	'Ring', ...
    'Little', ...
    'Feet', ...
    'Face' ...
};

userOptions.useAlternativeConditionLabels = false;

% Should RDMs' entries be rank transformed into [0,1] before they're displayed?
userOptions.rankTransform = true;

% Should rubber bands be shown on the MDS plot?
userOptions.rubberbands = true;

% What criterion shoud be minimised in MDS display?
userOptions.criterion = 'metricstress';
userOptions.colourScheme = jet(64);
userOptions.axislabels = {userOptions.conditionLabels{1} 1; userOptions.conditionLabels{2} 2; userOptions.conditionLabels{3} 3; userOptions.conditionLabels{4} 4;userOptions.conditionLabels{5} 5; userOptions.conditionLabels{6} 6; ...
    userOptions.conditionLabels{7} 7};

% How should figures be outputted?
userOptions.displayFigures = false;
userOptions.saveFiguresPDF = false;
userOptions.saveFiguresFig = true;
userOptions.saveFiguresPS = false;
userOptions.saveFiguresJpg = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FEATURES OF INTEREST SELECTION OPTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

userOptions.maskPath = [curFolder, subID , filesep, 'masks', filesep,'[[maskName]]'];
userOptions.maskNames = {mask};

end

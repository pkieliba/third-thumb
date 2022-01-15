% This script computes the dissimilarity between hand-feet, hand-lips representation,
% at pre- and post-scan. Those are latter compared in JASP using RM Anova

subjs = {'SF1','SF2','SF3','SF4','SF5','SF6','SF7','SF8','SF11','SF12', ...
    'SF13','SF14','SF15','SF16','SF17','SF19','SF21','SF22','SF23','SF24'};

hemi = 2; % RHemi: 1, LHemi: 2
preRDMs = [];
postRDMs = [];

for s = 1:length(subjs)
    load(['RSA/' subjs{s} '/RDMs_Feet_M1_pre.mat']);
    tempPre = squareform (RDMs(hemi).RDM);
    preRDMs(s,:) = tempPre;
    load(['RSA/' subjs{s} '/RDMs_Feet_M1_post.mat']);
    tempPost = squareform (RDMs(hemi).RDM);
    postRDMs(s,:) = tempPost;
end

lhFeet = [preRDMs(:,3), postRDMs(:,3)];
rhFeet = [preRDMs(:,2), postRDMs(:,2)];
lhFace = [preRDMs(:,5), postRDMs(:,5)];
rhFace = [preRDMs(:,4), postRDMs(:,4)];

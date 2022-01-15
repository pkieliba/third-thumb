% This script calculates the Spearman correlations between individual's RDM and the group average.
% Those are used to assess the typicality of the hand representation.

aug = {'SF1', 'SF2', 'SF3', 'SF4', 'SF5', 'SF6', 'SF7', 'SF8', ...
    'SF11', 'SF12', 'SF13', 'SF14', 'SF15', 'SF16', 'SF17', 'SF19', 'SF21', 'SF22', 'SF23', 'SF24'};
ctr = {'CF1', 'CF2', 'CF4', 'CF5', 'CF6', 'CF7', 'CF8', 'CF10', 'CF11', 'CF12'};

subj = [aug];
hand = 1; % left: 1, right: 2

for s = 1:length(subj)
    load(['RSA/' subj{s} '/RDMs_M1_pre.mat']);
    preRDMs(:,s) = squareform(RDMs(h).RDM(1:5,1:5));
    load(['RSA/' subj{s} '/RDMs_M1_post.mat']);
    postRDMs(:,s) = squareform(RDMs(h).RDM(1:5,1:5));
end

for s = 1:length(subj)
    tempRDM = preRDMs;
    tempRDM(:,s) = [];
    groupMean(:,s) = mean(tempRDM,2);
end

for s = 1:20
    [typicality(s,1),~] = corr(preRDMs(:,s), groupMean(:,s), 'Type', 'Spearman');
    [typicality(s,2),~] = corr(postRDMs(:,s), groupMean(:,s), 'Type', 'Spearman');
end

num2clip([fisher_z(typicality(:,1)), fisher_z(typicality(:,2))])

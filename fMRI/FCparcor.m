% This script computes partial coorrelations betweeen mean timecourses
% underlying hands and feet ROIs

subjects = {'SF1','SF2','SF3','SF4','SF5','SF6','SF7','SF8','SF11','SF12','SF13','SF14','SF15','SF16','SF17','SF19','SF21','SF22','SF23','SF24'};
sessions = {'pre','post'};

corrRF = zeros(20,2);
corrLF = zeros(20,2);
corrBF = zeros(20,2);
corrHands = zeros(20,2);

for n = 1:length(subjects)

    subj = subjects{n};

    for k = 1:length(sessions)

        ses = sessions{k};
        RH = importdata([fullfile('/vols/Data/soma/6Finger/', subj, '/', ses, '/masks/RH_seed.txt')]);
        LH = importdata([fullfile('/vols/Data/soma/6Finger/', subj, '/', ses, '/masks/LH_seed.txt')]);
        RF = importdata([fullfile('/vols/Data/soma/6Finger/', subj, '/', ses, '/masks/RF_seed.txt')]);
        LF = importdata([fullfile('/vols/Data/soma/6Finger/', subj, '/', ses, '/masks/LF_seed.txt')]);
        BF = importdata([fullfile('/vols/Data/soma/6Finger/', subj, '/', ses, '/masks/BF_seed.txt')]);

        corrBF(n,k) = partialcorr(RH, BF, LH);
        corrRF(n,k) = partialcorr(RH, RF, LH);
        corrLF(n,k) = partialcorr(RH, LF, LH);
        corrHands(n,k) = corr(RH, LH);

    end
end

save('/vols/Data/soma/6Finger/scripts/FCparcor.mat','corrBF','corrRF','corrLF','corrHands')

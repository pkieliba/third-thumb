% This script transforms the RDM data into long data format, so that it
% can be later analyses in R using LMM approach

subjs = {'SF1', 'SF2', 'SF3', 'SF4', 'SF5', 'SF6', 'SF7', 'SF8', ...
    'SF11', 'SF12', 'SF13', 'SF14', 'SF15', 'SF16', 'SF17', 'SF19', ...
    'SF22', 'SF21', 'SF23', 'SF24'}; 

for s = 1:length(subjs)
    
    load(['Beyond/' subjs{s} '/RDMs_M1_pre.mat']);
    tempPreL = reshape(triu(RDMs(1).RDM(1:5,1:5))',1,25);
    tempPreR = reshape(triu(RDMs(2).RDM(1:5,1:5))',1,25);
    tempPreL(tempPreL==0) = [];
    tempPreR(tempPreR==0) = [];
    
    preRDMsL(s*10-9:s*10,1) = tempPreL';
    preRDMsL(s*10-9:s*10,2) = 1;
    preRDMsL(s*10-9:s*10,3) = 1;
    preRDMsL(s*10-9:s*10,4) = 1:10;
    preRDMsL(s*10-9:s*10,5) = s;
    preRDMsL(s*10-9:s*10,6) = 1;
    
    preRDMsR(s*10-9:s*10,1) = tempPreR';
    preRDMsR(s*10-9:s*10,2) = 2;
    preRDMsR(s*10-9:s*10,3) = 1;
    preRDMsR(s*10-9:s*10,4) = 1:10;
    preRDMsR(s*10-9:s*10,5) = s;
    preRDMsR(s*10-9:s*10,6) = 1;
    
    load(['Beyond/' subjs{s} '/RDMs_M1_post.mat']);
    tempPostL = reshape(triu(RDMs(1).RDM(1:5,1:5))',1,25);
    tempPostR = reshape(triu(RDMs(2).RDM(1:5,1:5))',1,25);
    tempPostL(tempPostL==0) = [];
    tempPostR(tempPostR==0) = [];

    postRDMsL(s*10-9:s*10,1) = tempPostL';
    postRDMsL(s*10-9:s*10,2) = 1;
    postRDMsL(s*10-9:s*10,3) = 2;
    postRDMsL(s*10-9:s*10,4) = 1:10;
    postRDMsL(s*10-9:s*10,5) = s;
    postRDMsL(s*10-9:s*10,6) = 1;
    
    postRDMsR(s*10-9:s*10,1) = tempPostR';
    postRDMsR(s*10-9:s*10,2) = 2;
    postRDMsR(s*10-9:s*10,3) = 2;
    postRDMsR(s*10-9:s*10,4) = 1:10;
    postRDMsR(s*10-9:s*10,5) = s;
    postRDMsR(s*10-9:s*10,6) = 1;
      
end

longData = [preRDMsL; postRDMsL; preRDMsR; postRDMsR];
csvwrite('HandRep_RSA_Augmented.csv', longData);
txt = fileread('HandRep_RSA_Augmented.csv');
fid = fopen('HandRep_RSA_Augmented.csv', 'wt');
fprintf(fid, 'dist, hand, time, fingPair, participant, group\n');
fprintf(fid, '%s', txt);
fclose(fid);


subjects = {'SF1','SF2','SF3','SF4','SF5','SF6','SF7','SF8','SF11','SF12', ...
    'SF13','SF14','SF15','SF16','SF17','SF19','SF21','SF22','SF23','SF24'};

disp('Left hand')
for subj=1:length(subjects)
    disp(subjects{subj})
    plotRDM(subjects{subj},1)
    pause
    close all
end  

disp('Right hand')
for subj=1:length(subjects)
    disp(subjects{subj})
    plotRDM(subjects{subj},2) 
    pause
    close all
end  

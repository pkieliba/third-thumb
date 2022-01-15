% This script calculates and plots mean weights of the kinematic synergies 
% computed for the augmented and control groups

aug = {'SF5', 'SF6', 'SF7', 'SF8', 'SF11', 'SF13', 'SF14', 'SF15',  'SF16', 'SF17', 'SF19', 'SF21', 'SF22', 'SF23', 'SF24'};
ctr = {'CF1', 'CF2', 'CF4', 'CF6', 'CF7', 'CF8', 'CF10', 'CF11', 'CF12'};

syns = [];

for sub=1:length(ctr)
    temp = load(['/Users/paulina/Desktop/Cyberglove/' ctr{sub} '/PCA.mat']);
    for syn=1:5
        syns(sub,:,syn) = temp.scaled_PIJvel1.loadings(syn,:);
    end
    for syn=1:5
        syns(sub+length(ctr),:,syn) = temp.scaled_PIJvel5.loadings(syn,:);
    end
    
end

synsAug=[];

for sub=1:length(aug)
    temp = load(['/Users/paulina/Desktop/Cyberglove/' aug{sub} '/PCA.mat']);
    for syn=1:5
        synsAug(sub,:,syn) = temp.scaled_PIJvel1.loadings(syn,:);
    end
    for syn=1:5
        synsAug(sub+length(aug),:,syn) = temp.scaled_PIJvel5.loadings(syn,:);
    end
    
end

for sub=1:length(ctr)*2
    if syns(sub,4,5) > 0
        syns(sub,:,5) = -syns(sub,:,5);
    end
end

for sub=1:length(aug)*2
    if synsAug(sub,4,5) > 0
        synsAug(sub,:,5) = -synsAug(sub,:,5);
    end
end

synsTot = (abs(syns(1:9,:,1)) + abs(syns(10:18,:,1)))/2;
synsTotAug = (abs(synsAug(1:15,:,1)) + abs(synsAug(16:30,:,1)))/2;

synsTot = ((syns(1:9,:,5)) + (syns(10:18,:,5)))/2;
synsTotAug = ((synsAug(1:15,:,5)) + (synsAug(16:30,:,5)))/2;

data = [mean(abs(syns(:,:,1)))' mean(abs(synsAug(:,:,1)))'];
err = [(std(abs(synsTot))./sqrt(length(ctr)))' (std(abs(synsTotAug))./sqrt(length(aug)))'];

data = [mean((syns(:,:,5)))' mean((synsAug(:,:,5)))'];
err = [(std((synsTot))./sqrt(length(ctr)))' (std((synsTotAug))./sqrt(length(aug)))'];


figure()
barwitherr(err,data)
set(gca,'XTickLabel',{'Thumb','Index','Middle','Ring','Pinkie'})

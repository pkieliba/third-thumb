numSim = 10000; 
numVoxels = 3000;

magniFactor = 0.1;
inhiFactor = 0.1;

allAct = zeros(5,numSim,numVoxels);
allActMagni = zeros(5,numSim,numVoxels);
allActSix = zeros(5,numSim,numVoxels);
allActInhi = zeros(5,numSim,numVoxels);

sigma = 0.5;

canonHand = [1 4.6 5.7 7.1 5.9; 4.6 1 3.2 5 4.5; 5.7 3.2 1 3.3 3.7; 7.1 5 3.3 1 2.6; 5.9 4.5 3.7 2.6 1];
canonHandMagni = canonHand./((1+magniFactor) * ones(5,5) - magniFactor * eye(5)); 
canonHandSix = [canonHand, mean(squareform(canonHand - eye(5))) * ones(5,1)] ;
canonHandInhi = canonHand.*(1+inhiFactor);

%% BASELINE
dist = zeros(numSim,10);

for finger = 1:5
    for s = 1:numSim
        for nextFinger = 1:5
            finVoxels = ((nextFinger-1) * (numVoxels/5) + 1:nextFinger * (numVoxels/5));
            allAct(finger, s, finVoxels) = normrnd((1/canonHand(finger, nextFinger)), sigma, length(finVoxels), 1);
        end
    end
end

% Calculate distances
for s = 1:numSim
    dist(s,:) = pdist(squeeze(allAct(:,s,:)), 'euclidean');
end

%% CORTICAL MAGNIFICATION
distMagni = zeros(numSim,10);
            
for finger = 1:5
    for s = 1:numSim
        for nextFinger = 1:5
            finVoxels = ((nextFinger-1) * (numVoxels/5) + 1:nextFinger * (numVoxels/5));
            allActMagni(finger, s, finVoxels) = normrnd((1/canonHandMagni(finger, nextFinger)), sigma, length(finVoxels), 1);
        end
    end
end

% Calculate distances
for s = 1:numSim
    distMagni(s,:) = pdist(squeeze(allActMagni(:,s,:)), 'euclidean');
end


%% EXTRA DIGIT

distSix = zeros(numSim,10);

for finger = 1:5
    for s = 1:numSim
        for nextFinger = 1:6
            finVoxels = ((nextFinger-1) * (numVoxels/6) + 1:nextFinger * (numVoxels/6));
            allActSix(finger, s, finVoxels) = normrnd((1/canonHandSix(finger, nextFinger)), sigma, length(finVoxels), 1);
        end
    end
end

% Calculate distances
for s = 1:numSim
    distSix(s,:) = pdist(squeeze(allActSix(:,s,:)), 'euclidean');
end

%% INHIBITION

distInhi = zeros(numSim,10);

for finger = 1:5
    for s = 1:numSim
        for nextFinger = 1:5
            finVoxels = ((nextFinger-1) * (numVoxels/5) + 1:nextFinger * (numVoxels/5));
            allActInhi(finger, s, finVoxels) = normrnd((1/canonHandInhi(finger, nextFinger)), sigma, length(finVoxels) ,1);
        end
    end
end

% Calculate distances

for s = 1:numSim
    distInhi(s,:) = pdist(squeeze(allActInhi(:,s,:)), 'euclidean');
end


%% PLOTTING

figure()
subplot(2,4,1)
imagesc(squeeze(mean(allAct,2)))
pbaspect([1 1 1])
subplot(2,4,2)
imagesc(squeeze(mean(allActMagni,2)))
pbaspect([1 1 1])
subplot(2,4,3)
imagesc(squeeze(mean(allActSix,2)))
pbaspect([1 1 1])
subplot(2,4,4)
imagesc(squeeze(mean(allActInhi,2)))
pbaspect([1 1 1])
subplot(2,4,5)
imagesc(squareform(mean(dist)))
caxis([min(mean(dist))-0.1, max(mean(dist))+0.1])
pbaspect([1 1 1])
subplot(2,4,6)
imagesc(squareform(mean(distMagni)))
caxis([min(mean(dist))-0.1, max(mean(dist))+0.1])
pbaspect([1 1 1])
subplot(2,4,7)
imagesc(squareform(mean(distSix)))
caxis([min(mean(dist))-0.1, max(mean(dist))+0.1])
pbaspect([1 1 1])
subplot(2,4,8)
imagesc(squareform(mean(distInhi)))
caxis([min(mean(dist))-0.1, max(mean(dist))+0.1])
pbaspect([1 1 1])


figure()
scatter(ones(numSim,1).*5, mean(dist,2))
hold on;
scatter(ones(numSim,1).*6, mean(distMagni,2))
scatter(ones(numSim,1).*7, mean(distSix,2))
scatter(ones(numSim,1).*8, mean(distInhi,2))

xlim([4, 9]);
lgd=legend('Canonical', '10% Cortical Magnification', 'Extra Digit', '10% Inhibition', 'Location', 'southwest');
lgd.FontSize = 14;
ylabel('Average distance', 'FontSize', 14)
set(gca,'xtick', [])
set(gca,'xticklabel', [])

function [hist] = baileyPlot(Flex, Abd, diffFlex, diffAbd, numFlex, numAbd)

movFlex = Flex;
movAbd = Abd;
thresh = 10;
movFlex(Flex(:,1) <= 10,1) = 0;
movAbd(Abd(:,1) <= 10,1) = 0;

longVec = zeros(1, max(Flex(end,2), Abd(end,2)));
longVecFlex = longVec;
longVecAbd = longVec;

longVecFlex(movFlex(:,2)) = movFlex(:,1);
longVecAbd(movAbd(:,2)) = movAbd(:,1);

longVecFlex = [0 longVecFlex 0];
longVecAbd = [0 longVecAbd 0];

%% Interpolating the values within the movement periods
for n=1:numFlex
    temp = longVecFlex(diffFlex(2*n-1):diffFlex(2*n));
    xTemp = 1:length(temp);
    xiTemp = xTemp;
    zeroIdx = temp==0;
    temp(zeroIdx) = [];
    xTemp(zeroIdx) = [];
    tempInterp = interp1(xTemp, temp, xiTemp);
    longVecFlex(diffFlex(2*n-1):diffFlex(2*n)) = tempInterp;
end

for n=1:numAbd
    temp = longVecAbd(diffAbd(2*n-1):diffAbd(2*n));
    xTemp = 1:length(temp);
    xiTemp = xTemp;
    zeroIdx = temp==0;
    temp(zeroIdx) = [];
    xTemp(zeroIdx) = [];
    tempInterp = interp1(xTemp, temp, xiTemp);
    longVecAbd(diffAbd(2*n-1):diffAbd(2*n)) = tempInterp;
end

%% Normalisation
longVecAbd = longVecAbd/80;
longVecFlex = longVecFlex/175;

%% Calculate bilateral magnitude and magnitude ratio
bilateralMag = longVecAbd + longVecFlex;
magRatio = [];

for ms=1:length(longVecFlex)
    if longVecFlex(ms)==0 
        magRatio(ms) = 6;
    elseif longVecAbd(ms)==0
        magRatio(ms) = -6;
    else
        magRatio(ms) = log(longVecFlex(ms)/longVecAbd(ms));
    end
end

zeroIdx = bilateralMag==0;
bilateralMag(zeroIdx)= [];
magRatio(zeroIdx) = [];

%% Plot bivariate histogram
h = histogram2(magRatio, bilateralMag);
h.BinWidth = [0.2 0.05];

hist = histogram2('XBinEdges', h.XBinEdges, 'YBinEdges', h.YBinEdges, 'BinCounts', h.Values/60000)
hist.FaceColor = 'flat'
hist.DisplayStyle = 'tile'
view(2)
colorbar
xlabel('Magnitude ratio')
ylabel('Bilateral magnitude')

end

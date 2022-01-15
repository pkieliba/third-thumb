subjs = {'SF1', 'SF2', 'SF3', 'SF4', 'SF5', 'SF6', 'SF7', 'SF8', 'SF11', 'SF12', 'SF13', ...
    'SF14', 'SF15', 'SF16', 'SF17', 'SF19', 'SF22', 'SF21', 'SF23', 'SF24'};

hand = 2; % left: 1, right: 2
mask = 'M1'

load(['RSA/CTR_SI_average.mat'])
[template,~] = cmdscale(real(sqrt(double(squareform(average)))).^2);

preRDMs=[];
postRDMs=[];

for s = 1:length(subjs)
    load(['RSA/' subjs{s} '/RDMs_' mask '_pre.mat']);
    tempPre = reshape(triu(RDMs(hand).RDM(1:5,1:5))', 1, 25);
    tempPre(tempPre==0) = [];
    preRDMs(s,:) = tempPre;
end
                      
for s = 1:length(subjs)
    load(['RSA' subjs{s} '/RDMs_' mask '_post.mat']);
    tempPost = reshape(triu(RDMs(hand).RDM(1:5,1:5))', 1, 25);
    tempPost(tempPost==0) = [];
    postRDMs(s,:) = tempPost;
end

f(1) = figure;
subplot(221)
imagesc(squareform(real(mean(preRDMs))));
caxis([0 0.5])
pbaspect([1 1 1])
                       
subplot(222)
mdsdist_plot(double(real(preRDMs)),'template', template);
pbaspect([1 1 1])

subplot(223)
imagesc(squareform(real(mean(postRDMs))));
caxis([0 0.5])
pbaspect([1 1 1])
                       
subplot(224)
mdsdist_plot(double(real(postRDMs)),'template', template);
pbaspect([1 1 1])

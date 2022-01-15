function plotRDM(subj, hand)
    % hand: 1 (LH) or 2 (RH)

    load(['RSA/CTR_SI_average.mat'])
    [template,~] = cmdscale(real(sqrt(double(squareform(average)))).^2);

    preRDMs = [];
    postRDMs = [];

    load(['RSA/' subj '/RDMs_M1_pre.mat']);
    tempPre = reshape(triu(RDMs(hand).RDM(1:5,1:5))', 1, 25);
    tempPre(tempPre==0) = [];
    preRDMs = tempPre;

    f(1) = figure;
                      
    subplot(221)
    imagesc(RDMs(hand).RDM(1:5,1:5));
    caxis([0 0.5])
    pbaspect([1 1 1])
                      
    subplot(222)
    mdsdist_plot(double(real(preRDMs)), 'template', template);
    pbaspect([1 1 1])
                      
    load(['RSA/' subj '/RDMs_M1_post.mat']);
    tempPost = reshape(triu(RDMs(hand).RDM(1:5,1:5))', 1, 25);
    tempPost(tempPost==0) = [];
    postRDMs = tempPost;
                       
    subplot(223)
    imagesc(RDMs(hand).RDM(1:5,1:5));
    caxis([0 0.5])
    pbaspect([1 1 1])

    subplot(224)
    mdsdist_plot(double(real(postRDMs)), 'template', template);
    legend('T','I','M','R','L');
    pbaspect([1 1 1])
    
end

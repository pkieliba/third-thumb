function RDM = runRSA(sub, maskType, wholeBrain)

    PathData = '/vols/Data/soma/6Finger/';
    cd(PathData)
    toolboxRoot = '/home/fs0/paulinak/matlab/';
    addpath(genpath(toolboxRoot));
    ProjectOpt = '/vols/Data/soma/6Finger/scripts';
    addpath(genpath(ProjectOpt));
    
    if nargin < 4
        wholeBrain = 0;
    end
    
    if wholeBrain == 1
        
        mask = [maskType 'mask.nii.gz'];
        side = 3;
        userOptions = projectOptions(sub, side, mask);

        [betas, residuals] = rsa.fsl.getDataFromFSL(userOptions, sub);
        partQ = kron(1:length(userOptions.run_names), ones(1, length(userOptions.copes)))';  %runNumber (partition)
        partK = repmat(1:length(userOptions.copes), [1 length(userOptions.run_names)])';    %condNumber (CondVec)
        u_hat = rsa.fsl.noiseNormalizeBetaFSL(betas, residuals, partQ);   % Get noise normalised betas
        distance = rsa.distanceLDC(u_hat, partQ, partK);
        distance = ssqrt(distance);

        localRDM = squareform(real(distance));
        RDMs.RDM = localRDM;

        clear betas residuals u_hat distance localRDM;
        save(userOptions.outputFile, 'RDMs');
        return

    end

    for side = 1:2
        
        if side == 1
            mask = [maskType 'mask_RHemi.nii.gz'];
        elseif side == 2
            mask = [maskType 'mask_LHemi.nii.gz'];
        end
    
        userOptions = projectOptions(sub, side, mask);

        [betas,residuals] = rsa.fsl.getDataFromFSL(userOptions,sub);
        partQ = kron(1:length(userOptions.run_names),ones(1, length(userOptions.copes)))';  %runNumber (partition)
        partK = repmat(1:length(userOptions.copes),[1 length(userOptions.run_names)])';    %condNumber (CondVec)
        u_hat = rsa.fsl.noiseNormalizeBetaFSL(betas, residuals, partQ);   % Get noise normalised betas
        distance = rsa.distanceLDC(u_hat, partQ, partK);
        distance = ssqrt(distance);

        localRDM = squareform(real(distance));
        RDMs(side).RDM = localRDM;

        clear betas residuals u_hat distance localRDM;

    end
    
    save(userOptions.outputFile, 'RDMs');

end

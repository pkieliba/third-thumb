function [pre, post] = importTDres(subjects)

    path = /Volumes/ritd-ag-project-rd00k9-tmaki67/;
    dist = [0.71429, 0.83333, 0.85714, 1, 1.1667, 1.2, 1.4];
    
    % Pre
    for s = 1:length(subjects)
        load([path subjects{s}{1} '/Pre/Tactile Distance/' subjects{s}{1} '-pre-TD.mat']);
        
        % data acquisition errors
        if strcmp(subjects{s}{1}, 'SF5')
            resp(15,1) = NaN;
            resp(7,3) = NaN;
        elseif strcmp(subjects{s}{1}, 'SF7')
            resp(18,2) = NaN;
        elseif strcmp(subjects{s}{1}, 'SF8')
            resp(1,1) = NaN;
            resp(7,2) = NaN;
        elseif strcmp(subjects{s}{1}, 'SF12')
            resp(1,1) = NaN;
        end
        
        temp = [nansum(resp(blocks==5070)), nansum(resp(blocks==5060)), nansum(resp(blocks==6070))...
        nansum(resp(blocks==6060)), nansum(resp(blocks==7060)), nansum(resp(blocks==6050)), nansum(resp(blocks==7050))];
        times = [sum(~isnan(resp(blocks==5070))), sum(~isnan(resp(blocks==5060))), sum(~isnan(resp(blocks==6070)))...
        sum(~isnan(resp(blocks==6060))), sum(~isnan(resp(blocks==7060))), sum(~isnan(resp(blocks==6050))), sum(~isnan(resp(blocks==7050)))];
        
        score = times-temp;
        
        pre(:,:,s) = [dist', score', times'];
        
        a = [1,2,3...
        4,5,6]
        
    end

    % Post
    for s = 1:length(subjects)
        load([path subjects{s}{1} '/Post/Tactile Distance/' subjects{s}{1} '-post-TD.mat']);
        
        if strcmp(subjects{s}{1}, 'SF17')
            resp(1,1) = NaN;
            resp(3,1) = NaN;
            resp(8,3) = NaN;
        end

        temp = [nansum(resp(blocks==5070)), nansum(resp(blocks==5060)), nansum(resp(blocks==6070))...
        nansum(resp(blocks==6060)), nansum(resp(blocks==7060)), nansum(resp(blocks==6050)), nansum(resp(blocks==7050))];
        times = [sum(~isnan(resp(blocks==5070))), sum(~isnan(resp(blocks==5060))), sum(~isnan(resp(blocks==6070)))...
        sum(~isnan(resp(blocks==6060))), sum(~isnan(resp(blocks==7060))), sum(~isnan(resp(blocks==6050))), sum(~isnan(resp(blocks==7050)))];
        
        score = times-temp;
        
        post(:,:,s)=[dist', score', times'];
        
    end
    
end





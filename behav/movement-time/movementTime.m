function [mov_total, mov_time] = movementTime(dataFlex, dataAbd)

% Turn ON/OFF the plots
plots = 0;

%% Plot the movement magnitudes against the corresponding timestamps
if plots==1
    figure()
    if ~isempty(dataFlex)
        plot(dataFlex(:,2), dataFlex(:,1), 'b', 'DisplayName', 'flexion')
        hold on
    end
    if ~isempty(dataAbd)
        plot(dataAbd(:,2), dataAbd(:,1), 'r', 'DisplayName', 'abduction')
    end
    legend
end

%% Create two empty vectors in which we would mark which samples of data
% contain movement (based on threshold value), separately for each degree
% of freedom
movFlex = zeros(1,length(dataFlex));
movAbd = zeros(1,length(dataAbd));

thresh = 10; % Movement threshold (everything above this value is classified as movement)
if ~isempty(dataFlex)
    for i= 1:length(dataFlex(:,1))
        if dataFlex(i,1)>thresh
            movFlex(i) = 1;
        end
    end
end

if ~isempty(dataAbd)
    for i=1:length(dataAbd(:,1))
        if dataAbd(i,1)>thresh
            movAbd(i) = 1;
        end
    end
end

%% Remove single data spikes (possibly equipment glitches?)
for n=2:length(movFlex)-1
    tempSum = sum(movFlex(n-1:n+1));
    if tempSum <= 1
        movFlex(n) = 0;
    end
end

for n=2:length(movAbd)-1
    tempSum = sum(movAbd(n-1:n+1));
    if tempSum <= 1
        movAbd(n) = 0;
    end
end

%% Calcuate the differentials of the mov vectors. It will create new vectors
% in which 1 corresponds to the start of every movement and -1 to the stop of every
% movement
mov_seFlex = diff(movFlex);
mov_seAbd = diff(movAbd);
mov_sFlex = find(mov_seFlex==1);
mov_eFlex = find(mov_seFlex==-1);
mov_sAbd = find(mov_seAbd==1);
mov_eAbd = find(mov_seAbd==-1);

%% Plot the differential vectors. Note that they are ploted against the
% sample number and not the timestamp!
if plots==1
    figure()
    plot(mov_seFlex, 'b', 'DisplayName', 'flexion')
    hold on
    plot(mov_seAbd, 'r', 'DisplayName', 'abduction')
    legend
end

%% Create a vector as long as the number of milliseconds in the recording
if isempty(dataFlex)
    mov_time = zeros(1, dataAbd(end,2));
elseif isempty(dataAbd)
    mov_time = zeros(1, dataFlex(end,2));
else
    mov_time = zeros(1, max(dataFlex(end,2), dataAbd(end,2)));
end

% Set all the flexion movement intervals (end of the movement time - start of the movement time) to 1 in the mov_time vector
if ~(isempty(mov_sFlex) && isempty(mov_eFlex))
    if isempty(mov_sFlex) && ~isempty(mov_eFlex)
        mov_sFlex = 1;
    end
    if isempty(mov_eFlex) && ~isempty(mov_sFlex)
        mov_eFlex = length(dataFlex);
    end
    if dataFlex(mov_eFlex(1), 2) < dataFlex(mov_sFlex(1), 2) % account for the recording begining with a movement period
        mov_time(dataFlex(1,2):dataFlex(mov_eFlex(1), 2)) = 1;
        for n=2:length(mov_eFlex)
            mov_time(dataFlex(mov_sFlex(n-1), 2):dataFlex(mov_eFlex(n), 2)) = 1;
        end
    else
        for n=1:length(mov_eFlex)
            mov_time(dataFlex(mov_sFlex(n), 2):dataFlex(mov_eFlex(n), 2)) = 1;
        end
    end
    if  dataFlex(mov_eFlex(end), 2)<dataFlex(mov_sFlex(end), 2) % account for the recording ending with a movement period
        mov_time(dataFlex(mov_sFlex(end), 2):dataFlex(end, 2)) = 1;
    end
end

%% Set all the abduction movement intervals (end of the movmeent time - start of the ovement time) to 1 in the mov_time vector
if ~(isempty(mov_sAbd) && isempty(mov_eAbd))
    if isempty(mov_sAbd) && ~isempty(mov_eAbd)
        mov_sAbd = 1;
    end
    if isempty(mov_eAbd) && ~isempty(mov_sAbd)
        mov_eAbd = length(dataAbd);
    end
    if dataAbd(mov_eAbd(1),2) < dataAbd(mov_sAbd(1),2) % account for the recording begining with a movement period
        mov_time(dataAbd(1,2):dataAbd(mov_eAbd(1),2)) = 1;
        for n=2:length(mov_eAbd)
            mov_time(dataAbd(mov_sAbd(n-1),2):dataAbd(mov_eAbd(n),2)) = 1;
        end
    else
        for n=1:length(mov_eAbd)
            mov_time(dataAbd(mov_sAbd(n),2):dataAbd(mov_eAbd(n),2)) = 1;
        end
    end
    if dataAbd(mov_eAbd(end),2) < dataAbd(mov_sAbd(end),2) % account for the recording ending with a movement period
        mov_time(dataAbd(mov_sAbd(end),2):dataAbd(end,2)) = 1;
    end
end

%% Plot the raw data in the time, and mark the clasified movement periods
if plots==1
    figure()
    if ~isempty(dataFlex)
        plot(dataFlex(:,2), dataFlex(:,1), 'b', 'DisplayName', 'flexion')
    end
    hold on
    if ~isempty(dataAbd)
        plot(dataAbd(:,2), dataAbd(:,1), 'r', 'DisplayName', 'abduction')
    end
    plot(mov_time*100, 'g', 'DisplayName', 'movement periods')
    legend
end

%% Calculate the total movement time, by summing up the number of samples
% (milliseconds) equal to 1 in the mov_time vector

mov_total = sum(mov_time);
mov_total_hours = mov_total/3600000;

end

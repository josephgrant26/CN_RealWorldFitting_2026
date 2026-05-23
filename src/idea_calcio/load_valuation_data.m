function T = load_valuation_data()
    players = readtable('players.csv');
    valuations = readtable('player_valuations.csv');

    % Drop the duplicate column from players before joining
    players = players(:, {'player_id', 'date_of_birth'});

    T = innerjoin(players, valuations, 'Keys', 'player_id');
    T = T(:, {'player_id', 'date_of_birth', 'market_value_in_eur', 'date'});
    T = rmmissing(T);

    % Compute age at time of valuation
    T.age = years(datetime(T.date, 'InputFormat', 'yyyy-MM-dd') - ...
                  datetime(T.date_of_birth, 'InputFormat', 'yyyy-MM-dd'));

    % Keep one entry per player (most recent valuation)
    T = sortrows(T, 'date', 'descend');
    [~, idx] = unique(T.player_id);
    T = T(idx, :);

    % Keep realistic range and remove outliers
    T = T(T.age >= 15 & T.age <= 40, :);
    T = T(T.market_value_in_eur > 0, :);
    T = T(T.market_value_in_eur < 2e8, :);
end
    %OBJECTIVE AND EXPLANATION:
    %to do: 

    % dataset va bene?

    % poly 2nd grado
    % poly 3 grado
    % modello misto: a + bt + ct^2 + cos(2/pi)
    % modello exp


    % capire cosa c'è da studiare:
       % cosa fanno comandi di matLAB under the hood (tipo polyfit)
       % least squares: lez 17 e 18 e forse quadratura (19, 20)?
            % distinzione tra questo e interpolazione e perchè interpol non va bene  
       % saper spiegare come minchia siamo arrivati a questo modello misto: a + bt + ct^2 + cos(2/pi)
        % mi immagino ci sia un algoritmo tipo regressione che ci fa
        % arrivare a determinati parametri

    %   cosa rende mogliore un modello di fitting




function T = load_sunspot_data()
    T = readtable('sunspots.xls', 'FileType', 'text', 'Delimiter', ',');
    T.Properties.VariableNames = {'id', 'date', 'sunspots'};

    T.date = datetime(T.date, 'InputFormat', 'yyyy-MM-dd');
    T = rmmissing(T);

    % x = months since start of dataset
    T.month_idx = (0:height(T)-1)';

    T = T(:, {'month_idx', 'sunspots'});
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




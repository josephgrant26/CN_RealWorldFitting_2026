function T = load_exoplanet_data()
    T = readtable('exoplanets.csv', 'CommentStyle', '#');
    
    T = T(:, {'pl_name', 'pl_orbper', 'pl_bmasse', 'st_mass', 'pl_orbsmax'}); %name, orbit period, mass, starr mass, 
                                                                              % max orbital distance
    T = rmmissing(T); % no NaNs
    [~, idx] = unique(T.pl_name); % planet name is 'primary key' -> removes data on the same planet from different observation stations
    T = T(idx, :);
    T = T(T.pl_orbper < 1e6, :); % removes outliers 
    
    %OBJECTIVE AND EXPLANATION:
    %to do: 
    % studiare i modelli
    % trovare un quarto modello
    % capire come valutare quale modello è migliore
    % scrivere relazione


end


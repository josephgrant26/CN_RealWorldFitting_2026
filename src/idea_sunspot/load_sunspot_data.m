function T = load_sunspot_data()
    T = readtable('Sunspots.csv', 'FileType', 'text', 'Delimiter', ',');
    T.Properties.VariableNames = {'id', 'date', 'sunspots'};

    T.date = datetime(T.date, 'InputFormat', 'yyyy-MM-dd');
    T = rmmissing(T);

    
    T.month_idx = (0:height(T)-1)';

    T = T(:, {'month_idx', 'sunspots'});
end
    
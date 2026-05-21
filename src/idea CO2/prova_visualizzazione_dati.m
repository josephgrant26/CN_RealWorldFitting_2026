%% 1. OPZIONI DI IMPORTAZIONE
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [58, Inf]; % Salta le righe di testo iniziali
opts.Delimiter = ",";

% Definiamo i nomi delle colonne
opts.VariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.SelectedVariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

%% 2. IMPORTA I DATI
% Legge il file CSV usando le opzioni qua sopra
co2_annmean_mlo = readtable("C:\Users\matte\Desktop\co2_annmean_mlo.csv", opts);

%% 3. FARE IL GRAFICO
figure('Color', 'w'); % Apre una finestra per il grafico con sfondo bianco

% Disegna il grafico: asse X = Anno, asse Y = CO2_Media
% 'o-' serve per mostrare i punti uniti da una linea
plot(co2_annmean_mlo.Anno, co2_annmean_mlo.CO2_Media, 'o-', 'LineWidth', 1.5, 'Color', [0 0.447 0.741]); 

% Mette la griglia per leggere meglio i valori
grid on;

% Etichette descrittive
xlabel('Anno');
ylabel('Concentrazione CO2 (ppm)');
title('Dati Reali della CO2 Annuale a Mauna Loa');
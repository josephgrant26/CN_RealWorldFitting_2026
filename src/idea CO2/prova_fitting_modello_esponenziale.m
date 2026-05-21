%% 1. OPZIONI DI IMPORTAZIONE
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [58, Inf]; 
opts.Delimiter = ",";

opts.VariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.SelectedVariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

%% 2. IMPORTA I DATI
co2_annmean_mlo = readtable("C:\Users\matte\Desktop\progetto_calcolo\co2_annmean_mlo.csv", opts);

x = co2_annmean_mlo.Anno;
y = co2_annmean_mlo.CO2_Media;

%% 3. CALCOLO DEL FIT (Modello Esponenziale tramite Linearizzazione)
% Centriamo il tempo (t parte da 0)
t = x - x(1); 

% Trasformiamo i dati prendendo il logaritmo naturale delle Y
Y_log = log(y);

% Poiché ln(y) = ln(alpha) + beta*t, questo è un problema lineare (una retta!).
% Usiamo polyfit di grado 1 sui dati trasformati.
% p(1) sarà beta, p(2) sarà ln(alpha)
p = polyfit(t, Y_log, 1);

beta_ottimo = p(1);
alpha_ottimo = exp(p(2)); % Applichiamo l'esponenziale per ricavare alpha

% Calcoliamo i valori della curva esponenziale finale sulle Y originali
y_fit_esponenziale = alpha_ottimo * exp(beta_ottimo * t);

%% 4. CALCOLO DELL'ERRORE (Norma del Residuo)
% Nota: confrontiamo i dati reali 'y' con quelli del modello, non i logaritmi!
residuo_esponenziale = norm(y - y_fit_esponenziale);

% Mostriamo i risultati nella Command Window
fprintf('\n--- RISULTATI MODELLO ESPONENZIALE LINEARIZZATO ---\n');
fprintf('Formula: y = alpha * e^(beta * t)\n');
fprintf('Parametro alpha:     %f\n', alpha_ottimo);
fprintf('Parametro beta:      %f\n', beta_ottimo);
fprintf('Norma del residuo:   %f\n', residuo_esponenziale);

%% 5. GRAFICO DI CONFRONTO
figure('Color', 'w');

% 1. Disegna i dati reali (cerchietti blu)
plot(x, y, 'o', 'LineWidth', 1, 'Color', [0 0.447 0.741], 'DisplayName', 'Dati Reali');
hold on;

% 2. Sovrappone la curva del fit esponenziale (linea rossa continua)
plot(x, y_fit_esponenziale, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Fit Esponenziale');

grid on;
xlabel('Anno');
ylabel('Concentrazione CO2 (ppm)');
title('Fitting dei dati CO2 con Modello Esponenziale Linearizzato');
legend('Location', 'northwest');
hold off;
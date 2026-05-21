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

%% 3. CALCOLO DEL FIT (Modello Misto: Parabola + Logaritmo)
% Centriamo il tempo
t = x - x(1); 

% COSTRUZIONE DELLA MATRICE DEL SISTEMA A * c = y
% Colonna 1: 1 (termine noto 'a')
% Colonna 2: t (coefficiente 'b')
% Colonna 3: t^2 (coefficiente 'c')
% Colonna 4: ln(t + 1) (coefficiente 'd') -> in MATLAB il logaritmo naturale è 'log'
A = [ones(length(t), 1), t, t.^2, log(t + 1)];

% RISOLUZIONE CON I MINIMI QUADRATI (Operatore backslash)
c = A \ y;

% Estraiamo i coefficienti
a = c(1); b = c(2); col_c = c(3); d = c(4);

% Calcoliamo i valori stimati dal modello
y_fit_misto = A * c;

%% 4. CALCOLO DELL'ERRORE (Norma del Residuo)
residuo_misto = norm(y - y_fit_misto);

% Mostriamo i risultati nella Command Window
fprintf('\n--- RISULTATI MODELLO MISTO (PARABOLA + LOGARITMO) ---\n');
fprintf('Termine noto     (a): %f\n', a);
fprintf('Coefficiente t   (b): %f\n', b);
fprintf('Coefficiente t^2 (c): %f\n', col_c);
fprintf('Coefficiente log (d): %f\n', d);
fprintf('Norma del residuo:    %f\n', residuo_misto);

%% 5. GRAFICO DI CONFRONTO
figure('Color', 'w');

% 1. Disegna i dati reali
plot(x, y, 'o', 'LineWidth', 1, 'Color', [0 0.447 0.741], 'DisplayName', 'Dati Reali');
hold on;

% 2. Sovrappone la curva del fit misto (linea rossa continua)
plot(x, y_fit_misto, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Fit Misto (Parabola + Log)');

grid on;
xlabel('Anno');
ylabel('Concentrazione CO2 (ppm)');
title('Fitting dei dati CO2 con Modello Misto Parabola + Logaritmo');
legend('Location', 'northwest');
hold off;
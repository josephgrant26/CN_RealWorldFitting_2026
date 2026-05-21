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
%% il percorso è assoluto mettete il vostro
co2_annmean_mlo = readtable("C:\Users\matte\Desktop\progetto_calcolo\co2_annmean_mlo.csv", opts);

x = co2_annmean_mlo.Anno;
y = co2_annmean_mlo.CO2_Media;

%% 3. CALCOLO DEL FIT (Polinomio di 3° Grado)
% Centriamo il tempo come prima per stabilità numerica
t = x - x(1); 

% Passiamo il valore 3 a polyfit per cercare i coefficienti [A, B, C, D]
coefficienti_grado3 = polyfit(t, y, 3);

% Calcoliamo i valori del polinomio di 3° grado nei punti t
y_fit_grado3 = polyval(coefficienti_grado3, t);

%% 4. CALCOLO DELL'ERRORE (Norma del Residuo)
residuo_grado3 = norm(y - y_fit_grado3);

% Mostriamo i risultati nella Command Window
fprintf('\n--- RISULTATI POLINOMIO 3° GRADO ---\n');
fprintf('Coefficiente t^3 (A): %f\n', coefficienti_grado3(1));
fprintf('Coefficiente t^2 (B): %f\n', coefficienti_grado3(2));
fprintf('Coefficiente t   (C): %f\n', coefficienti_grado3(3));
fprintf('Termine noto     (D): %f\n', coefficienti_grado3(4));
fprintf('Norma del residuo:    %f\n', residuo_grado3);

%% 5. GRAFICO DI CONFRONTO
figure('Color', 'w');

% 1. DISEGNA I DATI REALI (Cerchietti blu) <--- Questa riga era sparita!
plot(x, y, 'o', 'LineWidth', 1, 'Color', [0 0.447 0.741], 'DisplayName', 'Dati Reali');
hold on; % Congela lo schermo

% 2. DISEGNA IL FIT (Linea rossa continua)
plot(x, y_fit_grado3, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Fit Polinomiale Grado 3');

% Abbellimenti del grafico
grid on;
xlabel('Anno');
ylabel('Concentrazione CO2 (ppm)');
title('Fitting dei dati CO2 con Polinomio di 3° Grado');
legend('Location', 'northwest');
hold off;
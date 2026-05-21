%% 1. OPZIONI DI IMPORTAZIONE
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [58, Inf]; % Salta le righe di testo iniziali
opts.Delimiter = ",";

opts.VariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.SelectedVariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

%% 2. IMPORTA I DATI
co2_annmean_mlo = readtable("C:\Users\matte\Desktop\progetto_calcolo\co2_annmean_mlo.csv", opts);

% Estraiamo i vettori x e y per comodità
x = co2_annmean_mlo.Anno;
y = co2_annmean_mlo.CO2_Media;

%% 3. CALCOLO DEL FIT (Polinomio di 2° Grado)
% Centriamo il tempo: t partirà da 0 (corrispondente al primo anno del dataset)
t = x - x(1); 

% polyfit trova i coefficienti [A, B, C] della parabola: y = A*t^2 + B*t + C
coefficienti_grado2 = polyfit(t, y, 2);

% polyval calcola i valori della parabola nei punti t per trovare la curva di fit
y_fit_grado2 = polyval(coefficienti_grado2, t);

%% 4. CALCOLO DELL'ERRORE (Norma del Residuo)
% Calcoliamo la norma due dello scarto tra i dati reali e quelli del modello
residuo_grado2 = norm(y - y_fit_grado2);

% Mostriamo i coefficienti e l'errore nella Command Window
fprintf('\n--- RISULTATI POLINOMIO 2° GRADO ---\n');
fprintf('Coefficiente t^2 (A): %f\n', coefficienti_grado2(1));
fprintf('Coefficiente t   (B): %f\n', coefficienti_grado2(2));
fprintf('Termine noto     (C): %f\n', coefficienti_grado2(3));
fprintf('Norma del residuo:    %f\n', residuo_grado2);

%% 5. GRAFICO DI CONFRONTO
figure('Color', 'w');

% 1. Disegna i dati reali (punti blu)
plot(x, y, 'o', 'LineWidth', 1, 'Color', [0 0.447 0.741], 'DisplayName', 'Dati Reali');
hold on; % <--- FONDAMENTALE: dice a MATLAB di non cancellare il disegno precedente

% 2. Sovrappone la curva di fitting (linea rossa spessa)
plot(x, y_fit_grado2, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Fit Polinomiale Grado 2');

% Abbellimenti del grafico
grid on;
xlabel('Anno');
ylabel('Concentrazione CO2 (ppm)');
title('Fitting dei dati CO2 con Polinomio di 2° Grado');
legend('Location', 'northwest'); % Mostra la legenda in alto a sinistra
hold off;
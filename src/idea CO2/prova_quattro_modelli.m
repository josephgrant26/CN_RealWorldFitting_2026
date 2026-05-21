%% =======================================================================
%% PROGETTO CALCOLO NUMERICO: APPROSSIMAZIONE DATI REALI (CO2 MAUNA LOA)
%% SCRIPT COMPLETO CON I 4 MODELLI DI FITTING (LINEE CONTINUE)
%% =======================================================================
clear; clc; close all;

%% 1. OPZIONI DI IMPORTAZIONE DATI
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [58, Inf]; 
opts.Delimiter = ",";

opts.VariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.SelectedVariableNames = ["Anno", "CO2_Media", "Incertezza"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

%% 2. IMPORTA I DATI REALI
co2_data = readtable("C:\Users\matte\Desktop\progetto_calcolo\co2_annmean_mlo.csv", opts);

x = co2_data.Anno;
y = co2_data.CO2_Media;

% Centratura del tempo per garantire stabilità numerica (t parte da 0)
t = x - x(1); 

%% =======================================================================
%% 3. CALCOLO DEI 4 MODELLI DI FITTING (MINIMI QUADRATI)
%% =======================================================================

%% --- MODELLO 1: Polinomio di 2° Grado (Parabola) ---
coeff_grado2 = polyfit(t, y, 2);
y_fit1 = polyval(coeff_grado2, t);
residuo1 = norm(y - y_fit1);

%% --- MODELLO 2: Polinomio di 3° Grado (Cubica) ---
coeff_grado3 = polyfit(t, y, 3);
y_fit2 = polyval(coeff_grado3, t);
residuo2 = norm(y - y_fit2);

%% --- MODELLO 3: Modello Misto (Parabola + Logaritmo) ---
A = [ones(length(t), 1), t, t.^2, log(t + 1)];
coeff_misto = A \ y; 
y_fit3 = A * coeff_misto;
residuo3 = norm(y - y_fit3);

%% --- MODELLO 4: Modello Esponenziale Puro (Linearizzato) ---
Y_log = log(y);
p_esp = polyfit(t, Y_log, 1);
beta_esp = p_esp(1);
alpha_esp = exp(p_esp(2));

y_fit4 = alpha_esp * exp(beta_esp * t);
residuo4 = norm(y - y_fit4);


%% =======================================================================
%% 4. STAMPA DELLA TABELLA DI CONFRONTO DEI RISULTATI
%% =======================================================================
fprintf('\n==================================================================\n');
fprintf('          TABELLA DI CONFRONTO DEI RESIDUI (NORMA-2)            \n');
fprintf('==================================================================\n');
fprintf('Modello 1 - Polinomio 2° Grado (Parabola):      %f\n', residuo1);
fprintf('Modello 2 - Polinomio 3° Grado (Cubica):        %f\n', residuo2);
fprintf('Modello 3 - Misto (Parabola + Logaritmo):       %f\n', residuo3);
fprintf('Modello 4 - Esponenziale Puro (Linearizzato):   %f\n', residuo4);
fprintf('==================================================================\n');


%% =======================================================================
%% 5. GRAFICO DI CONFRONTO FINALE CON LINEE TUTTE CONTINUE
%% =======================================================================
figure('Color', 'w', 'Position', [100, 100, 1000, 650]);

% 1. Disegna i dati reali usando punti neri pieni (k.) di dimensione 12
plot(x, y, 'k.', 'MarkerSize', 12, 'DisplayName', 'Dati Reali (Mauna Loa)');
hold on;

% 2. Disegna i 4 modelli usando sempre la linea continua ('-') ma colori diversi
plot(x, y_fit1, 'r-', 'LineWidth', 2, 'DisplayName', 'Modello 1: Pol. 2° Grado (Rosso)');
plot(x, y_fit2, 'g-', 'LineWidth', 2, 'DisplayName', 'Modello 2: Pol. 3° Grado (Verde)');
plot(x, y_fit3, 'b-', 'LineWidth', 2, 'DisplayName', 'Modello 3: Parabola + Log (Blu)');
plot(x, y_fit4, 'm-', 'LineWidth', 2, 'DisplayName', 'Modello 4: Esponenziale Puro (Magenta)');

% Configurazione assi e legende professionali
plot(x, y, 'yo', 'MarkerSize', 5, 'MarkerFaceColor', 'y', 'DisplayName', 'Dati Reali (Mauna Loa)');
grid on;
xlim([min(x)-1, max(x)+1]); 
xlabel('Anno', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Concentrazione CO2 (ppm)', 'FontSize', 12, 'FontWeight', 'bold');
title('Confronto Grafico dei 4 Modelli di Fitting - Dataset CO2', 'FontSize', 14, 'FontWeight', 'bold');

% Posizioniamo la legenda in alto a sinistra
legend('Location', 'northwest', 'FontSize', 11);
hold off;
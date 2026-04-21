% Data:
T = load_exoplanet_data();

x = T.pl_orbsmax;
y = T.pl_orbper;

x_pwr = T.pl_orbsmax;
y_pwr = T.pl_orbper;

%--------------------------------------%

% Fit polinomiale grado 2
pol2 = polyfit(x, y, 2);

% Coefficienti
a2 = pol2(1);
b2 = pol2(2);
c2 = pol2(3);

%--------------------------------------%

% Fit polinomiale grado 6
pol3 = polyfit(x, y, 6);

% Coefficienti
a3 = pol3(1);
b3 = pol3(2);
c3 = pol3(3);
d3 = pol3(4);

%--------------------------------------%

% Fit log linearized power law 
idx = x_pwr > 0 & y_pwr > 0;
x_pwr = x_pwr(idx);
y_pwr = y_pwr(idx);

X = log(x_pwr);
Y = log(y_pwr);

p = polyfit(X, Y, 1);

n = p(1);          
logk = p(2);
k = exp(logk);     

fprintf('Modello: y = %.4f * x^{%.4f}\n', k, n);

y_fit = k * x.^n;


%--------------------------------------%

% ===== CURVA X per il plot =====
x_range = linspace(min(x(x > 0)), max(x), 500); 

y_pol2 = polyval(pol2, x_range);
y_pol3 = polyval(pol3, x_range);
y_plaw = k * x_range.^n;

% Draw:

figure('Name', 'Exoplanet Orbital Fitting', 'NumberTitle', 'off');


plot(x, y, 'w.', 'MarkerSize', 10, 'DisplayName', 'Dati');
hold on;

% Pol. grado 2
plot(x_range, y_pol2, 'b-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Pol. grado 2'));

% Pol. grado 3
plot(x_range, y_pol3, 'r-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Pol. grado 3'));

% Power law
plot(x_range, y_plaw, 'g-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Power law: y = %.3f x^{%.3f}', k, n));

hold off;
legend('Location', 'northwest', 'FontSize', 9);
xlabel('Semi-asse maggiore (AU)');
ylabel('Periodo orbitale (giorni)');
title('Fitting orbite esopianeti');
grid on;
box on;
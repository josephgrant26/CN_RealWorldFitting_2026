% Data:
T = load_valuation_data();
x = T.age;
y = T.market_value_in_eur / 1e6; % convert to millions for readability
x_pwr = T.age;
y_pwr = T.market_value_in_eur / 1e6;
%--------------------------------------%
% Fit polinomiale grado 2
pol2 = polyfit(x, y, 2);
a2 = pol2(1); b2 = pol2(2); c2 = pol2(3);
%--------------------------------------%
% Fit polinomiale grado 3
pol3 = polyfit(x, y, 3);
a3 = pol3(1); b3 = pol3(2); c3 = pol3(3); d3 = pol3(4);
%--------------------------------------%
% Fit log linearized power law
idx = x_pwr > 0 & y_pwr > 0;
x_pwr = x_pwr(idx);
y_pwr = y_pwr(idx);
X = log(x_pwr);
Y = log(y_pwr);
p = polyfit(X, Y, 1);
n = p(1);
k = exp(p(2));
fprintf('Modello: y = %.4f * x^{%.4f}\n', k, n);
%--------------------------------------%
% ===== CURVA X per il plot =====
x_range = linspace(15, 40, 500);
y_pol2 = polyval(pol2, x_range);
y_pol3 = polyval(pol3, x_range);
y_plaw = k * x_range.^n;
% Draw:
figure('Name', 'Player Value vs Age Fitting', 'NumberTitle', 'off');
plot(x, y, 'w.', 'MarkerSize', 6, 'DisplayName', 'Dati');
hold on;
plot(x_range, y_pol2, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Pol. grado 2');
plot(x_range, y_pol3, 'r-', 'LineWidth', 1.8, 'DisplayName', 'Pol. grado 3');
plot(x_range, y_plaw, 'g-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Power law: y = %.3f x^{%.3f}', k, n));
hold off;
legend('Location', 'northeast', 'FontSize', 9);
xlabel('Età (anni)');
ylabel('Valore di mercato (M€)');
title('Fitting valore di mercato vs età');
grid on;
box on;
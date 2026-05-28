T = load_sunspot_data();
x = T.month_idx;
y = T.sunspots;
omega = 2*pi/132;
%--------------------------------------%

% Fit polinomiale grado 28
[poly_28, s_28, mu_28] = polyfit(x, y, 28);

% Fit polinomiale grado 3
poly_3 = polyfit(x, y, 3);


%--------------------------------------%
% Fit sinusoidale lineare nei parametri
% A*sin(wx + phi) + C = a*sin(wx) + b*cos(wx) + C
X_sine = [sin(omega*x), cos(omega*x), ones(size(x))];
coeffs_s = X_sine \ y;
a_s = coeffs_s(1); b_s = coeffs_s(2); C_s = coeffs_s(3);
A_s = sqrt(a_s^2 + b_s^2);
phi_s = atan2(b_s, a_s);
fprintf('Sine - A=%.4f, phi=%.4f, C=%.4f\n', A_s, phi_s, C_s);


%--------------------------------------%
% Fit serie di Fourier (2 armoniche)
% a1*sin(wx) + b1*cos(wx) + a2*sin(2wx) + b2*cos(2wx) + C
X_four = [sin(omega*x), cos(omega*x), ...
          sin(2*omega*x), cos(2*omega*x), ones(size(x))];
coeffs_f = X_four \ y;
a1=coeffs_f(1); b1=coeffs_f(2);
a2=coeffs_f(3); b2=coeffs_f(4); C_f=coeffs_f(5);
fprintf('Fourier - a1=%.4f, b1=%.4f, a2=%.4f, b2=%.4f, C=%.4f\n', ...
    a1, b1, a2, b2, C_f);


%--------------------------------------%
% Valutazione Modelli

y_pol28_fit  = polyval(poly_28, x, [], mu_28);
y_pol3_fit  = polyval(poly_3, x);
y_sine_fit  = a_s*sin(omega*x) + b_s*cos(omega*x) + C_s;
y_four_fit  = a1*sin(omega*x) + b1*cos(omega*x) + ...
              a2*sin(2*omega*x) + b2*cos(2*omega*x) + C_f;


% RMSE function
ss_tot = sum((y - mean(y)).^2);
rmse = @(y_fit) sqrt(mean((y - y_fit).^2));


% Print tabella RMSE 
fprintf('\n%-20s %8s\n', 'Modello', 'RMSE');
fprintf('%-20s %8.4f\n', 'Pol. grado 28',    rmse(y_pol28_fit));
fprintf('%-20s %8.4f\n', 'Pol. grado 3',    rmse(y_pol3_fit));
fprintf('%-20s %8.4f\n', 'Sine',            rmse(y_sine_fit));
fprintf('%-20s %8.4f\n', 'Fourier',         rmse(y_four_fit));




% R² and Adjusted R²
n_pts = length(y);
r2      = @(y_fit) 1 - sum((y - y_fit).^2) / ss_tot;
adj_r2  = @(y_fit, n_params) 1 - (1 - r2(y_fit)) * (n_pts-1) / (n_pts-n_params-1);

% Numero di parametri per ogni modello
p_pol28 = 29;  % grado 25 -> 26 coefficienti
p_pol3 = 4;  % grado 3 -> 4 coefficienti 
p_sine  = 3;   % a, b, C
p_four  = 5;   % a1, b1, a2, b2, C

fprintf('\n%-20s %8s %8s\n', 'Modello', 'R²', 'Adj-R²');
fprintf('%-20s %8.4f %8.4f\n', 'Pol. grado 28', r2(y_pol28_fit), adj_r2(y_pol28_fit, p_pol28));
fprintf('%-20s %8.4f %8.4f\n', 'Pol. grado 3', r2(y_pol3_fit), adj_r2(y_pol3_fit, p_pol3));
fprintf('%-20s %8.4f %8.4f\n', 'Sine',          r2(y_sine_fit),  adj_r2(y_sine_fit,  p_sine));
fprintf('%-20s %8.4f %8.4f\n', 'Fourier',       r2(y_four_fit),  adj_r2(y_four_fit,  p_four));


% RUNGE %
% valuta solo sul centro del dataset
n_pts = length(x);
edge_pct = 0.1; % estremo definito come il 10% più a dx o sx del dataset
n_edge = round(n_pts * edge_pct);

idx_left  = 1:n_edge;
idx_right = (n_pts-n_edge+1):n_pts;
idx_center = (n_edge+1):(n_pts-n_edge);


center_idx = idx_center;
border_idx = [idx_left(:); idx_right(:)];

% Refit sul centro del dataset
[poly28_cv, ~, mu28_cv] = polyfit(x(center_idx), y(center_idx), 28);
poly_3_cv = polyfit(x(center_idx), y(center_idx), 3);

% valuta RMSE agli estremi
y_pol28_test = polyval(poly28_cv, x(border_idx), [], mu28_cv);
y_poly3_test = polyval(poly_3_cv, x(border_idx));
y_sine_test  = a_s*sin(omega*x(border_idx)) + b_s*cos(omega*x(border_idx)) + C_s;

fprintf('\n%-20s %10s\n', 'Modello', 'RMSE estremi');
fprintf('%-20s %10.4f\n', 'Pol. grado 28', sqrt(mean((y(border_idx) - y_pol28_test).^2)));
fprintf('%-20s %10.4f\n', 'Pol. grado 3', sqrt(mean((y(border_idx) - y_poly3_test).^2)));
fprintf('%-20s %10.4f\n', 'Sine',          sqrt(mean((y(border_idx) - y_sine_test).^2)));



% PLOT %


x_range = linspace(min(x), max(x), 2000)';
y_pol28  = polyval(poly_28, x_range, [], mu_28);
y_pol3  = polyval(poly_3, x_range);
y_sine  = a_s*sin(omega*x_range) + b_s*cos(omega*x_range) + C_s;
y_four  = a1*sin(omega*x_range)  + b1*cos(omega*x_range) + ...
          a2*sin(2*omega*x_range) + b2*cos(2*omega*x_range) + C_f;

figure('Name', 'Sunspot Cycle Fitting', 'NumberTitle', 'off');
plot(x, y, 'w.', 'MarkerSize', 3, 'DisplayName', 'Dati');
hold on;
plot(x_range, y_pol28, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Pol. grado 28');
plot(x_range, y_pol3, 'y-', 'LineWidth', 1.8, 'DisplayName', 'Pol. grado 3');
plot(x_range, y_sine, 'm-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Sine: A=%.2f, \\phi=%.2f, C=%.2f', A_s, phi_s, C_s));
plot(x_range, y_four, 'c-', 'LineWidth', 1.8, ...
    'DisplayName', 'Fourier 2 armoniche');

legend('Location', 'northeast', 'FontSize', 9);
xlabel('Mesi dall''inizio del dataset (1749)');
ylabel('Numero medio di macchie solari');
title('Fitting ciclo delle macchie solari');
grid on;
box on;




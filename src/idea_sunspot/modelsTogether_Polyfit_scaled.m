T = load_sunspot_data();
x = T.month_idx;
y = T.sunspots;
omega = 2*pi/132;
%--------------------------------------%
% Fit polinomiale grado 6
[p, s, mu] = polyfit(x, y, 25);
%--------------------------------------%
% Linear trend + sine: y = a*x + b*sin(wx) + c*cos(wx) + d
X_trend = [x, sin(omega*x), cos(omega*x), ones(size(x))];
coeffs_t = X_trend \ y;
a_t=coeffs_t(1); b_t=coeffs_t(2); c_t=coeffs_t(3); d_t=coeffs_t(4);
fprintf('Trend+Sine - a=%.6f, A=%.4f, phi=%.4f, d=%.4f\n', ...
    a_t, sqrt(b_t^2+c_t^2), atan2(c_t,b_t), d_t);


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
% ===== CURVA X per il plot =====

% Evaluate all models at the actual data points x (not x_range)
y_pol6_fit  = polyval(p, x, [], mu);
y_sine_fit  = a_s*sin(omega*x) + b_s*cos(omega*x) + C_s;
y_four_fit  = a1*sin(omega*x) + b1*cos(omega*x) + ...
              a2*sin(2*omega*x) + b2*cos(2*omega*x) + C_f;
y_trend_fit = a_t*x + b_t*sin(omega*x) + c_t*cos(omega*x) + d_t;

% R² and RMSE function
ss_tot = sum((y - mean(y)).^2);
r2   = @(y_fit) 1 - sum((y - y_fit).^2) / ss_tot;
rmse = @(y_fit) sqrt(mean((y - y_fit).^2));

% Print comparison table
fprintf('\n%-20s %8s %8s\n', 'Modello', 'R²', 'RMSE');
fprintf('%-20s %8.4f %8.4f\n', 'Pol. grado 6',  r2(y_pol6_fit),  rmse(y_pol6_fit));
fprintf('%-20s %8.4f %8.4f\n', 'Sine',          r2(y_sine_fit),  rmse(y_sine_fit));
fprintf('%-20s %8.4f %8.4f\n', 'Fourier',       r2(y_four_fit),  rmse(y_four_fit));
fprintf('%-20s %8.4f %8.4f\n', 'Trend+Sine',    r2(y_trend_fit), rmse(y_trend_fit));


% x_range = linspace(min(x), max(x), 2000)';
y_pol6  = polyval(p, x_range, [], mu);
y_trend = a_t*x_range + b_t*sin(omega*x_range) + c_t*cos(omega*x_range) + d_t;
y_sine  = a_s*sin(omega*x_range) + b_s*cos(omega*x_range) + C_s;
y_four  = a1*sin(omega*x_range)  + b1*cos(omega*x_range) + ...
          a2*sin(2*omega*x_range) + b2*cos(2*omega*x_range) + C_f;
%--------------------------------------%
figure('Name', 'Sunspot Cycle Fitting', 'NumberTitle', 'off');
plot(x, y, 'w.', 'MarkerSize', 3, 'DisplayName', 'Dati');
hold on;
plot(x_range, y_pol6, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Pol. grado 6');
plot(x_range, y_trend, 'g-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Trend + Sine: slope=%.5f', a_t));
plot(x_range, y_sine, 'm-', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Sine: A=%.2f, \\phi=%.2f, C=%.2f', A_s, phi_s, C_s));
plot(x_range, y_four, 'c-', 'LineWidth', 1.8, ...
    'DisplayName', 'Fourier 2 armoniche');
hold off;
legend('Location', 'northeast', 'FontSize', 9);
xlabel('Mesi dall''inizio del dataset (1749)');
ylabel('Numero medio di macchie solari');
title('Fitting ciclo delle macchie solari');
grid on;
box on;
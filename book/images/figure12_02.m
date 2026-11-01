% Draw Figure 12.2: flight of a baseball without drag (code/chap12/baseball.m).
% Run in Octave from book/images; writes figure12_02_new.eps.

set(0, 'defaultfigurevisible', 'off');
P = [0; 1]; V = [40; 30]; W = [P; V];
[T, M] = ode45(@(t, W) [W(3:4); 0; -9.8], [0 6], W);
X = M(:, 1); Y = M(:, 2);
f = figure('units', 'inches', 'position', [0 0 4.3 3.4]);
plot(T, X, 'color', [0.6 0.6 0.6], 'linewidth', 3); hold on
plot(T, Y, 'color', [0.1 0.1 0.1], 'linewidth', 3);
xlabel('Time (s)'); ylabel('Position (m)');
legend('X position', 'Y position', 'location', 'northwest');
set(gca, 'fontname', 'Helvetica', 'fontsize', 8, 'box', 'off', 'tickdir', 'out');
axis([0 6 0 250]);
set(f, 'paperunits', 'inches', 'paperposition', [0 0 4.3 3.4]);
print(f, 'figure12_02_new.eps', '-depsc', '-FHelvetica:8');
printf('max y %.1f at t %.2f; end (%.1f, %.1f)\n', max(Y), T(Y==max(Y)), X(end), Y(end));

function res = rats_plot(t, y)
    % plot(t, y, 'r.')
    plot(t, y, 'r.', 'MarkerSize', 10)
    res = rats(t, y);
end
% Draw a force diagram for a projectile with drag.

function diagram()
    clf; hold on

    blue = [0, 0.44, 0.74];
    orange = [0.85, 0.32, 0.1];

    xl = [-5, 5];
    yl = [-5, 5];
    draw_axes(xl, yl)

    O = [0 0];
    P = [3 4];
    draw_vector(O, P, 'P', 'Color', blue)

    xlim(xl)
    ylim(yl)
    hold off
    saveas(gcf, '../../book/figs/vector1.eps', 'epsc')

    clf; hold on

    xl = [-5, 5];
    yl = [-5, 5];
    draw_axes(xl, yl)

    O = [0 0];
    A = [2, 4];
    draw_vector(O, A, 'A', 'Color', blue)

    B = [2, -2];
    draw_vector(O, B, 'B', 'Color', blue)

    AB = A + B
    draw_vector(O, AB, 'A + B', 'Color', blue)

    draw_line(A, AB, ':', 'Color', orange)
    draw_line(B, AB, ':', 'Color', orange)

    xlim(xl)
    ylim(yl)
    hold off
    saveas(gcf, '../../book/figs/vector2.eps', 'epsc')

    clf; hold on

    xl = [-5, 5];
    yl = [-5, 5];
    draw_axes(xl, yl)

    O = [0 0];
    V = [4, 2];
    draw_vector(O, V, 'V', 'Color', blue)

    Vhat = hat(V);
%    draw_vector(O, Vhat, '', 'Color', 'blue', 'LineWidth', 2)
%    text(Vhat(1), Vhat(2), 'hat(V)', ...
%                    'FontSize', 12, ...
%                    'FontWeight', 'bold', ...
%                    'Color', 'blue', ...
%                    'VerticalAlignment', 'bottom', ...
%                    'HorizontalAlignment', 'right')

    D = - Vhat * 2
    draw_vector(O, D, '', 'Color', blue)
    text(D(1), D(2), 'D', ...
                    'FontSize', 12, ...
                    'FontWeight', 'bold', ...
                    'Color', blue, ...
                    'HorizontalAlignment', 'right')

    G = [0 -3]
    draw_vector(O, G, 'G', 'Color', blue)

    A = D+G
    draw_vector(O, A, '', 'Color', orange)
    text(A(1), A(2), 'A', ...
                    'FontSize', 12, ...
                    'FontWeight', 'bold', ...
                    'Color', orange, ...
                    'HorizontalAlignment', 'right')


    xlim(xl)
    ylim(yl)
    hold off
    saveas(gcf, '../../book/figs/vector3.eps', 'epsc')

end

function res = hat(V)
    res = V / norm(V)
end

function res = perp(V)
    res = [-V(2) V(1)]
end

function draw_vector(A, B, label, varargin)
    blue = [0, 0.44, 0.74];

    draw_line(A, B, varargin{:})

    V = B - A
    h = 0.08 * V
    p = perp(h) / 2

    draw_line(B, B-h + p, varargin{:})
    draw_line(B, B-h - p, varargin{:})

    T = B + h
    text(T(1), T(2), label, ...
                    'FontSize', 12, ...
                    'FontWeight', 'bold', ...
                    'Color', blue, ...
                    'HorizontalAlignment', 'left')
end

function draw_line(V, W, varargin)
    xs = [V(1), W(1)];
    ys = [V(2), W(2)];

    plot(xs, ys, varargin{:})
end

function draw_axes(xl, yl)
    plot(xl, [0 0], 'k:')
    plot([0 0], yl, 'k:')
end

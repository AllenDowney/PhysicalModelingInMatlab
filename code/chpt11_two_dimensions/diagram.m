function diagram()
    clf; hold on
    
    xl = [-5, 5];
    yl = [-5, 5];
    draw_axes(xl, yl)
    
    O = [0 0];
    P = [3 4];
    draw_vector(O, P, 'b-')
    
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
    draw_vector(O, A, 'A', 'b-')
    
    B = [2, -2];
    draw_vector(O, B, 'B', 'b-')
    
    AB = A + B
    draw_vector(O, AB, 'A + B', 'b-')

    draw_line(A, AB, 'r:')
    draw_line(B, AB, 'r:')
    
    xlim(xl)
    ylim(yl)
    hold off
    saveas(gcf, '../../book/figs/vector2.eps', 'epsc')

end

function res = hat(V)
    res = V / norm(V)
end

function res = perp(V)
    res = [-V(2) V(1)]
end

function draw_vector(A, B, label, varargin)
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
                    'Color', 'blue', ...
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
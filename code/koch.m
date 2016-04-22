function koch ()
    clf; axis equal
    title 'quadric Koch curve by Allen'

    subplot(2,2,1)
    koch_square (1)
    
    subplot (2,2,2)
    koch_square (2)
    
    subplot (2,2,3)
    koch_square (3)
    
    subplot (2,2,4)
    koch_square (4)
    
function koch_square (n)
    v1 = [0,0];
    v2 = [1,0];
    v3 = [1,1];
    v4 = [0,1];
    
    draw_koch (v1, v2, n)
    draw_koch (v2, v3, n)
    draw_koch (v3, v4, n)
    draw_koch (v4, v1, n)
    
function draw_koch (v1, v2, n)
    v = v2 - v1;
    length = norm (v);

    if n == 0
        drawline (v1, v2);
        return
    end
    
    p1  = v1 + v / 3;
    p2  = v1 + 2 * v / 3;
    
    height = length/3 / sqrt(2);
    p3 = p1 + height * normalize (perp (v));
    p4 = p2 - height * normalize (perp (v));
    
    draw_koch (v1, p1, n-1);
    draw_koch (p1, p3, n-1);
    draw_koch (p3, p4, n-1);
    draw_koch (p4, p2, n-1);
    draw_koch (p2, v2, n-1);


function vp = perp (v)
    vp = [-v(2), v(1)];
    
function vn = normalize (v)
    vn = v / norm (v);
    
function drawline (v1, v2)
    z = [v1;v2];
    line (z(:,1), z(:,2))

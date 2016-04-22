function dXdt = f(t, X)
x = X(1);      
y = X(2);      
vx = X(3)
vy = X(4);

ax = fx(t, x, y, vx, vy)
ay = fy(t, x, y, vx, vy)
                          
dXdt = [vx; vy; ax; ay];
end

function a = fx(t, x, y, vx, vy)
a = 0
end

function a = fy(t, x, y, vx, vy)
a = -9.8
end

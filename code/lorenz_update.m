xnew = x + sigma * (y - x) * dt;
ynew = y + (x * (r - z) - y) * dt;
znew = z + (x*y - b*z) * dt;
x = xnew;
y = ynew;
z = znew;
    


% stephani gulbrandsen

a=0.9;
deltat=1;
N(1)=100;
B=[0.007, 0.0036, 0.0011, 0.0001, 0.0004, 0.0013, 0.0028, 0.0043, 0.0056];

for i=2:9
    N(i)=N(i-1)+(a*N(i-1)-B(i-1).*N(i-1)^1.7)*deltat;
end
N

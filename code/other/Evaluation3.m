av=zeros(10,1);
bv=zeros(10,1);
av(1)=200;
bv(1)=100;
for i=2:10;
    froma=round(0.03*av(i-1));
    fromb=round(0.05*bv(i-1));
    a=av(i-1)-froma+fromb;
    b=bv(i-1)-fromb+froma;
    av(i)=a;
    bv(i)=b;
end
[av bv]

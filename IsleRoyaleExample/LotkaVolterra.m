function DeltaY = LotkaVolterra(Y,a,b)
    R=Y(1);
    F=Y(2);
    DeltaR=a*(1-F).*R
    DeltaF=b*(R-1).*F
    DeltaY=[DeltaR; DeltaF]
end
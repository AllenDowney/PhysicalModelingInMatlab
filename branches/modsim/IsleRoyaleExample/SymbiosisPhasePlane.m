function SymbiosisPhasePlane(a,b,c,d)
close
[R,F]=meshgrid([0.1:0.15:5]);
[DeltaR,DeltaF] = LVEqs(R,F);
quiver(R,F,DeltaR,DeltaF,2,'k')
set(gca,'Box','off')
set(gca,'LineWidth',1.5)
set(gca,'XTick',[0 1 2])
set(gca,'YTick',[0 1 2])
hold on;
ylabel('Clown Fish Population','FontSize',16)
xlabel('Anenome Population','FontSize',16)
%axis([0 2.2 0 2.2])
figure


[ct,h]=contour(R,F,DeltaR)
clabel(ct,h)
ylabel('Clown Fish Population','FontSize',16)
xlabel('Anenome Population','FontSize',16)
title('\Delta A','FontSize',16)
figure

[ct,h]=contour(R,F,DeltaF)
clabel(ct,h)
ylabel('Clown Fish Population','FontSize',16)
xlabel('Anenome Population','FontSize',16)
title('\Delta C','FontSize',16)
    function [DeltaR,DeltaF] = LVEqs(R,F)
        DeltaR=a*(F-c*R-1).*R;
        DeltaF=b*(R-d*F-1).*F;
    end
end
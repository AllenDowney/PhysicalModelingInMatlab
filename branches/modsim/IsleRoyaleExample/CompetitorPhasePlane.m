function CompetitorPhasePlane(a,b,CC,w)
close
[R,F]=meshgrid([0.1:0.1:2]);
[DeltaR,DeltaF] = LVEqs(R,F);
quiver(R,F,DeltaR,DeltaF,2,'k')
set(gca,'Box','off')
set(gca,'LineWidth',1.5)
set(gca,'XTick',[0 1 2])
set(gca,'YTick',[0 1 2])
hold on;
xlabel('Rabbits','FontSize',16)
ylabel('Woodchucks','FontSize',16)
%axis([0 2.2 0 2.2])
figure


[ct,h]=contour(R,F,DeltaR,10)
clabel(ct,h)
xlabel('Rabbits','FontSize',16)
ylabel('Woodchucks','FontSize',16)
title('\Delta R','FontSize',16)
figure

[ct,h]=contour(R,F,DeltaF,10)
clabel(ct,h)
xlabel('Rabbits','FontSize',16)
ylabel('Woodchucks','FontSize',16)
title('\Delta W','FontSize',16)
    function [DeltaR,DeltaF] = LVEqs(R,F)
        DeltaR=a*(1-(R+w*F)/CC).*R;
        DeltaF=b*(1-(R+w*F)/CC).*F;
    end
end
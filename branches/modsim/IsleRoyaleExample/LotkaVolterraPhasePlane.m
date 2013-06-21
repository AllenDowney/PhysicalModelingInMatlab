function LotkaVolterraPhasePlane(a,b)
close
[R,F]=meshgrid([0.1:0.3:2]);
[DeltaR,DeltaF] = LVEqs(R,F);
quiver(R,F,DeltaR,DeltaF,'k','LineWidth',1.5)
set(gca,'Box','off')
set(gca,'LineWidth',1.5)
set(gca,'XTick',[0 1 2])
set(gca,'YTick',[0 1 2])
hold on;
xlabel('Rabbit Population (R/R_c)','FontSize',16)
ylabel('Fox Population (F/F_c)','FontSize',16)
axis([0 2.2 0 2.2])

%contour(R,F,DeltaR)
%contour(R,F,DeltaF)

    function [DeltaR,DeltaF] = LVEqs(R,F)
        DeltaR=a*(1-F).*R;
        DeltaF=b*(R-1).*F;
    end
end
clf; hold on
p = 100     % yeast population in billions

for i=1:6
    plot(i, p, 'ro')
    p = 2 * p
end

axis([0.9 6.1 0 3500])
set(gca,'XTick',[0 1 2 3 4 5 6])
xlabel('# generations')
ylabel('# cells (billions)')

saveas(gca,'yeast1.eps')

set(gca, 'yscale', 'log')
saveas(gca,'yeast2.eps')

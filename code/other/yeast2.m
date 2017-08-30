clf; hold on
p = 100         % yeast population in billions
s = 3000        % stock of sugar in g
factor = 0.01   % grams of sugar to create a new cell
factor = 1e-13

for i=1:50
    plot(i, p, 'ro')
    consumed = min(p * factor, s);
    s = s - consumed
    p = p + consumed / factor
end

%axis([0.9 6.1 0 3500])
%set(gca,'XTick',[0 1 2 3 4 5 6])
xlabel('# generations')
ylabel('# cells (billions)')
set(gca, 'yscale', 'log')
saveas(gca,'yeast3.eps')

function [] = PlotPortHist( port, age, portname, policyname)
BINS = 12;
PLOT_YEARS = [ 60 65 68 70 75 ];
PLOT_INDEX = PLOT_YEARS - age + 1;

figure;
annotation('textbox', [0 0.9 1 0.1], ...
    'String', policyname, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')

subplot(3,2,1);
hist(port(PLOT_INDEX(1),:),BINS);
title(strcat(portname,' Histogram  ', num2str(PLOT_YEARS(1))));
xlabel('Portfolio Value');
subplot(3,2,2);
hist(port(PLOT_INDEX(2),:),BINS);
title(strcat(portname,' Histogram  ', num2str(PLOT_YEARS(2))));
xlabel('Portfolio Value');
subplot(3,2,[3 4]);
hist(port(PLOT_INDEX(3),:),BINS);
title(strcat(portname,' Histogram  ', num2str(PLOT_YEARS(3))));
xlabel('Portfolio Value');
subplot(3,2,5);
hist(port(PLOT_INDEX(4),:),BINS);
title(strcat(portname,' Histogram  ', num2str(PLOT_YEARS(4))));
xlabel('Portfolio Value');
subplot(3,2,6);
hist(port(PLOT_INDEX(5),:),BINS);
title(strcat(portname,' Histogram  ', num2str(PLOT_YEARS(5))));
xlabel('Portfolio Value');
end


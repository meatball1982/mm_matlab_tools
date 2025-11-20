function [h]=fun_plot_batch(x,dat,col_mm,col_mm_edge)

min_lin = min(dat');
max_lin = max(dat');
mean_lin = mean(dat');

n_layer = 20;

del_up = max_lin - mean_lin;
del_down = mean_lin -min_lin;

% size(del_up)
% size(del_down)

alphas = linspace(0.9, 0.05, n_layer);   % 透明度

for i = 1:n_layer
    rat1 =     i/n_layer;
    rat2 = (i-1)/n_layer;
    
    up_y1 = mean_lin  + rat1 * del_up;
    up_y2 = mean_lin  + rat2 * del_up;
    
    low_y1 = mean_lin - rat1 * del_down;
    low_y2 = mean_lin - rat2 * del_down;
    
     x_lin = [x;flipud(x)];
     y1_lin = [up_y1'; flipud(up_y2')];
    y2_lin = [low_y1'; flipud(low_y2')];
    
    patch (x_lin,y1_lin,...
        col_mm,'FaceAlpha',alphas(i),'edgecolor','none');
    
    patch (x_lin,y2_lin,...
        col_mm,'FaceAlpha',alphas(i),'edgecolor','none');

    
end

h=gcf;
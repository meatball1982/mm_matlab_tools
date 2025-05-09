function [h]=fun_mm_plot_patch(x0,x1,y0,y1,col);

x=[x0 x1 x1 x0 x0];
y=[y0 y0 y1 y1 y0];

h=patch(x,y,col);
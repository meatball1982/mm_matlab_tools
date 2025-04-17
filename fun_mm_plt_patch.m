function [ha]=fun_mm_plt_patch(S,locb,col_mm)

hold on
for i = 1:length(S)
    x_lin = S(i).xdata;
    y_lin = S(i).ydata;
% %     h=patch(x_lin,y_lin,z_lin,col_mm(locb(i),:),...
% %                                          'edgecolor',col_mm(locb(i),:)); % no transpancy
    h=patch(x_lin,y_lin,col_mm(locb(i),:),...
                             'edgecolor',col_mm(locb(i),:),...
                             'facealpha',0.05*locb(i)); % transpancy

%     plot(x_lin,y_lin,'color',col_mm(locb(i),:),'linewidth',2)
end

colormap(col_mm)
hidden off
grid on
box on
ha=gca;
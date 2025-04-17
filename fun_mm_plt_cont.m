function [h]=fun_mm_plt_cont(S,locb,col_mm)

hold on
for i = 1:length(S)
    x_lin = S(i).xdata;
    y_lin = S(i).ydata;
% %     h=patch(x_lin,y_lin,z_lin,col_mm(locb(i),:),...
% %                                          'edgecolor',col_mm(locb(i),:)); % no transpancy
% %     h=patch(x_lin,y_lin,z_lin,col_mm(locb(i),:),...
% %                                           'edgecolor',col_mm(locb(i),:),...
% %                                           'facealpha',alp_va); % transpancy

    plot(x_lin,y_lin,'color',col_mm(locb(i),:),'linewidth',2)
end


hidden off
grid on
box on
h=gcf;
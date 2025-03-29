function [h]=fun_mm_bar_color(hi_va,hi_bi,col_mm)
% 
% % [h]=fun_mm_bar_color(hi_va,hi_bi,col_mm)
% 
%
% a=randn(5000,1);
% [hi_va,hi_bi]=hist(a,linspace(-4,4,40));
% col_mm= jet(100);
% [h]=fun_mm_bar_color(hi_va,hi_bi,col_mm)


n_col=length(col_mm(:,1));
n_bar= length(hi_va);
hi_max= max(hi_va);


% plot bar each time
hold on
for i =1:n_bar

    ind_col = floor((n_col-1)*hi_va(i)/hi_max)+1; % connect hi_va and colormap
    bar(hi_bi(i),hi_va(i),'edgecolor','none',...
        'facecolor',col_mm(ind_col,:),...
        'barwidth',0.2);

end

% other setting
colormap(col_mm)
caxis([0 hi_max])
colorbar
box on
grid on

h=gcf;

hold off
% clf





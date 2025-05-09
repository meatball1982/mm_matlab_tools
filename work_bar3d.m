clear all
clc
clf
close all


dat = [0.3	2.8	9.0	16.6	15.7	19.6	13.8	8.7	5.7	3.9	1.7	1.1	0.5	0.5	0.0	0.2	0.0
0.6	3.2	9.1	14.6	18.3	16.0	14.2	9.6	6.8	2.9	2.2	0.8	0.9	0.2	0.3	0.2	0.1
0.2	3.4	6.4	12.1	16.2	16.1	13.7	11.4	8.7	5.3	3.2	1.4	0.8	0.6	0.4	0.1	0.1];

[m,n]=size(dat)

% m=3;
% n=17;

X = repmat([1:n],[m,1])';
Y = repmat([1:m],[n,1]);
Z = dat';

X_lin = X(:);
Y_lin = Y(:);
Z_lin = Z(:);


h=figure(1)
set(h, 'Position', [100, 100, 1000, 400]);
hold on
scatterbar3(X_lin,Y_lin,Z_lin,0.64)
colormap(jet)
caxis([0 20])
for i = 1: length(X_lin)
    text(X_lin(i),Y_lin(i)+0.1,Z_lin(i)+0.3,[num2str(Z_lin(i),'%.1f')],'fontsize',14);
end
axis tight
view(-24,70)
% view(150,67)
grid on
box on
set(gca,'xtick',[1:n],'ytick',[1:m],'yticklabel',{'Cluster 1','Cluster2','Cluster 3'},'fontsize',14);
axis([0 18 0.5 3.5 0 20])

fi_na = '../../file_imgs/fig_plt_bar3d';
% fun_work_li_035_myfig_out(h,fi_na,3);


h2 = figure(2)
set(h2, 'Position', [1050, 100, 300, 200]);
axis off
caxis([0,20])
colormap(jet)
hc=colorbar
set(hc,'fontsize',14);
fi_na = '../../file_imgs/fig_plt_bar3d_colorbar';
% fun_work_li_035_myfig_out(h2,fi_na,3);







% colorbar
% hold on
% for i = 1:n
%     plot3(X(i,:),Y(i,:),Z(i,:),'o-','linewidth',2)
%     
% end
clear all
clc
clf
%% outline
% plot bar with multi colormap

%% main
dat = [  46.4000   29.2000   16.2000    35.6000    2.7000
   25.6000   40.6000   19.1000   14.1000   42.6000
   14.0000   19.3000   43.4000   17.6000   24.6000];

n_col = 50;
col_mat{1}=jet(n_col);
col_mat{2}=spring(n_col);
col_mat{3}=flipud(summer(n_col));
col_mat{4}=flipud(autumn(n_col));
col_mat{5}=flipud(winter(n_col));

shift_lin =[0 6 12];

h=figure(1)
set(h, 'Position', [100, 100, 300, 200]);

for k = 1:3
    shif = shift_lin(k);
    
    for j = 1:5
        y0=-1;
        x0 = shif + j - 0.4;
        x1 = shif + j + 0.4;
        
        col_clu=col_mat{j};
        
        for i = 1:ceil(dat(k,j))
        col_mm= col_clu(i,:);    
              
        y0 = y0+1;
        y1 = y0+1;
        
        [h]=fun_mm_plot_patch(x0,x1,y0,y1,col_mm);    
        end
        
        text(x0,y1+1.6,mat2str(dat(k,j)),'fontsize',6)
        
    end
end

box on
set(gca,'fontsize',12,'linewidth',1,...
    'xtick',[3 9 15],'xticklabel',{'Cluster1','Cluster2','Cluster3'})
ylabel('ylabel')

title('bar with multi colormap');
 
ylim([0 55])
xlim([0 18])
h=gcf;
fi_na = './fig_bar_multi_colormap';
fun_work_li_035_myfig_out(h,fi_na,3);

% h=gcf;
% fi_na = '../file_imgs/fig_05_B_multi_bar';
% fun_work_li_035_myfig_out(h,fi_na,3);

%% output legend
% figure(2)
% hold on
% x_patch = [1 3 3 1];
% y_patch = [0 0 1 1];
% for i = 1:5
%     col_clu=col_mat{i};
%     patch(x_patch,y_patch+i,col_clu(1,:))
% end
% plot([1:5],zeros(5,1),'-');
% plot(zeros(5,1),[1:5],'-');
% legend({'0','1','2','3','>=4'},'box','off','fontsize',20)
% h=gcf;
% fi_na = '../file_imgs/fig_05_C_legend';
% fun_work_li_035_myfig_out(h,fi_na,3);



% h1=subplot(2,2,1)
% col_mm1 = fun_mm_pycm('tab20b',10);
% colormap(h1,col_mm1)
% colorbar
% 
% h2=subplot(2,2,2)
% col_mm2 = fun_mm_pycm('tab20c',10);
% colormap(h2,col_mm2)
% colorbar
% 
% h3=subplot(2,2,3)
% col_mm3 = col_mm1(1:8,:);
% col_mm3 = [col_mm3;col_mm2(9:10,:)];
% colormap(h3,col_mm3)
% colorbar

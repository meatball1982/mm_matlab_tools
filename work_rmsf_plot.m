clear all
clc
clf

%% outline

%% main
n_cmp=8;
nam='Pastel1';
[col_mm]=fun_mm_pycm(nam,n_cmp);
col_mm = col_mm-0.1;
[col_mm_edge]=fun_mm_pycm('Set1',n_cmp);
col_mm_edge = col_mm_edge-0.1;


tm =load('./txt_rmsf_example.txt');
x = tm(:,1);
rmsf= tm(:,2:end);
hold on

h=figure(1)
set(h, 'Position', [100, 100, 260, 240]);

[h]=fun_plot_batch(x,rmsf,col_mm_edge(2,:),col_mm_edge(2,:));
for i = 1:length(rmsf(1,:))
    plot(x,rmsf(:,i),'color',col_mm_edge(2,:),'linewidth',0.1);
end
plot(x,mean(rmsf'),'color','k','linewidth',1.4);
plot(x,min(rmsf'),'color',col_mm(2,:),'linewidth',0.5)
plot(x,max(rmsf'),'color',col_mm(2,:),'linewidth',0.5)
grid on
set(gca,'GridLineStyle',':','GridAlpha',0.2)

axis tight
box on

set(gca,'fontsize',12,'linewidth',1.6)

h=gcf;
fi_na='./fig_rmsf_small';
fun_work_li_035_myfig_out(h,fi_na,3);


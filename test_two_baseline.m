clear all
clc
clf


y1 = randn(1000,1);
y2 = randn(800,1);

hi_va1 = hist(y1,20);
hi_va1 = hi_va1./sum(hi_va1);

hi_va2 = hist(y2,18);
hi_va2 = hi_va2./sum(hi_va2)+0.3;

x1 = [1:20];
x2 = [11:28];


blv1 = 0.00;
blv2 = 0.3;

ymax=0.5;% 4 plot
col_mm = jet(100);


subplot(2,2,1)
plot(x1,hi_va1,'r-');
hold on 
plot(x2,hi_va2,'g-');
axis([-1 30 -0.1 0.5])
title('Original data');



subplot(2,2,2)
hb1 = bar(x1,hi_va1);
hold on
hb2 = bar(x2,hi_va2);
set(hb1,'Basevalue',blv1,'Facecolor','r');
set(hb2,'Basevalue',blv2,'Facecolor','g');
axis([-1 30 -0.1 0.5])
title('Original Bar')

subplot(2,2,3)
hold on
[hbar_va1]=fun_mm_bar_baseline(x1,hi_va1,blv1,0.8,ymax,col_mm);
[hbar_va2]=fun_mm_bar_baseline(x2,hi_va2,blv2,0.8,ymax,col_mm);
box on
axis([-1 30 -0.1 0.5])
caxis([0 ymax])
colormap(col_mm)
colorbar
title('mm function bar')

h=gcf;
fi_na='./fig_mm_bar_diff_base_line';
% fun_work_li_035_myfig_out(h,fi_na,3)

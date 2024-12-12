clear all
clc
clf

x1 = randn(1000,1);
x2 = randn(800,1);

hi_va1 = hist(x1,20);
hi_va1 = hi_va1./sum(hi_va1);

hi_va2 = hist(x2,18);
hi_va2 = hi_va2./sum(hi_va2)+0.3;

y1 = [1:20];
y2 = [11:28];

blv1 = 0.00;
blv2 = 0.3;

pl_ymax=0.5;% 4 plot
pl_xmax=0.5;
col_mm = jet(100);

subplot(2,3,1)
plot(y1,hi_va1,'b-');
hold on 
plot(y2,hi_va2,'r-');
axis([-1 30 -0.1 0.5  ])
title('Original data');

subplot(2,3,2)
hb1 = bar(y1,hi_va1);
hold on
hb2 = bar(y2,hi_va2);
set(hb1,'Basevalue',blv1,'Facecolor','b');
set(hb2,'Basevalue',blv2,'Facecolor','r');
axis([-1 30 -0.1 0.5])
title('Original Bar')

subplot(2,3,3)
hold on
[hbar_va1]=fun_mm_bar_baseline(y1,hi_va1,blv1,0.5,pl_ymax,col_mm);
[hbar_va2]=fun_mm_bar_baseline(y2,hi_va2,blv2,0.5,pl_ymax,col_mm);
box on
axis([-1 30 -0.1 0.5])
caxis([0 pl_ymax])
colormap(col_mm)
% colorbar
title('mm function bar')

subplot(2,3,4)
plot(hi_va1,y1,'b-');
hold on 
plot(hi_va2,y2,'r-');
axis([-0.1 0.5 -1 30   ])
title('Original data H');

subplot(2,3,5)
hb1 = barh(y1,hi_va1);
hold on
hb2 = barh(y2,hi_va2);
set(hb1,'Basevalue',blv1,'Facecolor','b');
set(hb2,'Basevalue',blv2,'Facecolor','r');
% axis([-1 30 -0.1 0.5])
title('Original Barh')


subplot(2,3,6)
hold on
[hbar_va1]=fun_mm_barh_baseline(hi_va1,y1,blv1,0.5,pl_xmax,col_mm);
[hbar_va2]=fun_mm_barh_baseline(hi_va2,y2,blv2,0.5,pl_xmax,col_mm);
box on
axis([-0.1 0.5 -1 30 ])
caxis([0 pl_xmax])
colormap(col_mm)
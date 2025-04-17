clear all
clc
close all


[x1,y1,z1]=peaks(30);
z1 = abs(z1);

x2 = 3+y1 ; 
y2 = x1 ;
z2 = 0.6*z1;

n_line1 = 5;
n_line2 = 8;

col1 = flipud(cool(n_line1));
col2 = flipud(summer(n_line2));

[S1,s_lev1,locb1]=fun_mm_draw_cont_line(x1,y1,z1,n_line1);
[S2,s_lev2,locb2]=fun_mm_draw_cont_line(x2,y2,z2,n_line2);

h1=figure(1)
set(h1, 'Position', [100, 100, 500, 300]);
[h11]=fun_mm_plt_cont(S1,locb1,col1);
[h12]=fun_mm_plt_cont(S2,locb2,col2);

fi_na1 = './fig_cont_1_2';
% fun_work_li_035_myfig_out(h1,fi_na1,3)

h2=figure(2)
set(h2, 'Position', [600, 100, 500, 300]);
[ha11]=fun_mm_plt_patch(S1,locb1,col1); 
[ha12]=fun_mm_plt_patch(S2,locb2,col2);
fi_na2 = './fig_patch_1_2';
% fun_work_li_035_myfig_out(h2,fi_na2,3)


h3=figure(3)
set(h3, 'Position', [100, 600, 500, 300]);
% [ha1]=fun_mm_plt_patch(S1,locb1,col1); 
[ha32]=fun_mm_plt_patch(S2,locb2,col2);
[h31]=fun_mm_plt_cont(S1,locb1,col1);
fi_na3 = './fig_pc_1_2';
% fun_work_li_035_myfig_out(h3,fi_na3,3)


h4=figure(4)
contourf(x1,y1,z1,n_line1)
legend('I am cool','location','eastoutside','box','off')
colormap(col1)
colorbar
% fi_na4 = './fig_colorbar_1';
% fun_work_li_035_myfig_out(h4,fi_na4,3)

h5=figure(5)
contourf(x2,y2,z2,n_line2)
legend('I am autumn','location','eastoutside','box','off')
colormap(col2)
colorbar
% fi_na5 = './fig_colorbar_2';
% fun_work_li_035_myfig_out(h5,fi_na5,3)


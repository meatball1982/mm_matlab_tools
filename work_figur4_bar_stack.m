clear all
clc
close all

col_mm = fun_mm_pycm('tab20c',10);
col_any = fun_mm_pycm('tab20b',10);

col_clu1_mod = fun_mm_gen_colormap(col_mm(1:2,:),5);
col_clu2_mod = fun_mm_gen_colormap(col_mm(3:4,:),5);
col_clu3_mod = fun_mm_gen_colormap(col_mm(5:6,:),5);

col_clu1_any = fun_mm_gen_colormap(col_any(1:2,:),5);
col_clu2_any = fun_mm_gen_colormap(col_any(7:8,:),5);
col_clu3_any = fun_mm_gen_colormap(col_any(3:4,:),5);

col_mat{1} = col_clu1_mod;
col_mat{2} = col_clu1_any;
col_mat{3} = col_clu2_mod;
col_mat{4} = col_clu2_any;
col_mat{5} = col_clu3_mod;
col_mat{6} = col_clu3_any;


mod=[39.9	27.3	19.7	7.6	5.4
40.3	28.3	16.2	8.9	6.2
37.0	24.9	16.9	10.3	10.9];

any=[45.2	29.3	15.4	6.5	3.6
47.7	25.0	15.3	7.7	4.2
37.5	26.9	16.2	9.5	9.9];


tm([1:2:5],:)=mod;
tm([2:2:6],:)=any;

h=figure(1)
set(h, 'Position', [100, 100, 500, 700]);
for i =1:6
    tm2 = cumsum(tm(i,:));
    dat = [0 tm2(1:end-1) 100];

    Y = dat;
    
    col_mm = col_mat{i};
    for j = 1:5
        x0 = i-0.45;
        x1 = i+0.45;
        y0 = dat(j);
        y1 = dat(j+1);
        col=col_mm(j,:);
        [h]=fun_mm_plot_patch(x0,x1,y0,y1,col);
        text((x0+x1)/2-0.2,(y0+y1)/2,num2str(tm(i,j),'%3.1f'),'fontsize',14);
    end

    
end

% mm_xticlabel={'Cluster 1 Modern','Cluster 1 Any',...
%               'Cluster 2 Modern','Cluster 2 Any',...
%               'Cluster 3 Modern','Cluster 3 Any'};
          
mm_xticlabel={'Modern','Any',...
              'Modern','Any',...
              'Modern','Any'};
text(1.1,103,'Cluster1','fontsize',16);
text(3.1,103,'Cluster2','fontsize',16);
text(5.1,103,'Cluster3','fontsize',16);


text( 0.2,20,'0','fontsize',20)
text( 0.2,53,'1','fontsize',20)
text( 0.2,78,'2','fontsize',20)
text( 0.2,90,'3','fontsize',20)
text(-0.1,97,'>=4','fontsize',20)



set(gca,'yticklabel',{},'xtick',[1:6],'xticklabel',mm_xticlabel,'fontsize',16,'linewidth',2)
view(0,90)
axis tight
box on



fi_na = '../file_imgs/fig_plt_mod_any_med';
% fun_work_li_035_myfig_out(h,fi_na,3);




% h1 = subplot(2,4,1);
% colormap(h1,col_mm);
% colorbar;
% 
% h2=subplot(2,4,2);
% colormap(h2,col_clu1_mod);
% colorbar;
% 
% h3=subplot(2,4,3);
% colormap(h3,col_clu2_mod);
% colorbar;
% 
% h4=subplot(2,4,4);
% colormap(h4,col_clu3_mod);
% colorbar;
% 
% h5 = subplot(2,4,5);
% colormap(h5,col_any);
% colorbar;
% 
% h6=subplot(2,4,6);
% colormap(h6,col_clu1_any);
% colorbar;
% h7=subplot(2,4,7);
% colormap(h7,col_clu2_any);
% colorbar;
% h8=subplot(2,4,8);
% colormap(h8,col_clu3_any);
% colorbar;

% 
% 
% % RC=RC.draw();
% % 
% % for i=1:RC.ClassNum
% %     ind_edge = (i-1)*4+1;
% %     ind_face = (i-1)*4+2;
% %     RC.setPatchN(i,'FaceColor',col_mm(ind_face,:),...
% %                    'EdgeColor',col_mm(ind_edge,:))
% % end


function [h]=fun_mm_plot_string(dataMat,colName,rowName,Col_color,Row_color);

figure('Units','normalized','Position',[.02,.05,.47,.4])

CC=chordChart(dataMat,'rowName',rowName,'colName',colName,'Sep',1/80);
CC=CC.draw();

CListT=Col_color;
    
[m,n]=size(dataMat);

for i=1:n
    CC.setSquareT_N(i,'FaceColor',CListT(i,:))
end
CListF=Row_color;

for i=1:m
    CC.setSquareF_N(i,'FaceColor',CListF(i,:))
end
% 修改弦颜色(Modify chord color)
for i=1:n
    for j=1:m
        CC.setChordMN(j,i,'FaceColor',CListT(i,:),'FaceAlpha',.3)
    end
end

CC.tickState('on')
CC.labelRotate('on')
CC.setFont('FontSize',12,'FontName','Cambria')
CC.tickLabelState('on')
CC.setTickFont('Color',[0,0,.8],'FontName','Cambria')

for i = 1:size(dataMat,1)
     scatterHdl(i) = scatter(10.*ones(size(dataMat,1),1),10.*ones(size(dataMat,1),1),155, 'filled');
end
for i = 1:length(scatterHdl)
     scatterHdl(i).CData = CListF(i,:);
end
lgdHdl = legend(scatterHdl, rowName, 'Location','best', 'FontSize',12, 'FontName','Cambria', 'Box','off');
set(lgdHdl, 'Position',[.6882,.3577,.1658,.3254])

h=gcf;

% for i = 1:size(dataMat,2)
%      scatterHdr(i) = scatter(10.*ones(size(dataMat,2),1),10.*ones(size(dataMat,2),1),155, 'filled');
% end
% for i = 1:length(scatterHdr)
%      scatterHdr(i).CData = CListT(i,:);
% end
% lgdHdr = legend(scatterHdr, rowName, 'Location','best', 'FontSize',16, 'FontName','Cambria', 'Box','off');
% set(lgdHdr, 'Position',[.782,.3577,.1658,.3254])

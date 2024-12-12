function [h]=fun_mm_barh_baseline(x,y,baselinevalue,width,x_max,col_mm);
% [h]=fun_mm_barh_baseline(x,y,baselinevalue,width,x_max,col_mm)
% Inputs
% x : x 
% y : y 
% baselinevalue : the bottom line value
% width : the wdith of the bar
% y_max : the y max of the plot
% col_mm : the color, with this color, the bar is colored by hist value
% 
% example : 
% 
% y = randn(1000,1);
% hi_va = hist(y,20);
% hi_va = hi_va./sum(hi_va);
% x = [11:30];
% blv = -0.02;
% wid  = 0.8;
% ymax=0.5;% 4 plot
% col_mm = jet(100);
% [hbar_va1]=fun_mm_barh_baseline(x,hi_va,blv,wid,xmax,col_mm);

%% 
blv = baselinevalue;

n = length(x);

[rx,cx]=size(x);
if rx==1;
   x=x';
end

[ry,cy]=size(y);
if ry==1;
   y=y';
end

n_col = length(col_mm(:,1));

X1 = blv *ones(size(x));
X2 = x;
Y1 = y-0.5*width;
Y2 = y+0.5*width;

% X1 = x-0.5*width;
% X2 = x+0.5*width;
% Y1 = blv *ones(size(x));
% Y2 = y;
% Y2

XL = [X1 X2 X2 X1 X1];
YL = [Y1 Y1 Y2 Y2 Y1];


hold on
for i = 1:n
% for i = 1:1
    xlin = XL(i,:);
    ylin = YL(i,:);

    ind_col = floor((n_col-1)*x(i)/x_max)+1; 
%     ind_col
    patch(xlin,ylin,col_mm(ind_col,:));
%     patch(xlin,ylin,'r')
end


% hold on
% for i = 1:n
%     xlin = [X1(i) X2(i) X2(i) X1(i) X1(i)];
%     ylin = [Y1(i) Y1(i) Y2(i) Y2(i) Y1(i)];
%     patch(xlin,ylin,col)
% end

h=gcf;
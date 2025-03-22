function [col]=fun_mm_gen_colormap(Col,num_lin)
%
% Col=[1 0 0
%  1 1 0
%  0 1 1
%  0 0 1];
% 
% num_lin[5,10,20];
% 
% [col]=fun_mm_gen_colormap(Col,num_lin)
% peaks(30)
% colormap(col)
% colorbar

%% main
% [col]=fun_mm_gen_colormap(Col,num_lin)

n_col = length(Col(:,1));
n_lin = length(num_lin);

col =[];
if (n_col-1 )== n_lin
    for i = 1: n_lin
    startColor = Col(i,:);
    endColor   = Col(i+1,:);
    numColors  = num_lin(i);
    colormapValues = [linspace(startColor(1), endColor(1), numColors)', ...
                      linspace(startColor(2), endColor(2), numColors)', ...
                      linspace(startColor(3), endColor(3), numColors)'];
    colormapValues(end,:)=[];
    col = [col;colormapValues];
    end
end

col =[col;Col(end,:)];

% 创建 colormap
% customColormap = colormapValues;
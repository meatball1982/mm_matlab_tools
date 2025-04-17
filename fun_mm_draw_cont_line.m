function [S,s_lev,locb]=fun_mm_draw_cont_line(x,y,z,n)

[C,h]=contourf(x,y,z,n);

% get the structure, close the contour
S=contourdata(C);

for i = 1: length(S)
    s_lev(i,1)=S(i).level;
end

tm_s = unique(s_lev);
% n_col = length(tm_s);
[loca,locb]=ismember(s_lev,tm_s); % get the lin color position in col_mm
close all


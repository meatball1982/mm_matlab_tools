function [h]=fun_mm_polarbar(values,str,colors,radii);
% [h]=fun_mm_polarbar(values,str,colors,radii)
%
% 
% values = [2, 5, 9,10 12 15, 20,25,];         % 条形高度值
% str = {'USA', 'FRA', 'SRB', 'AUS', 'CHN', 'KOR', 'JPN', 'FRA'};
% radii = [ 5:5:30];
% [h]=fun_mm_polarbar(values,str,colors,radii);
% 
% based on post 
% https://blog.csdn.net/2403_87108415/article/details/149231971
% 

%% main
numBars = length(values);                % 条形数量（8）
innerRadius = 0.1;                        % 内环半径
maxValue = max(values);                 % 最大值（25）
barWidth = 2*pi/numBars * 0.995;          % 条形角度宽度（约0.7069弧度）
% colors = parula(numBars);               % 生成8种颜色

for i = 1:numBars
    startAngle = (i-1) * 2*pi/numBars ;  % 起始角度
    endAngle = startAngle + barWidth;    % 结束角度
    
    % 生成圆弧坐标点（100个点）
    theta = linspace(startAngle, endAngle, 100);
    x_inner = innerRadius * cos(theta);  % 内圆弧x坐标
    y_inner = innerRadius * sin(theta);  % 内圆弧y坐标
    x_outer = (innerRadius + values(i)) * cos(theta); % 外圆弧x坐标
    y_outer = (innerRadius + values(i)) * sin(theta); % 外圆弧y坐标
    
    % 组合多边形顶点（内弧+反向外弧）
    x = [x_inner, fliplr(x_outer)];
    y = [y_inner, fliplr(y_outer)];
    
    % 绘制填充多边形
    patch(x, y, colors(i, :), 'EdgeColor', 'k', 'FaceAlpha', 0.95-0.01*i);
    
    % 添加国家标签
    midAngle = mean([startAngle, endAngle]);  % 中心角度
    labelRadius = innerRadius + values(i) + 0.1*maxValue; % 标签半径（条形外+2单位）
    x_txt = labelRadius * cos(midAngle);      % 标签x位置
    y_txt = labelRadius * sin(midAngle);      % 标签y位置
    
    % 调整文本朝向（确保可读性）
    rotAngle = rad2deg(midAngle);
    if rotAngle > 90 && rotAngle <= 270
        rotAngle = rotAngle + 180;
    end
    
    % 添加文本标签
    text(x_txt, y_txt, str{i}, ...
        'Rotation', rotAngle, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 10, ...
        'FontWeight', 'bold');
end

axis equal;  % 等比例缩放
axis off;    % 隐藏坐标轴
% 设置显示范围（包含所有元素）
xlim([-(innerRadius+ 1.2*maxValue), (innerRadius+ 1.2*maxValue)]);
ylim([-(innerRadius+ 1.2*maxValue), (innerRadius+ 1.2*maxValue)]);

hold on;  % 保持当前图形
 
% 径向线（30度间隔）
for angle = 0:30:330
    rad_angle = deg2rad(angle);
    % 绘制从圆心到外边缘的线段
    x_line = [0, (innerRadius+1.1*maxValue)*cos(rad_angle)];
    y_line = [0, (innerRadius+1.1*maxValue)*sin(rad_angle)];
    %    x_line = [0, (innerRadius+1*maxValue)*cos(rad_angle)];
    % y_line = [0, (innerRadius+1*maxValue)*sin(rad_angle)];
    plot(x_line, y_line, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.5);
    
    % 添加角度标签
    % text_x = (innerRadius+maxValue+0.15)*cos(rad_angle);
    % text_y = (innerRadius+maxValue+0.15)*sin(rad_angle);
    % text(text_x, text_y, [num2str(angle) '°'], ...
    %     'HorizontalAlignment', 'center', 'FontSize', 8);
end
 
% 同心圆（半径刻度）
% radii = [5, 10, 15, 20, 25, 30];  % 圆环半径


for r = radii
    th = 0:pi/50:2*pi;            % 生成圆环点
    x_circle = r * cos(th);
    y_circle = r * sin(th);
    plot(x_circle, y_circle, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.5);
    
    % 添加半径标签（x轴正负方向）
    % text(r, 0, num2str(r), 'FontSize', 8, 'HorizontalAlignment', 'right');
    text(-r, 0, num2str(r), 'FontSize', 8, 'HorizontalAlignment', 'left');
end

% colormap(colors(1:end-2,:))
% colorbar

h=gcf;
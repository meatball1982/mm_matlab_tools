% FireBar Chart - MATLAB 实现
clear; close all; clc;

%% 读取数据
data = readtable('data.xlsx');
n = height(data);

%% 颜色
col = struct();
col.Age        = [0.412, 0.122, 0.451];  % #691F73
col.Education  = [1.000, 0.314, 0.000];  % #FF5000
col.Area       = [0.000, 0.384, 0.647];  % #0062A5
col.Train_Yes  = [0.886, 0.145, 0.063];  % #E22510
col.Train_No   = [0.894, 0.714, 0.420];  % #E4B66B
col.Mach_1     = [0.000, 0.345, 0.302];  % #00584D
col.Mach_2     = [0.851, 0.326, 0.310];  % #D9534F
col.Mach_3     = [0.941, 0.678, 0.306];  % #F0AD4E
col.Mach_4     = [0.357, 0.753, 0.871];  % #5BC0DE
col.Mach_5     = [0.361, 0.722, 0.361];  % #5CB85C

%% 参数
ring_thickness = 1.3;
ring_gap = 0.2;
r0 = 2.0;
ring_names = {'Machines', 'Training', 'Area', 'Education', 'Age'};
rings = struct();
for k = 1:numel(ring_names)
    r_in = r0 + (k-1) * (ring_thickness + ring_gap);
    r_out = r_in + ring_thickness;
    rings.(ring_names{k}) = [r_in, r_out];
end

total_radians = 1.5 * pi;
d_theta = total_radians / n;
thetas = linspace(pi/2 - d_theta/2, -pi + d_theta/2, n);
t_arc_start = thetas(1) - d_theta/2;
t_arc_end = thetas(end) + d_theta/2;

%% 创建图形
fig = figure('Position', [100, 100, 1400, 1400], 'Color', 'w', 'Visible', 'off');

% 主坐标系
ax = axes('Position', [0, 0, 1, 1]);
set(ax, 'DataAspectRatio', [1,1,1], 'Visible', 'off');
hold(ax, 'on');
xlim(ax, [-12, 12]);
ylim(ax, [-12, 12]);

%% 辅助函数
% 绘制扇形
draw_wedge = @(r_in, r_out, t_start, t_end, color) ...
    patch(...
        [r_in*cos(linspace(t_start,t_end,50)), r_out*cos(linspace(t_end,t_start,50))], ...
        [r_in*sin(linspace(t_start,t_end,50)), r_out*sin(linspace(t_end,t_start,50))], ...
        color, 'EdgeColor', [0.5,0.5,0.5], 'LineWidth', 0.3);

%% 绘制内两层扇形 (Machines, Training)
for i = 1:n
    t_start = thetas(i) - d_theta/2;
    t_end = thetas(i) + d_theta/2;

    % Machines
    m_val = data.Machines(i);
    m_col = col.(sprintf('Mach_%d', m_val));
    draw_wedge(rings.Machines(1), rings.Machines(2), t_start, t_end, m_col);

    % Training
    t_col = col.Train_Yes;
    if data.Training(i) == 0
        t_col = col.Train_No;
    end
    draw_wedge(rings.Training(1), rings.Training(2), t_start, t_end, t_col);
end

%% 扇区间隔线
for r_idx = 1:numel(ring_names)
    r_in = rings.(ring_names{r_idx})(1);
    r_out = rings.(ring_names{r_idx})(2);
    for i = 1:n
        t_start = thetas(i) - d_theta/2;
        plot(ax, [r_in*cos(t_start), r_out*cos(t_start)], ...
            [r_in*sin(t_start), r_out*sin(t_start)], ...
            'Color', [0.5,0.5,0.5], 'LineWidth', 0.6);
    end
    t_last = thetas(end) + d_theta/2;
    plot(ax, [r_in*cos(t_last), r_out*cos(t_last)], ...
        [r_in*sin(t_last), r_out*sin(t_last)], ...
        'Color', [0.5,0.5,0.5], 'LineWidth', 0.6);
end

%% 首尾扇区外框
for idx = [1, n]
    t0_start = thetas(idx) - d_theta/2;
    t0_end = thetas(idx) + d_theta/2;
    theta_sec = linspace(t0_start, t0_end, 50);
    for r_idx = 1:numel(ring_names)
        r_in = rings.(ring_names{r_idx})(1);
        r_out = rings.(ring_names{r_idx})(2);
        for r_bound = [r_in, r_out]
            plot(ax, r_bound*cos(theta_sec), r_bound*sin(theta_sec), ...
                'Color', [0.5,0.5,0.5], 'LineWidth', 0.6);
        end
        for t_edge = [t0_start, t0_end]
            plot(ax, [r_in*cos(t_edge), r_out*cos(t_edge)], ...
                [r_in*sin(t_edge), r_out*sin(t_edge)], ...
                'Color', [0.5,0.5,0.5], 'LineWidth', 0.6);
        end
    end
end

%% 外层火柴棒环 (Area, Education, Age)
ring_info = {
    'Area',       'Area',        [0, 1.5],  [0.3, 0.6, 1.0, 1.3];
    'Education',  'Education',   [-2, 17],  [0, 5, 10, 15];
    'Age',        'Age',         [20, 80],  [30, 50, 70];
};
for ri = 1:size(ring_info, 1)
    ring_name = ring_info{ri, 1};
    data_col = ring_info{ri, 2};
    v_lims = ring_info{ri, 3};
    ring_ticks = ring_info{ri, 4};

    r_in = rings.(ring_name)(1);
    r_out = rings.(ring_name)(2);

    % 半透明刻度环
    theta_arc = linspace(t_arc_start, t_arc_end, 200);
    for tick_val = ring_ticks
        tick_frac = (tick_val - v_lims(1)) / (v_lims(2) - v_lims(1));
        tick_radius = r_in + tick_frac * (r_out - r_in);
        plot(ax, tick_radius*cos(theta_arc), tick_radius*sin(theta_arc), ...
            'Color', col.(ring_name), 'LineWidth', 0.3, 'LineStyle', '-', ...
            'Color', [col.(ring_name), 0.2]);
    end

    % 火柴棒
    for i = 1:n
        t_center = thetas(i);
        val = data.(data_col)(i);
        val = max(min(val, v_lims(2)), v_lims(1));
        r_val = r_in + (val - v_lims(1)) / (v_lims(2) - v_lims(1)) * (r_out - r_in);

        plot(ax, [r_in*cos(t_center), r_val*cos(t_center)], ...
            [r_in*sin(t_center), r_val*sin(t_center)], ...
            'Color', col.(ring_name), 'LineWidth', 1.5);
        plot(ax, r_val*cos(t_center), r_val*sin(t_center), 'o', ...
            'Color', col.(ring_name), 'MarkerSize', 4, 'MarkerFaceColor', col.(ring_name));
    end
end

%% ID 文本
text_radius = rings.Age(2) + 0.4;
for i = 1:n
    x_text = text_radius * cos(thetas(i));
    y_text = text_radius * sin(thetas(i));
    rot_deg = rad2deg(thetas(i));
    if thetas(i) < -pi/2 || thetas(i) > pi/2
        rot_deg = rot_deg + 180;
    end
    text(x_text, y_text, num2str(data.ID(i)), ...
        'Rotation', rot_deg, 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'FontSize', 9, 'Parent', ax);
end

%% 左侧图表：在数据坐标系中直接绘制
% 每张图的位置: x = -rings[name][1], y_bottom = 0.2, w = ring_thickness, h = 6.0

% Age 箱线图+散点
r_name = 'Age';
x0 = -rings.(r_name)(2);
y0 = 0.2;
w = ring_thickness;
h = 6.0;
data_vals = data.Age;
v_min = 20; v_max = 80;
c = col.Age;

% 箱线图
q = quantile(data_vals, [0.25, 0.5, 0.75]);
iqr_val = q(3) - q(1);
lw = max(min(data_vals), q(1) - 1.5*iqr_val);
uw = min(max(data_vals), q(3) + 1.5*iqr_val);
map_y = @(v) y0 + (v - v_min) / (v_max - v_min) * h;
xs = [x0 + w*0.2, x0 + w*0.8];
rectangle(ax, 'Position', [xs(1), map_y(q(1)), xs(2)-xs(1), map_y(q(3))-map_y(q(1))], ...
    'FaceColor', c, 'FaceAlpha', 0.3, 'EdgeColor', c, 'LineWidth', 1.5);
plot(ax, xs, [map_y(q(2)), map_y(q(2))], 'Color', c, 'LineWidth', 2);
xm = mean(xs);
plot(ax, [xm, xm], [map_y(lw), map_y(q(1))], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xm, xm], [map_y(q(3)), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(lw), map_y(lw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(uw), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
% 散点
rng(42);
jit = -0.15 + 0.3*rand(size(data_vals));
scatter(ax, xm + jit*w, map_y(data_vals), 12, c, 'filled', 'MarkerFaceAlpha', 0.6);
% 外框
rectangle(ax, 'Position', [x0, y0, w, h], 'FaceColor', 'none', ...
    'EdgeColor', 'k', 'LineWidth', 0.8);
% 标题
text(ax, x0 + w/2, y0 + h + 0.6, {'Age', '(years)'}, 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Rotation', 0);

% Education 箱线图+散点
r_name = 'Education';
x0 = -rings.(r_name)(2);
data_vals = data.Education;
v_min = -2; v_max = 17;
c = col.Education;
map_y = @(v) y0 + (v - v_min) / (v_max - v_min) * h;
q = quantile(data_vals, [0.25, 0.5, 0.75]);
iqr_val = q(3) - q(1);
lw = max(min(data_vals), q(1) - 1.5*iqr_val);
uw = min(max(data_vals), q(3) + 1.5*iqr_val);
xs = [x0 + w*0.2, x0 + w*0.8];
rectangle(ax, 'Position', [xs(1), map_y(q(1)), xs(2)-xs(1), map_y(q(3))-map_y(q(1))], ...
    'FaceColor', c, 'FaceAlpha', 0.3, 'EdgeColor', c, 'LineWidth', 1.5);
plot(ax, xs, [map_y(q(2)), map_y(q(2))], 'Color', c, 'LineWidth', 2);
xm = mean(xs);
plot(ax, [xm, xm], [map_y(lw), map_y(q(1))], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xm, xm], [map_y(q(3)), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(lw), map_y(lw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(uw), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
rng(42);
jit = -0.15 + 0.3*rand(size(data_vals));
scatter(ax, xm + jit*w, map_y(data_vals), 12, c, 'filled', 'MarkerFaceAlpha', 0.6);
rectangle(ax, 'Position', [x0, y0, w, h], 'FaceColor', 'none', ...
    'EdgeColor', 'k', 'LineWidth', 0.8);
text(ax, x0 + w/2, y0 + h + 0.6, {'Education', '(years)'}, 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

% Area 箱线图+散点
r_name = 'Area';
x0 = -rings.(r_name)(2);
data_vals = data.Area;
v_min = 0; v_max = 1.5;
c = col.Area;
map_y = @(v) y0 + (v - v_min) / (v_max - v_min) * h;
q = quantile(data_vals, [0.25, 0.5, 0.75]);
iqr_val = q(3) - q(1);
lw = max(min(data_vals), q(1) - 1.5*iqr_val);
uw = min(max(data_vals), q(3) + 1.5*iqr_val);
xs = [x0 + w*0.2, x0 + w*0.8];
rectangle(ax, 'Position', [xs(1), map_y(q(1)), xs(2)-xs(1), map_y(q(3))-map_y(q(1))], ...
    'FaceColor', c, 'FaceAlpha', 0.3, 'EdgeColor', c, 'LineWidth', 1.5);
plot(ax, xs, [map_y(q(2)), map_y(q(2))], 'Color', c, 'LineWidth', 2);
xm = mean(xs);
plot(ax, [xm, xm], [map_y(lw), map_y(q(1))], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xm, xm], [map_y(q(3)), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(lw), map_y(lw)], 'Color', c, 'LineWidth', 1.2);
plot(ax, [xs(1), xs(2)], [map_y(uw), map_y(uw)], 'Color', c, 'LineWidth', 1.2);
rng(42);
jit = -0.15 + 0.3*rand(size(data_vals));
scatter(ax, xm + jit*w, map_y(data_vals), 12, c, 'filled', 'MarkerFaceAlpha', 0.6);
rectangle(ax, 'Position', [x0, y0, w, h], 'FaceColor', 'none', ...
    'EdgeColor', 'k', 'LineWidth', 0.8);
text(ax, x0 + w/2, y0 + h + 0.6, {'Area', '(ha)'}, 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

%% Training 纵向 stacked bar（数据坐标系）
r_name = 'Training';
x0 = -rings.(r_name)(2);
train_counts = histcounts(data.Training, [0, 1, 2]) / n * 100;
map_y = @(v) y0 + v / 100 * h;
% Yes (bottom), No (top)
t1 = train_counts(2); t0 = train_counts(1);
rectangle(ax, 'Position', [x0, map_y(0), w, map_y(t1)-map_y(0)], ...
    'FaceColor', col.Train_Yes, 'EdgeColor', 'none');
rectangle(ax, 'Position', [x0, map_y(t1), w, map_y(t1+t0)-map_y(t1)], ...
    'FaceColor', col.Train_No, 'EdgeColor', 'none');
% Training 外框
rectangle(ax, 'Position', [x0, y0, w, h], 'FaceColor', 'none', ...
    'EdgeColor', 'k', 'LineWidth', 0.8);
if t1 > 5
    text(ax, x0 + w/2, map_y(t1/2), sprintf('%.1f%%', t1), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
end
if t0 > 5
    text(ax, x0 + w/2, map_y(t1 + t0/2), sprintf('%.1f%%', t0), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
end
text(ax, x0 + w/2, y0 + h + 0.6, 'Training(%)', 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Rotation', 30);

%% Machines 纵向 stacked bar（数据坐标系）
r_name = 'Machines';
x0 = -rings.(r_name)(2);
mach_vals = data.Machines;
mach_cats = unique(mach_vals);
mach_counts = zeros(size(mach_cats));
for mi = 1:numel(mach_cats)
    mach_counts(mi) = sum(mach_vals == mach_cats(mi)) / n * 100;
end
map_y = @(v) y0 + v / 100 * h;
bottom = 0;
for mi = 1:numel(mach_cats)
    val = mach_counts(mi);
    c = col.(sprintf('Mach_%d', mach_cats(mi)));
    rectangle(ax, 'Position', [x0, map_y(bottom), w, map_y(bottom+val)-map_y(bottom)], ...
        'FaceColor', c, 'EdgeColor', 'none');
    if val > 5
        text(ax, x0 + w/2, map_y(bottom + val/2), sprintf('%.1f%%', val), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
    end
    bottom = bottom + val;
end
% Machines 外框
rectangle(ax, 'Position', [x0, y0, w, h], 'FaceColor', 'none', ...
    'EdgeColor', 'k', 'LineWidth', 0.8);
text(ax, x0 + w/2, y0 + h + 0.6, 'Machines(%)', 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Rotation', 30);

%% 环最终边界
theta_arc = linspace(t_arc_start, t_arc_end, 200);
for r_idx = 1:numel(ring_names)
    r_in = rings.(ring_names{r_idx})(1);
    r_out = rings.(ring_names{r_idx})(2);
    for r_bound = [r_in, r_out]
        plot(ax, r_bound*cos(theta_arc), r_bound*sin(theta_arc), ...
            'Color', [0.5,0.5,0.5], 'LineWidth', 0.8);
    end
    for t_edge = [t_arc_start, t_arc_end]
        plot(ax, [r_in*cos(t_edge), r_out*cos(t_edge)], ...
            [r_in*sin(t_edge), r_out*sin(t_edge)], ...
            'Color', [0.5,0.5,0.5], 'LineWidth', 0.8);
    end
end

%% 图例
leg_x = 0.10;
leg_y = 0.80;
leg_w = 0.25;
leg_h = 0.12;
ax_leg = axes('Position', [leg_x, leg_y, leg_w, leg_h]);
set(ax_leg, 'Visible', 'off', 'XLim', [0, 6], 'YLim', [0, 3]);
hold(ax_leg, 'on');

xs = [0, 1.8, 4.2];
dy = 0.5;
w = 0.3; h = 0.2;

% Col 1: Age, Education, Area
leg_items1 = {{'Age', 'Age'}, {'Education', 'Education'}, {'Area', 'Area'}};
for j = 1:numel(leg_items1)
    y = 2.7 - (j-1) * dy;
    rectangle(ax_leg, 'Position', [xs(1), y, w, h], 'FaceColor', col.(leg_items1{j}{2}), ...
        'EdgeColor', 'k', 'LineWidth', 0.5);
    text(xs(1)+0.4, y+0.1, leg_items1{j}{1}, 'FontSize', 11, 'Parent', ax_leg);
end

% Col 2: Training
leg_items2 = {{'Training Yes', 'Train_Yes'}, {'Training No', 'Train_No'}};
for j = 1:numel(leg_items2)
    y = 2.7 - (j-1) * dy;
    rectangle(ax_leg, 'Position', [xs(2), y, w, h], 'FaceColor', col.(leg_items2{j}{2}), ...
        'EdgeColor', 'k', 'LineWidth', 0.5);
    text(xs(2)+0.4, y+0.1, leg_items2{j}{1}, 'FontSize', 11, 'Parent', ax_leg);
end

% Col 3: M1-M5
for mi = 1:5
    y = 2.7 - (mi-1) * dy / 2;
    c = col.(sprintf('Mach_%d', mi));
    rectangle(ax_leg, 'Position', [xs(3), y, w, h], 'FaceColor', c, ...
        'EdgeColor', 'k', 'LineWidth', 0.5);
    text(xs(3)+0.4, y+0.1, sprintf('M%d', mi), 'FontSize', 11, 'Parent', ax_leg);
end

%% 标题
text(0, rings.Age(2) + 1.2, sprintf('FireBar Chart (n=%d)', n), ...
    'HorizontalAlignment', 'center', 'FontSize', 18, 'FontWeight', 'bold', 'Parent', ax);

%% 导出
exportgraphics(fig, 'firebar_matlab.png', 'Resolution', 200);
fprintf('Saved: firebar_matlab.png\n');
close(fig);

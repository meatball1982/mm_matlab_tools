# =========================================================================================
# ====================================== 1. 环境设置 =======================================
# =========================================================================================
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib.patches import FancyBboxPatch

# =========================================================================================
# ======================================2.颜色库=======================================
# =========================================================================================
color_schemes = {
    1: {
        "Age": "#691F73",
        "Education": "#FF5000",
        "Area": "#0062A5",
        "Train_Yes": "#E22510",
        "Train_No": "#E4B66B",
        "Mach_1": "#00584D",
        "Mach_2": "#D9534F",
        "Mach_3": "#F0AD4E",
        "Mach_4": "#5BC0DE",
        "Mach_5": "#5CB85C",
    },
}


# =========================================================================================
# ======================================3.绘图函数=======================================
# =========================================================================================
def create_plot(df, n, scheme_id=1, ring_thickness=1.3, ring_gap=0.2):
    colors = color_schemes.get(scheme_id, color_schemes[1])
    fig = plt.figure(figsize=(14, 14), facecolor="white")
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_aspect("equal")
    ax.axis("off")

    # 环半径定义（从内到外）
    r0 = 2.0
    rings = {}
    ring_names = ["Machines", "Training", "Area", "Education", "Age"]
    for k, name in enumerate(ring_names):
        r_in = r0 + k * (ring_thickness + ring_gap)
        r_out = r_in + ring_thickness
        rings[name] = (r_in, r_out)

    total_radians = 1.5 * np.pi
    d_theta = total_radians / n
    thetas = np.linspace(np.pi / 2 - d_theta / 2, -np.pi + d_theta / 2, n)
    t_arc_start = thetas[0] - d_theta / 2
    t_arc_end = thetas[-1] + d_theta / 2

    # 扇形色块的绘制函数
    def draw_wedge(ax, r_in, r_out, t_start, t_end, color):
        theta = np.linspace(t_start, t_end, 50)
        x = np.concatenate([r_in * np.cos(theta), r_out * np.cos(theta[::-1])])
        y = np.concatenate([r_in * np.sin(theta), r_out * np.sin(theta[::-1])])
        ax.fill(x, y, color=color, zorder=1)

    # 绘制内两层扇形（Machines 和 Training）
    for i in range(n):
        t_start = thetas[i] - d_theta / 2
        t_end = thetas[i] + d_theta / 2

        # Machines 扇形
        m_val = int(df["Machines"].iloc[i])
        m_col = colors.get(f"Mach_{m_val}", "#888888")
        draw_wedge(ax, rings["Machines"][0], rings["Machines"][1], t_start, t_end, m_col)

        # Training 扇形
        t_col = colors["Train_Yes"] if df["Training"].iloc[i] == 1 else colors["Train_No"]
        draw_wedge(ax, rings["Training"][0], rings["Training"][1], t_start, t_end, t_col)

    # 所有环的扇区间隔线
    for r_name in ["Machines", "Training", "Area", "Education", "Age"]:
        r_in, r_out = rings[r_name]
        for i in range(n):
            t_start = thetas[i] - d_theta / 2
            ax.plot(
                [r_in * np.cos(t_start), r_out * np.cos(t_start)],
                [r_in * np.sin(t_start), r_out * np.sin(t_start)],
                color="0.5", lw=0.6, zorder=2,
            )
        t_last = thetas[-1] + d_theta / 2
        ax.plot(
            [r_in * np.cos(t_last), r_out * np.cos(t_last)],
            [r_in * np.sin(t_last), r_out * np.sin(t_last)],
            color="0.5", lw=0.6, zorder=2,
        )

    # 第一个和最后一个数据的外框（所有环）
    for idx, label in [(0, "first"), (-1, "last")]:
        t0_start = thetas[idx] - d_theta / 2
        t0_end = thetas[idx] + d_theta / 2
        theta_sec = np.linspace(t0_start, t0_end, 50)
        lw_val = 0.6
        for r_name in ["Machines", "Training", "Area", "Education", "Age"]:
            r_in, r_out = rings[r_name]
            for r_bound in [r_in, r_out]:
                ax.plot(
                    r_bound * np.cos(theta_sec),
                    r_bound * np.sin(theta_sec),
                    color="0.5", lw=lw_val, zorder=3,
                )
            for t_edge in [t0_start, t0_end]:
                ax.plot(
                    [r_in * np.cos(t_edge), r_out * np.cos(t_edge)],
                    [r_in * np.sin(t_edge), r_out * np.sin(t_edge)],
                    color="0.5", lw=lw_val, zorder=3,
                )

    # 遍历外层火柴棒环（Area, Education, Age）
    for ring_name, data_col, v_lims, ring_ticks in zip(
        ["Area", "Education", "Age"],
        ["Area", "Education", "Age"],
        [(0, 1.5), (-2, 17), (20, 80)],
        [
            [0.3, 0.6, 1.0, 1.3],
            [0, 5, 10, 15],
            [30, 50, 70],
        ],
    ):
        r_in, r_out = rings[ring_name]
        # 绘制半透明刻度环（仅3/4圆弧）
        tick_r = r_in + 0.02 * (r_out - r_in)
        for tick_val in ring_ticks:
            tick_frac = (tick_val - v_lims[0]) / (v_lims[1] - v_lims[0])
            tick_radius = r_in + tick_frac * (r_out - r_in)
            theta_arc = np.linspace(t_arc_start, t_arc_end, 200)
            ax.plot(
                tick_radius * np.cos(theta_arc),
                tick_radius * np.sin(theta_arc),
                color=colors[ring_name],
                lw=0.3,
                alpha=0.2,
            )

        for i in range(n):
            t_center = thetas[i]
            val = df[data_col].iloc[i]
            clamped = np.clip(val, v_lims[0], v_lims[1])
            r_val = r_in + (clamped - v_lims[0]) / (v_lims[1] - v_lims[0]) * (r_out - r_in)

            # 火柴棒
            ax.plot(
                [r_in * np.cos(t_center), r_val * np.cos(t_center)],
                [r_in * np.sin(t_center), r_val * np.sin(t_center)],
                color=colors[ring_name],
                lw=1.5,
                zorder=1,
            )
            ax.plot(
                r_val * np.cos(t_center),
                r_val * np.sin(t_center),
                "o",
                color=colors[ring_name],
                markersize=4,
                zorder=2,
            )

    # 确保坐标轴显示完整
    ax.set_xlim(-12, 12)
    ax.set_ylim(-12, 12)

    # 添加ID文本
    text_radius = rings["Age"][1] + 0.4
    for i in range(n):
        x_text = text_radius * np.cos(thetas[i])
        y_text = text_radius * np.sin(thetas[i])
        rot_deg = np.degrees(thetas[i])
        if thetas[i] < -np.pi / 2 or thetas[i] > np.pi / 2:
            rot_deg += 180
        ax.text(
            x_text,
            y_text,
            str(df["ID"].iloc[i]),
            rotation=rot_deg,
            ha="center",
            va="center",
            fontsize=9,
        )

    # 箱型图和散点图组合图绘制函数
    def create_vertical_swarm(ax_sub, data, color, title, unit, ylim, ticks):
        ax_sub.set_ylim(ylim)
        ax_sub.set_title(f"{title}\n({unit})", fontsize=16, pad=10)
        ax_sub.set_xticks([])
        ax_sub.set_ylabel("")
        for spine in ax_sub.spines.values():
            spine.set_color("gray")
            spine.set_linewidth(0.5)
        # 箱线图
        bp = ax_sub.boxplot(
            data, vert=True, patch_artist=True, widths=0.5,
            boxprops=dict(facecolor=color, alpha=0.3, edgecolor=color, linewidth=1.5),
            whiskerprops=dict(color=color, linewidth=1.2),
            capprops=dict(color=color, linewidth=1.2),
            medianprops=dict(color=color, linewidth=2),
            flierprops=dict(marker="o", markerfacecolor=color, markersize=4, alpha=0.5),
        )
        # 蜜蜂散点图
        jitter = np.random.default_rng(42).uniform(-0.2, 0.2, len(data))
        ax_sub.scatter(1 + jitter, data, color=color, alpha=0.6, s=20, zorder=3)
        ax_sub.set_yticks(ticks)

    # 创建Age箱线图轴
    ax_age = ax.inset_axes(
        [-rings["Age"][1], 0.2, ring_thickness, 6.0],
        transform=ax.transData,
    )
    create_vertical_swarm(
        ax_age, df["Age"], colors["Age"], "Age", "years", [20, 80], [30, 40, 50, 60, 70]
    )
    ax_age.invert_xaxis()

    # Education
    ax_edu = ax.inset_axes(
        [-rings["Education"][1], 0.2, ring_thickness, 6.0], transform=ax.transData
    )
    create_vertical_swarm(
        ax_edu,
        df["Education"],
        colors["Education"],
        "Education",
        "years",
        [-2, 17],
        [0, 5, 10, 15],
    )
    ax_edu.invert_xaxis()

    # Area
    ax_area = ax.inset_axes(
        [-rings["Area"][1], 0.2, ring_thickness, 6.0], transform=ax.transData
    )
    create_vertical_swarm(
        ax_area,
        df["Area"],
        colors["Area"],
        "Area",
        "ha",
        [0, 1.5],
        [0.3, 0.6, 1.0, 1.3],
    )
    ax_area.invert_xaxis()

    # Training 百分比（纵向 stacked bar）
    ax_train = ax.inset_axes(
        [-rings["Training"][1], 0.2, ring_thickness, 6.0], transform=ax.transData
    )
    train_counts = df["Training"].value_counts(normalize=True) * 100
    t_0 = train_counts.get(0, 0)
    t_1 = train_counts.get(1, 0)
    ax_train.set_xlim(-0.5, 0.5)
    ax_train.set_ylim(0, 100)
    ax_train.bar(0, t_1, width=1.0, color=colors["Train_Yes"], zorder=2)
    ax_train.bar(0, t_0, bottom=t_1, width=1.0, color=colors["Train_No"], zorder=2)
    ax_train.set_title("Training(%)", rotation=45, ha="left", y=1.02, fontsize=16)
    ax_train.axis("off")
    if t_1 > 5:
        ax_train.text(0, t_1 / 2, f"{t_1:.1f}%", ha="center", va="center", color="white", fontsize=12, fontweight="bold")
    if t_0 > 5:
        ax_train.text(0, t_1 + t_0 / 2, f"{t_0:.1f}%", ha="center", va="center", color="white", fontsize=12, fontweight="bold")
    # Training 外框
    ax.add_patch(Rectangle(
        (-rings["Training"][1], 0.2), ring_thickness, 6.0,
        fill=False, edgecolor="black", lw=0.8, zorder=2,
    ))

    # Machines 百分比（纵向 stacked bar）
    ax_mach = ax.inset_axes(
        [-rings["Machines"][1], 0.2, ring_thickness, 6.0], transform=ax.transData
    )
    mach_counts = df["Machines"].value_counts(normalize=True).sort_index() * 100
    mach_colors = [colors.get(f"Mach_{int(m)}", "#888888") for m in mach_counts.index]
    ax_mach.set_xlim(-0.5, 0.5)
    ax_mach.set_ylim(0, 100)
    bottom = 0
    for val, c in zip(mach_counts.values, mach_colors):
        ax_mach.bar(0, val, width=1.0, bottom=bottom, color=c, zorder=2)
        if val > 5:
            ax_mach.text(0, bottom + val / 2, f"{val:.1f}%", ha="center", va="center", color="white", fontsize=11, fontweight="bold")
        bottom += val
    ax_mach.set_title("Machines(%)", rotation=45, ha="left", y=1.02, fontsize=16)
    ax_mach.axis("off")
    # Machines 外框
    ax.add_patch(Rectangle(
        (-rings["Machines"][1], 0.2), ring_thickness, 6.0,
        fill=False, edgecolor="black", lw=0.8, zorder=2,
    ))

    # 图例（左上，3列：Age/Education/Area | Training | Machines）
    leg_top = rings["Age"][1]
    ax_leg = ax.inset_axes([-9.5, leg_top - 3.0, 6.0, 3.0], transform=ax.transData)
    ax_leg.axis("off")
    ax_leg.set_xlim(0, 6.0)
    ax_leg.set_ylim(0, 3.0)

    w, h = 0.3, 0.2
    xs = [0.0, 1.8, 4.2]
    dy = 0.5
    # Col 1: Age, Education, Area
    for j, (label, color_key) in enumerate([("Age", "Age"), ("Education", "Education"), ("Area", "Area")]):
        y = 2.7 - j * dy
        ax_leg.add_patch(Rectangle((xs[0], y), w, h, facecolor=colors[color_key], edgecolor="black", lw=0.5))
        ax_leg.text(xs[0] + 0.4, y + 0.1, label, va="center", fontsize=11)
    # Col 2: Training Yes, Training No
    for j, (label, color_key) in enumerate([("Training Yes", "Train_Yes"), ("Training No", "Train_No")]):
        y = 2.7 - j * dy
        ax_leg.add_patch(Rectangle((xs[1], y), w, h, facecolor=colors[color_key], edgecolor="black", lw=0.5))
        ax_leg.text(xs[1] + 0.4, y + 0.1, label, va="center", fontsize=11)
    # Col 3: M1-M5
    for mi in range(1, 6):
        y = 2.7 - (mi - 1) * dy / 2
        c = colors.get(f"Mach_{mi}", "#888888")
        ax_leg.add_patch(Rectangle((xs[2], y), w, h, facecolor=c, edgecolor="black", lw=0.5))
        ax_leg.text(xs[2] + 0.4, y + 0.1, f"M{mi}", va="center", fontsize=11)

    # 图表标题
    ax.text(0, rings["Age"][1] + 1.2, f"FireBar Chart (n={n})",
            ha="center", va="center", fontsize=18, fontweight="bold")

    # 最后绘制所有环的边界（确保在最上层）
    theta_arc = np.linspace(t_arc_start, t_arc_end, 200)
    for r_name in ["Machines", "Training", "Area", "Education", "Age"]:
        r_in, r_out = rings[r_name]
        for r_bound in [r_in, r_out]:
            ax.plot(
                r_bound * np.cos(theta_arc),
                r_bound * np.sin(theta_arc),
                color="0.5", lw=0.8, zorder=3,
            )
        for t_edge in [t_arc_start, t_arc_end]:
            ax.plot(
                [r_in * np.cos(t_edge), r_out * np.cos(t_edge)],
                [r_in * np.sin(t_edge), r_out * np.sin(t_edge)],
                color="0.5", lw=0.8, zorder=3,
            )

    fig.savefig("firebar_chart.png", dpi=200, bbox_inches="tight")
    plt.close(fig)
    print(f"Saved: firebar_chart.png")


# =========================================================================================
# ======================================4.执行部分=======================================
# =========================================================================================
if __name__ == "__main__":
    RING_THICKNESS = 1.3
    RING_GAP = 0.2
    df_real_data = pd.read_excel(r"data.xlsx")
    n = len(df_real_data)
    plot_all = True
    if plot_all:
        for i in color_schemes.keys():
            create_plot(
                df_real_data,
                n,
                scheme_id=i,
                ring_thickness=RING_THICKNESS,
                ring_gap=RING_GAP,
            )
    else:
        TARGET_SCHEME = 1
        create_plot(
            df_real_data,
            n,
            scheme_id=TARGET_SCHEME,
            ring_thickness=RING_THICKNESS,
            ring_gap=RING_GAP,
        )

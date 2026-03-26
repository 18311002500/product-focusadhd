#!/usr/bin/env python3
"""
FocusFlow App Store 截图自动生成脚本 - 优化版 v2
修复字体和布局问题
"""

from PIL import Image, ImageDraw, ImageFont
import os

# iPhone 15 Pro Max 尺寸
WIDTH = 1290
HEIGHT = 2796

# FocusFlow 品牌色
PRIMARY_COLOR = (255, 107, 53)  # #FF6B35 - 橙色
SECONDARY_COLOR = (78, 205, 196)  # #4ECDC4 - 青色
SUCCESS_COLOR = (39, 174, 96)  # #27AE60 - 绿色
DANGER_COLOR = (233, 30, 99)  # #E91E63 - 粉色
DARK_COLOR = (44, 62, 80)  # #2C3E50 - 深蓝灰
LIGHT_BG = (247, 247, 247)  # #F7F7F7 - 浅灰背景
WHITE = (255, 255, 255)
GRAY = (128, 128, 128)
LIGHT_GRAY = (200, 200, 200)

def get_font(size):
    """获取字体"""
    font_paths = [
        "/tmp/NotoSansCJKsc-Bold.otf",
        "/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc",
    ]
    for path in font_paths:
        try:
            return ImageFont.truetype(path, size)
        except:
            continue
    return ImageFont.load_default()

def screenshot1_home():
    """截图 1: 首页 - 今日任务"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_card_title = get_font(48)
    font_card_subtitle = get_font(36)
    font_task = get_font(42)
    font_task_sub = get_font(32)
    font_tab = get_font(36)
    font_icon = get_font(48)
    
    # 标题栏
    draw.text((60, 100), "FocusFlow", fill=DARK_COLOR, font=font_title)
    
    # ===== 植物成长卡片 =====
    card_margin = 60
    card_y = 220
    card_height = 240
    
    # 卡片背景
    draw.rounded_rectangle(
        [card_margin, card_y, WIDTH-card_margin, card_y+card_height], 
        radius=30, fill=WHITE
    )
    
    # 左侧文字区域
    text_x = card_margin + 40
    text_y = card_y + 35
    
    # "我的植物" - 小字
    draw.text((text_x, text_y), "我的植物", fill=GRAY, font=font_card_subtitle)
    
    # "幼苗期" - 大字，在下方
    text_y += 50
    draw.text((text_x, text_y), "幼苗期", fill=DARK_COLOR, font=font_card_title)
    
    # 右侧植物图标 (绿色圆形 + P)
    icon_size = 80
    icon_x = WIDTH - card_margin - 40 - icon_size
    icon_y = card_y + 30
    draw.ellipse(
        [icon_x, icon_y, icon_x+icon_size, icon_y+icon_size], 
        fill=SUCCESS_COLOR
    )
    draw.text((icon_x+25, icon_y+18), "P", fill=WHITE, font=font_icon)
    
    # 进度条
    bar_y = card_y + 170
    bar_height = 20
    bar_margin = text_x
    bar_width = WIDTH - card_margin*2 - 80
    
    # 进度条背景
    draw.rounded_rectangle(
        [bar_margin, bar_y, bar_margin+bar_width, bar_y+bar_height],
        radius=10, fill=(230, 230, 230)
    )
    # 进度条填充 (75%)
    progress_width = int(bar_width * 0.75)
    draw.rounded_rectangle(
        [bar_margin, bar_y, bar_margin+progress_width, bar_y+bar_height],
        radius=10, fill=SUCCESS_COLOR
    )
    
    # 积分文字 - 在进度条下方
    text_y = bar_y + 35
    draw.text((bar_margin, text_y), "1250 能量点", fill=GRAY, font=font_task_sub)
    draw.text((WIDTH - card_margin - 40 - 200, text_y), "还需 250 点升级", fill=GRAY, font=font_task_sub)
    
    # ===== 今日任务标题 =====
    section_y = card_y + card_height + 60
    draw.text((60, section_y), "今日任务", fill=DARK_COLOR, font=font_card_title)
    
    # 添加按钮 (+)
    btn_size = 70
    btn_x = WIDTH - 60 - btn_size
    btn_y = section_y - 10
    draw.ellipse([btn_x, btn_y, btn_x+btn_size, btn_y+btn_size], fill=PRIMARY_COLOR)
    draw.text((btn_x+20, btn_y+10), "+", fill=WHITE, font=font_title)
    
    # ===== 任务卡片列表 =====
    tasks = [
        ("完成项目报告", "困难", DANGER_COLOR),
        ("回复邮件", "简单", SECONDARY_COLOR),
        ("阅读 30 分钟", "中等", PRIMARY_COLOR),
    ]
    
    card_y = section_y + 100
    card_height = 130
    card_margin_h = 60
    
    for task_name, difficulty, color in tasks:
        # 卡片背景
        draw.rounded_rectangle(
            [card_margin_h, card_y, WIDTH-card_margin_h, card_y+card_height],
            radius=20, fill=WHITE
        )
        
        # 难度指示点
        dot_size = 20
        dot_x = card_margin_h + 30
        dot_y = card_y + (card_height - dot_size) // 2
        draw.ellipse([dot_x, dot_y, dot_x+dot_size, dot_y+dot_size], fill=color)
        
        # 任务名称
        text_x = dot_x + dot_size + 25
        text_y = card_y + 25
        draw.text((text_x, text_y), task_name, fill=DARK_COLOR, font=font_task)
        
        # 难度文字
        text_y += 55
        draw.text((text_x, text_y), difficulty, fill=GRAY, font=font_task_sub)
        
        # 完成按钮 (绿色圆形 + 对勾)
        btn_size = 60
        btn_x = WIDTH - card_margin_h - 30 - btn_size
        btn_y = card_y + (card_height - btn_size) // 2
        draw.ellipse([btn_x, btn_y, btn_x+btn_size, btn_y+btn_size], fill=SUCCESS_COLOR)
        draw.text((btn_x+18, btn_y+12), "✓", fill=WHITE, font=font_card_title)
        
        card_y += card_height + 20
    
    # ===== 底部 Tab Bar =====
    tab_height = 120
    tab_y = HEIGHT - tab_height
    draw.rectangle([0, tab_y, WIDTH, HEIGHT], fill=WHITE)
    
    tabs = [("今日", True), ("专注", False), ("进度", False), ("徽章", False)]
    tab_width = WIDTH // 4
    
    for i, (label, selected) in enumerate(tabs):
        x = i * tab_width
        center_x = x + tab_width // 2
        color = PRIMARY_COLOR if selected else GRAY
        
        # 文字居中
        text_width = len(label) * 36
        draw.text((center_x - text_width//2, tab_y + 40), label, fill=color, font=font_tab)
    
    return img

def screenshot2_timer():
    """截图 2: 专注计时器"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_time = get_font(140)
    font_status = get_font(48)
    font_button = get_font(36)
    
    # 标题
    draw.text((60, 100), "专注计时", fill=DARK_COLOR, font=font_title)
    
    # 中心计时器圆环
    center_x = WIDTH // 2
    center_y = HEIGHT // 2 - 100
    outer_radius = 300
    inner_radius = 260
    
    # 背景圆环
    draw.ellipse(
        [center_x-outer_radius, center_y-outer_radius, 
         center_x+outer_radius, center_y+outer_radius],
        outline=(230, 230, 230), width=40
    )
    
    # 进度弧 (60%)
    draw.pieslice(
        [center_x-outer_radius, center_y-outer_radius,
         center_x+outer_radius, center_y+outer_radius],
        start=-90, end=126, fill=PRIMARY_COLOR
    )
    
    # 中心圆形遮盖，形成圆环效果
    draw.ellipse(
        [center_x-inner_radius, center_y-inner_radius,
         center_x+inner_radius, center_y+inner_radius],
        fill=LIGHT_BG
    )
    
    # 时间文字
    draw.text((center_x-180, center_y-90), "09:42", fill=DARK_COLOR, font=font_time)
    
    # 状态文字
    draw.text((center_x-90, center_y+80), "专注中...", fill=SUCCESS_COLOR, font=font_status)
    
    # 控制按钮
    button_y = HEIGHT - 280
    buttons = [
        ("暂停", PRIMARY_COLOR),
        ("停止", DANGER_COLOR),
        ("完成", SUCCESS_COLOR)
    ]
    
    btn_radius = 70
    total_width = len(buttons) * (btn_radius * 2 + 40) - 40
    start_x = (WIDTH - total_width) // 2 + btn_radius
    
    for i, (label, color) in enumerate(buttons):
        x = start_x + i * (btn_radius * 2 + 40)
        
        # 按钮背景光晕
        draw.ellipse(
            [x-btn_radius-10, button_y-btn_radius-10,
             x+btn_radius+10, button_y+btn_radius+10],
            fill=(*color, 50) if len(color) == 3 else color
        )
        
        # 按钮
        draw.ellipse(
            [x-btn_radius, button_y-btn_radius,
             x+btn_radius, button_y+btn_radius],
            fill=color
        )
        
        # 按钮文字
        text_width = len(label) * 36
        draw.text((x-text_width//2, button_y-18), label, fill=WHITE, font=font_button)
    
    return img

def screenshot3_badges():
    """截图 3: 徽章墙"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_subtitle = get_font(44)
    font_badge_name = get_font(36)
    font_icon = get_font(48)
    
    # 标题
    draw.text((60, 100), "徽章墙", fill=DARK_COLOR, font=font_title)
    draw.text((60, 190), "已解锁 3/20", fill=GRAY, font=font_subtitle)
    
    # 徽章数据 (图标类型, 名称, 是否解锁, 颜色)
    badges = [
        ("plant", "初次萌芽", True, SUCCESS_COLOR),
        ("fire", "连续3天", True, DANGER_COLOR),
        ("star", "积分别致", True, PRIMARY_COLOR),
        ("run", "运动达人", False, LIGHT_GRAY),
        ("target", "专注大师", False, LIGHT_GRAY),
        ("gem", "任务收藏家", False, LIGHT_GRAY),
        ("bird", "早起鸟", False, LIGHT_GRAY),
        ("book", "学习达人", False, LIGHT_GRAY),
    ]
    
    # 网格布局
    cols = 2
    start_y = 300
    card_width = (WIDTH - 180) // cols
    card_height = 200
    card_margin = 20
    
    for i, (icon_type, name, unlocked, color) in enumerate(badges):
        row = i // cols
        col = i % cols
        
        x = 60 + col * (card_width + card_margin)
        y = start_y + row * (card_height + card_margin)
        
        # 卡片背景色
        if unlocked:
            bg_color = (255, 248, 235)  # 暖黄色背景
        else:
            bg_color = (245, 245, 245)  # 灰色背景
        
        # 绘制卡片
        draw.rounded_rectangle(
            [x, y, x+card_width, y+card_height],
            radius=20, fill=bg_color
        )
        
        # 图标圆形背景
        icon_size = 70
        icon_x = x + (card_width - icon_size) // 2
        icon_y = y + 30
        
        if unlocked:
            draw.ellipse(
                [icon_x, icon_y, icon_x+icon_size, icon_y+icon_size],
                fill=color
            )
            icon_text = {"plant": "P", "fire": "F", "star": "S"}.get(icon_type, "?")
            draw.text((icon_x+22, icon_y+15), icon_text, fill=WHITE, font=font_icon)
        else:
            draw.ellipse(
                [icon_x, icon_y, icon_x+icon_size, icon_y+icon_size],
                fill=LIGHT_GRAY
            )
            draw.text((icon_x+22, icon_y+15), "L", fill=(150, 150, 150), font=font_icon)
        
        # 徽章名称
        text_color = DARK_COLOR if unlocked else GRAY
        text_width = len(name) * 36
        draw.text(
            (x + (card_width - text_width) // 2, y + 120),
            name, fill=text_color, font=font_badge_name
        )
    
    return img

def screenshot4_progress():
    """截图 4: 进度统计"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_card_label = get_font(36)
    font_big_number = get_font(120)
    font_stage = get_font(32)
    font_stage_name = get_font(36)
    
    # 标题
    draw.text((60, 100), "进度", fill=DARK_COLOR, font=font_title)
    
    # ===== 完成率大卡片 =====
    card_margin = 60
    card_y = 220
    card_height = 320
    
    draw.rounded_rectangle(
        [card_margin, card_y, WIDTH-card_margin, card_y+card_height],
        radius=30, fill=WHITE
    )
    
    # 卡片内容
    text_x = card_margin + 50
    text_y = card_y + 50
    
    draw.text((text_x, text_y), "本周完成率", fill=GRAY, font=font_card_label)
    
    text_y += 70
    draw.text((text_x, text_y), "78%", fill=SUCCESS_COLOR, font=font_big_number)
    
    text_y += 150
    draw.text((text_x, text_y), "比上周提升 12%", fill=GRAY, font=font_card_label)
    
    # ===== 统计数据行 =====
    stats_y = card_y + card_height + 50
    stat_height = 200
    stat_width = (WIDTH - 160) // 2
    
    stats = [
        ("总积分", "1,250", PRIMARY_COLOR),
        ("连续打卡", "5天", SECONDARY_COLOR)
    ]
    
    for i, (label, value, color) in enumerate(stats):
        x = 60 + i * (stat_width + 40)
        
        draw.rounded_rectangle(
            [x, stats_y, x+stat_width, stats_y+stat_height],
            radius=20, fill=WHITE
        )
        
        draw.text((x+30, stats_y+30), label, fill=GRAY, font=font_card_label)
        
        # 数字
        num_font = get_font(72)
        draw.text((x+30, stats_y+85), value, fill=color, font=num_font)
    
    # ===== 植物成长阶段 =====
    stage_card_y = stats_y + stat_height + 50
    stage_card_height = 280
    
    draw.rounded_rectangle(
        [card_margin, stage_card_y, WIDTH-card_margin, stage_card_y+stage_card_height],
        radius=30, fill=WHITE
    )
    
    draw.text((card_margin+50, stage_card_y+40), "植物成长阶段", fill=DARK_COLOR, font=font_stage_name)
    
    # 阶段指示器
    stages = [
        ("幼苗", True, SUCCESS_COLOR),
        ("成长", False, LIGHT_GRAY),
        ("茂盛", False, LIGHT_GRAY),
        ("开花", False, LIGHT_GRAY),
        ("结果", False, LIGHT_GRAY),
    ]
    
    stage_dot_size = 24
    stage_width = (WIDTH - card_margin*2 - 100) // len(stages)
    start_x = card_margin + 50
    dot_y = stage_card_y + 120
    
    for i, (name, active, color) in enumerate(stages):
        x = start_x + i * stage_width
        center_x = x + stage_width // 2
        
        # 圆点
        draw.ellipse(
            [center_x-stage_dot_size//2, dot_y,
             center_x+stage_dot_size//2, dot_y+stage_dot_size],
            fill=color
        )
        
        # 阶段名称
        text_width = len(name) * 32
        draw.text(
            (center_x - text_width//2, dot_y + 50),
            name, fill=color, font=font_stage
        )
    
    return img

def screenshot5_add_task():
    """截图 5: 添加任务弹窗"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    # 背景遮罩
    draw.rectangle([0, 0, WIDTH, HEIGHT], fill=(0, 0, 0, 100))
    
    font_title = get_font(56)
    font_label = get_font(40)
    font_input = get_font(40)
    font_button = get_font(40)
    font_small = get_font(32)
    
    # ===== 弹窗 =====
    dialog_margin = 80
    dialog_y = 450
    dialog_height = 1000
    
    draw.rounded_rectangle(
        [dialog_margin, dialog_y, WIDTH-dialog_margin, dialog_y+dialog_height],
        radius=30, fill=WHITE
    )
    
    # 弹窗标题
    title_width = len("添加任务") * 56
    draw.text(
        ((WIDTH - title_width) // 2, dialog_y + 50),
        "添加任务", fill=DARK_COLOR, font=font_title
    )
    
    content_x = dialog_margin + 60
    
    # ===== 任务名称输入 =====
    input_y = dialog_y + 160
    draw.text((content_x, input_y), "任务名称", fill=DARK_COLOR, font=font_label)
    
    input_box_y = input_y + 70
    input_box_height = 90
    draw.rounded_rectangle(
        [content_x, input_box_y, WIDTH-dialog_margin-60, input_box_y+input_box_height],
        radius=15, fill=(245, 245, 245)
    )
    draw.text((content_x+30, input_box_y+25), "完成项目报告", fill=DARK_COLOR, font=font_input)
    
    # ===== 难度选择 =====
    diff_y = input_box_y + input_box_height + 60
    draw.text((content_x, diff_y), "任务难度", fill=DARK_COLOR, font=font_label)
    
    difficulties = [
        ("简单", SECONDARY_COLOR, False),
        ("中等", PRIMARY_COLOR, False),
        ("困难", DANGER_COLOR, True)
    ]
    
    diff_btn_width = (WIDTH - dialog_margin*2 - 120 - 60) // 3
    diff_btn_height = 80
    diff_btn_y = diff_y + 70
    
    for i, (label, color, selected) in enumerate(difficulties):
        x = content_x + i * (diff_btn_width + 30)
        
        bg_color = color if selected else (240, 240, 240)
        text_color = WHITE if selected else color
        
        draw.rounded_rectangle(
            [x, diff_btn_y, x+diff_btn_width, diff_btn_y+diff_btn_height],
            radius=15, fill=bg_color
        )
        
        text_width = len(label) * 40
        draw.text(
            (x + (diff_btn_width - text_width) // 2, diff_btn_y + 20),
            label, fill=text_color, font=font_label
        )
    
    # ===== 积分预览 =====
    reward_y = diff_btn_y + diff_btn_height + 80
    draw.text((content_x, reward_y), "完成奖励", fill=DARK_COLOR, font=font_label)
    
    reward_text = "+30 积分"
    text_width = len(reward_text) * 40
    draw.text(
        (WIDTH - dialog_margin - 60 - text_width, reward_y),
        reward_text, fill=SUCCESS_COLOR, font=font_label
    )
    
    # ===== 按钮 =====
    button_y = dialog_y + dialog_height - 150
    button_height = 90
    button_width = (WIDTH - dialog_margin*2 - 60) // 2
    
    # 取消按钮
    draw.rounded_rectangle(
        [content_x, button_y, content_x+button_width, button_y+button_height],
        radius=15, fill=(230, 230, 230)
    )
    cancel_width = len("取消") * 40
    draw.text(
        (content_x + (button_width - cancel_width) // 2, button_y + 25),
        "取消", fill=DARK_COLOR, font=font_button
    )
    
    # 添加按钮
    add_btn_x = content_x + button_width + 30
    draw.rounded_rectangle(
        [add_btn_x, button_y, add_btn_x+button_width, button_y+button_height],
        radius=15, fill=PRIMARY_COLOR
    )
    add_width = len("添加") * 40
    draw.text(
        (add_btn_x + (button_width - add_width) // 2, button_y + 25),
        "添加", fill=WHITE, font=font_button
    )
    
    return img

def main():
    """主函数：生成所有截图"""
    output_dir = "screenshots"
    os.makedirs(output_dir, exist_ok=True)
    
    print("开始生成 FocusFlow App Store 截图 (优化版 v2)...")
    
    screenshots = [
        (screenshot1_home, "screenshot1_home.png", "首页 - 今日任务"),
        (screenshot2_timer, "screenshot2_timer.png", "专注计时器"),
        (screenshot3_badges, "screenshot3_badges.png", "徽章墙"),
        (screenshot4_progress, "screenshot4_progress.png", "进度统计"),
        (screenshot5_add_task, "screenshot5_add_task.png", "添加任务"),
    ]
    
    for func, filename, desc in screenshots:
        print(f"正在生成: {desc}...")
        img = func()
        filepath = os.path.join(output_dir, filename)
        img.save(filepath, "PNG", quality=95)
        print(f"✅ 已保存: {filepath}")
    
    print("\n🎉 所有截图生成完成！")
    print(f"📁 截图保存在: {os.path.abspath(output_dir)}/")
    print(f"📐 尺寸: {WIDTH}x{HEIGHT} (iPhone 15 Pro Max)")

if __name__ == "__main__":
    main()

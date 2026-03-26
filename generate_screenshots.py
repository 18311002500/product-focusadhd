#!/usr/bin/env python3
"""
FocusFlow App Store 截图自动生成脚本 - 最终优化版 v3
完全精确对齐，解决所有布局问题
"""

from PIL import Image, ImageDraw, ImageFont
import os

# iPhone 15 Pro Max 尺寸
WIDTH = 1290
HEIGHT = 2796

# FocusFlow 品牌色
PRIMARY_COLOR = (255, 107, 53)      # #FF6B35 - 橙色
SECONDARY_COLOR = (78, 205, 196)    # #4ECDC4 - 青色
SUCCESS_COLOR = (39, 174, 96)       # #27AE60 - 绿色
DANGER_COLOR = (233, 30, 99)        # #E91E63 - 粉色
DARK_COLOR = (44, 62, 80)           # #2C3E50 - 深蓝灰
LIGHT_BG = (247, 247, 247)          # #F7F7F7 - 浅灰背景
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

def draw_centered_text(draw, text, center_x, center_y, font, fill):
    """绘制居中文本"""
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = center_x - text_width // 2
    y = center_y - text_height // 2
    draw.text((x, y), text, fill=fill, font=font)

def screenshot1_home():
    """截图 1: 首页 - 今日任务 - 最终版"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_card_title = get_font(48)
    font_card_subtitle = get_font(36)
    font_task = get_font(42)
    font_task_sub = get_font(32)
    font_tab = get_font(36)
    font_icon = get_font(40)
    font_plus = get_font(60)
    font_check = get_font(36)
    
    margin = 60
    
    # 标题栏
    draw.text((margin, 100), "FocusFlow", fill=DARK_COLOR, font=font_title)
    
    # ===== 植物成长卡片 =====
    card_y = 220
    card_height = 260
    
    draw.rounded_rectangle(
        [margin, card_y, WIDTH-margin, card_y+card_height], 
        radius=30, fill=WHITE
    )
    
    # 左侧文字
    text_x = margin + 40
    draw.text((text_x, card_y + 40), "我的植物", fill=GRAY, font=font_card_subtitle)
    draw.text((text_x, card_y + 95), "幼苗期", fill=DARK_COLOR, font=font_card_title)
    
    # 右侧图标：绿色圆形 + P 居中
    icon_size = 90
    icon_x = WIDTH - margin - 40 - icon_size
    icon_y = card_y + 40
    
    draw.ellipse([icon_x, icon_y, icon_x+icon_size, icon_y+icon_size], fill=SUCCESS_COLOR)
    draw_centered_text(draw, "P", icon_x + icon_size//2, icon_y + icon_size//2 - 3, font_icon, WHITE)
    
    # 进度条
    bar_y = card_y + 180
    bar_height = 20
    bar_width = WIDTH - margin*2 - 80
    bar_x = margin + 40
    
    draw.rounded_rectangle([bar_x, bar_y, bar_x+bar_width, bar_y+bar_height], radius=10, fill=(230, 230, 230))
    draw.rounded_rectangle([bar_x, bar_y, bar_x+int(bar_width*0.75), bar_y+bar_height], radius=10, fill=SUCCESS_COLOR)
    
    # 积分文字
    draw.text((bar_x, bar_y + 40), "1250 能量点", fill=GRAY, font=font_task_sub)
    
    right_text = "还需 250 点升级"
    rt_bbox = draw.textbbox((0, 0), right_text, font=font_task_sub)
    rt_width = rt_bbox[2] - rt_bbox[0]
    draw.text((WIDTH - margin - 40 - rt_width, bar_y + 40), right_text, fill=GRAY, font=font_task_sub)
    
    # ===== 今日任务标题行 =====
    section_y = card_y + card_height + 70
    draw.text((margin, section_y), "今日任务", fill=DARK_COLOR, font=font_card_title)
    
    # 添加按钮 (+) 居右
    btn_size = 72
    btn_x = WIDTH - margin - btn_size
    btn_y = section_y - 10
    
    draw.ellipse([btn_x, btn_y, btn_x+btn_size, btn_y+btn_size], fill=PRIMARY_COLOR)
    draw_centered_text(draw, "+", btn_x + btn_size//2, btn_y + btn_size//2 - 5, font_plus, WHITE)
    
    # ===== 任务卡片列表 =====
    tasks = [
        ("完成项目报告", "困难", DANGER_COLOR),
        ("回复邮件", "简单", SECONDARY_COLOR),
        ("阅读 30 分钟", "中等", PRIMARY_COLOR),
    ]
    
    card_y = section_y + 100
    card_height = 140
    
    for task_name, difficulty, color in tasks:
        draw.rounded_rectangle([margin, card_y, WIDTH-margin, card_y+card_height], radius=20, fill=WHITE)
        
        # 难度指示点（垂直居中）
        dot_size = 24
        dot_x = margin + 35
        dot_y = card_y + (card_height - dot_size) // 2
        draw.ellipse([dot_x, dot_y, dot_x+dot_size, dot_y+dot_size], fill=color)
        
        # 任务名称和难度
        text_x = dot_x + dot_size + 30
        draw.text((text_x, card_y + 28), task_name, fill=DARK_COLOR, font=font_task)
        draw.text((text_x, card_y + 83), difficulty, fill=GRAY, font=font_task_sub)
        
        # 完成按钮（垂直居中）
        btn_size = 64
        btn_x = WIDTH - margin - 35 - btn_size
        btn_y = card_y + (card_height - btn_size) // 2
        
        draw.ellipse([btn_x, btn_y, btn_x+btn_size, btn_y+btn_size], fill=SUCCESS_COLOR)
        draw_centered_text(draw, "✓", btn_x + btn_size//2, btn_y + btn_size//2 - 3, font_check, WHITE)
        
        card_y += card_height + 20
    
    # ===== 底部 Tab Bar =====
    tab_height = 130
    tab_y = HEIGHT - tab_height
    draw.rectangle([0, tab_y, WIDTH, HEIGHT], fill=WHITE)
    
    tabs = [("今日", True), ("专注", False), ("进度", False), ("徽章", False)]
    tab_width = WIDTH // 4
    
    for i, (label, selected) in enumerate(tabs):
        center_x = i * tab_width + tab_width // 2
        color = PRIMARY_COLOR if selected else GRAY
        draw_centered_text(draw, label, center_x, tab_y + tab_height//2, font_tab, color)
    
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
    
    draw.ellipse([center_x-outer_radius, center_y-outer_radius, center_x+outer_radius, center_y+outer_radius],
                 outline=(230, 230, 230), width=40)
    draw.pieslice([center_x-outer_radius, center_y-outer_radius, center_x+outer_radius, center_y+outer_radius],
                  start=-90, end=126, fill=PRIMARY_COLOR)
    draw.ellipse([center_x-inner_radius, center_y-inner_radius, center_x+inner_radius, center_y+inner_radius],
                 fill=LIGHT_BG)
    
    # 时间文字
    draw.text((center_x-180, center_y-90), "09:42", fill=DARK_COLOR, font=font_time)
    draw.text((center_x-90, center_y+80), "专注中...", fill=SUCCESS_COLOR, font=font_status)
    
    # 控制按钮
    button_y = HEIGHT - 280
    buttons = [("暂停", PRIMARY_COLOR), ("停止", DANGER_COLOR), ("完成", SUCCESS_COLOR)]
    
    btn_radius = 70
    total_width = len(buttons) * (btn_radius * 2 + 40) - 40
    start_x = (WIDTH - total_width) // 2 + btn_radius
    
    for i, (label, color) in enumerate(buttons):
        x = start_x + i * (btn_radius * 2 + 40)
        draw.ellipse([x-btn_radius-10, button_y-btn_radius-10, x+btn_radius+10, button_y+btn_radius+10],
                     fill=(*color, 50) if len(color) == 3 else color)
        draw.ellipse([x-btn_radius, button_y-btn_radius, x+btn_radius, button_y+btn_radius], fill=color)
        draw_centered_text(draw, label, x, button_y - 2, font_button, WHITE)
    
    return img

def screenshot3_badges():
    """截图 3: 徽章墙 - 最终版"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_title = get_font(72)
    font_subtitle = get_font(44)
    font_badge_name = get_font(36)
    font_icon = get_font(40)
    
    margin = 60
    
    # 标题
    draw.text((margin, 100), "徽章墙", fill=DARK_COLOR, font=font_title)
    draw.text((margin, 190), "已解锁 3/20", fill=GRAY, font=font_subtitle)
    
    badges = [
        ("P", "初次萌芽", True, SUCCESS_COLOR),
        ("F", "连续3天", True, DANGER_COLOR),
        ("S", "积分别致", True, PRIMARY_COLOR),
        ("R", "运动达人", False, LIGHT_GRAY),
        ("T", "专注大师", False, LIGHT_GRAY),
        ("G", "任务收藏家", False, LIGHT_GRAY),
        ("B", "早起鸟", False, LIGHT_GRAY),
        ("L", "学习达人", False, LIGHT_GRAY),
    ]
    
    cols = 2
    start_y = 320
    gap_x = 25
    gap_y = 25
    
    card_width = (WIDTH - margin*2 - gap_x) // cols
    card_height = 210
    
    for i, (icon_text, name, unlocked, color) in enumerate(badges):
        row = i // cols
        col = i % cols
        
        x = margin + col * (card_width + gap_x)
        y = start_y + row * (card_height + gap_y)
        
        bg_color = (255, 248, 235) if unlocked else (245, 245, 245)
        draw.rounded_rectangle([x, y, x+card_width, y+card_height], radius=20, fill=bg_color)
        
        # 图标圆形背景
        icon_size = 90
        icon_x = x + (card_width - icon_size) // 2
        icon_y = y + 30
        
        icon_bg_color = color if unlocked else LIGHT_GRAY
        icon_text_color = WHITE if unlocked else (150, 150, 150)
        
        draw.ellipse([icon_x, icon_y, icon_x+icon_size, icon_y+icon_size], fill=icon_bg_color)
        draw_centered_text(draw, icon_text, icon_x + icon_size//2, icon_y + icon_size//2 - 3, font_icon, icon_text_color)
        
        # 徽章名称
        text_color = DARK_COLOR if unlocked else GRAY
        name_bbox = draw.textbbox((0, 0), name, font=font_badge_name)
        name_width = name_bbox[2] - name_bbox[0]
        name_x = x + (card_width - name_width) // 2
        draw.text((name_x, y + card_height - 55), name, fill=text_color, font=font_badge_name)
    
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
    
    # 完成率大卡片
    card_margin = 60
    card_y = 220
    card_height = 320
    
    draw.rounded_rectangle([card_margin, card_y, WIDTH-card_margin, card_y+card_height], radius=30, fill=WHITE)
    
    draw.text((card_margin+50, card_y+50), "本周完成率", fill=GRAY, font=font_card_label)
    draw.text((card_margin+50, card_y+120), "78%", fill=SUCCESS_COLOR, font=font_big_number)
    draw.text((card_margin+50, card_y+270), "比上周提升 12%", fill=GRAY, font=font_card_label)
    
    # 统计数据行
    stats_y = card_y + card_height + 50
    stat_height = 200
    stat_width = (WIDTH - 160) // 2
    
    stats = [("总积分", "1,250", PRIMARY_COLOR), ("连续打卡", "5天", SECONDARY_COLOR)]
    
    for i, (label, value, color) in enumerate(stats):
        x = 60 + i * (stat_width + 40)
        draw.rounded_rectangle([x, stats_y, x+stat_width, stats_y+stat_height], radius=20, fill=WHITE)
        draw.text((x+30, stats_y+30), label, fill=GRAY, font=font_card_label)
        
        num_font = get_font(72)
        draw.text((x+30, stats_y+85), value, fill=color, font=num_font)
    
    # 植物成长阶段
    stage_card_y = stats_y + stat_height + 50
    stage_card_height = 280
    
    draw.rounded_rectangle([card_margin, stage_card_y, WIDTH-card_margin, stage_card_y+stage_card_height], radius=30, fill=WHITE)
    draw.text((card_margin+50, stage_card_y+40), "植物成长阶段", fill=DARK_COLOR, font=font_stage_name)
    
    stages = [("幼苗", True, SUCCESS_COLOR), ("成长", False, LIGHT_GRAY), ("茂盛", False, LIGHT_GRAY), 
              ("开花", False, LIGHT_GRAY), ("结果", False, LIGHT_GRAY)]
    
    stage_width = (WIDTH - card_margin*2 - 100) // len(stages)
    start_x = card_margin + 50
    dot_y = stage_card_y + 120
    dot_size = 24
    
    for i, (name, active, color) in enumerate(stages):
        center_x = start_x + i * stage_width + stage_width // 2
        
        draw.ellipse([center_x-dot_size//2, dot_y, center_x+dot_size//2, dot_y+dot_size], fill=color)
        
        text_width = len(name) * 32
        draw.text((center_x - text_width//2, dot_y + 50), name, fill=color, font=font_stage)
    
    return img

def screenshot5_add_task():
    """截图 5: 添加任务弹窗 - 最终版"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    # 背景遮罩
    draw.rectangle([0, 0, WIDTH, HEIGHT], fill=(0, 0, 0, 80))
    
    font_title = get_font(56)
    font_label = get_font(40)
    font_input = get_font(40)
    font_button = get_font(40)
    
    # 弹窗
    margin = 100
    dialog_y = 380
    dialog_height = 1150
    
    draw.rounded_rectangle([margin, dialog_y, WIDTH-margin, dialog_y+dialog_height], radius=30, fill=WHITE)
    
    # 弹窗标题居中
    draw_centered_text(draw, "添加任务", WIDTH // 2, dialog_y + 80, font_title, DARK_COLOR)
    
    content_margin = margin + 60
    content_width = WIDTH - margin*2 - 120
    
    # 任务名称输入
    input_y = dialog_y + 170
    draw.text((content_margin, input_y), "任务名称", fill=DARK_COLOR, font=font_label)
    
    input_box_y = input_y + 60
    input_box_height = 100
    draw.rounded_rectangle([content_margin, input_box_y, content_margin+content_width, input_box_y+input_box_height],
                          radius=15, fill=(245, 245, 245))
    
    # 输入文字垂直居中
    input_text = "完成项目报告"
    input_bbox = draw.textbbox((0, 0), input_text, font=font_input)
    input_text_height = input_bbox[3] - input_bbox[1]
    input_text_y = input_box_y + (input_box_height - input_text_height) // 2 - 5
    draw.text((content_margin+30, input_text_y), input_text, fill=DARK_COLOR, font=font_input)
    
    # 难度选择
    diff_y = input_box_y + input_box_height + 70
    draw.text((content_margin, diff_y), "任务难度", fill=DARK_COLOR, font=font_label)
    
    difficulties = [("简单", SECONDARY_COLOR, False), ("中等", PRIMARY_COLOR, False), ("困难", DANGER_COLOR, True)]
    
    diff_btn_height = 90
    diff_btn_y = diff_y + 60
    gap = 25
    diff_btn_width = (content_width - gap*2) // 3
    
    for i, (label, color, selected) in enumerate(difficulties):
        x = content_margin + i * (diff_btn_width + gap)
        bg_color = color if selected else (240, 240, 240)
        text_color = WHITE if selected else color
        
        draw.rounded_rectangle([x, diff_btn_y, x+diff_btn_width, diff_btn_y+diff_btn_height], radius=15, fill=bg_color)
        draw_centered_text(draw, label, x + diff_btn_width//2, diff_btn_y + diff_btn_height//2 - 3, font_label, text_color)
    
    # 积分预览
    reward_y = diff_btn_y + diff_btn_height + 90
    draw.text((content_margin, reward_y), "完成奖励", fill=DARK_COLOR, font=font_label)
    
    reward_text = "+30 积分"
    reward_bbox = draw.textbbox((0, 0), reward_text, font=font_label)
    reward_width = reward_bbox[2] - reward_bbox[0]
    draw.text((content_margin + content_width - reward_width, reward_y), reward_text, fill=SUCCESS_COLOR, font=font_label)
    
    # 按钮
    button_y = dialog_y + dialog_height - 180
    button_height = 100
    gap = 30
    button_width = (content_width - gap) // 2
    
    # 取消按钮
    draw.rounded_rectangle([content_margin, button_y, content_margin+button_width, button_y+button_height],
                          radius=15, fill=(230, 230, 230))
    draw_centered_text(draw, "取消", content_margin + button_width//2, button_y + button_height//2 - 3, font_button, DARK_COLOR)
    
    # 添加按钮
    add_btn_x = content_margin + button_width + gap
    draw.rounded_rectangle([add_btn_x, button_y, add_btn_x+button_width, button_y+button_height],
                          radius=15, fill=PRIMARY_COLOR)
    draw_centered_text(draw, "添加", add_btn_x + button_width//2, button_y + button_height//2 - 3, font_button, WHITE)
    
    return img

def main():
    """主函数：生成所有截图"""
    output_dir = "screenshots"
    os.makedirs(output_dir, exist_ok=True)
    
    print("开始生成 FocusFlow App Store 截图 (最终版 v3)...")
    
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

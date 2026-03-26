#!/usr/bin/env python3
"""
FocusFlow App Store 截图自动生成脚本
完全自动化，无需人工介入
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

def create_gradient_background(draw, width, height, color1, color2):
    """创建渐变背景"""
    for y in range(height):
        r = int(color1[0] + (color2[0] - color1[0]) * y / height)
        g = int(color1[1] + (color2[1] - color1[1]) * y / height)
        b = int(color1[2] + (color2[2] - color1[2]) * y / height)
        draw.line([(0, y), (width, y)], fill=(r, g, b))

def draw_rounded_rect(draw, xy, radius, fill, outline=None):
    """绘制圆角矩形"""
    x1, y1, x2, y2 = xy
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline)

def draw_circle_progress(draw, center, radius, progress, color, bg_color):
    """绘制圆形进度条"""
    x, y = center
    # 背景圆
    draw.ellipse([x-radius, y-radius, x+radius, y+radius], outline=bg_color, width=20)
    # 进度弧（简化版）
    import math
    start_angle = -90
    end_angle = start_angle + (360 * progress)
    draw.pieslice([x-radius, y-radius, x+radius, y+radius], start=start_angle, end=end_angle, fill=color)

def get_font(size):
    """获取字体 - 优先使用支持中文的字体"""
    font_paths = [
        "/tmp/NotoSansCJKsc-Bold.otf",  # 下载的中文支持字体
        "/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc",
        "/System/Library/Fonts/PingFang.ttc",  # macOS 中文字体
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
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
    
    font_large = get_font(64)
    font_medium = get_font(48)
    font_small = get_font(36)
    font_title = get_font(56)
    
    # 标题栏
    draw.text((60, 120), "FocusFlow", fill=DARK_COLOR, font=font_large)
    
    # 植物成长卡片
    card_y = 240
    draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+280), 30, WHITE)
    draw.text((100, card_y+40), "我的植物", fill=(128, 128, 128), font=font_small)
    draw.text((100, card_y+100), "幼苗期 🌱", fill=DARK_COLOR, font=font_title)
    
    # 进度条
    bar_y = card_y + 200
    draw_rounded_rect(draw, (100, bar_y, WIDTH-100, bar_y+24), 12, (230, 230, 230))
    draw_rounded_rect(draw, (100, bar_y, 100+int((WIDTH-200)*0.75), bar_y+24), 12, SUCCESS_COLOR)
    draw.text((100, bar_y-50), "1250 能量点", fill=(128, 128, 128), font=font_small)
    draw.text((WIDTH-300, bar_y-50), "还需 250 点升级", fill=(128, 128, 128), font=font_small)
    
    # 今日任务标题
    task_y = 580
    draw.text((60, task_y), "今日任务", fill=DARK_COLOR, font=font_title)
    # 添加按钮
    draw.ellipse([WIDTH-140, task_y, WIDTH-60, task_y+80], fill=PRIMARY_COLOR)
    draw.text((WIDTH-115, task_y+15), "+", fill=WHITE, font=font_large)
    
    # 任务卡片
    tasks = [
        ("完成项目报告", "困难", DANGER_COLOR),
        ("回复邮件", "简单", SECONDARY_COLOR),
        ("阅读 30 分钟", "中等", PRIMARY_COLOR),
    ]
    
    card_y = 680
    for task, diff, color in tasks:
        draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+140), 20, WHITE)
        # 难度指示点
        draw.ellipse([100, card_y+55, 124, card_y+79], fill=color)
        draw.text((160, card_y+35), task, fill=DARK_COLOR, font=font_medium)
        draw.text((160, card_y+85), diff, fill=(128, 128, 128), font=font_small)
        # 完成按钮
        draw.ellipse([WIDTH-140, card_y+35, WIDTH-80, card_y+95], fill=SUCCESS_COLOR)
        draw.text((WIDTH-122, card_y+45), "✓", fill=WHITE, font=font_medium)
        card_y += 170
    
    # 底部 Tab Bar
    tab_y = HEIGHT - 140
    draw.rectangle([0, tab_y, WIDTH, HEIGHT], fill=WHITE)
    tabs = [("📋", "今日", True), ("⏱️", "专注", False), ("📊", "进度", False), ("🏆", "徽章", False)]
    tab_width = WIDTH // 4
    for i, (icon, label, selected) in enumerate(tabs):
        x = i * tab_width + tab_width // 2
        color = PRIMARY_COLOR if selected else (128, 128, 128)
        draw.text((x-30, tab_y+20), icon, fill=color, font=font_medium)
        draw.text((x-40, tab_y+80), label, fill=color, font=font_small)
    
    return img

def screenshot2_timer():
    """截图 2: 专注计时器"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_huge = get_font(120)
    font_medium = get_font(48)
    font_small = get_font(36)
    
    # 标题
    draw.text((60, 120), "专注计时", fill=DARK_COLOR, font=font_large)
    
    # 中心计时器
    center_x, center_y = WIDTH // 2, HEIGHT // 2 - 100
    radius = 280
    
    # 背景圆环
    draw.ellipse([center_x-radius, center_y-radius, center_x+radius, center_y+radius], 
                 outline=(230, 230, 230), width=20)
    
    # 进度弧（60% 进度）
    draw.pieslice([center_x-radius, center_y-radius, center_x+radius, center_y+radius],
                  start=-90, end=126, fill=PRIMARY_COLOR)
    
    # 中心文字
    draw.text((center_x-180, center_y-80), "09:42", fill=DARK_COLOR, font=font_huge)
    draw.text((center_x-80, center_y+80), "专注中...", fill=SUCCESS_COLOR, font=font_medium)
    
    # 控制按钮
    button_y = HEIGHT - 300
    buttons = [("⏸", PRIMARY_COLOR), ("⏹", DANGER_COLOR), ("✓", SUCCESS_COLOR)]
    button_spacing = 200
    start_x = (WIDTH - (len(buttons)-1) * button_spacing) // 2
    
    for i, (icon, color) in enumerate(buttons):
        x = start_x + i * button_spacing
        draw.ellipse([x-60, button_y-60, x+60, button_y+60], fill=(*color, 40))
        draw.ellipse([x-50, button_y-50, x+50, button_y+50], fill=color)
        draw.text((x-20, button_y-30), icon, fill=WHITE, font=font_medium)
    
    return img

def screenshot3_badges():
    """截图 3: 徽章墙"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_medium = get_font(48)
    font_small = get_font(36)
    
    # 标题
    draw.text((60, 120), "徽章墙", fill=DARK_COLOR, font=font_large)
    draw.text((60, 200), "已解锁 3/20", fill=(128, 128, 128), font=font_medium)
    
    # 徽章网格
    badges = [
        ("🌱", "初次萌芽", True),
        ("🔥", "连续3天", True),
        ("⭐", "积分别致", True),
        ("🏃", "运动达人", False),
        ("🎯", "专注大师", False),
        ("💎", "任务收藏家", False),
        ("🌟", "早起鸟", False),
        ("📚", "学习达人", False),
    ]
    
    cols = 2
    badge_width = (WIDTH - 120) // cols
    badge_height = 200
    start_y = 320
    
    for i, (icon, name, unlocked) in enumerate(badges):
        row = i // cols
        col = i % cols
        x = 60 + col * badge_width
        y = start_y + row * (badge_height + 20)
        
        bg_color = (255, 243, 224) if unlocked else (240, 240, 240)
        draw_rounded_rect(draw, (x, y, x+badge_width-20, y+badge_height), 20, bg_color)
        
        opacity = 255 if unlocked else 128
        # 绘制表情符号（用简单图形代替）
        if unlocked:
            draw.text((x+badge_width//2-50, y+30), icon, fill=DARK_COLOR, font=font_large)
            draw.text((x+40, y+130), name, fill=DARK_COLOR, font=font_small)
        else:
            draw.text((x+badge_width//2-50, y+30), "🔒", fill=(180, 180, 180), font=font_large)
            draw.text((x+40, y+130), name, fill=(180, 180, 180), font=font_small)
    
    return img

def screenshot4_progress():
    """截图 4: 进度统计"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_huge = get_font(100)
    font_medium = get_font(48)
    font_small = get_font(36)
    
    # 标题
    draw.text((60, 120), "进度", fill=DARK_COLOR, font=font_large)
    
    # 本周完成率卡片
    card_y = 240
    draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+300), 30, WHITE)
    draw.text((100, card_y+40), "本周完成率", fill=(128, 128, 128), font=font_small)
    draw.text((100, card_y+100), "78%", fill=SUCCESS_COLOR, font=font_huge)
    draw.text((100, card_y+220), "比上周提升 12%", fill=(128, 128, 128), font=font_small)
    
    # 统计数据行
    stats_y = 580
    stats = [("总积分", "1,250", PRIMARY_COLOR), ("连续打卡", "5天", SECONDARY_COLOR)]
    stat_width = (WIDTH - 140) // 2
    
    for i, (label, value, color) in enumerate(stats):
        x = 60 + i * (stat_width + 20)
        draw_rounded_rect(draw, (x, stats_y, x+stat_width, stats_y+200), 20, WHITE)
        draw.text((x+30, stats_y+30), label, fill=(128, 128, 128), font=font_small)
        draw.text((x+30, stats_y+90), value, fill=color, font=font_huge)
    
    # 植物成长阶段
    stage_y = 820
    draw_rounded_rect(draw, (60, stage_y, WIDTH-60, stage_y+280), 30, WHITE)
    draw.text((100, stage_y+40), "植物成长阶段", fill=DARK_COLOR, font=font_medium)
    
    stages = ["🌱", "🌿", "🌳", "🌸", "🍎"]
    stage_width = (WIDTH - 200) // len(stages)
    for i, stage in enumerate(stages):
        x = 100 + i * stage_width
        active = i == 0
        color = SUCCESS_COLOR if active else (200, 200, 200)
        draw.text((x, stage_y+120), stage, fill=DARK_COLOR if active else (180, 180, 180), font=font_large)
        draw.ellipse([x+40, stage_y+220, x+60, stage_y+240], fill=color)
    
    return img

def screenshot5_add_task():
    """截图 5: 添加任务弹窗"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    # 背景遮罩
    draw.rectangle([0, 0, WIDTH, HEIGHT], fill=(0, 0, 0, 100))
    
    font_large = get_font(56)
    font_medium = get_font(44)
    font_small = get_font(36)
    
    # 弹窗
    dialog_margin = 80
    dialog_y = 400
    dialog_height = 800
    draw_rounded_rect(draw, (dialog_margin, dialog_y, WIDTH-dialog_margin, dialog_y+dialog_height), 30, WHITE)
    
    # 标题
    draw.text((WIDTH//2-120, dialog_y+60), "添加任务", fill=DARK_COLOR, font=font_large)
    
    # 任务名称输入
    input_y = dialog_y + 180
    draw.text((dialog_margin+40, input_y), "任务名称", fill=DARK_COLOR, font=font_medium)
    draw_rounded_rect(draw, (dialog_margin+40, input_y+70, WIDTH-dialog_margin-40, input_y+150), 15, (240, 240, 240))
    draw.text((dialog_margin+70, input_y+85), "完成项目报告", fill=DARK_COLOR, font=font_medium)
    
    # 难度选择
    diff_y = input_y + 220
    draw.text((dialog_margin+40, diff_y), "任务难度", fill=DARK_COLOR, font=font_medium)
    
    difficulties = [("简单", SECONDARY_COLOR, False), ("中等", PRIMARY_COLOR, False), ("困难", DANGER_COLOR, True)]
    diff_width = (WIDTH - dialog_margin*2 - 120) // 3
    for i, (label, color, selected) in enumerate(difficulties):
        x = dialog_margin + 40 + i * (diff_width + 30)
        bg = color if selected else (240, 240, 240)
        text_color = WHITE if selected else color
        draw_rounded_rect(draw, (x, diff_y+70, x+diff_width, diff_y+150), 15, bg)
        draw.text((x+diff_width//2-40, diff_y+90), label, fill=text_color, font=font_small)
    
    # 积分预览
    reward_y = diff_y + 220
    draw.text((dialog_margin+40, reward_y), "完成奖励:", fill=DARK_COLOR, font=font_medium)
    draw.text((WIDTH-dialog_margin-250, reward_y), "+30 积分", fill=SUCCESS_COLOR, font=font_medium)
    
    # 按钮
    button_y = dialog_y + dialog_height - 150
    button_width = (WIDTH - dialog_margin*2 - 60) // 2
    
    # 取消按钮
    draw_rounded_rect(draw, (dialog_margin+40, button_y, dialog_margin+40+button_width, button_y+100), 15, (230, 230, 230))
    draw.text((dialog_margin+40+button_width//2-50, button_y+30), "取消", fill=DARK_COLOR, font=font_medium)
    
    # 添加按钮
    draw_rounded_rect(draw, (dialog_margin+60+button_width, button_y, WIDTH-dialog_margin-40, button_y+100), 15, PRIMARY_COLOR)
    draw.text((dialog_margin+60+button_width+button_width//2-50, button_y+30), "添加", fill=WHITE, font=font_medium)
    
    return img

def main():
    """主函数：生成所有截图"""
    output_dir = "screenshots"
    os.makedirs(output_dir, exist_ok=True)
    
    print("开始生成 FocusFlow App Store 截图...")
    
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

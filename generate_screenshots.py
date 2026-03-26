#!/usr/bin/env python3
"""
FocusFlow App Store 截图自动生成脚本 - 修复版
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
BLACK = (0, 0, 0)

def draw_rounded_rect(draw, xy, radius, fill, outline=None):
    """绘制圆角矩形"""
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline)

def get_font(size):
    """获取字体 - 优先使用支持中文的字体"""
    font_paths = [
        "/tmp/NotoSansCJKsc-Bold.otf",
        "/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc",
        "/System/Library/Fonts/PingFang.ttc",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ]
    
    for path in font_paths:
        try:
            return ImageFont.truetype(path, size)
        except:
            continue
    
    return ImageFont.load_default()

# 用彩色圆形代替 emoji
def draw_icon(draw, x, y, size, icon_type, color):
    """绘制图标（代替 emoji）"""
    if icon_type == "plant":  # 🌱 幼苗
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=SUCCESS_COLOR)
        draw.text((x-size//4, y-size//3), "P", fill=WHITE, font=get_font(size//2))
    elif icon_type == "fire":  # 🔥 连续
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=DANGER_COLOR)
        draw.text((x-size//4, y-size//3), "F", fill=WHITE, font=get_font(size//2))
    elif icon_type == "star":  # ⭐ 积分
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=PRIMARY_COLOR)
        draw.text((x-size//4, y-size//3), "S", fill=WHITE, font=get_font(size//2))
    elif icon_type == "run":  # 🏃 运动
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "R", fill=(150, 150, 150), font=get_font(size//2))
    elif icon_type == "target":  # 🎯 专注
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "T", fill=(150, 150, 150), font=get_font(size//2))
    elif icon_type == "gem":  # 💎 收藏
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "G", fill=(150, 150, 150), font=get_font(size//2))
    elif icon_type == "bird":  # 🐦 早起
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "B", fill=(150, 150, 150), font=get_font(size//2))
    elif icon_type == "book":  # 📚 学习
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "L", fill=(150, 150, 150), font=get_font(size//2))
    elif icon_type == "check":  # ✅ 完成
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=SUCCESS_COLOR)
        draw.text((x-size//4, y-size//3), "✓", fill=WHITE, font=get_font(size//2))
    elif icon_type == "lock":  # 🔒 锁定
        draw.ellipse([x-size//2, y-size//2, x+size//2, y+size//2], fill=(200, 200, 200))
        draw.text((x-size//4, y-size//3), "L", fill=(150, 150, 150), font=get_font(size//2))

def screenshot1_home():
    """截图 1: 首页 - 今日任务"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_medium = get_font(44)
    font_small = get_font(32)
    font_title = get_font(52)
    
    # 标题栏
    draw.text((60, 120), "FocusFlow", fill=DARK_COLOR, font=font_large)
    
    # 植物成长卡片
    card_y = 240
    draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+260), 30, WHITE)
    draw.text((100, card_y+30), "我的植物", fill=(128, 128, 128), font=font_small)
    
    # 用图标代替 emoji
    draw.ellipse([WIDTH-180, card_y+30, WIDTH-100, card_y+110], fill=SUCCESS_COLOR)
    draw.text((WIDTH-155, card_y+50), "P", fill=WHITE, font=font_medium)
    
    draw.text((100, card_y+85), "幼苗期", fill=DARK_COLOR, font=font_title)
    
    # 进度条
    bar_y = card_y + 180
    draw_rounded_rect(draw, (100, bar_y, WIDTH-100, bar_y+20), 10, (230, 230, 230))
    draw_rounded_rect(draw, (100, bar_y, 100+int((WIDTH-200)*0.75), bar_y+20), 10, SUCCESS_COLOR)
    
    # 积分文字
    draw.text((100, bar_y-40), "1250 能量点", fill=(128, 128, 128), font=font_small)
    draw.text((WIDTH-280, bar_y-40), "还需 250 点升级", fill=(128, 128, 128), font=font_small)
    
    # 今日任务标题
    task_y = 560
    draw.text((60, task_y), "今日任务", fill=DARK_COLOR, font=font_title)
    # 添加按钮
    draw.ellipse([WIDTH-140, task_y, WIDTH-60, task_y+80], fill=PRIMARY_COLOR)
    draw.text((WIDTH-108, task_y+12), "+", fill=WHITE, font=font_large)
    
    # 任务卡片
    tasks = [
        ("完成项目报告", "困难", DANGER_COLOR),
        ("回复邮件", "简单", SECONDARY_COLOR),
        ("阅读 30 分钟", "中等", PRIMARY_COLOR),
    ]
    
    card_y = 680
    for task, diff, color in tasks:
        draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+130), 20, WHITE)
        # 难度指示点
        draw.ellipse([100, card_y+50, 130, card_y+80], fill=color)
        draw.text((160, card_y+30), task, fill=DARK_COLOR, font=font_medium)
        draw.text((160, card_y+75), diff, fill=(128, 128, 128), font=font_small)
        # 完成按钮
        draw.ellipse([WIDTH-130, card_y+35, WIDTH-70, card_y+95], fill=SUCCESS_COLOR)
        draw.text((WIDTH-108, card_y+48), "✓", fill=WHITE, font=font_medium)
        card_y += 160
    
    # 底部 Tab Bar - 使用文字代替 emoji
    tab_y = HEIGHT - 140
    draw.rectangle([0, tab_y, WIDTH, HEIGHT], fill=WHITE)
    tabs = [("今日", True), ("专注", False), ("进度", False), ("徽章", False)]
    tab_width = WIDTH // 4
    for i, (label, selected) in enumerate(tabs):
        x = i * tab_width + tab_width // 2
        color = PRIMARY_COLOR if selected else (128, 128, 128)
        draw.text((x-40, tab_y+40), label, fill=color, font=font_medium)
    
    return img

def screenshot2_timer():
    """截图 2: 专注计时器"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_huge = get_font(120)
    font_medium = get_font(44)
    font_small = get_font(32)
    
    # 标题
    draw.text((60, 120), "专注计时", fill=DARK_COLOR, font=font_large)
    
    # 中心计时器
    center_x, center_y = WIDTH // 2, HEIGHT // 2 - 100
    radius = 280
    
    # 背景圆环
    draw.ellipse([center_x-radius, center_y-radius, center_x+radius, center_y+radius], 
                 outline=(230, 230, 230), width=20)
    
    # 进度弧（60% 进度）
    # 绘制圆弧使用 pieslice
    draw.pieslice([center_x-radius, center_y-radius, center_x+radius, center_y+radius],
                  start=-90, end=126, fill=PRIMARY_COLOR)
    # 绘制内圆遮盖中心，只保留圆环
    inner_radius = radius - 20
    draw.ellipse([center_x-inner_radius, center_y-inner_radius, 
                  center_x+inner_radius, center_y+inner_radius], fill=LIGHT_BG)
    
    # 中心文字
    draw.text((center_x-165, center_y-80), "09:42", fill=DARK_COLOR, font=font_huge)
    draw.text((center_x-90, center_y+70), "专注中...", fill=SUCCESS_COLOR, font=font_medium)
    
    # 控制按钮
    button_y = HEIGHT - 350
    buttons = [("暂停", PRIMARY_COLOR), ("停止", DANGER_COLOR), ("完成", SUCCESS_COLOR)]
    button_spacing = 220
    start_x = (WIDTH - (len(buttons)-1) * button_spacing) // 2
    
    for i, (label, color) in enumerate(buttons):
        x = start_x + i * button_spacing
        # 按钮背景
        draw.ellipse([x-70, button_y-70, x+70, button_y+70], fill=(*color, 40) if len(color) == 3 else color)
        # 按钮
        draw.ellipse([x-60, button_y-60, x+60, button_y+60], fill=color)
        draw.text((x-50, button_y-25), label, fill=WHITE, font=font_small)
    
    return img

def screenshot3_badges():
    """截图 3: 徽章墙"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_medium = get_font(44)
    font_small = get_font(32)
    
    # 标题
    draw.text((60, 120), "徽章墙", fill=DARK_COLOR, font=font_large)
    draw.text((60, 200), "已解锁 3/20", fill=(128, 128, 128), font=font_medium)
    
    # 徽章网格
    badges = [
        ("plant", "初次萌芽", True),
        ("fire", "连续3天", True),
        ("star", "积分别致", True),
        ("run", "运动达人", False),
        ("target", "专注大师", False),
        ("gem", "任务收藏家", False),
        ("bird", "早起鸟", False),
        ("book", "学习达人", False),
    ]
    
    cols = 2
    badge_width = (WIDTH - 180) // cols
    badge_height = 200
    start_y = 320
    
    for i, (icon_type, name, unlocked) in enumerate(badges):
        row = i // cols
        col = i % cols
        x = 60 + col * (badge_width + 20)
        y = start_y + row * (badge_height + 20)
        
        bg_color = (255, 243, 224) if unlocked else (240, 240, 240)
        text_color = DARK_COLOR if unlocked else (180, 180, 180)
        
        draw_rounded_rect(draw, (x, y, x+badge_width, y+badge_height), 20, bg_color)
        
        # 绘制图标
        icon_color = SUCCESS_COLOR if unlocked else (180, 180, 180)
        if unlocked:
            if icon_type == "plant":
                draw.ellipse([x+badge_width//2-40, y+30, x+badge_width//2+40, y+110], fill=SUCCESS_COLOR)
                draw.text((x+badge_width//2-20, y+50), "P", fill=WHITE, font=font_medium)
            elif icon_type == "fire":
                draw.ellipse([x+badge_width//2-40, y+30, x+badge_width//2+40, y+110], fill=DANGER_COLOR)
                draw.text((x+badge_width//2-20, y+50), "F", fill=WHITE, font=font_medium)
            elif icon_type == "star":
                draw.ellipse([x+badge_width//2-40, y+30, x+badge_width//2+40, y+110], fill=PRIMARY_COLOR)
                draw.text((x+badge_width//2-20, y+50), "S", fill=WHITE, font=font_medium)
        else:
            draw.ellipse([x+badge_width//2-40, y+30, x+badge_width//2+40, y+110], fill=(200, 200, 200))
            draw.text((x+badge_width//2-20, y+50), "L", fill=(150, 150, 150), font=font_medium)
        
        draw.text((x+badge_width//2-len(name)*22, y+130), name, fill=text_color, font=font_small)
    
    return img

def screenshot4_progress():
    """截图 4: 进度统计"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    font_large = get_font(64)
    font_huge = get_font(100)
    font_medium = get_font(44)
    font_small = get_font(32)
    
    # 标题
    draw.text((60, 120), "进度", fill=DARK_COLOR, font=font_large)
    
    # 本周完成率卡片
    card_y = 240
    draw_rounded_rect(draw, (60, card_y, WIDTH-60, card_y+280), 30, WHITE)
    draw.text((100, card_y+40), "本周完成率", fill=(128, 128, 128), font=font_small)
    draw.text((100, card_y+100), "78%", fill=SUCCESS_COLOR, font=font_huge)
    draw.text((100, card_y+210), "比上周提升 12%", fill=(128, 128, 128), font=font_small)
    
    # 统计数据行
    stats_y = 560
    stats = [("总积分", "1,250", PRIMARY_COLOR), ("连续打卡", "5天", SECONDARY_COLOR)]
    stat_width = (WIDTH - 140) // 2
    
    for i, (label, value, color) in enumerate(stats):
        x = 60 + i * (stat_width + 20)
        draw_rounded_rect(draw, (x, stats_y, x+stat_width, stats_y+180), 20, WHITE)
        draw.text((x+30, stats_y+30), label, fill=(128, 128, 128), font=font_small)
        draw.text((x+30, stats_y+80), value, fill=color, font=font_huge)
    
    # 植物成长阶段
    stage_y = 780
    draw_rounded_rect(draw, (60, stage_y, WIDTH-60, stage_y+240), 30, WHITE)
    draw.text((100, stage_y+40), "植物成长阶段", fill=DARK_COLOR, font=font_medium)
    
    stages = [("幼苗", True), ("成长", False), ("茂盛", False), ("开花", False), ("结果", False)]
    stage_width = (WIDTH - 280) // len(stages)
    for i, (stage, active) in enumerate(stages):
        x = 120 + i * stage_width
        color = SUCCESS_COLOR if active else (200, 200, 200)
        # 绘制圆形图标
        draw.ellipse([x+stage_width//2-40, stage_y+100, x+stage_width//2+40, stage_y+180], fill=color)
        draw.text((x+stage_width//2-35, stage_y+120), stage[0], fill=WHITE, font=font_medium)
        # 阶段名称
        draw.text((x+stage_width//2-35, stage_y+195), stage, fill=color, font=font_small)
    
    return img

def screenshot5_add_task():
    """截图 5: 添加任务弹窗"""
    img = Image.new('RGB', (WIDTH, HEIGHT), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    
    # 背景遮罩
    draw.rectangle([0, 0, WIDTH, HEIGHT], fill=(0, 0, 0, 80))
    
    font_large = get_font(56)
    font_medium = get_font(40)
    font_small = get_font(32)
    
    # 弹窗 - 居中显示完整
    dialog_margin = 80
    dialog_y = 500
    dialog_height = 900
    draw_rounded_rect(draw, (dialog_margin, dialog_y, WIDTH-dialog_margin, dialog_y+dialog_height), 30, WHITE)
    
    # 标题
    draw.text((WIDTH//2-100, dialog_y+50), "添加任务", fill=DARK_COLOR, font=font_large)
    
    # 任务名称输入
    input_y = dialog_y + 150
    draw.text((dialog_margin+40, input_y), "任务名称", fill=DARK_COLOR, font=font_medium)
    draw_rounded_rect(draw, (dialog_margin+40, input_y+60, WIDTH-dialog_margin-40, input_y+130), 15, (240, 240, 240))
    draw.text((dialog_margin+70, input_y+80), "完成项目报告", fill=DARK_COLOR, font=font_medium)
    
    # 难度选择
    diff_y = input_y + 200
    draw.text((dialog_margin+40, diff_y), "任务难度", fill=DARK_COLOR, font=font_medium)
    
    difficulties = [("简单", SECONDARY_COLOR, False), ("中等", PRIMARY_COLOR, False), ("困难", DANGER_COLOR, True)]
    diff_width = (WIDTH - dialog_margin*2 - 100) // 3
    for i, (label, color, selected) in enumerate(difficulties):
        x = dialog_margin + 40 + i * (diff_width + 25)
        bg = color if selected else (240, 240, 240)
        text_color = WHITE if selected else color
        draw_rounded_rect(draw, (x, diff_y+60, x+diff_width, diff_y+130), 15, bg)
        draw.text((x+diff_width//2-35, diff_y+80), label, fill=text_color, font=font_small)
    
    # 积分预览 - 修复重叠问题
    reward_y = diff_y + 200
    draw.text((dialog_margin+40, reward_y), "完成奖励:", fill=DARK_COLOR, font=font_medium)
    draw.text((WIDTH-dialog_margin-200, reward_y), "+30 积分", fill=SUCCESS_COLOR, font=font_medium)
    
    # 按钮
    button_y = dialog_y + dialog_height - 150
    button_width = (WIDTH - dialog_margin*2 - 60) // 2
    
    # 取消按钮
    draw_rounded_rect(draw, (dialog_margin+40, button_y, dialog_margin+40+button_width, button_y+90), 15, (230, 230, 230))
    draw.text((dialog_margin+40+button_width//2-40, button_y+30), "取消", fill=DARK_COLOR, font=font_medium)
    
    # 添加按钮
    draw_rounded_rect(draw, (dialog_margin+60+button_width, button_y, WIDTH-dialog_margin-40, button_y+90), 15, PRIMARY_COLOR)
    draw.text((dialog_margin+60+button_width+button_width//2-40, button_y+30), "添加", fill=WHITE, font=font_medium)
    
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

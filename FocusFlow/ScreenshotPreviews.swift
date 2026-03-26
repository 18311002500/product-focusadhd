//
//  ScreenshotPreviews.swift
//  FocusFlow
//
//  用于快速生成 App Store 截图的预览文件
//  使用方法：在 Xcode 中打开此文件，点击 Canvas 中的预览，右键导出图片
//

import SwiftUI

// MARK: - 截图 1: 首页（今日任务）
struct Screenshot1_HomeView: View {
    var body: some View {
        ZStack {
            // 背景
            Color(hex: "#F7F7F7")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 标题栏
                HStack {
                    Text("FocusFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                // 植物成长卡片
                PlantCardPreview()
                    .padding(.horizontal)
                
                // 今日任务
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("今日任务")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "#FF6B35"))
                    }
                    
                    // 任务列表
                    TaskCardPreview(title: "完成项目报告", difficulty: "困难", color: "#E91E63")
                    TaskCardPreview(title: "回复邮件", difficulty: "简单", color: "#4ECDC4")
                    TaskCardPreview(title: "阅读 30 分钟", difficulty: "中等", color: "#FF6B35")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Tab Bar
                HStack(spacing: 0) {
                    TabItemPreview(icon: "checklist", title: "今日", isSelected: true)
                    TabItemPreview(icon: "timer", title: "专注", isSelected: false)
                    TabItemPreview(icon: "chart.line.uptrend.xyaxis", title: "进度", isSelected: false)
                    TabItemPreview(icon: "medal", title: "徽章", isSelected: false)
                }
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
    }
}

// MARK: - 截图 2: 专注计时器
struct Screenshot2_TimerView: View {
    var body: some View {
        ZStack {
            Color(hex: "#F7F7F7")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("专注计时")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Spacer()
                
                // 计时器圆环
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(
                            Color(hex: "#FF6B35"),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 8) {
                        Text("09:42")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#2C3E50"))
                        
                        Text("专注中...")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#27AE60"))
                    }
                }
                
                Spacer()
                
                // 控制按钮
                HStack(spacing: 30) {
                    ControlButtonPreview(icon: "pause.fill", color: "#FF6B35")
                    ControlButtonPreview(icon: "stop.fill", color: "#E91E63")
                    ControlButtonPreview(icon: "checkmark", color: "#27AE60")
                }
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - 截图 3: 徽章墙
struct Screenshot3_BadgesView: View {
    let badges = [
        ("🌱", "初次萌芽", "完成第一个任务", true),
        ("🔥", "连续3天", "连续打卡3天", true),
        ("⭐", "积分别致", "获得100积分", true),
        ("🏃", "运动达人", "日步数过万", false),
        ("🎯", "专注大师", "专注时长10小时", false),
        ("💎", "任务收藏家", "完成50个任务", false),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F7F7F7")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("徽章墙")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("已解锁 3/20")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(badges, id: \.0) { badge in
                            BadgeCardPreview(
                                icon: badge.0,
                                title: badge.1,
                                desc: badge.2,
                                isUnlocked: badge.3
                            )
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - 截图 4: 进度统计
struct Screenshot4_ProgressView: View {
    var body: some View {
        ZStack {
            Color(hex: "#F7F7F7")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("进度")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // 本周完成率
                    ProgressCardPreview(
                        title: "本周完成率",
                        value: "78%",
                        subtitle: "比上周提升 12%",
                        color: "#27AE60"
                    )
                    
                    // 统计数据
                    HStack(spacing: 16) {
                        StatCardPreview(title: "总积分", value: "1,250", color: "#FF6B35")
                        StatCardPreview(title: "连续打卡", value: "5天", color: "#4ECDC4")
                    }
                    .padding(.horizontal)
                    
                    // 植物成长阶段
                    PlantStagePreview()
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - 截图 5: 添加任务
struct Screenshot5_AddTaskView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("添加任务")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 任务输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("任务名称")
                        .font(.headline)
                    TextField("", text: .constant("完成项目报告"))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 44)
                }
                
                // 难度选择
                VStack(alignment: .leading, spacing: 12) {
                    Text("任务难度")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        DifficultyButtonPreview(title: "简单", color: "#4ECDC4", isSelected: false)
                        DifficultyButtonPreview(title: "中等", color: "#FF6B35", isSelected: false)
                        DifficultyButtonPreview(title: "困难", color: "#E91E63", isSelected: true)
                    }
                }
                
                // 积分预览
                HStack {
                    Text("完成奖励:")
                    Spacer()
                    Text("+30 积分")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#27AE60"))
                }
                
                // 按钮
                HStack(spacing: 16) {
                    Button("取消") {}
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    
                    Button("添加") {}
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FF6B35"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .padding(40)
        }
    }
}

// MARK: - 预览组件

struct PlantCardPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("我的植物")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("幼苗期")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Text("🌱")
                    .font(.system(size: 60))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("1250 能量点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("还需 250 点升级")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#27AE60"))
                            .frame(width: geometry.size.width * 0.75, height: 12)
                    }
                }
                .frame(height: 12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

struct TaskCardPreview: View {
    let title: String
    let difficulty: String
    let color: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(hex: color))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(difficulty)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(Color(hex: "#27AE60"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct TabItemPreview: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(title)
                .font(.caption)
        }
        .foregroundColor(isSelected ? Color(hex: "#FF6B35") : .gray)
        .frame(maxWidth: .infinity)
    }
}

struct ControlButtonPreview: View {
    let icon: String
    let color: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.title)
            .foregroundColor(Color(hex: color))
            .frame(width: 70, height: 70)
            .background(Color(hex: color).opacity(0.15))
            .cornerRadius(35)
    }
}

struct BadgeCardPreview: View {
    let icon: String
    let title: String
    let desc: String
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 40))
                .opacity(isUnlocked ? 1 : 0.3)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .opacity(isUnlocked ? 1 : 0.5)
        }
        .frame(width: 100, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isUnlocked ? Color(hex: "#FFF3E0") : Color.gray.opacity(0.1))
        )
    }
}

struct ProgressCardPreview: View {
    let title: String
    let value: String
    let subtitle: String
    let color: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Color(hex: color))
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct StatCardPreview: View {
    let title: String
    let value: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: color))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct PlantStagePreview: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("植物成长阶段")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 20) {
                ForEach(["🌱", "🌿", "🌳", "🌸", "🍎"], id: \.self) { stage in
                    VStack {
                        Text(stage)
                            .font(.system(size: 32))
                            .opacity(stage == "🌱" ? 1 : 0.3)
                        Circle()
                            .fill(stage == "🌱" ? Color(hex: "#27AE60") : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

struct DifficultyButtonPreview: View {
    let title: String
    let color: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(isSelected ? .white : Color(hex: color))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color(hex: color) : Color(hex: color).opacity(0.1))
            .cornerRadius(12)
    }
}

// MARK: - Color 扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - 预览
struct ScreenshotPreviews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone 15 Pro Max 尺寸
            Screenshot1_HomeView()
                .previewLayout(.fixed(width: 430, height: 932))
                .previewDisplayName("1. 首页")
            
            Screenshot2_TimerView()
                .previewLayout(.fixed(width: 430, height: 932))
                .previewDisplayName("2. 专注计时器")
            
            Screenshot3_BadgesView()
                .previewLayout(.fixed(width: 430, height: 932))
                .previewDisplayName("3. 徽章墙")
            
            Screenshot4_ProgressView()
                .previewLayout(.fixed(width: 430, height: 932))
                .previewDisplayName("4. 进度统计")
            
            Screenshot5_AddTaskView()
                .previewLayout(.fixed(width: 430, height: 932))
                .previewDisplayName("5. 添加任务")
        }
    }
}

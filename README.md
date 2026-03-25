# FocusFlow - ADHD生产力工具

[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

<p align="center">
  <img src="screenshots/app_icon.png" alt="FocusFlow Icon" width="120"/>
</p>

## 🎯 产品介绍

FocusFlow是一款专为ADHD（注意力缺陷多动障碍）患者设计的生产力工具。针对传统任务管理工具对ADHD大脑"无效"的痛点，FocusFlow通过游戏化机制、即时正向反馈和身体活动整合，帮助ADHD用户建立可持续的任务完成习惯。

**核心价值**：让ADHD大脑也能享受完成任务的多巴胺奖励

## ✨ 核心功能

### 🎮 游戏化任务系统
- 任务难度分级（简单/中等/困难），不同难度对应不同奖励
- 积分系统：完成任务获得能量点
- 任务池：不强制当天完成，减轻心理负担

### 🏆 即时奖励机制
- **徽章体系**：连续完成、首次达成等20+徽章成就
- **植物成长系统**：虚拟植物随积分增长而成长、开花、结果
- **庆祝动画**：任务完成时的视觉反馈

### ⏱️ ADHD优化专注计时器
- 灵活计时：5/10/15/20分钟可选（非固定25分钟番茄钟）
- 暂停友好：允许暂停不计入失败
- 彩色进度环：直观感受时间流逝

### 📊 视觉化进度
- 今日视图：大按钮、鲜艳色彩的任务列表
- 进度仪表盘：周/月完成率统计
- 成长之路：植物各阶段可视化

### 💪 身体活动整合
- HealthKit集成：读取步数数据
- 活动提醒：久坐提醒功能

## 🎨 设计特点

- **减少认知负荷**：大按钮、简洁文字、清晰层级
- **正向情绪设计**：明亮色彩、圆润形状、庆祝动画
- **即时反馈**：点击有响应、进度可视化

## 📱 截图

<p align="center">
  <img src="screenshots/screenshot1.png" alt="首页" width="250"/>
  <img src="screenshots/screenshot2.png" alt="专注计时器" width="250"/>
  <img src="screenshots/screenshot3.png" alt="进度页" width="250"/>
</p>

*截图占位符 - 请在 App Store 上架后替换为实际截图*

## 🛠️ 技术栈

- **开发语言**：Swift 5.9+
- **UI框架**：SwiftUI
- **最低版本**：iOS 16.0
- **数据持久化**：Core Data + UserDefaults
- **架构模式**：MVVM
- **健康数据**：HealthKit

## 📦 安装

### 要求
- iOS 16.0+
- Xcode 15.0+

### 从源码运行

1. 克隆仓库
```bash
git clone https://github.com/yourusername/product-focusadhd.git
cd product-focusadhd
```

2. 打开项目
```bash
open FocusFlow/FocusFlow.xcodeproj
```

3. 在Xcode中选择目标设备，点击运行

## 💰 定价策略

| 方案 | 价格 | 功能 |
|------|------|------|
| **终身版** | $9.99 | 解锁所有功能，永久使用 |
| **订阅版** | $2.99/月 | 全部功能，按月付费 |

### 免费版限制
- 最多创建10个任务
- 基础专注计时器
- 3个基础徽章

## 🗺️ 路线图

### V1.0 (当前版本)
- ✅ 核心任务系统
- ✅ 基础游戏化
- ✅ 专注计时器
- ✅ 本地数据存储

### V1.1
- Widget小组件
- Siri快捷指令
- 详细数据统计

### V1.2
- 成就分享
- 挑战模式

### V2.0
- iPad/Mac支持
- iCloud同步
- Apple Watch App

## 🏗️ 项目结构

```
FocusFlow/
├── FocusFlow/
│   ├── FocusFlowApp.swift          # 应用入口
│   ├── ContentView.swift           # 主视图
│   ├── Views/                      # UI组件
│   │   ├── HomeView.swift          # 首页
│   │   ├── AddTaskView.swift       # 添加任务
│   │   ├── FocusTimerView.swift    # 专注计时器
│   │   ├── ProgressView.swift      # 进度页
│   │   └── BadgesView.swift        # 徽章墙
│   ├── Models/                     # 数据模型
│   │   ├── CoreDataEntities.swift  # Core Data实体
│   │   ├── PersistenceController.swift
│   │   └── GameModels.swift        # 游戏模型
│   ├── ViewModels/                 # 业务逻辑
│   │   ├── TaskViewModel.swift
│   │   ├── GameViewModel.swift
│   │   └── FocusTimerViewModel.swift
│   └── Utils/                      # 工具类
│       ├── ColorExtensions.swift
│       └── NotificationManager.swift
├── FocusFlowTests/                 # 单元测试
└── FocusFlowUITests/               # UI测试
```

## 🧪 测试

运行单元测试：
```bash
cd FocusFlow
xcodebuild test -scheme FocusFlow -destination 'platform=iOS Simulator,name=iPhone 15'
```

运行UI测试：
```bash
xcodebuild test -scheme FocusFlowUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📄 许可

本项目采用 [MIT 许可证](LICENSE)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📮 联系

如有问题或建议，请通过GitHub Issues联系我们。

---

<p align="center">
  <b>让每一次专注都有意义 🌱</b>
</p>

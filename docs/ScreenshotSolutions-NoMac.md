# 无 Mac 生成 iOS 截图的解决方案

> 针对没有 Mac 的用户，提供多种生成 App Store 截图的方法

---

## 🏆 推荐方案对比

| 方案 | 成本 | 难度 | 质量 | 时间 |
|------|------|------|------|------|
| 在线工具 (AppScreens) | 免费 | ⭐ 简单 | ⭐⭐⭐ 好 | 10分钟 |
| 第三方服务 (ShotBot) | $10-30 | ⭐ 简单 | ⭐⭐⭐⭐⭐ 专业 | 10分钟 |
| 借用朋友 Mac | 免费 | ⭐⭐ 中等 | ⭐⭐⭐⭐⭐ 真实 | 30分钟 |
| 云 Mac 服务 | $1-5/小时 | ⭐⭐⭐ 较难 | ⭐⭐⭐⭐⭐ 真实 | 1小时 |

---

## 方案 1：AppScreens 在线工具（推荐 ⭐⭐⭐⭐⭐）

### 网址
```
https://appscreens.com
```

### 使用步骤

1. **访问网站**
   - 打开 https://appscreens.com
   - 无需注册即可使用基础功能

2. **选择设备**
   ```
   iPhone 15 Pro Max (6.7") - 必选
   iPhone 14 Pro Max (6.7") - 备选
   iPad Pro 12.9" - 如果需要 iPad 截图
   ```

3. **上传截图**
   - 使用手机拍摄 FocusFlow 界面照片
   - 上传到 AppScreens

4. **选择模板**
   - 选择 "App Store Screenshots" 模板
   - 选择背景颜色（建议使用 FocusFlow 品牌色 #FF6B35）

5. **添加文字**
   - 截图 1: "游戏化任务管理"
   - 截图 2: "ADHD友好专注计时器"
   - 截图 3: "徽章成就系统"
   - 截图 4: "可视化进度追踪"
   - 截图 5: "简洁的任务创建"

6. **导出**
   - 点击 Download
   - 保存 5 张截图

### 优点
- ✅ 完全免费
- ✅ 无需 Mac
- ✅ 操作简单
- ✅ 提供 App Store 标准尺寸

---

## 方案 2：ShotBot 专业服务（推荐 ⭐⭐⭐⭐⭐）

### 网址
```
https://shotbot.io
```

### 价格
- 基础版：免费
- 专业版：$10-30/套截图

### 优点
- ✅ 专业设计师模板
- ✅ 一键生成全套截图
- ✅ 支持多语言
- ✅ App Store 优化

---

## 方案 3：借用朋友 Mac（最真实 ⭐⭐⭐⭐⭐）

### 准备工作

1. **将项目推送到 GitHub**（已完成 ✅）

2. **请朋友帮忙执行**
   ```bash
   # 朋友需要执行
   git clone https://github.com/18311002500/product-focusadhd.git
   cd product-focusadhd
   open FocusFlow.xcodeproj
   ```

3. **使用 ScreenshotPreviews.swift**
   - 我已经创建了 `ScreenshotPreviews.swift`
   - 朋友打开后，右键导出截图即可
   - 5 张截图，5 分钟完成

4. **截图发给您**
   - 微信、邮件、云盘分享

---

## 方案 4：云 Mac 服务

### 推荐服务

| 服务 | 网址 | 价格 | 说明 |
|------|------|------|------|
| MacinCloud | macincloud.com | $1-2/小时 | 适合临时使用 |
| AWS EC2 Mac | aws.amazon.com | ~$1.5/小时 | 按小时计费 |
| MacStadium | macstadium.com | $99/月 | 专业云 Mac |

### 使用步骤 (MacinCloud 示例)

1. **注册账号**
   - 访问 macincloud.com
   - 注册并充值

2. **租用 Mac**
   - 选择 "Pay-As-You-Go" 计划
   - 选择 macOS 版本

3. **远程连接**
   - 使用 VNC 或 RDP 连接
   - 安装 Xcode

4. **克隆项目并截图**
   ```bash
   git clone https://github.com/18311002500/product-focusadhd.git
   cd product-focusadhd
   open FocusFlow.xcodeproj
   ```

5. **导出截图**
   - 使用 ScreenshotPreviews.swift 导出
   - 上传到云盘或邮件发送

---

## 📋 我的建议

### 最快方案：AppScreens (10分钟)
```
1. 访问 https://appscreens.com
2. 上传应用界面照片（手机拍的也可以）
3. 选择 iPhone 15 Pro Max 模板
4. 添加文字，导出
```

### 最佳方案：借用朋友 Mac (30分钟)
```
1. 找有 Mac 的朋友
2. 发送 GitHub 仓库链接
3. 让朋友运行 ScreenshotPreviews.swift
4. 导出 5 张截图发给您
```

### 最专业方案：ShotBot ($10-30)
```
1. 访问 https://shotbot.io
2. 上传应用截图
3. 选择专业模板
4. 自动生成全套截图
```

---

## ⚠️ 重要提醒

App Store 审核要求：
- ✅ 截图必须是应用真实界面
- ✅ 不能包含虚假功能
- ✅ 尺寸必须符合要求

**建议优先使用真实截图（借用 Mac）或高质量在线工具。**

---

**创建时间**: 2026-03-26
**版本**: 1.0

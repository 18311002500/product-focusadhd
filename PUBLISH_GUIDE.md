# FocusFlow - App Store 发布前操作指南

> 本指南包含从注册账号到提交审核的完整步骤
> 预计总耗时：2-3 小时
> 费用：$99（Apple Developer 年费）

---

## 📋 操作清单概览

| 步骤 | 任务 | 预计时间 | 费用 |
|------|------|---------|------|
| 1 | 注册 Apple Developer 账号 | 30分钟 | $99 |
| 2 | 配置 App Store Connect | 20分钟 | $0 |
| 3 | 创建 App 记录 | 10分钟 | $0 |
| 4 | 配置 IAP 产品 | 15分钟 | $0 |
| 5 | 准备应用截图 | 30分钟 | $0 |
| 6 | 构建并上传 App | 20分钟 | $0 |
| 7 | 提交审核 | 10分钟 | $0 |
| **总计** | | **2小时35分钟** | **$99** |

---

## 步骤 1：注册 Apple Developer 账号

### 1.1 准备工作
- **Apple ID**: 1125476659@qq.com（已有）
- **支付方式**: Visa/Mastercard 信用卡 或 支付宝
- **实名信息**: 真实姓名、地址、电话

### 1.2 注册流程

**Step 1: 访问开发者网站**
```
网址: https://developer.apple.com
```
- 点击右上角 "Account"
- 使用 Apple ID 登录: 1125476659@qq.com

**Step 2: 加入开发者计划**
1. 点击 "Join the Apple Developer Program"
2. 点击 "Enroll" 按钮
3. 阅读并同意开发者协议

**Step 3: 选择账号类型**
- 选择 **"Individual"**（个人账号）
- 原因：显示个人名字，无需公司注册

**Step 4: 填写个人信息**
```
Legal Name: [您的真实姓名拼音，如 Zhang San]
Address: [真实地址，英文或拼音]
Phone: +86 [您的手机号]
Email: 1125476659@qq.com
```

**Step 5: 付款**
- 金额: $99 USD（约 ¥720 人民币）
- 支付方式: 信用卡或支付宝
- 点击 "Purchase" 完成支付

**Step 6: 等待审核**
- 个人账号：通常 **即时通过** 或最长 24 小时
- 检查邮箱确认邮件

---

## 步骤 2：配置 App Store Connect

### 2.1 登录 App Store Connect
```
网址: https://appstoreconnect.apple.com
```
- 使用 Apple Developer 账号登录

### 2.2 签署协议
1. 点击 "Agreements, Tax, and Banking"
2. 找到 "Paid Applications Agreement"
3. 点击 "Request" 并同意条款

### 2.3 配置税务信息
1. 在 "Tax Forms" 部分点击 "Set Up"
2. 选择 **"U.S. Tax Forms"**
3. 填写 **W-8BEN** 表格（非美国税务居民）
4. 选择 "Individual" 类型
5. 填写姓名、国籍、地址
6. 提交表格

### 2.4 配置收款银行账户
1. 在 "Bank Accounts" 部分点击 "Add Bank Account"
2. 选择国家: **China**
3. 填写银行账户信息：
   - 银行名称
   - 账户持有人姓名
   - 银行账号
   - SWIFT 代码（向银行查询）
4. 保存配置

---

## 步骤 3：创建 App 记录

### 3.1 进入 App 管理
1. 在 App Store Connect 点击 "My Apps"
2. 点击左上角的 **"+"** 按钮
3. 选择 "New App"

### 3.2 填写应用信息

**基本信息：**
```
Platform: iOS
Name: FocusFlow
Primary Language: Simplified Chinese
Bundle ID: com.focusflow.app
SKU: focusflow-001
User Access: Full Access
```

**注意：**
- **Bundle ID** 一旦创建不能修改
- **Name** 如果已被占用，需要更换（如 FocusFlow ADHD）

### 3.3 保存并进入详情页
- 点击 "Create"
- 进入应用详情页面

---

## 步骤 4：配置 IAP（应用内购买）

### 4.1 进入 IAP 配置
1. 在应用详情页左侧菜单点击 "Features"
2. 点击 "In-App Purchases"
3. 点击 **"+"** 创建新产品

### 4.2 创建终身解锁产品

**选择类型：**
- Type: **Non-Consumable**（非消耗型）

**填写产品信息：**
```
Reference Name: 终身解锁
Product ID: com.focusflow.lifetime
Cleared for Sale: ✅ 勾选
```

**定价：**
- Price Tier: Tier 5 ($4.99 USD)

**本地化（中文）：**
```
Display Name: 完整版解锁
Description: 一次付费，永久解锁所有高级功能，包括无限任务、高级徽章、详细统计、云备份等。
```

**本地化（英文）：**
```
Display Name: Full Version Unlock
Description: One-time purchase to unlock all premium features forever, including unlimited tasks, advanced badges, detailed stats, and iCloud backup.
```

**保存：** 点击 "Save"

### 4.3 添加截图（可选，审核用）
- 上传 1-3 张展示付费功能的截图

---

## 步骤 5：准备应用截图

### 5.1 截图规格要求

| 设备 | 尺寸 | 数量 |
|------|------|------|
| iPhone 6.7" | 1290×2796 | 5张 |
| iPhone 6.5" | 1284×2778 | 5张 |
| iPad Pro 12.9" | 2048×2732 | 5张 |

### 5.2 使用模拟器截图

**Step 1: 打开 Xcode**
```bash
# 在终端打开项目
cd /path/to/product-focusadhd
open FocusFlow.xcodeproj
```

**Step 2: 选择模拟器**
- 在 Xcode 顶部选择模拟器（如 iPhone 15 Pro Max）
- 点击运行按钮

**Step 3: 准备截图场景**
按顺序准备以下 5 个界面：

1. **今日任务** - 展示任务列表和植物成长
2. **专注计时器** - 展示计时器界面
3. **徽章页面** - 展示已解锁和未解锁徽章
4. **进度统计** - 展示周/月统计数据
5. **添加任务** - 展示任务创建界面

**Step 4: 截图**
- 在模拟器中使用 **Cmd + S** 截图
- 或从菜单栏 Device → Screenshot
- 保存到桌面

### 5.3 截图优化（可选）
- 使用 Figma 或 Canva 添加文字说明
- 保持风格一致

---

## 步骤 6：构建并上传 App

### 6.1 更新版本信息

**在 Xcode 中：**
1. 打开项目
2. 选择 Target: FocusFlow
3. 进入 "General" 标签
4. 设置：
   ```
   Version: 1.0.0
   Build: 1
   ```

### 6.2 配置签名

1. 进入 "Signing & Capabilities"
2. 确保：
   - Team: 选择您的开发者账号
   - Bundle Identifier: com.focusflow.app
   - Automatically manage signing: ✅ 勾选

### 6.3 构建 Archive

**Step 1: 选择设备**
- 顶部设备选择: **"Any iOS Device (arm64)"**

**Step 2: Archive**
```
菜单栏 → Product → Archive
```
- 等待构建完成（可能需要几分钟）

### 6.4 上传 App

**Step 1: 打开 Organizer**
- Archive 完成后自动打开 Organizer
- 或从菜单栏 Window → Organizer

**Step 2: 分发**
1. 选择最新的 Archive
2. 点击 "Distribute App"
3. 选择: **App Store Connect**
4. 点击 "Next"
5. 选择: **Upload**
6. 点击 "Next"

**Step 3: 签名和上传**
1. 选择自动签名
2. 点击 "Upload"
3. 等待上传完成（可能需要 10-30 分钟）

**成功提示：**
- 看到 "Upload Successful" 表示成功
- 邮件会收到确认通知

---

## 步骤 7：提交审核

### 7.1 进入应用详情

1. 访问 https://appstoreconnect.apple.com
2. 点击 "My Apps"
3. 选择 "FocusFlow"

### 7.2 填写应用信息

**App Information:**
```
Subtitle: ADHD友好的专注力工具
Category: Productivity (主要), Health & Fitness (次要)
```

**Pricing and Availability:**
```
Price: Free
Availability: All countries
```

### 7.3 上传截图

1. 点击左侧 "1.0 Prepare for Submission"
2. 在 "Screenshots" 部分上传：
   - iPhone 6.7" 截图（5张）
   - iPhone 6.5" 截图（5张）
   - iPad Pro 截图（5张，如有）

### 7.4 填写版本信息

**What's New in This Version:**
```
首版本发布，包含：
- 游戏化任务管理系统
- ADHD优化专注计时器
- 徽章成就系统
- 植物成长机制
- 详细进度统计
```

**Promotional Text:**
```
专为ADHD设计的生产力工具，通过游戏化机制帮助您建立专注习惯。
```

**Description:**
```
FocusFlow 是一款专为 ADHD（注意力缺陷多动障碍）用户设计的生产力工具。

【核心功能】
🎮 游戏化任务系统
通过完成任务获得积分，解锁徽章，种植您的虚拟花园。

⏱️ ADHD友好专注计时器
5/10/15/20分钟灵活选择，比传统番茄钟更适合 ADHD 大脑。

🏆 徽章成就系统
完成特定目标解锁独特徽章，正向激励持续进步。

📊 详细统计
追踪您的专注时间、任务完成率，可视化进步轨迹。

💾 数据安全
所有数据本地存储，支持 iCloud 备份，隐私优先。

【为什么选择 FocusFlow？】
- 专为 ADHD 设计，理解您的困难
- 无订阅压力，一次付费终身使用
- 本地存储，无需担心隐私泄露
- 轻量级，不占用手机空间

立即下载，开启您的专注力提升之旅！
```

**Keywords:**
```
ADHD, 专注力, 生产力, 番茄钟, 任务管理, 习惯养成, 时间管理, 效率工具
```

**Support URL:**
```
https://github.com/18311002500/product-focusadhd
```

**Marketing URL:**（可选）
```
https://github.com/18311002500/product-focusadhd
```

### 7.5 选择构建版本

1. 在 "Build" 部分
2. 点击 "+" 或 "Select a build before you submit your app"
3. 选择您刚刚上传的构建版本
4. 点击 "Done"

### 7.6 填写审核信息

**Sign-in Information:**
- 如果应用需要登录，提供测试账号
- 我们的应用：不需要登录，留空

**Contact Information:**
```
First Name: [您的名]
Last Name: [您的姓]
Phone Number: +86 [您的手机号]
Email: 1125476659@qq.com
```

**Notes:**
```
This app is specifically designed for users with ADHD (Attention Deficit Hyperactivity Disorder). 
All data is stored locally on the device with optional iCloud backup.
No user account or login is required.
```

**Attachment:**（可选）
- 如有需要，上传演示视频或额外说明

### 7.7 提交审核

1. 点击右上角 **"Submit for Review"**
2. 回答出口合规问题（通常都选 "No"）
3. 确认内容分级
4. 点击 "Submit"

**成功提示：**
- 应用状态变为 "Waiting for Review"
- 邮件收到确认通知

---

## ⏱️ 审核等待与后续

### 审核时间
- **首次提交**: 1-7 个工作日
- **更新提交**: 1-3 个工作日

### 审核结果

**通过：**
- 应用状态变为 "Ready for Sale"
- 自动上架 App Store
- 邮件通知

**被拒：**
- 查看拒绝原因
- 修改后重新提交
- 常见原因：功能简单、缺少隐私政策、崩溃等

### 上架后操作

1. **分享应用链接**
   ```
   https://apps.apple.com/app/id[您的App ID]
   ```

2. **监控数据**
   - App Store Connect → Analytics
   - 查看下载量、收入、用户反馈

3. **回复用户评论**
   - 积极回复，提升评分

4. **迭代更新**
   - 根据用户反馈优化功能

---

## 🆘 常见问题解决

### Q1: Bundle ID 已被占用？
**解决**: 更换 Bundle ID，如 `com.focusflow.adhd` 或 `com.yourname.focusflow`

### Q2: 应用名称已被占用？
**解决**: 添加副标题，如 "FocusFlow - ADHD专注助手"

### Q3: 上传失败？
**解决**: 
- 检查网络连接
- 确保版本号和构建号递增
- 查看 Xcode 错误日志

### Q4: IAP 未显示？
**解决**:
- 确保 IAP 状态为 "Cleared for Sale"
- 等待几分钟同步
- 在沙盒环境测试

---

## 📞 需要帮助？

- **Apple 开发者支持**: https://developer.apple.com/support
- **GitHub 仓库**: https://github.com/18311002500/product-focusadhd
- **检查清单**: 查看 RELEASE_CHECKLIST.md

---

**文档创建时间**: 2026-03-25  
**版本**: 1.0.0  
**祝发布顺利！** 🚀

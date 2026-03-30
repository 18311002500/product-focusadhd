# CI/CD 设置指南 - 无需 Mac 自动构建

本指南将帮助你配置 GitHub Actions 自动构建 FocusFlow iOS 应用并上传到 App Store，**无需 Mac 电脑**。

---

## 📋 完成设置所需步骤（预计 30-45 分钟）

### 第一步：在 App Store Connect 创建 API Key（10 分钟）

这是认证 GitHub Actions 与 Apple 服务器通信的关键步骤。

1. 访问 https://appstoreconnect.apple.com
2. 使用你的 Apple Developer 账号登录: `1125476659@qq.com`
3. 点击 "用户和访问"（Users and Access）
4. 选择 "集成"（Integrations）标签页
5. 点击 "添加" 按钮创建新 API Key
6. 填写信息：
   - **名称**: `GitHub Actions CI/CD`
   - **访问级别**: `Admin`（或 `App Manager`）
7. 点击 "生成"，你会看到：
   - **Issuer ID**: 类似 `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
   - **Key ID**: 类似 `ABCDEF1234`
8. **重要**：点击 "下载 API Key"，保存 `.p8` 文件

> ⚠️ **警告**：Key 只能下载一次，务必妥善保存！

---

### 第二步：获取 Team ID（1 分钟）

1. 访问 https://developer.apple.com/account
2. 点击 "Membership"
3. 找到 **Team ID**（类似 `ABCD123456`）

---

### 第三步：在 GitHub 添加 Secrets（5 分钟）

这些敏感信息会被安全存储，不会在代码中泄露。

1. 访问 https://github.com/18311002500/product-focusadhd
2. 点击 "Settings"（设置）标签
3. 左侧菜单选择 "Secrets and variables" → "Actions"
4. 点击 "New repository secret" 逐一添加：

| Secret 名称 | 值 | 获取方式 |
|------------|-----|---------|
| `APP_STORE_CONNECT_KEY_ID` | Key ID | 第一步下载的 Key ID |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | 第一步的 Issuer ID |
| `APP_STORE_CONNECT_KEY` | Base64 编码的 Key | 见下方说明 |
| `TEAM_ID` | Team ID | 第二步获取的 Team ID |
| `KEYCHAIN_PASSWORD` | 任意密码 | 例如：`focusflow2024` |

#### 将 .p8 文件转换为 Base64：

**选项 A - 使用网页工具（最简单）：**
1. 访问 https://www.base64encode.org/
2. 粘贴 `.p8` 文件的全部内容
3. 点击编码，复制结果

**选项 B - 使用命令行（如有 WSL）：**
```bash
base64 -i AuthKey_ABCD123456.p8
```

将 Base64 字符串粘贴到 `APP_STORE_CONNECT_KEY` 字段。

---

### 第四步：在 Apple Developer Portal 创建 App ID（3 分钟）

1. 访问 https://developer.apple.com/account
2. 点击 "Identifiers"
3. 点击 "+" 按钮
4. 选择 "App IDs"
5. 选择 "App"
6. 填写信息：
   - **Description**: `FocusFlow`
   - **Bundle ID**: `com.focusflow.app`
7. **勾选功能**：
   - ✅ HealthKit
   - ✅ In-App Purchase
8. 点击 "Continue" → "Register"

---

### 第五步：在 App Store Connect 创建 App 记录（5 分钟）

1. 访问 https://appstoreconnect.apple.com
2. 点击 "我的 App"
3. 点击 "+" 按钮 → "新建 App"
4. 填写信息：
   - **平台**: iOS
   - **名称**: `FocusFlow`（如已被占用，尝试 `FocusFlow - ADHD专注助手`）
   - **主要语言**: 简体中文
   - **套装 ID**: `com.focusflow.app`（下拉选择）
   - **SKU**: `focusflow-001`
   - **用户访问权限**: 完全访问权限
5. 点击 "创建"

---

### 第六步：配置应用信息（10 分钟）

在 App 记录中填写以下信息：

**App 信息**
- **副标题**: `ADHD友好的生产力工具`
- **分类**: 生产力（主要）+ 健康与健身（次要）

**定价和有效性**
- **价格**: 免费
- **可用性**: 所有国家/地区

**版本 1.0 信息**
- **版本号**: `1.0.0`
- **此版本的新增内容**: 
  ```
  首版本发布，包含：
  - 游戏化任务管理系统
  - ADHD优化专注计时器
  - 徽章成就系统
  - 植物成长机制
  - 详细进度统计
  ```

**应用描述**（复制到描述字段）：
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

**关键词**（在 App Store 搜索中使用）：
```
ADHD, 专注力, 生产力, 番茄钟, 任务管理, 习惯养成, 时间管理, 效率工具
```

**技术支持网址**:
```
https://18311002500.github.io/product-focusadhd/
```

---

### 第七步：上传应用截图（5 分钟）

1. 下载项目中的截图文件：`screenshots/` 目录下的 5 张 PNG
2. 在 App Store Connect 中，点击 "1.0 准备提交"
3. 在 "App 预览和截图" 部分上传：
   - **iPhone 6.7" 显示屏**: 1290 × 2796 像素 - 上传 5 张
   - **iPhone 6.5" 显示屏**: 1284 × 2778 像素 - 使用相同截图，GitHub 会自动调整
4. 无需 iPad 截图（如果不上架 iPad 版）

---

### 第八步：配置 IAP（应用内购买）（5 分钟）

1. 在 App Store Connect 左侧菜单点击 "功能"
2. 点击 "App 内购买项目"
3. 点击 "+" 创建新产品：
   - **类型**: 非消耗型
   - **参考名称**: `终身解锁`
   - **产品 ID**: `com.focusflow.lifetime`
   - **Cleared for Sale**: ✅ 勾选
4. **定价**：选择级别 5（$4.99 USD）
5. **本地化**（中文）：
   - **显示名称**: `完整版解锁`
   - **描述**: `一次付费，永久解锁所有高级功能，包括无限任务、高级徽章、详细统计、云备份等。`
6. 点击 "存储"

---

## 🚀 运行自动构建

完成以上所有设置后，即可触发自动构建：

### 方式一：手动触发（推荐首次使用）

1. 访问 GitHub 仓库
2. 点击 "Actions" 标签
3. 在左侧选择 "Build and Deploy to App Store"
4. 点击右侧 "Run workflow"
5. 选择：
   - **Release type**: `testflight`（首次测试）
   - **Version number**: `1.0.0`
   - **Build number**: `1`
6. 点击 "Run workflow"

构建过程大约需要 10-15 分钟。

### 方式二：自动触发

修改 `.github/workflows/deploy.yml` 中的触发条件：

```yaml
on:
  push:
    tags:
      - 'v*'  # 推送 v1.0.0 标签时自动构建
```

---

## ✅ 构建成功后的步骤

1. **TestFlight 测试**（约 30 分钟）
   - 构建完成后，你会收到邮件
   - 下载 TestFlight App
   - 测试应用功能是否正常

2. **提交审核**
   - 在 App Store Connect 中选择构建版本
   - 填写审核信息
   - 点击 "提交以供审核"
   - 等待 1-7 天审核

3. **上线**
   - 审核通过后自动上架
   - 在 Analytics 查看下载数据

---

## 🆘 常见问题

### Q1: 构建失败 "Authentication failed"
**解决**: 检查 GitHub Secrets 是否正确设置，特别是 Base64 编码的 Key

### Q2: Bundle ID 冲突
**解决**: 使用不同的 Bundle ID，如 `com.focusflow.adhd` 或 `com.yourname.focusflow`

### Q3: 应用名称已被占用
**解决**: 使用 `FocusFlow - ADHD专注助手` 或其他变体

### Q4: IAP 未显示
**解决**: 确保 IAP 状态为 "准备提交"，并关联到应用中

### Q5: 证书错误
**解决**: 这是正常的，Fastlane 会自动创建证书。如持续失败，可在 Apple Developer Portal 手动删除旧证书后重试

---

## 📞 需要帮助？

- **Apple 开发者支持**: https://developer.apple.com/support
- **GitHub Actions 文档**: https://docs.github.com/en/actions
- **Fastlane 文档**: https://docs.fastlane.tools

---

## 📁 项目文件说明

| 文件/目录 | 用途 |
|----------|------|
| `.github/workflows/deploy.yml` | GitHub Actions 配置 |
| `fastlane/Fastfile` | Fastlane 自动化脚本 |
| `fastlane/Appfile` | App 基础配置 |
| `project.yml` | xcodegen 项目配置（生成 xcodeproj） |
| `Gemfile` | Ruby 依赖 |
| `FocusFlow.entitlements` | 应用权限（HealthKit、IAP） |

---

**设置完成时间**: 预计 30-45 分钟  
**首次构建时间**: 预计 10-15 分钟  
**祝发布顺利！** 🎉

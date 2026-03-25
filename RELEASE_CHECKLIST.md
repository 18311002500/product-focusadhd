# FocusFlow - App Store 发布检查清单

> 版本: 1.0.0  
> 目标: 提交 App Store 审核

---

## ✅ 开发完成检查

### 核心功能
- [x] 游戏化任务系统
- [x] 专注计时器 (5/10/15/20分钟)
- [x] 徽章成就系统
- [x] 植物成长机制
- [x] 积分系统
- [x] 本地数据存储 (Core Data)
- [x] 应用图标 (所有尺寸)
- [x] IAP (StoreKit) 集成
- [x] 隐私政策
- [x] 单元测试

### Managers 完成
- [x] IAPManager.swift - 应用内购买
- [x] HealthKitManager.swift - HealthKit 集成
- [x] SoundManager.swift - 音效管理
- [x] NotificationManager.swift - 推送通知

---

## 📋 App Store 提交前检查

### 1. 账号与证书
- [ ] 注册 Apple Developer 账号 ($99)
- [ ] 完成账号验证
- [ ] 配置 App Store Connect
- [ ] 配置收款银行账户
- [ ] 创建 App 记录

### 2. 应用元数据
- [x] 应用名称: FocusFlow
- [x] 副标题: ADHD友好的生产力工具
- [x] 应用描述 (中文)
- [x] 应用描述 (英文)
- [x] 关键词列表
- [x] 隐私政策 URL
- [x] 支持 URL

### 3. 截图与预览
- [ ] iPhone 6.7" 截图 (1290×2796) - 5张
- [ ] iPhone 6.5" 截图 (1284×2778) - 5张
- [ ] iPad Pro 12.9" 截图 (2048×2732) - 5张
- [ ] 应用预览视频 (可选)

### 4. 构建与上传
- [ ] 更新版本号 (CFBundleShortVersionString)
- [ ] 更新构建号 (CFBundleVersion)
- [ ] 在 Xcode 中 Archive
- [ ] 上传到 App Store Connect
- [ ] 选择构建版本

### 5. 审核信息
- [ ] 登录信息 (如需要)
- [ ] 审核备注
- [ ] 联系信息

---

## 🎯 IAP 产品配置

需要在 App Store Connect 中配置：

### 产品 1: 终身解锁
- **产品 ID**: com.focusflow.lifetime
- **价格**: $9.99
- **类型**: 非消耗型

### 产品 2: 月度订阅
- **产品 ID**: com.focusflow.monthly
- **价格**: $2.99/月
- **类型**: 自动续期订阅
- **订阅组**: focusflow_premium

---

## 🚀 提交流程

### 步骤 1: 准备
1. 确认所有功能测试通过
2. 在真机上测试
3. 检查内存和性能

### 步骤 2: 构建
```bash
# 在 Xcode 中
1. Product → Archive
2. Distribute App → App Store Connect
3. Upload
```

### 步骤 3: App Store Connect
1. 访问 https://appstoreconnect.apple.com
2. 选择 FocusFlow 应用
3. 填写应用信息
4. 上传截图
5. 选择构建版本
6. 提交审核

---

## ⚠️ 审核注意事项

### 常见被拒原因及避免方法

| 问题 | 解决方案 |
|------|---------|
| 功能过于简单 | 确保有足够功能深度 |
| 缺少隐私政策 | 已在 docs/PrivacyPolicy.md 准备 |
| 崩溃或明显bug | 充分测试后再提交 |
| 误导性描述 | 描述准确，不夸大功能 |
| IAP 问题 | 确保所有产品ID配置正确 |

### 审核时间
- 首次提交: 1-7 天
- 更新提交: 1-3 天

---

## 📊 发布后监控

### 关键指标
- [ ] 下载量
- [ ] 付费转化率
- [ ] 用户评分/评论
- [ ] 崩溃报告
- [ ] 收入统计

### 收入目标
- **目标**: $300/月
- **达成条件**: 约 30-100 付费用户

---

## 🔧 技术信息

### 项目信息
- **仓库**: https://github.com/18311002500/product-focusadhd
- **Bundle ID**: com.focusflow.app (需配置)
- **最低 iOS 版本**: 16.0
- **开发语言**: Swift 5.9+
- **UI 框架**: SwiftUI

### 依赖
- StoreKit (IAP)
- HealthKit (活动追踪)
- Core Data (本地存储)
- UserNotifications (推送)

### 成本
- Apple Developer: $99/年
- 服务器成本: $0 (本地存储)
- 第三方服务: $0

---

## 📞 支持与联系

- **开发者**: FocusFlow Team
- **支持邮箱**: (待配置)
- **隐私政策**: https://18311002500.github.io/product-focusadhd/privacy

---

**检查清单创建时间**: 2026-03-25  
**版本**: 1.0.0  
**状态**: 开发完成，等待账号注册

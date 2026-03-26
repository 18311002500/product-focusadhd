# App Store Connect 创建 App 记录指南

> 本指南说明如何在 App Store Connect 中创建 FocusFlow 应用记录
> 前置条件：Apple Developer 账号已审核通过
> 预计耗时：10-15 分钟

---

## 🎯 目标

在 App Store Connect 中创建 FocusFlow 应用记录，获得：
- ✅ App 唯一标识符
- ✅ App Store 详情页面
- ✅ 可以上传构建版本和截图

---

## 📋 前置条件

- [x] Apple Developer 账号已审核通过
- [x] 已登录 App Store Connect
- [x] 已确定应用名称、Bundle ID

---

## 🚀 操作步骤

### 步骤 1: 登录 App Store Connect

1. 访问：
   ```
   https://appstoreconnect.apple.com
   ```

2. 使用您的 Apple Developer 账号登录
   ```
   账号: 1125476659@qq.com
   ```

---

### 步骤 2: 进入 App 管理页面

1. 登录后，点击首页的 **"我的 App"** (My Apps)
   
   或直接访问：
   ```
   https://appstoreconnect.apple.com/apps
   ```

2. 点击左上角的 **"+"** 按钮

3. 选择 **"新建 App"** (New App)

---

### 步骤 3: 填写应用基本信息

弹出的表单中填写以下信息：

#### 平台 (Platforms)
```
☑️ iOS
```

#### 应用名称 (Name)
```
FocusFlow - ADHD专注助手
```

**注意：**
- 如果名称已被占用，尝试备选方案：
  - `FocusFlow: ADHD生产力工具`
  - `FocusFlow - 专注力训练`
  - `FocusFlow 专注计时器`

#### 主要语言 (Primary Language)
```
简体中文 (Simplified Chinese)
```

#### Bundle ID
```
com.focusflow.app
```

**重要提示：**
- Bundle ID 一旦创建**不能修改**
- 确保与应用代码中的 Bundle ID 一致
- 如果已被占用，使用备选：
  - `com.focusflow.adhd`
  - `com.yourname.focusflow`

#### SKU
```
focusflow-001
```

**说明：**
- SKU 是内部使用的唯一标识
- 可以是任意字符串，建议使用应用名+序号

#### 用户访问权限 (User Access)
```
☑️ 完全访问权限 (Full Access)
```

---

### 步骤 4: 创建应用

1. 确认所有信息填写正确
2. 点击 **"创建"** (Create) 按钮
3. 等待系统创建应用记录（约几秒）

---

### 步骤 5: 进入应用详情页

创建成功后，会自动进入应用详情页。

页面左侧菜单包括：
```
📱 App Information        - 应用信息
💰 Pricing and Availability - 定价和可用性
🖼️ 1.0 Prepare for Submission - 准备提交（截图、描述等）
🎁 Features               - 功能（IAP、Game Center等）
📊 App Analytics          - 应用分析
⚙️ TestFlight            - 测试分发
```

---

### 步骤 6: 填写应用信息 (App Information)

点击左侧 **"App Information"**

#### 副标题 (Subtitle)
```
游戏化任务管理，建立专注习惯
```

#### 类别 (Category)
```
主要类别: 效率 (Productivity)
次要类别: 健康健美 (Health & Fitness)
```

#### 内容版权 (Content Rights)
```
此应用不包含第三方内容
```

#### 年龄分级 (Age Rating)
```
4+ 岁
```

**说明：**
- 选择 "4+" 表示适合所有年龄
- 如包含 HealthKit 等功能，可能需要调整

---

### 步骤 7: 设置定价和可用性

点击左侧 **"Pricing and Availability"**

#### 价格 (Price)
```
免费 (Free)
```

#### 可用性 (Availability)
```
所有国家或地区 (All countries or regions)
```

或选择特定地区：
```
☑️ 中国大陆
☑️ 中国香港
☑️ 中国台湾
☑️ 美国
☑️ 日本
...（其他目标市场）
```

#### 预定发布 (Pre-Order)（可选）
```
不启用预定发布
```

---

### 步骤 8: 保存设置

1. 点击页面右上角的 **"存储"** (Save) 按钮
2. 确认所有更改已保存

---

## ✅ 创建完成检查清单

- [ ] App 记录在 App Store Connect 中可见
- [ ] 应用名称正确显示
- [ ] Bundle ID 与应用代码一致
- [ ] 类别设置正确（效率 + 健康健美）
- [ ] 定价设置为免费
- [ ] 目标市场已选择

---

## 📋 下一步操作

App 记录创建完成后，继续以下步骤：

1. **配置 IAP 产品**
   - 进入 "Features" → "In-App Purchases"
   - 创建终身解锁产品

2. **上传应用截图**
   - 进入 "1.0 Prepare for Submission"
   - 上传 iPhone 和 iPad 截图

3. **填写版本信息**
   - 应用描述、关键词、更新说明

4. **上传构建版本**
   - 在 Xcode 中 Archive 并上传

5. **提交审核**
   - 确认所有信息
   - 提交给 Apple 审核

---

## 🆘 常见问题

### Q1: Bundle ID 已被占用？
**解决：**
- 使用备选 Bundle ID，如 `com.focusflow.adhd`
- 在 Xcode 中修改 Bundle Identifier
- 确保代码和 App Store Connect 一致

### Q2: 应用名称已被占用？
**解决：**
- 添加副标题区分，如 "FocusFlow - ADHD专注助手"
- 使用备选名称
- 确认没有其他应用使用相同名称

### Q3: 创建后找不到应用？
**解决：**
- 检查是否登录了正确的 Apple Developer 账号
- 在 "My Apps" 页面使用搜索功能
- 确认应用创建成功（可能有延迟）

### Q4: 可以修改 Bundle ID 吗？
**解决：**
- **不能修改已创建的 Bundle ID**
- 如需更改，必须删除应用重新创建
- 删除应用会丢失所有数据，谨慎操作

---

## 📞 帮助与支持

- **App Store Connect 帮助**: https://help.apple.com/app-store-connect/
- **Apple 开发者支持**: https://developer.apple.com/support/

---

## 📊 完成状态

创建完成后，您将获得：

| 项目 | 值 | 用途 |
|------|-----|------|
| App 名称 | FocusFlow - ADHD专注助手 | 显示在 App Store |
| Bundle ID | com.focusflow.app | 应用唯一标识 |
| App ID | 自动分配 | 用于分析、推广链接 |

---

**创建时间**: 2026-03-26
**版本**: 1.0

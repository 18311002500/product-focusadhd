# FocusFlow - GitHub 上传指南

## 📊 项目完成状态

| 项目 | 状态 | 说明 |
|------|------|------|
| 产品设计文档 (PRD) | ✅ | 完整的需求分析、功能设计 |
| iOS App 代码 | ✅ | SwiftUI + Core Data，17个Swift文件 |
| 单元测试 | ✅ | 基础测试覆盖 |
| Git 本地仓库 | ✅ | 已提交，等待推送 |
| GitHub 远程上传 | ⏳ | 需要 Personal Access Token |

## 🔐 为什么需要手动上传？

**GitHub 安全政策更新 (2021年8月起):**
- ❌ 不再支持密码直接认证
- ✅ 必须使用 Personal Access Token (PAT) 或 SSH Key
- ✅ 这是为了保护用户账号安全

## 🚀 上传方式 (三选一)

### 方式一：使用自动脚本 (推荐)

在终端运行：
```bash
cd /home/xctc/.openclaw/workspace/product-focusadhd
bash upload-to-github.sh
```

脚本会引导您创建 Token 并完成上传。

---

### 方式二：手动命令行上传

**步骤 1: 创建 Personal Access Token**
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. Note 填写: `FocusFlow Token`
4. Expiration 选择: `90 days`
5. 勾选权限: ☑️ **repo** (完整仓库访问)
6. 点击 "Generate token"
7. **复制生成的 token** (格式: `ghp_xxxxxxxxxxxx`)

**步骤 2: 推送代码**
```bash
cd /home/xctc/.openclaw/workspace/product-focusadhd

# 使用 token 推送
git remote set-url origin "https://1125476659:YOUR_TOKEN@github.com/1125476659/product-focusadhd.git"
git push -u origin main

# 清理 (推送后执行，删除 token 历史)
git remote set-url origin https://github.com/1125476659/product-focusadhd.git
```

---

### 方式三：GitHub Web 界面手动上传

1. 访问 https://github.com/new
2. Repository name: `product-focusadhd`
3. Description: `FocusFlow - ADHD productivity app with gamification`
4. 选择 "Public"
5. 点击 "Create repository"
6. 按页面提示的命令上传代码

---

## 📁 项目结构预览

```
product-focusadhd/
├── 📄 PRD.md                    # 产品需求文档 (详细)
├── 📄 README.md                 # 项目说明
├── 📄 LICENSE                   # MIT 许可证
├── 🚀 upload-to-github.sh       # 上传辅助脚本
├── 💻 FocusFlow/                # 主应用代码
│   ├── FocusFlowApp.swift
│   ├── Views/                   # 5个视图组件
│   ├── ViewModels/              # 3个ViewModel
│   ├── Models/                  # Core Data模型
│   └── Utils/                   # 工具类
├── 🧪 FocusFlowTests/           # 测试代码
└── 🎯 FocusFlow.xcodeproj/      # Xcode项目
```

**代码统计:**
- Swift 文件: 17个
- 代码行数: 约 2800+ 行
- 测试文件: 2个

---

## ✅ 上传后检查清单

- [ ] 访问 https://github.com/1125476659/product-focusadhd 确认代码已上传
- [ ] 检查 README.md 显示正常
- [ ] 确认所有 Swift 文件已上传
- [ ] 检查 LICENSE 文件

---

## 🆘 故障排除

**问题 1: "Invalid username or token"**
- 原因: Token 不正确或已过期
- 解决: 重新创建 Token，确保复制完整

**问题 2: "Repository not found"**
- 原因: 仓库不存在
- 解决: 先在 GitHub 网页创建仓库

**问题 3: "Permission denied"**
- 原因: Token 权限不足
- 解决: 创建 Token 时勾选 "repo" 权限

---

## 📞 需要帮助？

如果遇到问题，可以：
1. 运行 `bash upload-to-github.sh` 使用交互式脚本
2. 查看 GitHub 官方文档: https://docs.github.com/en/authentication
3. 使用 GitHub Desktop 客户端进行图形化操作

---

**文档创建时间**: 2026-03-25  
**项目版本**: v1.0.0 MVP

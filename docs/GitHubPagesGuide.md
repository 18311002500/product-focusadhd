# GitHub Pages 隐私政策部署指南

> 本指南说明如何将 FocusFlow 隐私政策部署到 GitHub Pages
> 费用：免费 | 预计耗时：10 分钟

---

## 🎯 目标

创建一个可通过以下 URL 访问的隐私政策页面：
```
https://18311002500.github.io/product-focusadhd/
```

这个 URL 将用于：
- ✅ App Store 提交时的 "Privacy Policy URL"
- ✅ 应用内的隐私政策链接
- ✅ 用户支持文档

---

## 📋 前置条件

- [x] 已有 GitHub 账号 (18311002500)
- [x] 代码已推送到 GitHub 仓库
- [x] 隐私政策 HTML 文件已准备好 (`docs/index.html`)

---

## 🚀 部署步骤

### 步骤 1: 确认文件位置

确保 `docs/index.html` 存在于您的仓库中：

```
product-focusadhd/
├── docs/
│   └── index.html          ← 隐私政策页面
├── FocusFlow/
├── README.md
└── ...
```

**文件内容确认：**
- ✅ 包含完整的隐私政策文本
- ✅ 使用了 FocusFlow 品牌颜色 (#FF6B35)
- ✅ 包含联系方式
- ✅ 响应式设计（适配手机和电脑）

---

### 步骤 2: 推送代码到 GitHub

如果 `docs/index.html` 还未提交：

```bash
# 进入项目目录
cd /path/to/product-focusadhd

# 添加文件
git add docs/index.html

# 提交
git commit -m "Add privacy policy page for GitHub Pages"

# 推送到 GitHub
git push origin main
```

---

### 步骤 3: 启用 GitHub Pages

**方法 1: 通过 GitHub 网站（推荐）**

1. 访问仓库页面：
   ```
   https://github.com/18311002500/product-focusadhd
   ```

2. 点击顶部菜单 **"Settings"**（设置）

3. 在左侧菜单中找到 **"Pages"**（页面），点击打开

4. 在 "Source" 部分：
   - Branch: 选择 **"main"** 或 **"master"**
   - Folder: 选择 **"/docs"**
   - 点击 **"Save"**（保存）

   ![GitHub Pages Settings](https://docs.github.com/assets/images/help/pages/publishing-source-folder.png)

5. 等待 1-5 分钟，页面会显示：
   ```
   Your site is published at https://18311002500.github.io/product-focusadhd/
   ```

---

**方法 2: 通过 GitHub Actions（高级）**

如果您希望使用 GitHub Actions 自动部署：

1. 创建文件 `.github/workflows/pages.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs
```

2. 提交并推送：
```bash
git add .github/workflows/pages.yml
git commit -m "Add GitHub Actions workflow for Pages"
git push
```

---

### 步骤 4: 验证部署

**检查步骤：**

1. 打开浏览器，访问：
   ```
   https://18311002500.github.io/product-focusadhd/
   ```

2. 确认页面显示：
   - ✅ FocusFlow 隐私政策标题
   - ✅ 完整的隐私政策内容
   - ✅ 格式正确，无乱码
   - ✅ 在手机上显示正常（响应式）

3. 测试链接：
   - 所有内部链接正常
   - 外部链接（如 Apple 隐私政策）可点击

---

### 步骤 5: 更新项目文档

在以下文件中更新隐私政策 URL：

**1. README.md**
```markdown
## 📄 隐私政策

详细隐私政策请访问：
https://18311002500.github.io/product-focusadhd/
```

**2. App Store 元数据**
在 App Store Connect 中填写：
```
Privacy Policy URL: https://18311002500.github.io/product-focusadhd/
```

**3. 应用内代码（如需要）**
在 `FocusFlow/Views/SettingsView.swift` 中添加：
```swift
Button("隐私政策") {
    if let url = URL(string: "https://18311002500.github.io/product-focusadhd/") {
        UIApplication.shared.open(url)
    }
}
```

---

## 🔧 自定义域名（可选）

如果您有自己的域名，可以配置自定义域名：

### 步骤 1: 添加 CNAME 文件

创建文件 `docs/CNAME`：
```
privacy.focusflow.app
```

### 步骤 2: 配置 DNS

在您的域名服务商处添加 DNS 记录：

| 类型 | 主机 | 值 |
|------|------|-----|
| CNAME | privacy | 18311002500.github.io |

### 步骤 3: 启用 HTTPS

1. 在 GitHub Pages 设置中
2. 勾选 "Enforce HTTPS"
3. 等待证书颁发（可能需要 24 小时）

---

## 📊 部署检查清单

- [ ] `docs/index.html` 文件已创建
- [ ] 文件已推送到 GitHub
- [ ] GitHub Pages 已启用（source: /docs）
- [ ] 页面可以正常访问
- [ ] 页面内容完整、格式正确
- [ ] 隐私政策 URL 已记录在 App Store 元数据中

---

## 🆘 常见问题

### Q1: 页面显示 404？
**解决：**
- 确认文件名为 `index.html`（小写）
- 确认文件在 `docs/` 文件夹中
- 等待 5-10 分钟后刷新
- 检查 GitHub Pages 设置中的 Branch 是否正确

### Q2: 页面样式丢失？
**解决：**
- 检查 HTML 中的 CSS 是否正确
- 确认所有资源路径使用相对路径
- 在浏览器中按 F12 查看控制台错误

### Q3: 如何更新隐私政策？
**解决：**
- 直接编辑 `docs/index.html`
- 提交并推送到 GitHub
- 更改会在几分钟内自动生效

### Q4: GitHub Pages 有访问限制吗？
**解答：**
- 公共仓库：无限制，免费
- 私有仓库：需要 GitHub Pro 才能使用 Pages
- 您的仓库是公共的，所以完全免费

### Q5: 可以同时托管多个页面吗？
**解答：**
- 每个仓库只能有一个 GitHub Pages 站点
- 可以通过子路径访问其他页面，如：
  ```
  /docs/terms.html → https://.../terms.html
  /docs/support.html → https://.../support.html
  ```

---

## 📞 帮助与支持

- **GitHub Pages 文档**: https://docs.github.com/en/pages
- **GitHub 支持**: https://support.github.com

---

## ✅ 完成状态

部署完成后，您将获得：

| 项目 | URL | 用途 |
|------|-----|------|
| 隐私政策 | https://18311002500.github.io/product-focusadhd/ | App Store 提交 |
| 项目主页 | https://github.com/18311002500/product-focusadhd | 代码仓库 |

---

**创建时间**: 2026-03-26
**版本**: 1.0

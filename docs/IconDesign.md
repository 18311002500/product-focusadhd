# FocusFlow 应用图标设计规范

## 设计理念

**主题：** 成长与专注

**核心元素：** 
- 🌱 幼苗/植物 - 代表成长
- 🎯 靶心/箭头 - 代表专注目标
- 渐变色彩 - 代表活力与积极性

## 设计风格

- **简洁现代**：扁平化设计，易于识别
- **色彩明亮**：使用应用主色调（橙红渐变）
- **高辨识度**：在 App Store 列表中脱颖而出
- **适应性强**：在各种尺寸下都清晰可见

## 色彩方案

**主色：**
- 起始色：`#FF6B35` (活力橙)
- 结束色：`#FF8E53` (温暖橙)

**辅助色：**
- 植物绿：`#27AE60`
- 背景渐变：`#FF6B35` → `#FF8E53`

## 图标规格

### 必需尺寸

| 尺寸 | 用途 | 文件名 |
|-----|------|--------|
| 1024×1024 | App Store | Icon-1024.png |
| 180×180 | iPhone @3x | Icon-60@3x.png |
| 120×120 | iPhone @2x | Icon-60@2x.png |
| 167×167 | iPad Pro @2x | Icon-83.5@2x.png |
| 152×152 | iPad @2x | Icon-76@2x.png |
| 76×76 | iPad @1x | Icon-76.png |
| 120×120 | iPhone Spotlight @3x | Icon-40@3x.png |
| 80×80 | iPhone Spotlight @2x | Icon-40@2x.png |
| 87×87 | iPhone Settings @3x | Icon-29@3x.png |
| 58×58 | iPhone Settings @2x | Icon-29@2x.png |
| 60×60 | iPhone Notification @3x | Icon-20@3x.png |
| 40×40 | iPhone Notification @2x | Icon-20@2x.png |

### 生成脚本

你可以使用以下命令生成所有图标尺寸（需要安装 ImageMagick）：

```bash
# 从 1024x1024 主图标生成所有尺寸
convert Icon-1024.png -resize 180x180 Icon-60@3x.png
convert Icon-1024.png -resize 120x120 Icon-60@2x.png
convert Icon-1024.png -resize 167x167 Icon-83.5@2x.png
convert Icon-1024.png -resize 152x152 Icon-76@2x.png
convert Icon-1024.png -resize 76x76 Icon-76.png
convert Icon-1024.png -resize 120x120 Icon-40@3x.png
convert Icon-1024.png -resize 80x80 Icon-40@2x.png
convert Icon-1024.png -resize 87x87 Icon-29@3x.png
convert Icon-1024.png -resize 58x58 Icon-29@2x.png
convert Icon-1024.png -resize 60x60 Icon-20@3x.png
convert Icon-1024.png -resize 40x40 Icon-20@2x.png
convert Icon-1024.png -resize 29x29 Icon-29.png
convert Icon-1024.png -resize 40x40 Icon-40.png
convert Icon-1024.png -resize 20x20 Icon-20.png
```

## 图标设计草图

### 设计A：目标植物（推荐）

```
┌────────────────────────────────────┐
│                                    │
│         ░░░░░░░░░░░░               │
│       ░░▓▓▓▓▓▓▓▓▓▓░░               │
│      ░░▓▓  🌱  ▓▓░░                │
│     ░░▓▓  ╱ ╲  ▓▓░░                │
│     ░▓▓  ╱   ╲ ▓▓░                 │
│    ░░▓▓ ╱  ●  ╲▓▓░                 │  ● = 靶心
│    ░░▓▓╱       ▓▓░                 │  🌱 = 生长的植物
│     ░▓▓  🎯    ▓▓░                 │  🎯 = 目标/专注
│      ░▓▓▓▓▓▓▓▓▓▓░                  │
│       ░░░░░░░░░░░░                 │
│                                    │
└────────────────────────────────────┘
```

**特点：**
- 中心是靶心（专注目标）
- 靶心上长出幼苗（成长）
- 圆形背景，橙红渐变

### 设计B：专注时钟

```
┌────────────────────────────────────┐
│                                    │
│         ░░░░░░░░░░░░               │
│       ░░▓▓▓▓▓▓▓▓▓▓░░               │
│      ░░▓▓   12   ▓▓░░              │
│     ░░▓▓  9 🌱 3  ▓▓░░              │
│     ░▓▓     ╱     ▓▓░               │
│    ░░▓▓    ●────  ▓▓░               │  ● = 中心点
│    ░░▓▓           ▓▓░               │  🌱 = 秒针（叶子形状）
│     ░▓▓    6      ▓▓░               │
│      ░▓▓▓▓▓▓▓▓▓▓░                  │
│       ░░░░░░░░░░░░                 │
│                                    │
└────────────────────────────────────┘
```

## 在线图标生成工具

你可以使用以下免费工具生成图标：

1. **App Icon Generator** - https://appicon.co/
   - 上传 1024×1024 PNG，自动生成所有尺寸

2. **Figma Icon Template** - 搜索 "iOS App Icon Template"
   - 使用 Figma 设计后直接导出

3. **Canva** - https://www.canva.com/
   - 使用模板设计图标

## 设计检查清单

- [ ] 图标尺寸为 1024×1024 像素
- [ ] PNG 格式，无透明度（圆角由系统自动处理）
- [ ] 色彩模式为 RGB
- [ ] 文字清晰可读（如果有文字）
- [ ] 在各种背景色下都清晰可见
- [ ] 简洁设计，在小尺寸下依然清晰
- [ ] 符合 App Store 审核指南

## 注意事项

1. **不要使用透明背景** - iOS 会自动应用圆角
2. **不要添加光泽效果** - 这是 iOS 6 时代的设计
3. **不要使用白色背景** - 在白色背景的设置页面会看不见
4. **确保对比度** - 确保图标在深色和浅色模式下都清晰可见

## 替代方案：使用 SF Symbols

如果你不想设计自定义图标，可以使用 SF Symbols 组合：

```swift
Image(systemName: "target")
    .foregroundColor(.orange)
    .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.orange.opacity(0.2))
    )
```

但建议还是使用自定义设计，让应用在 App Store 中更具辨识度。

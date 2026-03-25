#!/bin/bash
# GitHub 代码上传脚本 - FocusFlow ADHD生产力工具
# 运行方式: bash upload-to-github.sh

echo "=========================================="
echo "  FocusFlow - GitHub 上传脚本"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd /home/xctc/.openclaw/workspace/product-focusadhd

echo -e "${YELLOW}步骤 1/4: 检查 Git 仓库状态...${NC}"
git status --short
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Git 仓库状态正常${NC}"
else
    echo -e "${RED}✗ Git 仓库检查失败${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}步骤 2/4: 配置 GitHub 认证...${NC}"
echo ""
echo "GitHub 已于 2021 年 8 月停止使用密码验证。"
echo "请按以下步骤创建 Personal Access Token (PAT):"
echo ""
echo "1. 访问 https://github.com/settings/tokens"
echo "2. 点击 'Generate new token (classic)'"
echo "3. 输入 Note: FocusFlow Token"
echo "4. 选择有效期 (建议 90 天)"
echo "5. 勾选权限: repo (完整仓库访问)"
echo "6. 点击 'Generate token'"
echo "7. 复制生成的 token (ghp_xxxxxxxxxxxx)"
echo ""

# 提示用户输入 token
read -sp "请输入您的 GitHub Personal Access Token: " TOKEN
echo ""

if [ -z "$TOKEN" ]; then
    echo -e "${RED}✗ Token 不能为空${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}步骤 3/4: 配置远程仓库...${NC}"
git remote remove origin 2>/dev/null
git remote add origin "https://1125476659:${TOKEN}@github.com/1125476659/product-focusadhd.git"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 远程仓库配置成功${NC}"
else
    echo -e "${RED}✗ 远程仓库配置失败${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}步骤 4/4: 推送代码到 GitHub...${NC}"
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}  ✅ 代码上传成功!${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo ""
    echo "仓库地址: https://github.com/1125476659/product-focusadhd"
    echo ""
    echo "项目文件统计:"
    find . -name "*.swift" | wc -l | xargs echo "  Swift 文件数:"
    git log --oneline -1 | xargs echo "  最新提交:"
else
    echo ""
    echo -e "${RED}==========================================${NC}"
    echo -e "${RED}  ❌ 上传失败${NC}"
    echo -e "${RED}==========================================${NC}"
    echo ""
    echo "可能的原因:"
    echo "  - Token 权限不足 (需要勾选 'repo')"
    echo "  - Token 已过期"
    echo "  - 网络连接问题"
    echo ""
    echo "请重试或手动上传:"
    echo "  1. 访问 https://github.com/new"
    echo "  2. 创建名为 'product-focusadhd' 的仓库"
    echo "  3. 按页面提示上传代码"
fi

# 清理 token
git remote remove origin 2>/dev/null
git remote add origin https://github.com/1125476659/product-focusadhd.git 2>/dev/null

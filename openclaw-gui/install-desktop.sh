#!/bin/bash

# 安装 OpenClaw 桌面快捷方式

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_FILE="$SCRIPT_DIR/openclaw-gui.desktop"
USER_DESKTOP="$HOME/Desktop"

echo "正在安装 OpenClaw 桌面快捷方式..."

# 检查桌面目录
if [ ! -d "$USER_DESKTOP" ]; then
    echo "创建桌面目录: $USER_DESKTOP"
    mkdir -p "$USER_DESKTOP"
fi

# 复制到桌面
cp "$DESKTOP_FILE" "$USER_DESKTOP/"

# 设置执行权限
chmod +x "$USER_DESKTOP/openclaw-gui.desktop"
chmod +x "$SCRIPT_DIR/launch.sh"

echo "✓ 快捷方式已安装到桌面"
echo ""
echo "现在可以在桌面双击 'OpenClaw AI 助手' 图标启动应用"
echo ""
echo "提示: 如果双击没有反应，请右键点击图标 → 属性 → 权限 → 勾选'允许将文件作为程序执行'"

#!/bin/bash

# OpenClaw Desktop Launcher for macOS

cd "$(dirname "$0")"

echo "OpenClaw Desktop Launcher"
echo "========================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到 Python3，请先安装 Python 3.7+"
    echo "下载地址: https://www.python.org/downloads/"
    read -p "按 Enter 键退出..."
    exit 1
fi

echo "正在启动 OpenClaw 桌面启动器..."
echo ""

python3 simple_launcher.py

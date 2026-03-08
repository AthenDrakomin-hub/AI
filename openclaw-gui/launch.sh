#!/bin/bash

# OpenClaw 桌面启动器（简化版）

cd /workspace/projects/openclaw-gui

# 检查依赖
if ! python3 -c "import requests" 2>/dev/null; then
    echo "正在安装依赖..."
    pip install -r requirements_simple.txt
fi

# 启动启动器
echo "启动 OpenClaw 桌面启动器..."
python3 simple_launcher.py

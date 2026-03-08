#!/bin/bash

# OpenClaw GUI Web 版本启动脚本

cd /workspace/projects/openclaw-gui

# 检查依赖
if ! python3 -c "import PyQtWebEngine" 2>/dev/null; then
    echo "正在安装依赖..."
    pip install -r requirements.txt
fi

# 检查 OpenClaw Gateway 是否运行
if ! curl -s http://localhost:5000 > /dev/null 2>&1; then
    echo "⚠️  警告: OpenClaw Gateway 未运行"
    echo "请先启动 OpenClaw Gateway，然后再运行 GUI"
fi

# 启动 GUI (Web 模式)
echo "启动 OpenClaw Desktop GUI (Web 模式)..."
python3 main_web.py

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
OpenClaw Desktop Launcher
使用系统默认浏览器启动 OpenClaw Web 界面
"""

import webbrowser
import threading
import time
import subprocess
import sys

def check_gateway():
    """检查 OpenClaw Gateway 是否运行"""
    import requests
    try:
        response = requests.get("http://localhost:5000", timeout=5)
        return response.status_code == 200
    except:
        return False

def main():
    """主函数"""
    print("OpenClaw Desktop Launcher")
    print("=" * 40)

    # 检查 Gateway
    print("正在检查 OpenClaw Gateway...")
    if check_gateway():
        print("✓ OpenClaw Gateway 正在运行")
    else:
        print("✗ OpenClaw Gateway 未运行")
        print("\n请先启动 OpenClaw Gateway：")
        print("  openclaw gateway")
        print("\n或者在后台启动：")
        print("  openclaw gateway &")
        sys.exit(1)

    # 打开浏览器
    url = "http://localhost:5000"
    print(f"\n正在打开浏览器...")
    print(f"访问地址: {url}")

    try:
        webbrowser.open(url)
        print("✓ 浏览器已打开")
    except Exception as e:
        print(f"✗ 无法打开浏览器: {e}")
        print(f"\n请手动访问: {url}")

    print("\n提示: 按 Ctrl+C 关闭此窗口（浏览器会继续运行）")
    print("      或直接关闭此窗口")

    # 保持运行
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n程序已退出")

if __name__ == "__main__":
    main()

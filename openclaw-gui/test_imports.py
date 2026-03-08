#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试依赖是否正确安装
"""

import sys

print("正在测试依赖...")

try:
    from PyQt5.QtCore import QT_VERSION_STR
    from PyQt5.QtWidgets import QApplication
    from PyQt5.QtCore import QUrl
    from PyQt5.QtWebEngineWidgets import QWebEngineView
    print("✓ PyQt5 已安装")
    print(f"  版本: {QT_VERSION_STR}")
except ImportError as e:
    print(f"✗ PyQt5 导入失败: {e}")
    sys.exit(1)

try:
    import PyQtWebEngine
    print("✓ PyQtWebEngine 已安装")
except ImportError as e:
    print(f"✗ PyQtWebEngine 导入失败: {e}")
    sys.exit(1)

try:
    # 测试创建 QApplication（不显示窗口）
    app = QApplication(sys.argv)
    web_view = QWebEngineView()
    print("✓ QWebEngineView 可以创建")
except Exception as e:
    print(f"✗ 创建 QWebEngineView 失败: {e}")
    sys.exit(1)

print("\n✓ 所有依赖测试通过！")
print("可以运行: python3 main_web.py")

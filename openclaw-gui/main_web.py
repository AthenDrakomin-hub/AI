#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
OpenClaw Desktop GUI - Web 模式
使用 QWebEngineView 嵌入 OpenClaw Web 界面
"""

import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QStatusBar
from PyQt5.QtCore import QUrl, QTimer
from PyQt5.QtWebEngineWidgets import QWebEngineView


class OpenClawWebView(QMainWindow):
    """OpenClaw Web 视图窗口"""

    def __init__(self):
        super().__init__()
        self.setup_ui()

    def setup_ui(self):
        """初始化 UI"""
        self.setWindowTitle("OpenClaw AI 助手")
        self.setGeometry(100, 100, 1200, 800)
        self.setMinimumSize(800, 600)

        # 创建 Web 视图
        self.web_view = QWebEngineView()
        self.setCentralWidget(self.web_view)

        # 添加状态栏
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("正在连接到 OpenClaw Gateway...")

        # 加载 OpenClaw Web 界面
        self.web_view.loadFinished.connect(self.on_load_finished)
        self.web_view.load(QUrl("http://localhost:5000"))

    def on_load_finished(self, success):
        """页面加载完成"""
        if success:
            self.status_bar.showMessage("✓ 已连接到 OpenClaw Gateway")
        else:
            self.status_bar.showMessage("✗ 无法连接到 OpenClaw Gateway，请确保服务正在运行")


def main():
    """主函数"""
    app = QApplication(sys.argv)
    app.setApplicationName("OpenClaw Desktop")

    window = OpenClawWebView()
    window.show()

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()

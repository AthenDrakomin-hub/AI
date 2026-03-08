#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
OpenClaw Desktop GUI
基于 PyQt5 的原生桌面应用
"""

import sys
import json
import threading
import requests
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QTextEdit, QPushButton, QLabel, QScrollArea, QFrame
)
from PyQt5.QtCore import Qt, QThread, pyqtSignal
from PyQt5.QtGui import QFont, QTextCursor


class MessageBubble(QWidget):
    """消息气泡组件"""
    def __init__(self, text, is_user, parent=None):
        super().__init__(parent)
        self.is_user = is_user
        self.setup_ui(text)

    def setup_ui(self, text):
        layout = QVBoxLayout()
        layout.setContentsMargins(20, 10, 20, 10)

        # 创建气泡
        bubble = QLabel(text)
        bubble.setWordWrap(True)
        bubble.setTextInteractionFlags(Qt.TextSelectableByMouse)

        if self.is_user:
            # 用户消息：右对齐，蓝色
            bubble.setStyleSheet("""
                QLabel {
                    background-color: #007AFF;
                    color: white;
                    padding: 12px 16px;
                    border-radius: 18px;
                    font-size: 14px;
                    max-width: 400px;
                }
            """)
            layout.setAlignment(Qt.AlignRight)
        else:
            # AI 消息：左对齐，灰色
            bubble.setStyleSheet("""
                QLabel {
                    background-color: #E5E5EA;
                    color: black;
                    padding: 12px 16px;
                    border-radius: 18px;
                    font-size: 14px;
                    max-width: 400px;
                }
            """)
            layout.setAlignment(Qt.AlignLeft)

        layout.addWidget(bubble)
        self.setLayout(layout)


class OpenClawClient(QThread):
    """OpenClaw API 通信客户端"""
    response_received = pyqtSignal(str)

    def __init__(self, message):
        super().__init__()
        self.message = message
        self.base_url = "http://localhost:5000"

    def run(self):
        """发送消息并获取响应"""
        try:
            # 尝试发送消息到 OpenClaw Gateway
            # 注意：这里需要根据 OpenClaw 的实际 API 调整
            response = requests.post(
                f"{self.base_url}/api/chat",
                json={"message": self.message},
                timeout=30
            )

            if response.status_code == 200:
                result = response.json()
                self.response_received.emit(result.get("response", "未知响应"))
            else:
                self.response_received.emit(f"错误: HTTP {response.status_code}")

        except requests.exceptions.ConnectionError:
            self.response_received.emit("无法连接到 OpenClaw Gateway，请确保服务正在运行 (http://localhost:5000)")
        except Exception as e:
            self.response_received.emit(f"请求失败: {str(e)}")


class OpenClawWindow(QMainWindow):
    """OpenClaw 主窗口"""

    def __init__(self):
        super().__init__()
        self.setup_ui()

    def setup_ui(self):
        """初始化 UI"""
        self.setWindowTitle("OpenClaw AI 助手")
        self.setGeometry(100, 100, 800, 600)
        self.setMinimumSize(600, 500)

        # 设置应用样式
        self.setStyleSheet("""
            QMainWindow {
                background-color: #F5F5F7;
            }
        """)

        # 创建中央部件
        central_widget = QWidget()
        self.setCentralWidget(central_widget)

        # 主布局
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.setSpacing(0)

        # 顶部标题栏
        header = QFrame()
        header.setStyleSheet("""
            QFrame {
                background-color: #FFFFFF;
                border-bottom: 1px solid #E5E5EA;
            }
        """)
        header_layout = QVBoxLayout(header)
        header_layout.setContentsMargins(20, 15, 20, 15)

        title_label = QLabel("OpenClaw AI 助手")
        title_label.setFont(QFont("Arial", 18, QFont.Bold))
        title_label.setStyleSheet("color: #1D1D1F;")

        status_label = QLabel("● 已连接到 Gateway")
        status_label.setFont(QFont("Arial", 11))
        status_label.setStyleSheet("color: #34C759;")

        header_layout.addWidget(title_label)
        header_layout.addWidget(status_label)
        main_layout.addWidget(header)

        # 消息显示区域
        self.messages_scroll = QScrollArea()
        self.messages_scroll.setWidgetResizable(True)
        self.messages_scroll.setStyleSheet("""
            QScrollArea {
                border: none;
                background-color: #F5F5F7;
            }
        """)

        self.messages_container = QWidget()
        self.messages_layout = QVBoxLayout(self.messages_container)
        self.messages_layout.setContentsMargins(0, 20, 0, 20)
        self.messages_layout.setSpacing(15)
        self.messages_layout.addStretch()

        self.messages_scroll.setWidget(self.messages_container)
        main_layout.addWidget(self.messages_scroll)

        # 输入区域
        input_container = QFrame()
        input_container.setStyleSheet("""
            QFrame {
                background-color: #FFFFFF;
                border-top: 1px solid #E5E5EA;
            }
        """)
        input_layout = QVBoxLayout(input_container)
        input_layout.setContentsMargins(20, 15, 20, 15)

        # 输入框和发送按钮
        input_row = QHBoxLayout()
        input_row.setSpacing(10)

        self.input_text = QTextEdit()
        self.input_text.setPlaceholderText("输入消息...")
        self.input_text.setMaximumHeight(100)
        self.input_text.setStyleSheet("""
            QTextEdit {
                border: 1px solid #E5E5EA;
                border-radius: 10px;
                padding: 10px;
                background-color: #F5F5F7;
                font-size: 14px;
            }
            QTextEdit:focus {
                border: 2px solid #007AFF;
            }
        """)
        self.input_text.textChanged.connect(self.on_input_changed)

        self.send_button = QPushButton("发送")
        self.send_button.setEnabled(False)
        self.send_button.setFixedSize(80, 40)
        self.send_button.setStyleSheet("""
            QPushButton {
                background-color: #007AFF;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 14px;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #0051D5;
            }
            QPushButton:disabled {
                background-color: #C7C7CC;
            }
        """)
        self.send_button.clicked.connect(self.send_message)

        input_row.addWidget(self.input_text)
        input_row.addWidget(self.send_button)

        input_layout.addLayout(input_row)
        main_layout.addWidget(input_container)

        # 添加欢迎消息
        self.add_message("你好！我是 OpenClaw AI 助手。有什么我可以帮助你的吗？", is_user=False)

    def on_input_changed(self):
        """输入框内容变化时更新按钮状态"""
        text = self.input_text.toPlainText().strip()
        self.send_button.setEnabled(bool(text))

    def add_message(self, text, is_user):
        """添加消息到界面"""
        bubble = MessageBubble(text, is_user)
        self.messages_layout.insertWidget(
            self.messages_layout.count() - 1,
            bubble
        )
        # 滚动到底部
        self.messages_scroll.verticalScrollBar().setValue(
            self.messages_scroll.verticalScrollBar().maximum()
        )

    def send_message(self):
        """发送消息"""
        text = self.input_text.toPlainText().strip()
        if not text:
            return

        # 添加用户消息
        self.add_message(text, is_user=True)

        # 清空输入框
        self.input_text.clear()
        self.send_button.setEnabled(False)

        # 发送到 OpenClaw
        self.client = OpenClawClient(text)
        self.client.response_received.connect(self.on_response_received)
        self.client.start()

    def on_response_received(self, response):
        """收到响应"""
        self.add_message(response, is_user=False)


def main():
    """主函数"""
    app = QApplication(sys.argv)
    app.setApplicationName("OpenClaw Desktop")

    window = OpenClawWindow()
    window.show()

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()

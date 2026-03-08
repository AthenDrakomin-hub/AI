# OpenClaw 桌面 GUI - 快速开始

## 一键启动

```bash
cd /workspace/projects/openclaw-gui
./launch.sh
```

## 工作原理

启动器会自动：
1. ✓ 检查 OpenClaw Gateway 是否运行
2. ✓ 使用系统默认浏览器打开 http://localhost:5000
3. ✓ 显示连接状态和访问地址

## 系统要求

- Python 3.7+
- OpenClaw Gateway 运行中
- 系统默认浏览器（Chrome/Firefox/Safari/Edge 等）

## 特性

- 🚀 零配置，开箱即用
- 🌐 跨平台支持（Windows/Mac/Linux）
- 💻 桌面应用体验
- ⚡ 轻量级，最小依赖

## 故障排除

### Gateway 未运行
```bash
openclaw gateway
```

### 浏览器未自动打开
手动访问：http://localhost:5000

## 高级选项

### 使用特定浏览器
编辑 `simple_launcher.py`：
```python
webbrowser.get('chrome').open(url)  # Chrome
webbrowser.get('firefox').open(url) # Firefox
```

### 开发桌面应用
参考项目中的其他版本：
- `main_web.py` - PyQt Web 模式
- `main.py` - 原生聊天界面

## 技术细节

- 使用 Python webbrowser 模块
- 通过 HTTP 检查 Gateway 状态
- 无需理解 OpenClaw WebSocket 协议
- 直接使用完整的 Web UI 功能

# OpenClaw 桌面 GUI

基于 Python 的 OpenClaw 桌面启动器，支持一键安装到桌面。

## 🚀 快速开始

### Linux 系统
```bash
cd /workspace/projects/openclaw-gui
./install-desktop.sh
```
然后双击桌面上的 "OpenClaw AI 助手" 图标启动

### Windows 系统
双击 `openclaw-gui.bat` 文件即可启动

### macOS 系统
双击 `openclaw-gui.command` 文件即可启动

## ✨ 核心特性

- 🖥️ 桌面快捷方式，一键启动
- 🌐 跨平台支持（Windows/Mac/Linux）
- ⚡ 零配置，开箱即用
- 🔍 自动检测 OpenClaw Gateway 状态
- 💻 使用系统浏览器，体验最佳

## 📦 文件说明

### 桌面启动文件
- `openclaw-gui.desktop` - Linux 桌面快捷方式
- `openclaw-gui.bat` - Windows 批处理启动文件
- `openclaw-gui.command` - macOS 启动文件

### 安装脚本
- `install-desktop.sh` - Linux 自动安装脚本

### 核心程序
- `simple_launcher.py` - 简化启动器（推荐）
- `launch.sh` - 启动脚本
- `main_web.py` - PyQt Web 模式
- `main.py` - 原生聊天界面

### 文档
- `README.md` - 主文档
- `QUICKSTART.md` - 快速开始指南
- `DESKTOP_SHORTCUT.md` - 桌面快捷方式安装指南

## 📖 详细文档

- [快速开始](QUICKSTART.md)
- [桌面快捷方式安装](DESKTOP_SHORTCUT.md)
- [完整说明](README.md)

## 🔧 系统要求

- Python 3.7+
- OpenClaw Gateway 运行中
- 系统默认浏览器（Chrome/Firefox/Safari/Edge 等）

## 🎯 使用场景

1. **日常对话**：快速与 OpenClaw AI 交互
2. **任务执行**：通过桌面界面执行 AI 任务
3. **便捷访问**：无需打开浏览器，一键启动
4. **桌面集成**：与其他桌面应用无缝配合

## 🛠️ 故障排除

### 无法启动
1. 检查 OpenClaw Gateway 是否运行：`openclaw gateway`
2. 确认 Python 已安装：`python --version`
3. 查看详细错误信息

### 浏览器未自动打开
手动访问：http://localhost:5000

### 权限问题
```bash
chmod +x launch.sh
chmod +x openclaw-gui.desktop
```

## 💡 提示

- 推荐使用桌面快捷方式，体验更佳
- 可以固定到任务栏/启动台，方便快速访问
- 首次启动会自动检查依赖

## 🎉 现在就开始

选择你的系统，按照上面的说明安装，即可在桌面一键启动 OpenClaw！

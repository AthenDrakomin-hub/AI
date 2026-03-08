# OpenClaw 桌面 GUI - 桌面快捷方式安装

## Linux 安装

### 自动安装（推荐）
```bash
cd /workspace/projects/openclaw-gui
./install-desktop.sh
```

### 手动安装
1. 复制 `openclaw-gui.desktop` 到桌面：
```bash
cp openclaw-gui.desktop ~/Desktop/
```

2. 设置执行权限：
```bash
chmod +x ~/Desktop/openclaw-gui.desktop
chmod +x launch.sh
```

3. 如果双击没有反应，右键点击图标 → 属性 → 权限 → 勾选"允许将文件作为程序执行"

## Windows 安装

### 使用批处理文件
1. 将 `openclaw-gui.bat` 放到桌面
2. 双击即可启动

### 创建桌面快捷方式
1. 右键点击 `openclaw-gui.bat` → 发送到 → 桌面快捷方式
2. 双击快捷方式启动

## macOS 安装

### 使用 Command 文件
1. 将 `openclaw-gui.command` 放到桌面
2. 双击即可启动

### 首次运行可能需要授权
1. 右键点击 `openclaw-gui.command` → 打开
2. 系统会提示安全警告，点击"打开"

## 跨平台通用方式

### 简单方式（所有平台）
1. 将整个 `openclaw-gui` 文件夹复制到桌面
2. 进入文件夹
3. 双击 `launch.sh`（Linux/macOS）或 `openclaw-gui.bat`（Windows）

## 注意事项

### Linux
- 确保 `launch.sh` 有执行权限：`chmod +x launch.sh`
- 如果桌面环境不支持 .desktop 文件，可以直接运行 `launch.sh`

### Windows
- 需要安装 Python 3.7+
- 可以在 https://www.python.org/downloads/ 下载

### macOS
- 需要安装 Python 3.7+
- 首次运行 .command 文件可能需要在系统偏好设置中授权

## 故障排除

### Linux: 双击没有反应
```bash
chmod +x ~/Desktop/openclaw-gui.desktop
```

### Windows: 找不到 Python
- 安装 Python: https://www.python.org/downloads/
- 确保安装时勾选"Add Python to PATH"

### macOS: 无法打开 .command 文件
1. 打开终端
2. 运行：`chmod +x ~/Desktop/openclaw-gui.command`
3. 再次双击

## 自定义图标

### Linux (.desktop)
修改 `openclaw-gui.desktop` 中的 `Icon` 行：
```
Icon=/path/to/your/icon.png
```

### Windows
右键快捷方式 → 属性 → 更改图标

### macOS
需要创建 .app 包，较为复杂，建议使用 .command 文件

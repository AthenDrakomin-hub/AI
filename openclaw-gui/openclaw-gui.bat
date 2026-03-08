@echo off
REM OpenClaw Desktop Launcher for Windows

cd /d "%~dp0"

echo OpenClaw Desktop Launcher
echo ==========================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 Python，请先安装 Python 3.7+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo 正在启动 OpenClaw 桌面启动器...
echo.

python simple_launcher.py

if errorlevel 1 (
    echo.
    echo 启动失败，请检查 OpenClaw Gateway 是否运行
    echo.
)

pause

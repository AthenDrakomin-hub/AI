#!/bin/bash
# OpenClaw Fly.io 一键部署脚本

set -e

echo "======================================================"
echo "  OpenClaw Fly.io 部署脚本"
echo "======================================================"
echo ""

# 检查 flyctl 是否安装
if ! command -v flyctl &> /dev/null; then
    echo "❌ 错误: 未找到 flyctl"
    echo "请先安装 Fly.io CLI: https://fly.io/docs/hands-on/install-flyctl/"
    exit 1
fi

echo "✓ flyctl 已安装"
echo ""

# 检查是否已登录
if ! flyctl auth whoami &> /dev/null; then
    echo "请先登录 Fly.io:"
    flyctl auth login
fi

echo "✓ 已登录 Fly.io"
echo ""

# 设置应用名称
APP_NAME="openclaw-ai-assistant"
read -p "应用名称 [$APP_NAME]: " input_app_name
APP_NAME=${input_app_name:-$APP_NAME}

# 设置区域
REGION="sin"
read -p "区域 [$REGION] (sin/hkg/sea/nrt): " input_region
REGION=${input_region:-$REGION}

# 设置 Coze API Key
read -p "Coze API Key: " COZE_API_KEY

if [ -z "$COZE_API_KEY" ]; then
    echo "❌ 错误: Coze API Key 不能为空"
    exit 1
fi

# 设置 Telegram Bot Token（可选）
read -p "Telegram Bot Token (可选): " TELEGRAM_TOKEN

echo ""
echo "======================================================"
echo "  部署配置"
echo "======================================================"
echo "应用名称: $APP_NAME"
echo "区域: $REGION"
echo "Coze API Key: ${COZE_API_KEY:0:20}..."
echo "Telegram Bot Token: ${TELEGRAM_TOKEN:0:20}..."
echo ""

read -p "确认部署? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "部署已取消"
    exit 0
fi

echo ""
echo "======================================================"
echo "  开始部署"
echo "======================================================"
echo ""

# 创建 fly.toml
cat > fly.toml << EOF
# fly.toml app configuration file
app = "$APP_NAME"
primary_region = "$REGION"

[build]
  builder = "dockerfile"

[env]
  NODE_ENV = "production"
  PORT = "5000"

[http_service]
  internal_port = 5000
  force_https = true
  auto_stop_machines = "stop"
  auto_start_machines = true
  min_machines_running = 0
  processes = ["app"]

  [[http_service.checks]]
    interval = "30s"
    timeout = "10s"
    grace_period = "10s"
    method = "GET"
    path = "/"

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 1024

[[mounts]]
  source = "openclaw_data"
  destination = "/root/.openclaw"
EOF

echo "✓ fly.toml 已创建"
echo ""

# 初始化应用（如果不存在）
if ! flyctl info --app $APP_NAME &> /dev/null; then
    echo "创建应用..."
    flyctl launch --name $APP_NAME --region $REGION --no-deploy --copy-config
else
    echo "✓ 应用已存在"
fi

# 设置环境变量
echo ""
echo "设置环境变量..."
flyctl secrets set --app $APP_NAME COZE_WORKLOAD_IDENTITY_API_KEY="$COZE_API_KEY"

if [ -n "$TELEGRAM_TOKEN" ]; then
    flyctl secrets set --app $APP_NAME TELEGRAM_BOT_TOKEN="$TELEGRAM_TOKEN"
fi

echo "✓ 环境变量已设置"
echo ""

# 部署应用
echo ""
echo "部署应用..."
flyctl deploy --app $APP_NAME

echo ""
echo "======================================================"
echo "  部署完成"
echo "======================================================"
echo ""
echo "应用 URL: https://$APP_NAME.fly.dev"
echo ""
echo "查看日志:"
echo "  flyctl logs --app $APP_NAME"
echo ""
echo "查看状态:"
echo "  flyctl status --app $APP_NAME"
echo ""

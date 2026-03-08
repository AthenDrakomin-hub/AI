# OpenClaw Fly.io 一键部署脚本 (PowerShell)
# 使用方法: powershell -ExecutionPolicy Bypass -File deploy-fly.ps1

$ErrorActionPreference = "Stop"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Fly.io 部署脚本" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# 检查 flyctl 是否安装
if (-not (Get-Command flyctl -ErrorAction SilentlyContinue)) {
    Write-Host "❌ 错误: 未找到 flyctl" -ForegroundColor Red
    Write-Host "请先安装 Fly.io CLI: https://fly.io/docs/hands-on/install-flyctl/" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ flyctl 已安装" -ForegroundColor Green
Write-Host ""

# 检查是否已登录
try {
    $null = flyctl auth whoami
} catch {
    Write-Host "请先登录 Fly.io:" -ForegroundColor Yellow
    flyctl auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 登录失败" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✓ 已登录 Fly.io" -ForegroundColor Green
Write-Host ""

# 设置应用名称
$APP_NAME = Read-Host "应用名称 [openclaw-ai-assistant]"
if ([string]::IsNullOrWhiteSpace($APP_NAME)) {
    $APP_NAME = "openclaw-ai-assistant"
}

# 设置区域
$REGION = Read-Host "区域 [sin] (sin/hkg/sea/nrt)"
if ([string]::IsNullOrWhiteSpace($REGION)) {
    $REGION = "sin"
}

# 设置 Coze API Key
$COZE_API_KEY = Read-Host "Coze API Key"
if ([string]::IsNullOrWhiteSpace($COZE_API_KEY)) {
    Write-Host "❌ 错误: Coze API Key 不能为空" -ForegroundColor Red
    exit 1
}

# 设置 Telegram Bot Token（可选）
$TELEGRAM_TOKEN = Read-Host "Telegram Bot Token (可选)"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  部署配置" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "应用名称: $APP_NAME" -ForegroundColor White
Write-Host "区域: $REGION" -ForegroundColor White
Write-Host "Coze API Key: $($COZE_API_KEY.Substring(0, [Math]::Min(20, $COZE_API_KEY.Length)))..." -ForegroundColor Gray
if (-not [string]::IsNullOrWhiteSpace($TELEGRAM_TOKEN)) {
    Write-Host "Telegram Bot Token: $($TELEGRAM_TOKEN.Substring(0, [Math]::Min(20, $TELEGRAM_TOKEN.Length)))..." -ForegroundColor Gray
}
Write-Host ""

$confirm = Read-Host "确认部署? (y/n)"
if ($confirm -ne "y") {
    Write-Host "部署已取消" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  开始部署" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# 创建 fly.toml
$flyToml = @"
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
"@

$flyToml | Out-File -FilePath "fly.toml" -Encoding utf8

Write-Host "✓ fly.toml 已创建" -ForegroundColor Green
Write-Host ""

# 初始化应用（如果不存在）
$appInfo = flyctl info --app $APP_NAME 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "创建应用..." -ForegroundColor Yellow
    flyctl launch --name $APP_NAME --region $REGION --no-deploy --copy-config
} else {
    Write-Host "✓ 应用已存在" -ForegroundColor Green
}

# 设置环境变量
Write-Host ""
Write-Host "设置环境变量..." -ForegroundColor Yellow
flyctl secrets set --app $APP_NAME COZE_WORKLOAD_IDENTITY_API_KEY="$COZE_API_KEY"

if (-not [string]::IsNullOrWhiteSpace($TELEGRAM_TOKEN)) {
    flyctl secrets set --app $APP_NAME TELEGRAM_BOT_TOKEN="$TELEGRAM_TOKEN"
}

Write-Host "✓ 环境变量已设置" -ForegroundColor Green
Write-Host ""

# 部署应用
Write-Host ""
Write-Host "部署应用..." -ForegroundColor Yellow
flyctl deploy --app $APP_NAME

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "  部署完成" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "应用 URL: https://$APP_NAME.fly.dev" -ForegroundColor Green
    Write-Host ""
    Write-Host "查看日志:" -ForegroundColor White
    Write-Host "  flyctl logs --app $APP_NAME" -ForegroundColor Gray
    Write-Host ""
    Write-Host "查看状态:" -ForegroundColor White
    Write-Host "  flyctl status --app $APP_NAME" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ 部署失败，请查看错误信息" -ForegroundColor Red
    exit 1
}

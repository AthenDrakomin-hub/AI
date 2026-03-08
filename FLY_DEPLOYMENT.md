# OpenClaw Fly.io 部署指南

## 📋 前置要求

1. **安装 Fly.io CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh
   # 或在 Windows 上下载: https://fly.io/docs/hands-on/install-flyctl/
   ```

2. **登录 Fly.io**
   ```bash
   flyctl auth login
   ```

3. **准备 API 密钥**
   - Coze API Key
   - Telegram Bot Token（可选）
   - 飞书 App ID/Secret（可选）

---

## 🚀 部署步骤

### 步骤 1：初始化 Fly.io 应用

```bash
flyctl launch
```

配置选项：
- App name: `openclaw-ai-assistant`（或自定义）
- Region: `sin`（新加坡，离国内近）或其他区域
- Postgres: `No`（不需要）
- Redis: `No`（不需要）

### 步骤 2：配置环境变量

```bash
# 设置 Coze API Key
flyctl secrets set COZE_WORKLOAD_IDENTITY_API_KEY="your_api_key_here"

# 设置 Telegram Bot Token（可选）
flyctl secrets set TELEGRAM_BOT_TOKEN="8600105667:AAHWiZM4gkugWnNLhJ56fBgRVOIB3OwlAg0"

# 设置飞书配置（可选）
flyctl secrets set FEISHU_APP_ID="your_app_id"
flyctl secrets set FEISHU_APP_SECRET="your_app_secret"
```

### 步骤 3：部署应用

```bash
flyctl deploy
```

### 步骤 4：查看应用状态

```bash
# 查看应用状态
flyctl status

# 查看日志
flyctl logs

# 打开应用
flyctl open
```

---

## 🔧 配置说明

### fly.toml

```toml
app = "openclaw-ai-assistant"
primary_region = "sin"

[env]
  NODE_ENV = "production"
  PORT = "5000"

[http_service]
  internal_port = 5000
  force_https = true
  auto_stop_machines = "stop"
  auto_start_machines = true
  min_machines_running = 0
```

### 主要配置项

- **primary_region**: 主区域，推荐 `sin`（新加坡）或 `hkg`（香港）
- **internal_port**: 内部端口，OpenClaw 默认 5000
- **auto_stop_machines**: 自动停止机器以节省成本
- **auto_start_machines**: 有请求时自动启动
- **min_machines_running**: 最小运行实例数，0 表示完全按需启动

---

## 📊 成本控制

Fly.io 按使用时长计费：

- **共享 CPU**: 1 核心约 $0.00015/秒
- **内存**: 1GB 约 $0.00024/秒
- **存储**: 1GB 约 $0.00000015/秒

**月度估算**：
- 24/7 运行: 约 $30-50/月
- 按需运行: 最低 $0（空闲时自动停止）

---

## 🔄 更新部署

### 更新配置文件后重新部署

```bash
flyctl deploy
```

### 重新启动应用

```bash
flyctl apps restart openclaw-ai-assistant
```

---

## 🔍 监控和调试

### 查看日志

```bash
# 实时日志
flyctl logs -a openclaw-ai-assistant

# 历史日志
flyctl logs -a openclaw-ai-assistant --lines 100
```

### 查看应用信息

```bash
flyctl info
```

### 进入 SSH

```bash
flyctl ssh console
```

---

## 🌐 访问应用

部署完成后：

1. **应用 URL**: `https://openclaw-ai-assistant.fly.dev`
2. **Dashboard**: 访问 URL 查看控制面板

---

## ⚠️ 注意事项

1. **数据持久化**
   - 使用 Fly.io Volumes 持久化数据
   - 配置文件和凭证保存在挂载卷中

2. **网络限制**
   - 某些渠道（如 WhatsApp、Telegram）需要公网访问
   - 确保 Fly.io 应用可以从外部访问

3. **资源限制**
   - 默认配置: 1 CPU, 1GB 内存
   - 可根据需要调整（修改 fly.toml）

4. **免费额度**
   - Fly.io 提供 $5/月的免费额度
   - 适合开发和小规模使用

---

## 🛠️ 故障排除

### 问题 1：部署失败

```bash
# 查看详细日志
flyctl deploy --verbose

# 检查 Dockerfile 语法
docker build -t test .
```

### 问题 2：应用无法启动

```bash
# 查看 SSH 日志
flyctl ssh console

# 检查进程
ps aux | grep openclaw
```

### 问题 3：渠道连接失败

```bash
# 检查网络配置
flyctl ssh console
curl -I https://api.telegram.org
```

---

## 📚 相关资源

- [Fly.io 官方文档](https://fly.io/docs/)
- [OpenClaw 官方文档](https://docs.openclaw.ai/)
- [Docker 部署指南](https://docs.openclaw.ai/deployment/docker)

---

## 🎉 完成

部署完成后，你可以：
1. 通过 HTTPS 访问 OpenClaw Dashboard
2. 使用配置的渠道（WhatsApp/Telegram）与 AI 对话
3. 通过 `flyctl` 管理和监控应用

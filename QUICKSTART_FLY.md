# 🚀 OpenClaw Fly.io 快速部署指南

## 📦 已创建的文件

1. ✅ `fly.toml` - Fly.io 配置文件
2. ✅ `Dockerfile` - Docker 镜像构建文件
3. ✅ `.dockerignore` - Docker 忽略文件
4. ✅ `.env.example` - 环境变量示例
5. ✅ `FLY_DEPLOYMENT.md` - 完整部署文档
6. ✅ `deploy-fly.sh` - Linux/Mac 部署脚本
7. ✅ `deploy-fly.ps1` - Windows 部署脚本

---

## ⚡ 5 分钟快速部署

### Windows 用户

1. **安装 Fly.io CLI**
   ```powershell
   # 下载并安装: https://fly.io/docs/hands-on/install-flyctl/
   winget install flyctl
   ```

2. **登录 Fly.io**
   ```powershell
   flyctl auth login
   ```

3. **运行部署脚本**
   ```powershell
   cd C:\Users\88903\openclaw-workspace
   powershell -ExecutionPolicy Bypass -File deploy-fly.ps1
   ```

4. **输入配置信息**
   - 应用名称: `openclaw-ai-assistant`
   - 区域: `sin`（新加坡）
   - Coze API Key: `cDl2UlViWWh2ZTlwbFJ1c1VHV0tpU09HQzNzdDJuVVk6Nlk1cWFJMHRLUVFHSjV1VDJ3TTduVkQxQnAzRzhYZEIwNzZSTENjRWV0UkpyOHBqMG1Kd1JaZk52NkhsTk4yMA==`
   - Telegram Bot Token: `8600105667:AAHWiZM4gkugWnNLhJ56fBgRVOIB3OwlAg0`

5. **等待部署完成**
   - 部署时间: 5-10 分钟
   - 完成后会显示应用 URL

---

### Linux/Mac 用户

1. **安装 Fly.io CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **登录 Fly.io**
   ```bash
   flyctl auth login
   ```

3. **运行部署脚本**
   ```bash
   cd /workspace/projects
   ./deploy-fly.sh
   ```

---

## 🎯 部署完成后

### 访问应用

1. **打开应用 URL**: `https://openclaw-ai-assistant.fly.dev`
2. **Dashboard**: 查看控制面板
3. **测试渠道**: 通过 Telegram/WhatsApp 发送测试消息

### 管理应用

```powershell
# 查看状态
flyctl status --app openclaw-ai-assistant

# 查看日志
flyctl logs --app openclaw-ai-assistant

# 重新部署
flyctl deploy --app openclaw-ai-assistant

# 停止应用
flyctl apps stop openclaw-ai-assistant

# 启动应用
flyctl apps start openclaw-ai-assistant
```

---

## 💰 成本估算

### 按需运行（推荐）
- **空闲时**: $0（自动停止）
- **使用时**: 按秒计费
- **月度**: $0-$20（取决于使用频率）

### 24/7 运行
- **基本配置**: $30-50/月
- **1 CPU, 1GB 内存**

### 免费额度
- **每月**: $5 免费额度
- **适合**: 开发、测试

---

## 🔧 配置调整

### 修改资源限制

编辑 `fly.toml`:

```toml
[[vm]]
  cpu_kind = "shared"
  cpus = 2  # 增加到 2 CPU
  memory_mb = 2048  # 增加到 2GB
```

### 修改自动停止策略

```toml
[http_service]
  auto_stop_machines = "off"  # 不自动停止
  min_machines_running = 1  # 最少运行 1 个实例
```

---

## 📊 监控和日志

### 查看日志

```powershell
# 实时日志
flyctl logs --app openclaw-ai-assistant

# 历史日志（最近 100 行）
flyctl logs --app openclaw-ai-assistant --lines 100
```

### 查看监控

访问 Fly.io Dashboard:
```
https://fly.io/apps/openclaw-ai-assistant/monitoring
```

---

## 🐛 故障排除

### 问题 1: 部署失败

```powershell
# 查看详细日志
flyctl deploy --app openclaw-ai-assistant --verbose

# 检查应用状态
flyctl status --app openclaw-ai-assistant
```

### 问题 2: 应用无法访问

```powershell
# 检查应用是否运行
flyctl status --app openclaw-ai-assistant

# 查看日志
flyctl logs --app openclaw-ai-assistant

# 重启应用
flyctl apps restart openclaw-ai-assistant
```

### 问题 3: 渠道连接失败

```powershell
# 进入 SSH
flyctl ssh console --app openclaw-ai-assistant

# 测试网络
curl -I https://api.telegram.org
```

---

## 🔄 更新部署

### 修改配置后重新部署

```powershell
# 1. 修改文件
# 2. 重新部署
flyctl deploy --app openclaw-ai-assistant
```

### 仅更新环境变量

```powershell
flyctl secrets set --app openclaw-ai-assistant NEW_KEY="new_value"
```

---

## 📚 更多信息

- **完整文档**: [FLY_DEPLOYMENT.md](./FLY_DEPLOYMENT.md)
- **Fly.io 官方文档**: https://fly.io/docs/
- **OpenClaw 文档**: https://docs.openclaw.ai/

---

## 🎉 开始部署

现在运行部署脚本，将 OpenClaw 部署到 Fly.io！

**Windows**:
```powershell
powershell -ExecutionPolicy Bypass -File deploy-fly.ps1
```

**Linux/Mac**:
```bash
./deploy-fly.sh
```

---

**准备好就运行脚本！** 🚀

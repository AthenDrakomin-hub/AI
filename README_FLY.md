# Fly.io 部署文件

OpenClaw 项目在 Fly.io 云平台部署所需的所有文件和脚本。

## 📁 文件列表

| 文件 | 说明 |
|------|------|
| `fly.toml` | Fly.io 应用配置文件 |
| `Dockerfile` | Docker 镜像构建文件 |
| `.dockerignore` | Docker 构建忽略文件 |
| `.env.example` | 环境变量示例文件 |
| `deploy-fly.sh` | Linux/Mac 部署脚本 |
| `deploy-fly.ps1` | Windows PowerShell 部署脚本 |
| `FLY_DEPLOYMENT.md` | 完整部署文档 |
| `QUICKSTART_FLY.md` | 快速开始指南 |

## 🚀 快速开始

### Windows
```powershell
powershell -ExecutionPolicy Bypass -File deploy-fly.ps1
```

### Linux/Mac
```bash
./deploy-fly.sh
```

## 📖 文档

- **快速开始**: [QUICKSTART_FLY.md](./QUICKSTART_FLY.md)
- **完整文档**: [FLY_DEPLOYMENT.md](./FLY_DEPLOYMENT.md)

## 💡 提示

1. 确保已安装 Fly.io CLI: `flyctl`
2. 部署前先登录: `flyctl auth login`
3. 准备好 API 密钥（Coze、Telegram 等）

## 🔗 相关链接

- [Fly.io 官方网站](https://fly.io/)
- [OpenClaw 官方文档](https://docs.openclaw.ai/)

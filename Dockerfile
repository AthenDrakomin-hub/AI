# OpenClaw Dockerfile for Fly.io
FROM node:22-alpine

# 安装必要的依赖
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    xvfb

# 设置 Chromium 环境变量
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 创建工作目录
WORKDIR /workspace/projects

# 复制配置文件
COPY openclaw.json /workspace/projects/
COPY agents/ /workspace/projects/agents/
COPY extensions/ /workspace/projects/extensions/
COPY credentials/ /workspace/projects/credentials/
COPY canvas/ /workspace/projects/canvas/

# 安装 OpenClaw
RUN npm install -g openclaw@latest

# 创建数据目录
RUN mkdir -p /root/.openclaw && \
    chmod 755 /root/.openclaw

# 复制初始配置
RUN cp /workspace/projects/openclaw.json /root/.openclaw/

# 暴露端口
EXPOSE 5000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5000/ || exit 1

# 启动 OpenClaw Gateway
CMD ["openclaw", "gateway", "--host", "0.0.0.0", "--port", "5000"]

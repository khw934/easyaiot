FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

WORKDIR /app

RUN set -ex && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        g++ \
        python3-dev \
        libgl1 \
        libglib2.0-0 \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
COPY .offline-cache/pip /opt/offline-pip
ARG OFFLINE_MODE=0

RUN set -ex && \
    if [ -n "$(find /opt/offline-pip -maxdepth 1 -type f 2>/dev/null)" ]; then \
        echo "检测到本地离线 pip 资源，优先离线安装..." && \
        pip install -r requirements.txt --no-index --find-links /opt/offline-pip; \
    elif [ "$OFFLINE_MODE" = "1" ]; then \
        echo "OFFLINE_MODE=1 且未检测到离线 pip 资源，请先执行 cache_resources.sh" && \
        exit 1; \
    else \
        echo "未检测到离线 pip 资源，使用在线源安装..." && \
        pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
        pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple; \
    fi && \
    apt-get purge -y --auto-remove gcc g++ python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY . .

# 构建时校验前端静态资源（clone 后若缺少 static 会在此失败，便于排查）
RUN test -f static/style.css && test -f static/script.js && test -f static/all.min.css

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fs http://localhost:8000/ > /dev/null || exit 1

CMD ["python", "app.py", "--env=docker"]

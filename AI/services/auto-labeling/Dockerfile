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
RUN pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install -r requirements.txt --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    apt-get purge -y --auto-remove gcc g++ python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY . .

# 构建时校验前端静态资源（clone 后若缺少 static 会在此失败，便于排查）
RUN test -f static/style.css && test -f static/script.js && test -f static/all.min.css

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fs http://localhost:8000/ > /dev/null || exit 1

CMD ["python", "app.py", "--env=docker"]

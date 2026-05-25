#!/bin/bash

# ============================================
# VIDEO 离线资源预下载脚本（ARM架构）
# 功能：
# 1) 拉取并保存构建所需 Docker 镜像到本地目录
# 2) 下载 requirements.txt 的 pip 依赖包到本地目录
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

image_to_tar_name() {
    echo "$1" | sed 's#[/:]#_#g'
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

OFFLINE_CACHE_DIR="${SCRIPT_DIR}/.offline-cache"
OFFLINE_DOCKER_CACHE_DIR="${OFFLINE_CACHE_DIR}/docker"
OFFLINE_PIP_CACHE_DIR="${OFFLINE_CACHE_DIR}/pip"

ARM_BASE_IMAGE="${ARM_BASE_IMAGE:-pytorch/manylinuxaarch64-builder:cuda12.9}"

mkdir -p "$OFFLINE_DOCKER_CACHE_DIR" "$OFFLINE_PIP_CACHE_DIR"

if ! check_command docker; then
    print_error "未检测到 docker，请先安装 Docker"
    exit 1
fi

download_docker_image() {
    local image="$1"
    local tar_file="${OFFLINE_DOCKER_CACHE_DIR}/$(image_to_tar_name "$image").tar"

    print_info "拉取镜像: $image"
    docker pull "$image"
    print_info "保存镜像到: $tar_file"
    docker save -o "$tar_file" "$image"
    print_success "镜像离线包已保存: $image"
}

print_info "开始下载并保存 Docker 离线镜像..."
download_docker_image "$ARM_BASE_IMAGE"

download_pip_packages() {
    print_info "清理旧的 pip 离线包，避免不同 Python ABI 混用..."
    find "$OFFLINE_PIP_CACHE_DIR" -maxdepth 1 -type f -delete 2>/dev/null || true

    print_info "使用 ARM 基础镜像下载与容器一致的 pip 离线包..."
    set +e
    docker run --rm \
        -v "$SCRIPT_DIR:/work" \
        -w /work \
        "$ARM_BASE_IMAGE" \
        /bin/bash -lc '
set -e
if [ -x /opt/python/cp311-cp311/bin/pip3.11 ]; then
    PIP_BIN=/opt/python/cp311-cp311/bin/pip3.11
elif [ -x /opt/python/cp310-cp310/bin/pip3.10 ]; then
    PIP_BIN=/opt/python/cp310-cp310/bin/pip3.10
elif command -v pip3 >/dev/null 2>&1; then
    PIP_BIN=$(command -v pip3)
else
    echo "未找到可用 pip3"
    exit 1
fi

"$PIP_BIN" --version
"$PIP_BIN" download -r requirements.txt -d .offline-cache/pip --timeout 120 --retries 3 -i https://pypi.tuna.tsinghua.edu.cn/simple
'
    local docker_download_status=$?
    set -e

    if [ $docker_download_status -eq 0 ]; then
        print_success "pip 离线包下载完成（与目标容器 ABI 一致）"
        return 0
    fi

    if [ "${ALLOW_HOST_PIP_FALLBACK:-0}" != "1" ]; then
        print_error "容器内下载 pip 离线包失败，已停止（默认禁用本机回退，避免生成 ABI 不匹配的离线包）"
        print_info "如确需回退，可显式执行: ALLOW_HOST_PIP_FALLBACK=1 ./cache_resources_arm.sh"
        return 1
    fi

    print_warning "容器内下载失败，已启用 ALLOW_HOST_PIP_FALLBACK=1，尝试使用本机 python3 回退下载..."
    if ! check_command python3; then
        print_error "未检测到 python3，且容器内下载失败，无法准备 pip 离线包"
        return 1
    fi
    if ! python3 -m pip --version >/dev/null 2>&1; then
        print_error "python3 未安装 pip，且容器内下载失败，无法准备 pip 离线包"
        return 1
    fi

    python3 -m pip download -r requirements.txt -d "$OFFLINE_PIP_CACHE_DIR" --timeout 120 --retries 3
    print_warning "已使用本机环境回退下载 pip 离线包，可能与目标容器 ABI 不一致（建议仅临时使用）"
    return 0
}

print_info "开始下载 pip 依赖到本地目录: $OFFLINE_PIP_CACHE_DIR"
download_pip_packages

print_info "离线资源目录："
du -sh "$OFFLINE_CACHE_DIR" 2>/dev/null || true
print_success "离线资源准备完成，可在离线服务器上使用 install_linux_arm.sh 自动导入"

# shellcheck shell=bash
# 共享 Docker registry-mirrors + DNS 配置（供 install_linux_kylin / business 等脚本 source）
# 调用方需提供: check_command, print_info, print_success, print_warning, print_error
#
# 环境变量:
#   DOCKER_MIRROR   镜像源，默认 https://docker.m.daocloud.io/
#   DOCKER_DNS      逗号分隔 DNS，默认 223.5.5.5,119.29.29.29（阿里/腾讯）
#   EASYAIOT_FORCE_DOCKER_DNS=1  强制写入 DNS（即使 resolv.conf 非 loopback）

DOCKER_MIRROR="${DOCKER_MIRROR:-https://docker.m.daocloud.io/}"
# 国内公网 DNS；麒麟等系统 /etc/resolv.conf 常指向 ::1/127.0.0.53，Docker 内无法使用
DOCKER_DNS="${DOCKER_DNS:-223.5.5.5,119.29.29.29}"

restart_docker_if_active() {
    if systemctl is-active --quiet docker 2>/dev/null; then
        print_info "正在重启 Docker 服务以使配置生效..."
        systemctl daemon-reload 2>/dev/null || true
        systemctl restart docker
        print_success "Docker 服务已重启"
    fi
}

# 宿主机 resolv.conf 是否指向 loopback（Docker 守护进程无法用此类 DNS）
_host_resolv_uses_loopback_dns() {
    [ -f /etc/resolv.conf ] || return 1
    grep -Eiq '^\s*nameserver\s+(127\.|::1)' /etc/resolv.conf 2>/dev/null
}

# 是否应在 daemon.json 写入公网 DNS
_should_configure_docker_dns() {
    [ "${EASYAIOT_FORCE_DOCKER_DNS:-0}" = "1" ] && return 0
    _host_resolv_uses_loopback_dns && return 0
    # 麒麟/统信等国产系统常见 DNS 异常，默认补齐
    if [ -f /etc/os-release ] && grep -Eiq 'kylin|uos|openEuler|UnionTech' /etc/os-release 2>/dev/null; then
        return 0
    fi
    return 1
}

# 配置 Docker 镜像源 +（按需）DNS
# 优先 python3 合并 JSON；无 python3 时用 jq；皆无则仅在文件不存在时写最小配置
configure_docker_mirror() {
    print_info "配置 Docker 镜像源..."

    local config_file="/etc/docker/daemon.json"
    local want_dns=0
    local dns_csv="$DOCKER_DNS"

    if _should_configure_docker_dns; then
        want_dns=1
        print_info "将配置 Docker DNS: ${dns_csv}（避免守护进程使用 ::1/127.0.0.53 导致拉取失败）"
    fi

    if [ "${EUID:-$(id -u)}" -ne 0 ]; then
        print_warning "配置 Docker 镜像源需要 root 权限，跳过此步骤"
        return 0
    fi
    mkdir -p /etc/docker

    if [ ! -f "$config_file" ]; then
        local wrote=0
        if [ "$want_dns" -eq 1 ] && check_command python3; then
            if python3 - "$config_file" "$DOCKER_MIRROR" "$dns_csv" <<'PYEOF'
import json, sys
path, mirror, dns_csv = sys.argv[1], sys.argv[2], sys.argv[3]
dns = [x.strip() for x in dns_csv.split(",") if x.strip()]
json.dump({"registry-mirrors": [mirror], "dns": dns}, open(path, "w"), indent=2, ensure_ascii=False)
PYEOF
            then
                wrote=1
            fi
        fi
        if [ "$wrote" -eq 0 ]; then
            if [ "$want_dns" -eq 1 ]; then
                local dns_json
                dns_json=$(echo "$dns_csv" | awk -F',' '{
                  printf "["
                  for (i=1;i<=NF;i++) { gsub(/^[ \t]+|[ \t]+$/,"",$i); if($i!=""){ if(n++)printf ", "; printf "\"%s\"", $i } }
                  printf "]"
                }')
                printf '{\n  "registry-mirrors": ["%s"],\n  "dns": %s\n}\n' "$DOCKER_MIRROR" "$dns_json" > "$config_file"
            else
                printf '{\n  "registry-mirrors": ["%s"]\n}\n' "$DOCKER_MIRROR" > "$config_file"
            fi
        fi
        print_success "已写入 Docker 镜像源配置: $DOCKER_MIRROR"
        [ "$want_dns" -eq 1 ] && print_success "已写入 Docker DNS: $dns_csv"
        restart_docker_if_active
        return 0
    fi

    if check_command python3; then
        local rc=0
        python3 - "$config_file" "$DOCKER_MIRROR" "$want_dns" "$dns_csv" <<'PYEOF' || rc=$?
import json, sys
path, mirror, want_dns, dns_csv = sys.argv[1], sys.argv[2], sys.argv[3] == "1", sys.argv[4]
cfg = json.load(open(path))
changed = False

# mirrors: 规整为唯一目标源
cur = [m.rstrip("/") for m in cfg.get("registry-mirrors", []) if isinstance(m, str)]
if cur != [mirror.rstrip("/")]:
    cfg["registry-mirrors"] = [mirror]
    changed = True

# dns: 仅在需要且尚未配置（或仍是 loopback）时写入
if want_dns:
    dns = [x.strip() for x in dns_csv.split(",") if x.strip()]
    existing = cfg.get("dns") if isinstance(cfg.get("dns"), list) else []
    existing_norm = [str(x).strip() for x in existing]
    loopback = any(x.startswith("127.") or x in ("::1",) for x in existing_norm)
    if not existing_norm or loopback or existing_norm != dns:
        if existing_norm != dns:
            cfg["dns"] = dns
            changed = True

if not changed:
    sys.exit(0)
json.dump(cfg, open(path, "w"), indent=2, ensure_ascii=False)
sys.exit(3)
PYEOF
        case $rc in
            0)
                print_success "Docker 镜像源配置已就绪（$DOCKER_MIRROR）"
                [ "$want_dns" -eq 1 ] && print_success "Docker DNS 配置已就绪（$dns_csv）"
                ;;
            3)
                print_success "Docker 镜像源已更新为 $DOCKER_MIRROR"
                [ "$want_dns" -eq 1 ] && print_success "Docker DNS 已更新为 $dns_csv"
                restart_docker_if_active
                ;;
            *)
                print_error "解析 $config_file 失败（非法 JSON？），请手动检查"
                return 1
                ;;
        esac
        return 0
    fi

    if check_command jq; then
        local tmp_json
        tmp_json=$(mktemp)
        if [ "$want_dns" -eq 1 ]; then
            # shellcheck disable=SC2016
            if ! jq --arg m "$DOCKER_MIRROR" --arg csv "$dns_csv" '
                .["registry-mirrors"] = [$m]
                | .dns = ($csv | split(",") | map(gsub("^\\s+|\\s+$";"")) | map(select(length>0)))
              ' "$config_file" > "$tmp_json" 2>/dev/null; then
                rm -f "$tmp_json"
                print_error "解析 $config_file 失败（非法 JSON？），请手动检查"
                return 1
            fi
        else
            if ! jq --arg m "$DOCKER_MIRROR" '.["registry-mirrors"] = [$m]' "$config_file" > "$tmp_json" 2>/dev/null; then
                rm -f "$tmp_json"
                print_error "解析 $config_file 失败（非法 JSON？），请手动检查"
                return 1
            fi
        fi
        if cmp -s "$config_file" "$tmp_json" 2>/dev/null; then
            rm -f "$tmp_json"
            print_success "Docker 镜像源配置已就绪（$DOCKER_MIRROR）"
            return 0
        fi
        mv "$tmp_json" "$config_file"
        print_success "Docker 镜像源已更新为 $DOCKER_MIRROR"
        [ "$want_dns" -eq 1 ] && print_success "Docker DNS 已更新为 $dns_csv"
        restart_docker_if_active
        return 0
    fi

    print_warning "未安装 jq/python3 且 $config_file 已存在，跳过自动配置（请手动确认 registry-mirrors 含 $DOCKER_MIRROR，并建议添加 dns: [\"223.5.5.5\",\"119.29.29.29\"]）"
}

# 从 DaoCloud 等国内前缀直连拉取并 tag 回原名（registry-mirrors 失效时的回退）
# 用法: docker_pull_with_mirror_fallback [--platform linux/arm64] image:tag
docker_pull_with_mirror_fallback() {
    local platform_args=()
    while [ $# -gt 0 ]; do
        case "$1" in
            --platform)
                platform_args=(--platform "$2")
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    local img="${1:-}"
    [ -n "$img" ] || return 1

    export DOCKER_CONTENT_TRUST=0

    if docker pull "${platform_args[@]}" "$img"; then
        return 0
    fi

    local mirror_host="${DOCKER_MIRROR_HOST:-docker.m.daocloud.io}"
    mirror_host="${mirror_host#https://}"
    mirror_host="${mirror_host#http://}"
    mirror_host="${mirror_host%/}"

    local candidates=()
    # 已是镜像站路径则不再套前缀
    if [[ "$img" == "$mirror_host"/* ]]; then
        return 1
    fi
    # 官方库简写 postgres:18 → library/postgres:18
    if [[ "$img" != */* ]]; then
        candidates+=("${mirror_host}/library/${img}")
    elif [[ "$img" == library/* ]]; then
        candidates+=("${mirror_host}/${img}")
    else
        # docker hub 命名空间：emqx/emqx:5.8.7
        candidates+=("${mirror_host}/${img}")
    fi

    local c
    for c in "${candidates[@]}"; do
        print_info "镜像源直连回退拉取: $c"
        if docker pull "${platform_args[@]}" "$c"; then
            docker tag "$c" "$img" 2>/dev/null || true
            print_success "已拉取并标记为 $img"
            return 0
        fi
    done
    return 1
}

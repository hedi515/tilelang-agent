#!/bin/bash

set -euo pipefail

# ========================
#       常量定义
# ========================
NODE_MIN_VERSION=18
NODE_INSTALL_VERSION=22
NVM_VERSION="v0.40.3"

# 镜像配置（可通过参数切换）
USE_CHINA_MIRROR="${USE_CHINA_MIRROR:-false}"

# ========================
#       工具函数
# ========================

log_info() {
    echo "🔹 $*"
}

log_success() {
    echo "✅ $*"
}

log_error() {
    echo "❌ $*" >&2
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    else
        echo "unknown"
    fi
}

# 检测是否在中国网络环境
detect_china_network() {
    if timeout 3 curl -s --max-time 2 "https://www.google.com" >/dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

# ========================
#     Node.js 安装函数
# ========================

install_nodejs() {
    local platform=$(detect_os)

    case "$platform" in
        linux|darwin)
            log_info "Installing Node.js on $platform..."

            # 设置镜像源
            local nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"
            local nodejs_mirror=""

            if [ "$USE_CHINA_MIRROR" = "true" ] || detect_china_network; then
                log_info "Using China mirrors for faster download..."
                nvm_url="https://gitee.com/mirrors/nvm/raw/${NVM_VERSION}/install.sh"
                nodejs_mirror="https://npmmirror.com/mirrors/node"
            fi

            # 安装 nvm
            log_info "Installing nvm ($NVM_VERSION)..."
            curl -s "$nvm_url" | bash

            # 加载 nvm
            log_info "Loading nvm environment..."
            export NVM_DIR="$HOME/.nvm"
            \. "$NVM_DIR/nvm.sh"

            # 设置 Node.js 镜像源
            if [ -n "$nodejs_mirror" ]; then
                log_info "Setting Node.js mirror to $nodejs_mirror..."
                export NVM_NODEJS_ORG_MIRROR="$nodejs_mirror"
            fi

            # 安装 Node.js
            log_info "Installing Node.js $NODE_INSTALL_VERSION..."
            nvm install "$NODE_INSTALL_VERSION"

            # 设置为默认版本
            log_info "Setting Node.js $NODE_INSTALL_VERSION as default..."
            nvm alias default "$NODE_INSTALL_VERSION"

            # 验证安装
            node -v &>/dev/null || {
                log_error "Node.js installation failed"
                exit 1
            }
            log_success "Node.js installed: $(node -v)"
            log_success "npm version: $(npm -v)"
            ;;
        *)
            log_error "Unsupported platform: $platform"
            exit 1
            ;;
    esac
}

# ========================
#     Node.js 检查函数
# ========================

check_nodejs() {
    if command -v node &>/dev/null; then
        current_version=$(node -v | sed 's/v//')
        major_version=$(echo "$current_version" | cut -d. -f1)

        if [ "$major_version" -ge "$NODE_MIN_VERSION" ]; then
            log_success "Node.js is already installed: v$current_version"
            return 0
        else
            log_info "Node.js v$current_version is installed but version < $NODE_MIN_VERSION. Upgrading..."
            install_nodejs
        fi
    else
        log_info "Node.js not found. Installing..."
            install_nodejs
    fi
}

# ========================
#        主流程
# ========================

main() {
    local use_china_flag=""
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --china|-c)
                USE_CHINA_MIRROR="true"
                use_china_flag=" (China Mirror)"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --china, -c    Use China mirrors for faster download"
                echo "  --help, -h     Show this help message"
                echo ""
                echo "Environment Variables:"
                echo "  USE_CHINA_MIRROR=true  Force use China mirrors"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    echo "🚀 Node.js Installation Script${use_china_flag}"
    echo ""
    
    check_nodejs
    
    echo ""
    log_success "🎉 Installation completed successfully!"
    echo ""
    echo "📝 To use Node.js in your current shell, run:"
    echo "   export NVM_DIR=\"\$HOME/.nvm\""
    echo "   [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
    if [ "$USE_CHINA_MIRROR" = "true" ] || detect_china_network; then
        echo "   export NVM_NODEJS_ORG_MIRROR=\"https://npmmirror.com/mirrors/node\""
    fi
    echo ""
    echo "   Or restart your terminal"
}

main "$@"

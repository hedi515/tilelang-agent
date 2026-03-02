#!/bin/bash

# Claude Code CLI 前置环境准备脚本
# 用于安装和配置运行Claude Code CLI所需的环境
# 包括: Node.js、npm、以及相关的环境配置

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# 版本配置
REQUIRED_NODE_VERSION=18
DEFAULT_NODE_VERSION="lts"  # 默认使用LTS版本

# 检测操作系统
detect_os() {
    # 检测WSL环境
    if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    WSL_ENV=true
    echo -e "${CYAN}检测到 WSL 环境${NC}"
    else
    WSL_ENV=false
    fi
    
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]] || [ "$WSL_ENV" = true ]; then
    # Linux 或 WSL
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_FAMILY=$ID_LIKE
        OS_VERSION=$VERSION_ID
    else
        OS="linux"
        OS_FAMILY="unknown"
        OS_VERSION="unknown"
    fi
    PLATFORM="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    OS="macos"
    OS_FAMILY="darwin"
    OS_VERSION=$(sw_vers -productVersion)
    PLATFORM="darwin"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    echo -e "${RED}❌ Windows 系统暂不支持此安装方式${NC}"
    echo -e "${YELLOW}请访问 https://www.aicodemirror.com 查看 Windows 安装指南${NC}"
    exit 1
    else
    echo -e "${RED}❌ 不支持的操作系统: $OSTYPE${NC}"
    exit 1
    fi
    
    echo -e "${CYAN}检测到系统: ${OS} ${OS_VERSION} (${PLATFORM})${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 强制超时下载函数
safe_download() {
    local url="$1"
    local output="$2"
    local timeout_seconds="$3"
    local description="$4"
    
    echo -e "${CYAN}${description}${NC}"
    echo -e "${YELLOW}URL: ${url}${NC}"
    echo -e "${YELLOW}超时设置: ${timeout_seconds}秒${NC}"
    
    # 创建一个子shell来执行下载
    (
    # 设置强制超时信号处理
    trap 'echo -e "\n${RED}❌ 下载被强制中断${NC}"; exit 124' TERM
    
    # 执行下载，使用多种超时机制
    timeout "$timeout_seconds" curl \
        --connect-timeout 10 \
        --max-time "$timeout_seconds" \
        --retry 2 \
        --retry-delay 2 \
        --fail \
        --location \
        --silent \
        --show-error \
        --output "$output" \
        "$url"
    ) &
    
    local download_pid=$!
    local elapsed=0
    
    # 监控下载进程
    while kill -0 "$download_pid" 2>/dev/null; do
    if [ $elapsed -ge $timeout_seconds ]; then
        echo -e "\n${RED}❌ 下载超时，强制终止进程...${NC}"
        kill -TERM "$download_pid" 2>/dev/null
        sleep 2
        kill -KILL "$download_pid" 2>/dev/null
        return 124
    fi
    
    printf "."
    sleep 1
    elapsed=$((elapsed + 1))
    done
    
    # 等待进程结束并获取退出码
    wait "$download_pid" 2>/dev/null
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
    echo -e "\n${GREEN}✓ 下载成功${NC}"
    return 0
    else
    echo -e "\n${RED}❌ 下载失败 (退出码: $exit_code)${NC}"
    return $exit_code
    fi
}

# 安全的git clone函数
safe_git_clone() {
    local repo="$1"
    local target="$2"
    local timeout_seconds="$3"
    local description="$4"
    
    echo -e "${CYAN}${description}${NC}"
    echo -e "${YELLOW}仓库: ${repo}${NC}"
    echo -e "${YELLOW}超时设置: ${timeout_seconds}秒${NC}"
    
    # 创建子shell执行git clone
    (
    trap 'echo -e "\n${RED}❌ 克隆被强制中断${NC}"; exit 124' TERM
    
    timeout "$timeout_seconds" git clone \
        --depth 1 \
        --single-branch \
        --branch v0.39.0 \
        "$repo" \
        "$target"
    ) &
    
    local clone_pid=$!
    local elapsed=0
    
    # 监控克隆进程
    while kill -0 "$clone_pid" 2>/dev/null; do
    if [ $elapsed -ge $timeout_seconds ]; then
        echo -e "\n${RED}❌ 克隆超时，强制终止进程...${NC}"
        kill -TERM "$clone_pid" 2>/dev/null
        sleep 2
        kill -KILL "$clone_pid" 2>/dev/null
        return 124
    fi
    
    printf "."
    sleep 1
    elapsed=$((elapsed + 1))
    done
    
    wait "$clone_pid" 2>/dev/null
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
    echo -e "\n${GREEN}✓ 克隆成功${NC}"
    return 0
    else
    echo -e "\n${RED}❌ 克隆失败 (退出码: $exit_code)${NC}"
    return $exit_code
    fi
}

# 检测WSL中Node.js是否为原生版本
check_wsl_native_node() {
    if [ "$WSL_ENV" = true ]; then
    if command_exists node; then
        local node_path=$(which node)
        local npm_path=$(which npm)
        
        echo -e "${CYAN}Node.js路径: ${node_path}${NC}"
        echo -e "${CYAN}npm路径: ${npm_path}${NC}"
        
        # 检查Node.js路径是否指向Windows
        if [[ "$node_path" == *"/mnt/c/"* ]] || [[ "$node_path" == *".exe"* ]]; then
            echo -e "${YELLOW}⚠ 检测到Windows版本的Node.js: ${node_path}${NC}"
            return 1  # 非原生
        fi
        
        # 检查npm路径
        if [[ "$npm_path" == *"/mnt/c/"* ]] || [[ "$npm_path" == *".exe"* ]]; then
            echo -e "${YELLOW}⚠ 检测到Windows版本的npm: ${npm_path}${NC}"
            return 1  # 非原生
        fi
        
        # 检查node执行是否返回Windows路径
        local node_exec_test=$(node -e "console.log(process.execPath)" 2>/dev/null)
        if [[ "$node_exec_test" == *":\\\\"* ]] || [[ "$node_exec_test" == *".exe"* ]] || [[ "$node_exec_test" == *"C:\\\\"* ]]; then
            echo -e "${YELLOW}⚠ Node.js指向Windows执行文件: ${node_exec_test}${NC}"
            return 1  # 非原生
        fi
        
        # 检查平台信息
        local platform_info=$(node -e "console.log(process.platform)" 2>/dev/null)
        if [[ "$platform_info" == "win32" ]]; then
            echo -e "${YELLOW}⚠ Node.js运行在Windows平台: ${platform_info}${NC}"
            return 1  # 非原生
        fi
        
        # 检查是否能正确访问Linux文件系统
        local fs_test=$(node -e "console.log(require('fs').existsSync('/etc/passwd'))" 2>/dev/null)
        if [[ "$fs_test" != "true" ]]; then
            echo -e "${YELLOW}⚠ Node.js无法访问Linux文件系统${NC}"
            return 1  # 非原生
        fi
        
        echo -e "${GREEN}✓ 检测到WSL原生Node.js${NC}"
        return 0  # 原生
    else
        return 1  # 未找到
    fi
    else
    return 0  # 非WSL环境，跳过检查
    fi
}

# 显示无sudo权限的安装指南
show_no_sudo_guide() {
    echo -e "${CYAN}=== 无sudo权限安装指南 ===${NC}"
    echo -e "${YELLOW}由于没有sudo权限，推荐使用以下方法安装Node.js：${NC}"
    echo ""
    echo -e "${BOLD}方法1: 使用nvm (推荐)${NC}"
    echo "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "source ~/.bashrc"
    echo "nvm install --lts"
    echo "nvm use --lts"
    echo ""
    echo -e "${BOLD}方法2: 使用国内镜像的nvm${NC}"
    echo "curl -o- https://gitee.com/mirrors/nvm/raw/v0.39.0/install.sh | bash"
    echo "source ~/.bashrc"
    echo "nvm install --lts"
    echo "nvm use --lts"
    echo ""
    echo -e "${BOLD}方法3: 手动安装${NC}"
    echo "1. 访问 https://nodejs.org/zh-cn/"
    echo "2. 下载LTS版本的二进制包"
    echo "3. 解压到 ~/node"
    echo "4. 添加到PATH: echo 'export PATH=\$HOME/node/bin:\$PATH' >> ~/.bashrc"
    echo ""
    echo -e "${GREEN}安装完成后请重新运行此脚本${NC}"
}

# 获取最新LTS版本
get_latest_lts_version() {
    local lts_version=""
    
    # 尝试从不同源获取LTS版本信息
    if curl -s --max-time 5 https://nodejs.org/dist/index.json > /dev/null 2>&1; then
    # 使用官方API
    lts_version=$(curl -s https://nodejs.org/dist/index.json | grep -o '"lts":"[^"]*"' | head -1 | cut -d'"' -f4)
    elif curl -s --max-time 5 https://registry.npmmirror.com/-/binary/node/ > /dev/null 2>&1; then
    # 使用国内镜像
    lts_version=$(curl -s https://registry.npmmirror.com/-/binary/node/ | grep -o 'v[0-9]*\.[0-9]*\.[0-9]*' | grep -E 'v(18|20|22)\.' | head -1 | cut -d'v' 

2 | cut -d'.' -f1)
    fi
    
    # 如果获取失败，使用默认版本
    if [ -z "$lts_version" ] || [ "$lts_version" = "false" ]; then
    echo "22"  # 当前最新LTS是22.x
    else
    # 如果是版本名称，转换为数字
    case "$lts_version" in
        "Hydrogen"|"hydrogen") echo "18" ;;
        "Iron"|"iron") echo "20" ;;
        "Jod"|"jod") echo "22" ;;
        *) echo "22" ;;  # 默认最新
    esac
    fi
}

# 清理WSL PATH中的Windows Node.js路径
clean_wsl_windows_path() {
    if [ "$WSL_ENV" = true ]; then
    # 检查PATH中是否包含Windows Node.js
    local has_windows_node=false
    if echo "$PATH" | grep -q "/mnt/c.*node" || which node 2>/dev/null | grep -q "/mnt/c"; then
        has_windows_node=true
    fi
    
    if [ "$has_windows_node" = true ]; then
        echo -e "${YELLOW}检测到PATH中包含Windows Node.js路径${NC}"
        echo -e "${CYAN}为避免冲突，建议临时清理PATH...${NC}"
        
        # 创建一个清理后的PATH，移除Windows相关的路径
        local clean_path=""
        IFS=':' read -ra PATH_ARRAY <<< "$PATH"
        for path_item in "${PATH_ARRAY[@]}"; do
            # 跳过Windows相关路径
            if [[ ! "$path_item" == *"/mnt/c/"* ]] && [[ ! "$path_item" == *".exe"* ]]; then
                if [ -z "$clean_path" ]; then
                    clean_path="$path_item"
                else
                    clean_path="$clean_path:$path_item"
                fi
            fi
        done
        
        # 临时使用清理后的PATH
        export PATH="$clean_path"
        echo -e "${GREEN}✓ 已临时清理PATH中的Windows路径${NC}"
    fi
    fi
}

# WSL环境特殊检查
check_wsl_environment() {
    if [ "$WSL_ENV" = true ]; then
    echo -e "${CYAN}=== WSL 环境检查 ===${NC}"
    
    # 清理Windows Node.js路径
    clean_wsl_windows_path
    
    # 检查是否需要更新包列表
    if [ ! -f /var/lib/apt/lists/lock ] || [ -z "$(find /var/lib/apt/lists -name '*.deb' -newer /var/lib/apt/lists/lock 2>/dev/null)" ]; then
        echo -e "${YELLOW}首次运行或包列表过期，可能需要更新软件包列表...${NC}"
        if sudo -n true 2>/dev/null; then
            sudo apt-get update
        else
            echo -e "${YELLOW}⚠ 没有sudo权限，建议手动运行: sudo apt-get update${NC}"
        fi
    fi
    
    # 检查网络连接
    if ! curl -s --max-time 5 http://archive.ubuntu.com > /dev/null; then
        echo -e "${RED}⚠ 网络连接异常，可能影响安装${NC}"
    fi
    
    # 检查磁盘空间
    local available_space=$(df / | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 1048576 ]; then  # 1GB in KB
        echo -e "${YELLOW}⚠ 磁盘空间可能不足，可用空间: $(df -h / | awk 'NR==2 {print $4}')${NC}"
    fi
    
    echo -e "${GREEN}✓ WSL 环境检查完成${NC}"
    fi
}

# 获取包管理器
get_package_manager() {
    if [[ "$PLATFORM" == "darwin" ]]; then
    if command_exists brew; then
        echo "brew"
    else
        echo "none"
    fi
    elif [[ "$PLATFORM" == "linux" ]]; then
    # 优先检测常见的包管理器
    if command_exists apt-get || command_exists apt; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists zypper; then
        echo "zypper"
    elif command_exists apk; then
        echo "apk"
    elif command_exists pacman; then
        echo "pacman"
    else
        echo "none"
    fi
    fi
}

# 安装Node.js - macOS
install_node_macos() {
    echo -e "${YELLOW}正在为 macOS 安装 Node.js...${NC}"
    
    local pkg_manager=$(get_package_manager)
    local node_version=$(get_latest_lts_version)
    
    echo -e "${CYAN}将安装 Node.js LTS 版本: ${node_version}.x${NC}"
    
    if [ "$pkg_manager" == "brew" ]; then
    echo -e "${CYAN}使用 Homebrew 安装 Node.js...${NC}"
    
    # 检查并配置国内镜像（如果在中国）
    if curl -s --max-time 2 http://www.google.com > /dev/null; then
        echo "使用默认 Homebrew 源"
    else
        echo -e "${YELLOW}检测到可能在中国，配置 Homebrew 国内镜像...${NC}"
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    fi
    
    # 根据LTS版本安装
    if [ "$node_version" = "22" ]; then
        brew install node  # 最新版本
    else
        brew install node@${node_version}
        brew link --overwrite node@${node_version}
    fi
    else
    echo -e "${YELLOW}未检测到 Homebrew，使用官方安装包...${NC}"
    echo -e "${CYAN}请访问 https://nodejs.org/zh-cn/download/ 下载并安装 Node.js${NC}"
    echo -e "${YELLOW}推荐使用国内镜像: https://npmmirror.com/mirrors/node/${NC}"
    echo ""
    echo "安装完成后，请重新运行此脚本"
    exit 1
    fi
}

# 安装Node.js - Linux
install_node_linux() {
    echo -e "${YELLOW}正在为 Linux 安装 Node.js...${NC}"
    
    local pkg_manager=$(get_package_manager)
    local node_version=$(get_latest_lts_version)
    
    echo -e "${CYAN}将安装 Node.js LTS 版本: ${node_version}.x${NC}"
    
    # 检查sudo权限
    local has_sudo=false
    if sudo -n true 2>/dev/null; then
    has_sudo=true
    fi
    
    # 检查git是否安装（nvm依赖）
    if ! command_exists git; then
    echo -e "${YELLOW}安装git（nvm依赖）...${NC}"
    if [ "$has_sudo" = true ]; then
        case "$pkg_manager" in
            apt) sudo apt-get install -y git ;;
            yum|dnf) sudo $pkg_manager install -y git ;;
            *) echo -e "${RED}❌ 需要安装git才能使用nvm${NC}"; exit 1 ;;
        esac
    else
        echo -e "${RED}❌ nvm需要git，但没有sudo权限安装${NC}"
        echo -e "${YELLOW}建议：先安装git或选择其他安装方式${NC}"
        exit 1
    fi
    fi
    
    # 使用统一的安装脚本
    echo -e "${CYAN}使用统一安装脚本安装 Node.js...${NC}"
    
    # 检测网络环境
    local china_flag=""
    if ! timeout 3 curl -s --max-time 2 "https://www.google.com" >/dev/null 2>&1; then
        china_flag="--china"
        echo -e "${YELLOW}检测到中国网络环境，使用国内镜像${NC}"
    fi
    
    # 调用统一安装脚本
    if [ -f "$SCRIPT_DIR/install_node.sh" ]; then
        bash "$SCRIPT_DIR/install_node.sh" $china_flag
    else
        echo -e "${RED}❌ 未找到 install_node.sh 脚本${NC}"
        exit 1
    fi
    
    # 加载 nvm 环境
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # WSL环境验证原生性
    if [ "$WSL_ENV" = true ]; then
        echo -e "${CYAN}验证WSL原生Node.js...${NC}"
        if check_wsl_native_node; then
            echo -e "${GREEN}✓ WSL原生Node.js验证成功${NC}"
        else
            echo -e "${YELLOW}⚠ 需要重新加载shell环境${NC}"
        fi
    fi
    
    # 验证环境
    if command_exists node && command_exists npm; then
        echo -e "${GREEN}✓ Node.js环境已就绪${NC}"
        echo -e "Node.js版本: ${CYAN}$(node --version)${NC}"
        echo -e "npm版本: ${CYAN}$(npm --version)${NC}"
    else
        echo -e "${RED}❌ Node.js环境加载失败${NC}"
        exit 1
    fi
}

# 配置 npm 国内镜像
configure_npm_mirror() {
    echo -e "${YELLOW}配置 npm 国内镜像...${NC}"
    
    # 检查网络环境
    if curl -s --max-time 2 http://www.google.com > /dev/null; then
    echo "检测到国际网络环境，使用默认 npm 源"
    else
    echo -e "${CYAN}配置淘宝 npm 镜像...${NC}"
    npm config set registry https://registry.npmmirror.com
    echo -e "${GREEN}✓ npm 镜像配置成功${NC}"
    fi
}

# 检查并安装 Node.js
check_and_install_node() {
    echo -e "${BLUE}=== 检查 Node.js 环境 ===${NC}"
    
    local latest_lts=$(get_latest_lts_version)
    echo -e "推荐 LTS 版本: ${CYAN}${latest_lts}.x${NC}"
    
    if command_exists node && command_exists npm; then
    # WSL环境下检查是否为原生Node.js
    if [ "$WSL_ENV" = true ]; then
        echo -e "${CYAN}WSL环境检查Node.js原生性...${NC}"
        if ! check_wsl_native_node; then
            echo -e "${RED}❌ 检测到Windows版本的Node.js，Claude Code无法在WSL中正常工作${NC}"
            echo -e "${YELLOW}正在自动安装WSL原生Node.js...${NC}"
            
            install_node_linux
            
            # 验证安装
            if check_wsl_native_node; then
                echo -e "${GREEN}✓ WSL原生Node.js安装成功${NC}"
            else
                echo -e "${RED}❌ WSL原生Node.js安装失败${NC}"
                exit 1
            fi
        fi
    fi
    
    local node_version=$(node --version 2>/dev/null | cut -d'v' -f2)
    local npm_version=$(npm --version 2>/dev/null)
    
    echo -e "当前 Node.js 版本: ${CYAN}v${node_version}${NC}"
    echo -e "当前 npm 版本: ${CYAN}v${npm_version}${NC}"
    
    # 检查版本是否满足要求
    local node_major=$(echo $node_version | cut -d'.' -f1)
    
    if [ "$node_major" -ge "$REQUIRED_NODE_VERSION" ]; then
        echo -e "${GREEN}✓ Node.js 版本满足要求${NC}"
        
        # 检查是否是最新LTS，仅提示但不自动升级
        if [ "$node_major" -lt "$latest_lts" ]; then
            echo -e "${YELLOW}💡 提示：当前使用 Node.js ${node_major}.x，最新LTS版本是 ${latest_lts}.x${NC}"
            echo -e "${CYAN}如需升级，可以手动运行: nvm install ${latest_lts}${NC}"
        else
            echo -e "${GREEN}✓ 已安装最新LTS版本${NC}"
        fi
        return 0
    else
        echo -e "${YELLOW}⚠ Node.js 版本过低，正在自动升级到 ${REQUIRED_NODE_VERSION} 或更高版本${NC}"
        echo -e "${CYAN}将安装最新LTS版本 ${latest_lts}.x${NC}"
        if [[ "$PLATFORM" == "darwin" ]]; then
            install_node_macos
        else
            install_node_linux
        fi
    fi
    else
    echo -e "${YELLOW}⚠ 未检测到 Node.js，正在自动安装...${NC}"
    
    # 检查sudo权限
    local has_sudo_here=false
    if sudo -n true 2>/dev/null; then
        has_sudo_here=true
    fi
    
    if [ "$has_sudo_here" = false ] && [[ "$PLATFORM" == "linux" ]]; then
        echo -e "${CYAN}将使用nvm方式安装Node.js（无需sudo权限）${NC}"
    fi
    
    if [[ "$PLATFORM" == "darwin" ]]; then
        install_node_macos
    else
        install_node_linux
    fi
    
    # 验证安装
    if command_exists node && command_exists npm; then
        echo -e "${GREEN}✓ Node.js 安装成功${NC}"
        node --version
        npm --version
    else
        echo -e "${RED}❌ Node.js 安装失败${NC}"
        exit 1
    fi
    fi
}

# 主函数
main() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}     Claude Code CLI 前置环境准备程序${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # 检查sudo权限状态
    local has_sudo_main=false
    if sudo -n true 2>/dev/null; then
    has_sudo_main=true
    echo -e "${GREEN}✓ 检测到sudo权限${NC}"
    else
    echo -e "${YELLOW}⚠ 未检测到sudo权限，将使用nvm方式安装${NC}"
    echo -e "${CYAN}💡 nvm方式无需sudo权限，更安全便捷${NC}"
    fi
    echo ""
    
    # 1. 检测操作系统
    detect_os
    echo ""
    
    # 2. WSL环境特殊检查
    check_wsl_environment
    echo ""
    
    # 3. 检查并安装 Node.js
    check_and_install_node
    echo ""
    
    # 4. 配置npm镜像
    configure_npm_mirror
    echo ""
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 前置环境准备完成！${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}环境信息：${NC}"
    echo -e "Node.js: ${CYAN}$(node --version)${NC}"
    echo -e "npm: ${CYAN}$(npm --version)${NC}"
    echo -e "npm registry: ${CYAN}$(npm config get registry)${NC}"
    echo ""
    echo -e "${GREEN}现在可以安装 Claude Code CLI 了！${NC}"
}

# 信号处理 - 确保脚本可以被中断
cleanup() {
    echo -e "\n${YELLOW}⚠ 安装被用户中断${NC}"
    # 清理可能的临时文件
    rm -f "$HOME/nvm.tar.gz" "$HOME/node.tar.xz" 2>/dev/null
    # 终止所有子进程
    jobs -p | xargs -r kill 2>/dev/null
    exit 130
}

# 设置信号处理
trap cleanup INT TERM
trap 'echo -e "\n${RED}❌ 安装过程中出现错误${NC}"; exit 1' ERR

# 运行主函数
main "$@"
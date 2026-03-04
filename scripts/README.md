# 安装脚本

本目录包含 TileLang Agent 的环境配置脚本。

## 脚本列表

| 脚本名称 | 功能描述 | 使用场景 | 依赖 | 详细说明 |
|---------|---------|---------|------|---------|
| init_home.sh | 容器启动时初始化 home 目录软链接 | 容器重启后恢复持久化配置 | bash, ln, chown | [创建软链接到持久化存储](../guide/enviroment/home_persistence.md) |
| install_node.sh | Node.js 自动安装 | 安装或升级 Node.js 环境 | curl, bash | 支持中国镜像，使用 nvm 安装 |
| install_tilelang.sh | TileLang 安装 | 一键安装 TileLang 开发环境 | git, bash | 自动配置 GitHub 镜像加速 |
| opencode_apikey_config.sh | OpenCode API Key 配置 | 配置 OpenCode 的 API Key 和模型端点 | bash | 交互式输入配置 |

## 使用样例

### 完整安装流程

```bash
# 1. 安装 Node.js（自动检测网络环境）
bash scripts/install_node.sh

# 2. 加载 nvm 环境（如需要）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. 安装 OpenCode
npm install -g opencode-ai

# 4. 配置 API Key
bash scripts/opencode_apikey_config.sh

# 5. 备份 home 目录（首次）
sudo bash scripts/backup_home.sh

# 6. 初始化 home 目录软链接
sudo bash scripts/init_home.sh
```

### 单独使用脚本

#### init_home.sh

```bash
# 容器重启后初始化 home 目录
sudo bash scripts/init_home.sh

# 初始化前需要修改脚本中的配置：
# SOURCE_HOME="/home/developer"        # 源家目录
# TARGET_HOME="/mnt/workspace/home"      # 目标持久化目录
# MAPPED_PATHS=("agent" ".bashrc")      # 需要持久化的路径
```

#### install_node.sh

```bash
# 自动检测网络环境
bash scripts/install_node.sh

# 强制使用中国镜像
bash scripts/install_node.sh --china

# 通过环境变量
USE_CHINA_MIRROR=true bash scripts/install_node.sh

# 显示帮助信息
bash scripts/install_node.sh --help
```

#### install_tilelang.sh

```bash
# 使用默认配置
bash scripts/install_tilelang.sh

# 指定仓库地址
bash scripts/install_tilelang.sh --repo git@github.com:your-repo/tilelang-ascend.git

# 显示帮助信息
bash scripts/install_tilelang.sh --help
```

#### opencode_apikey_config.sh

```bash
# 交互式配置
bash scripts/opencode_apikey_config.sh

# 按提示输入：
# 请输入 API Key: [your-api-key]
# 请输入END_POINT_ID (例如: ep-202620242022-123456): [your-end-point-id]
```

## 添加新脚本规范

### 1. 命名规范

- 使用小写字母和下划线
- 使用描述性名称，如 `install_python.sh`、`setup_env.sh`
- 避免使用缩写，除非是通用缩写（如 `api`、`config`）

**示例**:
```
✅ install_python.sh
✅ setup_docker.sh
✅ configure_git.sh

❌ installpy.sh
❌ setup-docker.sh
❌ cfg_git.sh
```

### 2. 脚本头部

每个脚本必须包含以下头部信息：

```bash
#!/bin/bash
# ======================================================
# 脚本简短描述（一行）
# 详细说明（多行）：
#   功能说明
#   使用场景
#   注意事项
# 执行时机：首次/每次/按需
# ======================================================
```

**示例**:
```bash
#!/bin/bash
# ======================================================
# Python 环境安装脚本
# 功能说明：
#   自动检测 Python 版本，如未安装或版本过低则安装
#   使用 pyenv 管理 Python 版本
# 使用场景：
#   首次配置开发环境
#   升级 Python 版本
# 注意事项：
#   需要网络连接
#   建议使用中国镜像加速
# 执行时机：首次或按需
# ======================================================
```

### 3. 错误处理

脚本必须包含错误处理：

```bash
set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时报错
set -o pipefail  # 管道命令失败时退出
```

### 4. 日志函数

建议使用统一的日志函数：

```bash
log_info() {
    echo "🔹 $*"
}

log_success() {
    echo "✅ $*"
}

log_error() {
    echo "❌ $*" >&2
}

log_warning() {
    echo "⚠️  $*" >&2
}
```

### 5. 参数处理

脚本应该支持 `--help` 参数：

```bash
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --option1, -o1    选项1说明"
    echo "  --option2, -o2    选项2说明"
    echo "  --help, -h        显示帮助信息"
    echo ""
    echo "Environment Variables:"
    echo "  ENV_VAR1           环境变量1说明"
    echo "  ENV_VAR2           环境变量2说明"
    exit 0
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --option1|-o1)
            OPTION1="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            ;;
    esac
done
```

### 6. 配置区域

脚本应该有清晰的配置区域：

```bash
# ---------- 用户配置区域 ----------
CONFIG_VAR1="default_value1"
CONFIG_VAR2="default_value2"
# ---------- 配置结束 ----------
```

### 7. 验证安装

脚本应该验证安装结果：

```bash
# 验证安装
if command -v python3 &>/dev/null; then
    log_success "Python installed: $(python3 --version)"
else
    log_error "Python installation failed"
    exit 1
fi
```

### 8. 添加到 README

添加新脚本后，需要更新此 README.md：

1. 在"脚本列表"表格中添加新脚本信息
2. 在"使用样例"中添加使用示例
3. 在"添加新脚本规范"中更新相关说明（如需要）

### 9. 测试脚本

添加新脚本后，应该进行测试：

```bash
# 测试帮助信息
bash scripts/your_script.sh --help

# 测试基本功能
bash scripts/your_script.sh

# 测试参数
bash scripts/your_script.sh --option1 value1

# 验证结果
# 检查脚本是否正确执行
# 检查是否有错误输出
# 检查是否达到预期效果
```

### 10. 权限设置

脚本应该具有可执行权限：

```bash
chmod +x scripts/your_script.sh
```

## 常见问题

### Q: 脚本执行权限不足？

A: 添加执行权限：
```bash
chmod +x scripts/your_script.sh
```

### Q: 脚本执行失败？

A: 检查以下内容：
1. 脚本头部是否正确（`#!/bin/bash`）
2. 依赖命令是否已安装
3. 配置项是否正确
4. 是否有足够的权限

### Q: 如何调试脚本？

A: 使用 `bash -x` 调试：
```bash
bash -x scripts/your_script.sh
```

### Q: 脚本需要 sudo 权限？

A: 使用 sudo 执行：
```bash
sudo bash scripts/your_script.sh
```

## 更多信息

- [主文档](../README.md)
- [操作指南](../guide/README.md)
- [环境配置](../guide/enviroment/)

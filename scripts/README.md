# 安装脚本

本目录包含 TileLang 开发环境配置脚本。

## 脚本列表

### install_node.sh

**功能**: 统一的 Node.js 安装脚本

**特性**:
- 自动检测网络环境，中国境内自动使用镜像
- 支持 Linux 和 macOS
- 使用 nvm 安装 Node.js 22
- 最低版本要求：Node.js 18
- 自动检测已安装版本，如版本过低则升级

**使用方法**:
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

**执行后提示**:
如需在当前 shell 中使用 Node.js，请运行：
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

或重启终端。

### install_tilelang.sh

**功能**: 在算力平台环境环境上一键安装 tilelang

**特性**:
- 自动配置 GitHub 镜像加速
- 支持自定义仓库地址
- 处理子模块依赖
- 完整的安装流程验证

**使用方法**:
```bash
# 使用默认配置
bash scripts/install_tilelang.sh

# 指定仓库地址
REPO_URL=git@github.com:your-repo/tilelang-ascend.git bash scripts/install_tilelang.sh
```

**配置项**:
```bash
MIRROR_URL="https://ghfast.top/https://github.com/"
DEFAULT_REPO="git@github.com:jackwangc/ai-tile.git"
PROJECT_DIR="ai-tile"
```

### opencode_apikey_config.sh

**功能**: 配置 OpenCode 的 API Key

**使用方法**:
```bash
bash scripts/opencode_apikey_config.sh
# 按提示输入 API Key 和 END_POINT_ID
```

**交互输入示例**:
```
请输入 API Key:
[输入您的 API Key]

请输入END_POINT_ID (例如: ep-202620242022-123456):
[输入您的 END_POINT_ID]
```

**配置文件位置**: `~/.config/opencode/opencode.json`

### backup_home.sh

**功能**: 首次备份 home 目录到持久化目录

**使用方法**:
```bash
sudo bash scripts/backup_home.sh
```

**配置**: 修改脚本中的以下配置项
```bash
SOURCE_HOME="/home/developer"           # 当前容器内的家目录路径
TARGET_HOME="/mnt/workspace/home"       # 持久化目标目录路径
EXCLUDE_LIST=(                        # 不需要备份的文件/目录名
    "Ascend"
    "ascend"
    "opensource"
)
```

**注意**: 
- 首次运行容器后手动执行一次
- 有些内容不会被备份，配置在脚本中的排除列表 `EXCLUDE_LIST` 里

### init_home.sh

**功能**: 容器启动时初始化 home 目录软链接

**使用方法**:
```bash
sudo bash scripts/init_home.sh
```

**配置**: 必须与 backup_home.sh 保持一致
```bash
SOURCE_HOME=" /home/developer"       # 当前容器内的家目录路径
TARGET_HOME="/mnt/workspace/home"       # 持久化目标目录路径
MAPPED_PATHS=(                       # 需要持久化的路径
    "agent"
    ".bashrc"
    ".bash_aliases"
    # ... 更多路径
)
```

**注意**:
- 需要先运行 backup_home.sh 进行首次备份
- 每次重启后执行此脚本即可恢复配置
- 有些文件/目录被占用，无法完全链接过去，比如 `.codearts-server`
- 有些文件/目录在环境初始时并不存在，使用过程中才会创建，如果备份时没有，可以自行创建

## 完整安装流程

在云服务器初始化时，按顺序执行以下命令：

```bash
# 1. 安装 Node.js
bash scripts/install_node.sh

# 2. 加载 nvm 环境（如需要）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. 安装 opencode
npm install -g opencode-ai

# 4. 配置 API Key
bash scripts/opencode_apikey_config.sh

# 5. 备份 home 目录（首次）
sudo bash scripts/backup_home.sh

# 6. 初始化 home 目录软链接
sudo bash scripts/init_home.sh
```

## 验证安装

安装完成后，可以通过以下命令验证：

```bash
# 检查 Node.js 版本
node -v

# 检查 npm 版本
npm -v

# 检查 opencode 版本
opencode --version
```

## 注意事项

1. 确保 Node.js 版本 >= 18
2. API Key 和 END_POINT_ID 需要提前准备好
3. 安装过程中需要网络连接
4. 建议使用 bash 执行脚本
5. 中国网络环境建议使用 `--china` 参数

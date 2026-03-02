# 脚本参考

详细说明各个脚本的功能、配置和使用方法。

## install_node.sh

### 功能说明

统一的 Node.js 安装脚本，支持自动网络检测和镜像切换。

### 参数说明

| 参数 | 说明 |
|------|------|
| `--china, -c` | 强制使用中国镜像 |
| `--help, -h` | 显示帮助信息 |

### 环境变量

| 变量 | 说明 |
|------|------|
| `USE_CHINA_MIRROR=true` | 强制使用中国镜像 |

### 网络检测

脚本会自动检测网络环境：
- 如果能访问 Google，使用官方源
- 否则自动使用中国镜像

### 镜像配置

**中国镜像**:
- NVM: `https://gitee.com/mirrors/nvm/raw`
- Node.js: `https://npmmirror.com/mirrors/node`

**官方源**:
- NVM: `https://raw.githubusercontent.com/nvm-sh/nvm`
- Node.js: `https://nodejs.org/dist`

### 版本配置

```bash
NODE_MIN_VERSION=18      # 最低版本要求
NODE_INSTALL_VERSION=22   # 安装版本
NVM_VERSION="v0.40.3"    # nvm 版本
```

### 支持平台

- Linux
- macOS

### 使用示例

```bash
# 自动检测网络环境
bash scripts/install_node.sh

# 强制使用中国镜像
bash scripts/install_node.sh --china

# 通过环境变量
USE_CHINA_MIRROR=true bash scripts/install_node.sh

# 显示帮助
bash scripts/install_node.sh --help
```

### 安装流程

1. 检测操作系统
2. 检测网络环境
3. 选择合适的镜像源
4. 下载并安装 nvm
5. 加载 nvm 环境
6. 设置 Node.js 镜像（如使用中国镜像）
7. 安装 Node.js 22
8. 设置为默认版本
9. 验证安装

### 验证安装

```bash
# 检查 Node.js 版本
node -v
# 输出: v22.x.x

# 检查 npm 版本
npm -v
# 输出: 10.x.x
```

---

## install_tilelang.sh

### 功能说明

在算力平台环境环境上一键安装 tilelang-ascend。

### 配置项

```bash
MIRROR_URL="https://ghfast.top/https://github.com/"
DEFAULT_REPO="git@github.com:jackwangc/ai-tile.git"
PROJECT_DIR="ai-tile"
```

### 使用流程

1. 检查系统环境（Linux only）
2. 配置 SSH 密钥（如果需要）
3. 克隆仓库
4. 配置子模块镜像
5. 初始化子模块
6. 更新子模块
7. 执行安装脚本
8. 验证安装

### 使用示例

```bash
# 使用默认配置
bash scripts/install_tilelang.sh

# 指定仓库地址
REPO_URL=git@github.com:your-repo/tilelang-ascend.git bash scripts/install_tilelang.sh

# 指定项目目录
PROJECT_DIR=my-tilelang bash scripts/install_tilelang.sh
```

### 前置条件

- Linux 操作系统
- Git 已安装
- Python 3.10 或更高
- Bash shell
- GitHub 仓库访问权限

### 子模块镜像配置

脚本会自动配置 `.gitmodules` 使用镜像加速：

```gitmodules
[submodule "3rdparty/tvm"]
    path = 3rdparty/tvm
    url = https://ghfast.top/https://github.com/tlc-pack/tvm.git
```

---

## opencode_apikey_config.sh

### 功能说明

交互式配置 OpenCode 的 API Key 和模型端点。

### 配置文件位置

`~/.config/opencode/opencode.json`

### 配置格式

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "myprovider": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "volcengine",
      "options": {
        "baseURL": "https://ark.cn-beijing.volces.com/api/v3",
        "apiKey": "your-api-key"
      },
      "models": {
        "ep-202620242022-123456": {
          "name": "GLM-4-7-ep-202620242022-123456"
        }
      }
    }
  }
}
```

### 使用示例

```bash
bash scripts/opencode_apikey_config.sh
```

**交互流程**:
```
请输入 API Key:
[输入您的 API Key]

请输入END_POINT_ID (例如: ep-202620242022-123456):
[输入您的 END_POINT_ID]

配置文件已生成: /home/developer/.config/opencode/opencode.json
{...配置内容...}
```

### 注意事项

1. API Key 需要提前准备好
2. END_POINT_ID 格式：`ep-YYYYMMDDHHMM-XXXXXX`
3. 配置文件会被覆盖，如需保留请先备份

---

## backup_home.sh

### 功能说明

首次备份容器家目录到持久化存储。

### 配置项

```bash
SOURCE_HOME="/home/developer"           # 当前容器内的家目录路径
TARGET_HOME="/mnt/workspace/home"       # 持久化目标目录路径
EXCLUDE_LIST=(                        # 不需要备份的文件/目录名
    "Ascend"
    "ascend"
    "opensource"
)
```

### 使用步骤

1. 首次运行容器后执行
2. 根据需要修改配置项
3. 执行脚本进行备份
4. 后续使用 init_home.sh 恢复

### 使用示例

```bash
# 直接执行
sudo bash scripts/backup_home.sh

# 如果目标目录已存在且不为空，会提示确认
# 输入 y 或 Y 继续，其他取消
```

### 排除列表说明

`EXCLUDE_LIST` 中的顶层文件/目录将不会被复制到 `TARGET_HOME`：

- `Ascend`: 昇腾相关目录，通常很大
- `ascend`: 昇腾相关目录
- `opensource`: 开源代码目录

可以根据需要添加或删除排除项。

### 备份内容

脚本会备份所有顶层条目（包括隐藏文件），除了排除列表中的项。

### 注意事项

1. 需要使用 sudo 执行
2. 首次运行前确保 `TARGET_HOME` 存在或可创建
3. 如果 `TARGET_HOME` 已存在且不为空，会提示确认
4. 有些内容不会被备份，配置在脚本中的排除列表里

---

## init_home.sh

### 功能说明

容器启动时初始化 home 目录，创建软链接到持久化存储。

### 配置项

必须与 backup_home.sh 保持一致：

```bash
SOURCE_HOME="/home/developer"       # 当前容器内的家目录路径
TARGET_HOME="/mnt/workspace/home"   # 持久化目标目录路径
MAPPED_PATHS=(                   # 需要持久化的路径
    "agent"
    ".bashrc"
    ".bash_aliases"
    ".bash_history"
    ".bun"
    ".cache"
    "CANNBot"
    "codearts"
    ".codearts-server/extensions"
    ".config"
    ".gitconfig"
    ".local"
    "log"
    ".opencode"
    ".pip"
    ".profile"
    ".ssh"
    "var"
    ".vscode-server"
)
```

### 使用步骤

1. 确保已运行 backup_home.sh
2. 容器启动后执行
3. 检查软链接是否正确创建

### 使用示例

```bash
# 直接执行
sudo bash scripts/init_home.sh
```

### 处理逻辑

对于 `MAPPED_PATHS` 中的每个路径：

1. 检查目标是否存在于 `TARGET_HOME`
2. 如果源已存在且不是链接，移动到备份目录
3. 如果源是错误的链接，删除
4. 创建新的符号链接
5. 修复链接权限

### 注意事项

1. 需要先运行 backup_home.sh 进行首次备份
2. 必须使用 sudo 执行
3. 确保在运行此脚本前，没有进程占用相关路径（如 vscode-server）
4. 有些文件/目录被占用，无法完全链接过去，比如 `.codearts-server`
5. 有些文件/目录在环境初始时并不存在，使用过程中才会创建，如果备份时没有，可以自行创建

### 故障排除

**问题**: 无法移动文件/目录

**症状**: `错误：无法移动 $src 到 $backup_path`

**原因**: 有进程正在使用该文件/目录（例如 vscode-server）

**解决**: 手动终止占用进程后重新运行此脚本

**问题**: 目标不存在

**症状**: `错误：目标 $dst 不存在`

**原因**: 未运行 backup_home.sh

**解决**: 先运行 backup_home.sh 进行首次备份

---

## 完整安装流程

### 首次配置

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

### 容器重启后

```bash
# 只需重新初始化 home 目录软链接
sudo bash scripts/init_home.sh
```

### 验证安装

```bash
# 检查 Node.js 版本
node -v

# 检查 npm 版本
npm -v

# 检查 opencode 版本
opencode --version

# 检查配置文件
cat ~/.config/opencode/opencode.json
```

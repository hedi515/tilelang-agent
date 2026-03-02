# TileLang Agent

TileLang 开发辅助工具集，提供环境配置脚本和自定义 AI Skills，提升在算力平台上的开发效率。

## 快速开始

| 步骤 | 说明 | 详细文档 |
|------|------|----------|
| 1. 环境安装 | 配置开发环境，包括 Node.js、OpenCode 等 | [详细安装指南](guide/getting-started/installation.md) |
| 2. 项目挂载 | 将 tilelang-agent 挂载到开发目录，使用自定义 Skills | [项目挂载指南](guide/getting-started/project-setup.md) |
| 3. Home 持久化 | 配置 home 目录持久化，避免容器重启丢失配置 | [Home 持久化指南](guide/getting-started/home-persistence.md) |

## 目录结构

```
tilelang-agent/
├── scripts/                    # 环境境配置脚本
│   ├── install_node.sh         # Node.js 安装
│   ├── install_tilelang.sh     # TileLang 安装
│   ├── opencode_apikey_config.sh  # API Key 配置
│   ├── backup_home.sh          # Home 目录备份
│   └── init_home.sh           # Home 目录初始化
├── .agents/skills/            # 自定义 AI Skills
│   ├── tilelang-install-skill  # TileLang 安装
│   ├── tilelang-debug-helper   # 调试辅助
│   ├── skill-creator           # Skill 创建工具
│   ├── requesting-code-review    # 代码审查
│   └── xlsx                  # Excel 处理
├── guide/                     # 操作指南
│   ├── getting-started/        # 快速开始
│   ├── development/            # 开发指南
│   └── reference/             # 参考文档
├── tilelang-ascend-docs/      # TileLang 架构文档
│   └── AGENTS.md             # 架构说明
└── statistics/                # 统计数据
```

## 主要功能

### 环境配置脚本

| 脚本名称 | 功能 | 特性 | 详细文档 |
|----------|------|------|----------|
| install_node.sh | Node.js 自动安装 | 支持中国镜像，自动检测网络环境，使用 nvm 安装 Node.js 22 | [脚本参考](guide/reference/scripts.md#install_node_sh) |
| install_tilelang.sh | TileLang 安装 | 一键安装和配置 TileLang 开发环境，自动配置 GitHub 镜像加速 | [脚本参考](guide/reference/scripts.md#install_tilelang_sh) |
| opencode_apikey_config.sh | OpenCode 配置 | 一键配置 API Key 和模型端点，交互式输入 | [脚本参考](guide/reference/scripts.md#opencode_apikey_config_sh) |
| backup_home.sh | Home 目录备份 | 首次备份容器家目录到持久化存储，支持排除列表 | [脚本参考](guide/reference/scripts.md#backup_home_sh) |
| init_home.sh | Home 目录初始化 | 容器启动时初始化 home 目录软链接，恢复持久化配置 | [脚本参考](guide/reference/scripts.md#init_home_sh) |

### AI Skills

| Skill 名称 | 功能 | 使用场景 | 触发方式 | 详细文档 |
|------------|------|----------|----------|----------|
| tilelang-install-skill | TileLang 安装 | 在算力平台环境上安装 TileLang，配置 SSH 密钥，克隆仓库 | 提及"安装 TileLang"、"设置 TileLang"等关键词 | [Skill 参考](guide/reference/skills-reference.md#tilelang-install-skill) |
| tilelang-debug-helper | 调试辅助 | 为 TileLang 示例添加 GDB 调试支持，创建可调试版本 | 提及"调试"、"GDB"、"断点"等关键词 | [Skill 参考](guide/reference/skills-reference.md#tilelang-debug-helper) |
| skill-creator | Skill 创建 | 创建新 Skills，改进现有 Skills，运行评估和性能测试 | 提及"创建 skill"、"优化 skill"等关键词 | [Skill 参考](guide/reference/skills-reference.md#skill-creator) |
| requesting-code-review | 代码审查 | 自动进行代码质量检查，发现潜在问题 | 完成任务、实现功能或准备合并时自动触发 | [Skill 参考](guide/reference/skills-reference.md#requesting-code-review) |
| xlsx | Excel 处理 | 处理和分析 Excel 文件，数据转换和生成报告 | 提及 Excel、xlsx 等关键词 | [Skill 参考](guide/reference/skills-reference.md#xlsx) |

## 详细文档

| 文档分类 | 文档名称 | 说明 | 链接 |
|----------|----------|------|------|
| **快速开始** | 环境安装 | 配置开发环境的详细步骤，包括 Node.js、OpenCode、Home 持久化 | [查看文档](guide/getting-started/installation.md) |
| **快速开始** | 项目挂载 | 将 tilelang-agent 挂载到开发目录的步骤和验证方法 | [查看文档](guide/getting-started/project-setup.md) |
| **快速开始** | Home 持久化 | 配置 home 目录持久化，避免容器重启丢失配置 | [查看文档](guide/getting-started/home-persistence.md) |
| **开发指南** | Skills 使用 | 如何在 TileLang 开发中使用自定义 Skills，自动触发和手动调用 | [查看文档](guide/development/skills.md) |
| **开发指南** | 测试策略 | TileLang 开发中的测试方法和策略，包括单元测试、集成测试、性能测试 | [查看文档](guide/development/testing.md) |
| **参考文档** | 脚本参考 | 详细说明各个脚本的功能、配置项、使用方法和故障排除 | [查看文档详细说明](guide/reference/scripts.md) |
| **参考文档** | Skills 参考 | Skills 的详细功能说明、使用流程、VSCode 配置和最佳实践 | [查看文档详细说明](guide/reference/skills-reference.md) |

## 快速命令

### 安装环境

```bash
# 安装 Node.js（自动检测网络）
bash scripts/install_node.sh

# 配置 OpenCode API Key
bash scripts/opencode_apikey_config.sh

# 备份 home 目录
sudo bash scripts/backup_home.sh

# 初始化 home 目录
sudo bash scripts/init_home.sh
```

### 挂载项目

```bash
# 挂载 .agents 目录
ln -s /path/to/tilelang-agent/.agents \
      /path/to/tilelang-ascend/.agents

# 挂载 AGENTS.md（可选）
ln -s /path/to/tilelang-agent/tilelang-ascend-docs/AGENTS.md \
      /path/to/tilelang-ascend/AGENTS.md
```

## 使用示例

### 开发新算子

```
用户: 我要开发一个新的 Flash Attention 算子
# → AI 使用 tilelang-debug-helper 和 requesting-code-review

用户: 算子写好了，帮我 review
# → AI 自动触发 requesting-code-review

用户: 测试时遇到问题，帮我调试
# → AI 使用 tilelang-debug-helper
```

### 快速修复 Bug

```
用户: 这个 GEMM 示例有 bug
# → AI 使用 tilelang-debug-helper 添加调试代码

用户: 修复完成，review 一下
# → AI 使用 requesting-code-review
```

## 算力平台使用

当前算力平台已上线，可以通过以下方式访问：

| 访问方式 | 说明 | 推荐度 |
|----------|------|----------|
| 个人电脑 | 直接访问 | ⭐⭐ |
| 开源空间 | 通过平台访问 | ⭐⭐⭐ |
| 黄区 Jumper | 跳转蓝区访问，体验更丝滑 | ⭐⭐⭐⭐ |

**在算力平台上使用本工具集可以：**
- 快速配置开发环境
- 避免平台崩溃导致的配置丢失
- 提高开发效率

## 贡献

欢迎提交 Issue 和 Pull Request！

### 贡献指南

| 步骤 | 操作 |
|------|------|
| 1 | Fork 本仓库 |
| 2 | 创建特性分支 (`git checkout -b feature/AmazingFeature`) |
| 3 | 提交更改 (`git commit -m 'Add some AmazingFeature'`) |
| 4 | 推送到分支 (`git push origin feature/AmazingFeature`) |
| 5 | 开启 Pull Request |

## 许可证

MIT License

## 联系方式

如有问题或建议，请通过以下方式联系：

| 方式 | 链接 |
|------|------|
| 提交 Issue | [GitHub Issues](https://github.com/hedi515/tilelang-agent/issues) |
| 发送邮件 | - |

## 相关资源

| 资源名称 | 说明 | 链接 |
|----------|------|------|
| TileLang-Ascend | TileLang 主项目 | [GitHub](https://github.com/tile-ai/tilelang-ascend) |
| OpenCode | AI 编程助手 | [官网](https://opencode.ai) |
| Skills 市场 | 更多 AI Skills | [Skills.sh](https://skills.sh/) |

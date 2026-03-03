# TileLang Agent

TileLang 开发辅助工具集，提供环境配置脚本和自定义 AI Skills，提升在算力平台上的开发效率。

## 快速开始

| 步骤 | 说明 | 详细文档 |
|------|------|----------|
| 1. 环境安装 | 配置开发环境，包括 Node.js、OpenCode 等 | [详细安装指南](guide/development/opencode_installation_guide.md) |
| 2. Home 持久化 | 配置 home 目录持久化，避免容器重启丢失配置 | [Home 持久化指南](guide/enviroment/home_persistence.md) |
| 3. 项目挂载 | 将 tilelang-agent 挂载到开发目录，使用自定义 Skills | [项目挂载指南](guide/enviroment/tilelang_agent_mount.md) |

## 目录结构

```
tilelang-agent/
├── scripts/                    # 环境配置脚本
│   ├── install_node.sh         # Node.js 安装
│   ├── install_tilelang.sh     # TileLang 安装
│   ├── opencode_apikey_config.sh  # API Key 配置
│   ├── backup_home.sh          # Home 目录备份
│   ├── init_home.sh           # Home 目录初始化
│   └── README.md              # 脚本使用说明
├── guide/                     # 操作指南
│   ├── README.md              # 操作指南概览
│   ├── development/            # 开发相关
│   │   └── opencode_installation_guide.md  # OpenCode 安装指南
│   └── enviroment/            # 环境配置
│       ├── home_persistence.md  # Home 持久化
│       └── tilelang_agent_mount.md  # 项目挂载
├── statistics/                # 统计数据
│   ├── README.md              # 统计数据说明
│   ├── 202602/                # 2026年2月统计
│   │   ├── tilelang_ascend_stats.md
│   │   └── tilelang_ascend_stats.xlsx
│   ├── 202603/                # 2026年3月统计（待生成）
│   └── github_repo_stats_prompt.md  # 统计提示词
├── .agents/                   # 通用 AI Skills
│   └── skills/
│       └── skill-creator/     # Skill 创建工具
├── tilelang-ascend-agent/    # TileLang-Ascend 专用目录
│   ├── .agents/              # TileLang-Ascend AI Skills
│   │   └── skills/
│   │       ├── tilelang-debug-helper/      # 调试辅助
│   │       ├── setup-tilelang-agent/      # 安装挂载
│   │       ├── tilelang-install-skill/      # TileLang 安装
│   │       └── requesting-code-review/    # 代码审查
│   ├── AGENTS.md             # TileLang-Ascend 项目架构说明
│   └── README.md            # 本目录说明文档
└── README.md                  # 项目主文档
```

## 主要功能

### 环境配置脚本

提供自动化脚本用于配置开发环境。详细说明请参考 [脚本参考](scripts/README.md)。

| 脚本名称 | 功能 |
|----------|------|
| install_node.sh | Node.js 自动安装（支持中国镜像，使用 nvm 安装 Node.js 22） |
| install_tilelang.sh | TileLang 安装（一键安装和配置，自动配置 GitHub 镜像加速） |
| opencode_apikey_config.sh | OpenCode 配置（一键配置 API Key 和模型端点） |
| backup_home.sh | Home 目录备份（首次备份容器家目录到持久化存储） |
| init_home.sh | Home 目录初始化（容器启动时初始化 home 目录软链接） |

### AI Skills

提供自定义 AI Skills 增强 OpenCode Agent 能力。详细说明请参考：

- [通用 Skills](.agents/skills/) - 通用技能（如 skill-creator）
- [TileLang-Ascend Skills](tilelang-ascend-agent/README.md) - TileLang-Ascend 专用技能

| Skill 类别 | 说明 |
|-----------|------|
| tilelang-debug-helper | TileLang 调试辅助，为示例添加 GDB 调试支持 |
| setup-tilelang-agent | TileLang-Ascend Agent 安装挂载 |
| tilelang-install-skill | TileLang 安装，包括系统检查、SSH 配置、仓库克隆等 |
| requesting-code-review | 代码审查，自动进行代码质量检查 |
| skill-creator | Skill 创建，创建新 Skills，改进现有 Skills |

## 算力平台使用

当前算力平台已上线，可以通过以下方式访问：

| 访问方式 | 说明 | 推荐度 |
|----------|------|----------|
| 个人电脑 | 蓝区电脑直接访问 | ⭐⭐ |
| 开源空间 | 黄区通过开源空间访问 | ⭐⭐⭐ |
| 个人电脑 + 黄区 Jumper | 黄区跳转到蓝区访问，体验更丝滑 | ⭐⭐⭐⭐ |

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

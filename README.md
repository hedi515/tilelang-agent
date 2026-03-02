# TileLang Agent

TileLang 开发辅助工具集，提供环境配置脚本和自定义 AI Skills，提升在算力平台上的开发效率。

## 快速开始

### 1. 环境安装

配置开发环境，包括 Node.js、OpenCode 等：

[详细安装指南](guide/getting-started/installation.md)

### 2. 项目挂载

将 tilelang-agent 挂载到开发目录，使用自定义 Skills：

[项目挂载指南](guide/getting-started/project-setup.md)

### 3. Home 持久化

配置 home 目录持久化，避免容器重启丢失配置：

[Home 持久化指南](guide/getting-started/home-persistence.md)

## 目录结构

```
tilelang-agent/
├── scripts/                    # 环境配置脚本
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
│   ├── getting-started/         # 快速开始
│   ├── development/            # 开发指南
│   └── reference/             # 参考文档
├── tilelang-ascend-docs/      # TileLang 架构文档
│   └── AGENTS.md             # 架构说明
└── statistics/                # 统计数据
```

## 主要功能

### 环境配置

- **Node.js 自动安装**: 支持中国镜像，自动检测网络环境
- **OpenCode 配置**: 一键配置 API Key 和模型端点
- **Home 持久化**: 容器重启后保持配置和文件

### 开发辅助

- **TileLang 安装**: 一键安装和配置 TileLang 开发环境
- **调试辅助**: 为示例添加 GDB 调试支持
- **代码审查**: 自动进行代码质量检查
- **Skill 创建**: 快速创建和优化自定义 Skills

## 文档

### 快速开始

- [环境安装](guide/getting-started/installation.md) - 配置开发环境
- [项目挂载](guide/getting-started/project-setup.md) - 挂载到开发目录
- [Home 持久化](guide/getting-started/home-persistence.md) - 配置持久化

### 开发指南

- [Skills 使用](guide/development/skills.md) - 如何使用自定义 Skills
- [测试策略](guide)development/testing.md) - 测试方法和最佳实践

### 参考文档

- [脚本参考](guide/reference/scripts.md) - 脚本详细说明
- [Skills 参考](guide/reference/skills-reference.md) - Skills 详细说明

### 脚本文档

- [安装脚本概览](scripts/README.md) - 所有脚本说明和使用示例

### Skills 文档

- [Skills 概览](.agents/skills/README.md) - 可用 Skills 列表和使用指南

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
mkdir -p /path/to/tilelang-ascend/docs
ln -s /path/to/tilelang-agent/tilelang-ascend-docs/AGENTS.md \
      /path/to/tilelang-ascend/docs/AGENTS.md
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

1. **个人电脑** - 直接访问
2. **开源空间** - 通过平台访问
3. **黄区 Jumper** - 推荐方式，跳转蓝区访问，体验更丝滑

在算力平台上使用本工具集可以：
- 快速配置开发环境
- 避免平台崩溃导致的配置丢失
- 提高开发效率

## 贡献

欢迎提交 Issue 和 Pull Request！

### 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

MIT License

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 [Issue](https://github.com/hedi515/tilelang-agent/issues)
- 发送邮件

## 相关资源

- [TileLang-Ascend](https://github.com/tile-ai/tilelang-ascend) - TileLang 主项目
- [OpenCode](https://opencode.ai) - AI 编程助手
- [Skills 市场](https://skills.sh/) - 更多 AI Skills

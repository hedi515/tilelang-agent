# 操作指南

本目录包含 TileLang Agent 的使用指南。

## 文档列表

### 环境配置

| 文档 | 说明 |
|------|------|
| [enviroment/home_persistence.md](enviroment/home_persistence.md) | Home 目录持久化配置，避免容器重启丢失配置 |
| [enviroment/tilelang_agent_mount.md](enviroment/tilelang_agent_mount.md) | 项目挂载指南，将 tilelang-agent 挂载到开发目录 |

### 开发

| 文档 | 说明 |
|------|------|
| [development/opencode_installation_guide.md](development/opencode_installation_guide.md) | OpenCode 安装指南，包括 Node.js、OpenCode、API Key 配置 |

## 使用流程

1. **OpenCode 安装** - 参考 [development/opencode_installation_guide.md](development/opencode_installation_guide.md)
2. **Home 持久化** - 参考 [enviroment/home_persistence.md](enviroment/home_persistence.md)
3. **项目挂载** - 参考 [enviroment/tilelang_agent_mount.md](enviroment/tilelang_agent_mount.md)

## 快速命令

```bash
# 1. 安装 Node.js
bash ../scripts/install_node.sh

# 2. 安装 OpenCode
npm install -g opencode-ai

# 3. 配置 API Key
bash ../scripts/opencode_apikey_config.sh

# 4. 备份 home 目录
sudo bash ../scripts/backup_home.sh

# 5. 初始化 home 目录
sudo bash ../scripts/init_home.sh

# 6. 挂载到项目
ln -s tilelang-agent/tilelang-agent/.agents \
      tilelang-ascend/.agents
```

## 验证安装

```bash
# 检查 Node.js
node -v

# 检查 OpenCode
opencode --version

# 检查 Skills
ls -la /tilelang-ascend/.agents/skills/
```

## 更多信息

- [主文档](../README.md)
- [脚本参考](../scripts/README.md)
- [Skills 概览](../.agents/skills/README.md)

# TileLang Agent - Skills 目录

本目录包含 TileLang 项目专用的 AI Skills，为 OpenCode Agent 提供项目特定的 AI 能力。

## 目录结构

```
tilelang-agent/
├── .agents/              # AI Skills 目录
│   └── skills/          # 具体技能实现
│       ├── tilelang-install-skill/    # TileLang 安装
│       ├── setup-tilelang-agent/      # TileLang Agent 安装挂载
│       └── skill-creator/            # Skill 创建（软链接）
├── scripts/             # 辅助脚本
│   ├── install_node.sh               # Node.js 安装
│   ├── install_tilelang.sh           # TileLang 安装
│   ├── opencode_apikey_config.sh     # API Key 配置
│   └── init_home.sh                # Home 目录持久化
├── guide/               # 操作指南
│   └── enviroment/
│       └── home_persistence.md      # Home 目录持久化说明
└── README.md            # 主文档
```

## Skills 功能总览

| Skill 名称 | 功能描述 | 使用场景 | 触发关键词 | 使用方法 |
|-----------|---------|---------|-----------|---------|
| tilelang-install-skill | TileLang 安装 | 完整的 TileLang 安装流程，包括系统检查、SSH 配置、仓库克隆等 | 安装 TileLang、设置 TileLang、配置 TileLang | 1. 检查系统兼容性<br/>2. 配置 SSH 密钥<br/>3. 克隆仓库<br/>4. 配置镜像加速<br/>5. 更新子模块<br/>6. 执行安装脚本<br/>7. 验证安装 |
| setup-tilelang-agent | TileLang Agent 安装挂载 | 将 tilelang-agent 挂载到 tilelang-ascend 项目，创建软链接 | 安装、挂载、设置、配置 | 1. 确定安装目录<br/>2. 创建 .agents 和 AGENTS.md 软链接<br/>3. 更新 .gitignore<br/>4. 验证安装 |
| skill-creator | Skill 创建 | 创建新 Skills，改进现有 Skills，运行评估和性能测试 | 创建 skill、优化 skill、改进 skill | 1. 创建 Skill 目录和 SKILL.md<br/>2. 编写 Skill 内容<br/>3. 测试 Skill<br/>4. 评估和优化 |

## 详细说明

### 1. tilelang-install-skill

**功能**：完整的 TileLang 安装流程

**使用场景**：
- 在 Linux 系统上安装 TileLang
- 配置 SSH 密钥访问 GitHub
- 克隆并初始化子模块
- 执行安装脚本

**使用方法**：
1. 检查系统兼容性（Linux only）
2. 配置 SSH 密钥（生成或使用现有密钥）
3. 克隆 TileLang 仓库
4. 配置 GitHub 镜像加速
5. 初始化和更新子模块
6. 执行 `install_ascend.sh` 脚本
7. 清理镜像配置
8. 验证安装

**输出**：
- 安装进度信息
- 成功或错误消息
- 验证结果

### 2. setup-tilelang-agent

**功能**：将 tilelang-agent 挂载到 tilelang-ascend 项目

**使用场景**：
- 安装 tilelang-agent 到项目
- 设置自定义 AI agent skills
- 配置开发环境

**使用方法**：
1. 确定安装目录（TL_ROOT 环境变量或用户指定）
2. 创建软链接：
   - `.agents` → `tilelang-agent/tilelang-agent/.agents`
   - `AGENTS.md` → `tilelang-agent/tilelang-agent/AGENTS.md`
3. 更新 `.gitignore` 忽略这些链接
4. 验证安装成功

**输出**：
- 安装摘要（路径、链接）
- 验证结果

### 3. skill-creator

**功能**：创建和优化 Skills

**使用方法**：
1. 创建 Skill 目录结构
2. 编写 SKILL.md 文件（包含 YAML front matter）
3. 实现 Skill 功能
4. 测试 Skill
5. 运行评估和优化

**输出**：
- Skill 文件
- 测试结果
- 优化建议

## 使用指南

### 挂载到 tilelang-ascend 项目

```bash
# 挂载 .agents 目录
ln -s /path/to/tilelang-agent/tilelang-agent/.agents \
      /path/to/tilelang-ascend/.agents

# 挂载 AGENTS.md
ln -s /path/to/tilelang-agent/tilelang-agent/AGENTS.md \
      /path/to/tilelang-ascend/AGENTS.md
```

### 验证挂载

```bash
# 检查 .agents 软链接
ls -la /path/to/tilelang-ascend/.agents

# 检查 AGENTS.md 软链接
ls -la /path/to/tilelang-ascend/AGENTS.md

# 检查 Skills
ls -la /path/to/tilelang-ascend/.agents/skills/
```

### 使用 Skills

Skills 会根据对话内容自动触发：

```
# 自动触发示例
用户: 帮我安装 TileLang
# AI 自动加载 tilelang-install-skill

用户: 安装这个仓库
# AI 自动加载 setup-tilelang-agent

# 手动指定
用户: 使用 skill-creator 创建一个新的 skill
```

## 修改规范

### 添加新 Skill

1. **创建 Skill 目录**
   ```bash
   mkdir -p .agents/skills/your-skill-name
   ```

2. **创建 SKILL.md 文件**
   - 必须包含 YAML front matter
   - 格式：
     ```yaml
     ---
     name: your-skill-name
     description: 简短描述，说明何时使用此 skill
     ---
     ```

3. **编写 Skill 内容**
   - 功能说明
   - 使用场景
   - 使用步骤
   - 示例代码
   - 注意事项

4. **更新 README.md**
   - 在 Skills 表格中添加新 Skill 信息
   - 确保信息完整准确

5. **测试 Skill**
   - 验证触发关键词是否正确
   - 测试 Skill 功能是否正常
   - 检查文档是否清晰

### Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

#### Scope 范围

- `skills`: Skills 相关
- `scripts`: 脚本相关
- `docs`: 文档相关

#### 示例

```bash
# 添加新 Skill
git commit -m "feat(skills): add new skill for debugging"

# 修改文档
git commit -m "docs: update README.md - add new skill description"

# 修复脚本问题
git commit -m "fix(scripts): fix init_home.sh SSH ownership issue"
```

## 相关资源

- [主文档](../README.md)
- [操作指南](../guide/README.md)
- [脚本参考](../scripts/README.md)
- [Home 目录持久化](../guide/enviroment/home_persistence.md)
- [TileLang-Ascend 仓库](https://github.com/tile-ai/tilelang-ascend)
- [OpenCode 文档](https://opencode.ai)

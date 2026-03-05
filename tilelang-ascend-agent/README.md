# TileLang-Ascend Agent - Skills 目录

本目录包含 TileLang-Ascend 项目专用的 AI Skills，为 OpenCode Agent 提供项目特定的 AI 能力。

## 目录结构

```
tilelang-ascend-agent/
├── .agents/              # AI Skills 目录
│   └── skills/          # 具体技能实现
│       ├── tilelang-debug-helper/      # 调试辅助
│       ├── requesting-code-review/    # 代码审查
│       └── skill-creator/            # Skill 创建（软链接）
├── AGENTS.md             # TileLang-Ascend 项目架构说明
└── README.md            # 本文档
```

## Skills 功能总览

| Skill 名称 | 功能描述 | 使用场景 | 触发关键词 | 使用方法 |
|-----------|---------|---------|-----------|---------|
| tilelang-debug-helper | TileLang 调试辅助 | 为 TileLang 示例添加 GDB 调试支持，创建可调试版本 | 调试、GDB、断点、VSCode 调试 | 1. 读取需要调试的示例文件<br/>2. 在合适位置添加调试代码（打印 PID、等待 GDB 附加）<br/>3. 保存调试版本文件 |
| requesting-code-review | 代码审查 | 自动进行代码质量检查，发现潜在问题 | 完成、实现、审查、review | 1. 获取 git SHA（BASE_SHA、HEAD_SHA）<br/>2. 调用 code-reviewer subagent<br/>3. 根据反馈修复问题 |
| skill-creator | Skill 创建 | 创建新 Skills，改进现有 Skills，运行评估和性能测试（软链接） | 创建 skill、优化 skill、改进 skill | 1. 创建 Skill 目录和 SKILL.md<br/>2. 编写 Skill 内容<br/>3. 测试 Skill<br/>4. 评估和优化 |

## 详细说明

### 1. tilelang-debug-helper

**功能**：为 TileLang 示例添加 GDB 调试支持

**使用场景**：
- 调试 TileLang 示例代码
- 添加 GDB 调试代码
- 创建可调试版本的示例
- 需要检查 C++ 代码执行流程

**使用方法**：
1. 读取需要调试的示例文件（通常在 `examples/` 目录）
2. 找到合适的位置插入调试代码（在 kernel 执行之前）
3. 添加以下代码：
   ```python
   import os
   print(f"PID: {os.getpid()}")
   input("Press Enter after attaching GDB...")
   ```
4. 保存修改后的文件

**输出**：
- 调试版本的文件路径
- 使用说明（运行、附加 GDB、继续）

### 2. requesting-code-review

**功能**：自动进行代码质量检查

**使用场景**：
- 完成任务后审查
- 实现主要功能前审查
- 合并到主分支前审查

**使用方法**：
1. 获取 git SHA：
   ```bash
   BASE_SHA=$(git rev-parse HEAD~1)
   HEAD_SHA=$(git rev-parse HEAD)
   ```
2. 调用 code-reviewer subagent
3. 根据反馈修复问题：
   - Critical：立即修复
   - Important：继续前修复
   - Minor：记录稍后处理

**输出**：
- 代码审查结果
- 发现的问题（Critical/Important/Minor）
- 评估建议

### 3. skill-creator

**功能**：创建和优化 Skills（软链接）

**使用场景**：
- 从零创建新 Skill
- 改进现有 Skill
- 运行 Skill 评估和性能测试

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

## AGENTS.md 在 OpenCode 中的作用

### 作用

`AGENTS.md` 是 TileLang-Ascend 项目的架构说明文档，为 OpenCode Agent 提供项目结构的全面理解。

### 主要价值

1. **项目理解**
   - 帮助 AI Agent 快速理解项目结构
   - 明确各模块的职责和关系
   - 理解编译流程和数据流

2. **代码导航**
   - 提供代码定位和导航指引
   - 明确文件和目录的用途
   - 辅助快速找到相关代码

3. **开发指导**
   - 明确各模块的协作方式
   - 提供开发规范和最佳实践
   - 指导问题诊断方向

4. **问题诊断**
   - 辅助定位问题和理解错误来源
   - 提供架构层面的上下文
   - 支持更准确的错误分析

### 如何使用

#### 1. 自动加载

OpenCode Agent 会自动加载项目根目录的 `AGENTS.md` 文件：

```bash
# 在 tilelang-ascend 项目根目录
/path/to/tilelang-ascend/AGENTS.md
```

#### 2. 挂载使用

如果 `AGENTS.md` 不在项目根目录，可以挂载：

```bash
# 创建软链接
ln -s /path/to/tilelang-agent/tilelang-ascend-agent/AGENTS.md \
      /path/to/tilelang-ascend/AGENTS.md
```

#### 3. 验证加载

检查 OpenCode Agent 是否正确加载：

```bash
# 查看项目上下文
# OpenCode Agent 会显示加载的文档
```

### 如何修改

#### 1. 修改原则

- **保持结构一致**：遵循现有文档结构
- **使用标准格式**：使用 Markdown 标准格式
- **版本兼容性**：更新时保持向后兼容
- **准确性**：确保信息准确和完整

#### 2. 更新内容

**项目结构变化时**：
- 更新"目录结构说明"章节
- 添加新的目录或文件说明
- 更新架构图（如需要）

**新增功能时**：
- 在相应章节添加功能说明
- 更新"技术特性"章节
- 添加使用示例

**重大变更时**：
- 更新"整体架构图"
- 更新"模块间数据流"
- 添加迁移指南（如需要）

#### 3. 提交规范

```bash
# 格式：<type>(<scope>): <subject>

# 示例
git commit -m "docs(agents): update AGENTS.md - add new module description"
git commit -m "docs(agents): update architecture diagram for new feature"
```

#### 4. 验证修改

修改后验证：
- 文档结构是否完整
- 链接是否有效
- Mermaid 图是否正确
- 内容是否准确

## 使用指南

### 挂载到 tilelang-ascend 项目

```bash
# 挂载 .agents 目录
ln -s /path/to/tilelang-agent/tilelang-ascend-agent/.agents \
      /path/to/tilelang-ascend/.agents

# 挂载 AGENTS.md
ln -s /path/to/tilelang-agent/tilelang-ascend-agent/AGENTS.md \
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
用户: 帮我调试这个 GEMM 示例
# AI 自动加载 tilelang-debug-helper

用户: 我刚完成了这个功能，帮我 review 一下
# AI 自动加载 requesting-code-review

# 手动指定
用户: 使用 tilelang-install-skill 安装 TileLang
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

### 修改 AGENTS.md

1. **修改原则**
   - 保持文档结构一致
   - 使用 Markdown 标准格式
   - 更新时保持版本兼容性

2. **更新内容**
   - 项目结构变化时更新目录结构说明
   - 新增功能时添加到相应章节
   - 重大变更时更新架构图

3. **提交信息格式**
   ```bash
   git commit -m "docs: update AGENTS.md - 添加新模块说明"
   ```

### Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type 类型

- `f`eat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

#### Scope 范围

- `skills`: Skills 相关
- `agents`: AGENTS.md 相关
- `docs`: 文档相关

#### 示例

```bash
# 添加新 Skill
git commit -m "feat(skills): add new skill for debugging"

# 修改 AGENTS.md
git commit -m "docs(agents): update AGENTS.md - add new module description"

# 修复 Skill 问题
git commit -m "fix(skills): fix trigger keywords in debug-helper skill"
```

## 相关资源

- [主文档](../README.md)
- [操作指南](../guide/README.md)
- [脚本参考](../scripts/README.md)
- [TileLang-Ascend 仓库](https://github.com/tile-ai/tilelang-ascend)
- [OpenCode 文档](https://opencode.ai)

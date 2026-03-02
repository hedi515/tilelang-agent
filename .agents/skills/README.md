# AI Skills

本目录包含自定义的 AI Skills，用于辅助 TileLang 开发。

## 可用 Skills

### tilelang-install-skill

**功能**: 完整的 TileLang 安装流程

**使用场景**:
- 在算力平台环境上安装 TileLang
- 配置 SSH 密钥
- 克隆仓库并初始化子模块
- 处理安装过程中的各种问题

**触发方式**: 提及"安装 TileLang"、"设置 TileLang"、"配置 TileLang"等关键词

**详细文档**: [.agents/skills/tilelang-install-skill/SKILL.md](../.agents/skills/tilelang-install-skill/SKILL.md)

### tilelang-debug-helper

**功能**: 为 TileLang 示例添加调试能力

**使用场景**:
- 调试 TileLang 示例代码
- 添加 GDB 调试代码
- 创建可调试版本的示例
- 需要检查 C++ 代码执行流程

**触发方式**: 提及"调试"、"GDB"、"断点"、"VSCode 调试"等关键词

**详细文档**: [.agents/skills/tilelang-debug-helper/SKILL.md](../.agents/skills/tilelang-debug-helper/SKILL.md)

### skill-creator

**功能**: 创建和优化 Skills

**使用场景**:
- 从零创建新 Skill
- 改进现有 Skill
- 运行 Skill 评估和性能测试
- 优化 Skill 的描述以提高触发准确率

**触发方式**: 提及"创建 skill"、"优化 skill"、"改进 skill"等关键词

**详细文档**: [.agents/skills/skill-creator/SKILL.md](../.agents/skills/skill-creator/SKILL.md)

### requesting-code-review

**功能**: 代码审查

**使用场景**:
- 完成任务后进行代码审查
- 实现主要功能前审查
- 合并到主分支前审查
- 需要代码质量检查

**触发方式**: 完成任务、实现功能或准备合并时自动触发

**详细文档**: [.agents/skills/requesting-code-review/SKILL.md](../.agents/skills/requesting-code-review/SKILL.md)

### xlsx

**功能**: Excel 文件处理

**使用场景**:
- 处理 Excel 数据文件
- 数据转换和分析
- 生成 Excel 报告

**详细文档**: [.agents/skills/xlsx/SKILL.md](../.agents/skills/xlsx/SKILL.md)

## 使用示例

### 在对话中使用 Skill

大多数 Skills 会根据对话内容自动触发：

```
用户: 帮我安装 TileLang
# AI 会自动加载 tilelang-install-skill

用户: 这个 GEMM 示例有问题，帮我调试一下
# AI 会自动加载 tilelang-debug-helper

用户: 我想创建一个新的 skill 来处理 JSON 文件
# AI 会自动加载 skill-creator

用户: 我刚完成了这个功能，帮我 review 一下
# AI 会自动加载 requesting-code-review
```

### 手动指定 Skill

如果自动触发不满足需求，可以手动指定：

```
用户: 使用 skill-creator 创建一个新 skill
用户: 使用 tilelang-debug-helper 调试这个文件
用户: 使用 requesting-code-review 审查这段代码
```

### 组合使用

Skills 可以组合使用完成复杂任务：

```
# 场景：开发新算子
用户: 我要开发一个新的 Flash Attention 算子
# → AI 可能使用 skill-creator 创建开发流程

用户: 算子写好了，帮我 review
# → 触发 requesting-code-review

AI: 发现几个问题：
1. 内存布局检查不够完善
2. 缺少边界条件处理
3. 可以添加性能优化建议

用户: 好的，我来修复这些问题
[用户修复代码]

用户: 修复完成，再次 review
# → 再次触发 requesting-code-review

AI: 现在看起来不错，可以测试了

用户: 测试时遇到问题，帮我调试
# → 触发 tilelang-debug-helper

AI: 已添加调试代码，运行后会打印 PID，等待 GDB 附加...
```

## 最佳实践

### 1. 明确表达意图

清晰说明需要做什么，帮助 AI 选择合适的 Skill：

```
❌ 不好的示例：
用户: 这个有问题

✅ 好的示例：
用户: 这个 GEMM 示例运行时出现段错误，帮我调试一下
```

### 2. 提供上下文

给出相关文件路径和错误信息：

```
✅ 好的示例：
用户: examples/gemm/example_gemm.py 中的 GEMM 算子在第 50 行出现段错误，
错误信息是：Segmentation fault (core dumped)，帮我调试
```

### 3. 分步骤进行

复杂任务分解为多个步骤，每步使用合适的 Skill：

```
✅ 好的示例：
用户: 我要开发一个新的算子，分三步：
1. 先用 skill-creator 创建开发框架
2. 实现核心逻辑
3. 用 requesting-code-review 审查代码
```

### 4. 及时反馈

对 AI 的输出提供反馈，帮助改进：

```
✅ 好的示例：
用户: 你生成的调试代码有问题，PID 打印的位置不对，
应该在 main 函数开始时就打印，请修改
```

## 完整开发流程示例

### 开发新算子

```
# 步骤 1: 创建开发框架
用户: 我要开发一个新的 Flash Attention 算子，使用 skill-creator 创建开发框架

AI: 好的，我来帮你创建 Flash Attention 算子的开发框架...
[AI 创建文件结构、基础代码、测试框架]

# 步骤 2: 实现核心逻辑
用户: 现在开始实现核心逻辑，参考 examples/flash_attention/ 中的实现

AI: 好的，让我先查看参考实现...
[AI 分析参考代码，实现核心逻辑]

# 步骤 3: 代码审查
[AI 自动触发 requesting-code-review]

AI: 代码审查发现以下问题：
1. 内存分配没有检查大小
2. 缺少输入验证
3. 注释不够详细

# 步骤 4: 修复问题
用户: 好的，我来修复这些问题
[用户修复代码]

# 步骤 5: 再次审查
用户: 修复完成，再次 review
[AI 再次触发 requesting-code-review]

AI: 现在代码质量不错，可以测试了

# 步骤 6: 测试和调试
用户: 测试时发现性能问题，帮我调试
[AI 触发 tilelang-debug-helper]

AI: 已添加调试代码，运行后会打印 PID，等待 GDB 附加...
# 用户使用 VSCode 附加 GDB 进行调试

# 步骤 7: 最终审查
用户: 调试完成，问题已解决，最终 review 一下
[AI 最终代码审查]

AI: 代码已通过最终审查，可以提交了
```

### 快速修复 Bug

```
# 步骤 1: 描述问题
用户: examples/gemm/example_gemm.py 在处理 1024x1024 矩阵时结果不正确，
预期结果应该是单位矩阵，但实际结果包含非对角线元素

# 步骤 2: 调试
[AI 触发 tilelang-debug-helper]

AI: 我来添加调试代码，帮你定位问题...

# 步骤 3: 分析问题
用户: 运行后发现是 L0C 寄存器没有正确清零

# 步骤 4: 修复
用户: 我来修复这个问题，在循环开始前添加 L0C 清零

# 步骤 5: 验证
用户: 修复完成，帮我 review 一下
[AI 触发 requesting-code-review]

AI: 修复正确，代码审查通过
```

## 更多信息

- [Skill 开发指南](https://github.com/anthropics/skills)
- [Skills 市场](https://skills.sh/)
- [Skills 使用指南](../guide/development/skills.md)
- [Skills 参考](../guide/reference/skills-reference.md)

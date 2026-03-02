# Skills 使用指南

如何在 TileLang 开发中使用自定义 Skills。

## 概述

Skills 是可重用的 AI 能力模块，可以自动触发或手动调用。tilelang-agent 提供了多个专为 TileLang 开发优化的 Skills。

## 自动触发

大多数 Skills 会根据对话内容自动触发，无需手动指定。

### 安装相关

当对话中涉及安装、配置、设置等关键词时，会自动触发 `tilelang-install-skill`：

```
用户: 帮我在算力平台上安装 TileLang
# → 自动触发 tilelang-install-skill

用户: 我想设置 TileLang 开发环境
# → 自动触发 tilelang-install-skill

用户: 如何配置 CANN 环境？
# → 自动触发 tilelang-install-skill
```

### 调试相关

当对话中涉及调试、GDB、断点等关键词时，会自动触发 `tilelang-debug-helper`：

```
用户: 这个 GEMM 示例有 bug，帮我调试
# → 自动触发 tilelang-debug-helper

用户: 我需要用 GDB 调试这个内核
# → 自动触发 tilelang-debug-helper

用户: VSCode 调试配置怎么设置？
# → 自动触发 tilelang-debug-helper
```

### 代码审查

当完成任务、实现功能或准备提交时，会自动触发 `requesting-code-review`：

```
用户: 我刚完成了这个功能，帮我 review 一下
# → 自动触发 requesting-code-review

用户: 准备提交代码了
# → 自动触发 requesting-code-review

用户: 代码写完了，检查一下有没有问题
# → 自动触发 requesting-code-review
```

### Skill 创建

当对话中涉及创建、优化、改进 Skills 知识时，会自动触发 `skill-creator`：

```
用户: 我想创建一个新的 skill 来处理 JSON 文件
# → 自动触发 skill-creator

用户: 帮我优化这个 skill 的描述
# → 自动触发 skill-creator

用户: 我想改进现有 skill 的性能
# → 自动触发 skill-creator
```

## 手动调用

如果自动触发不满足需求，可以手动指定 Skill：

```
用户: 使用 skill-creator 创建一个新 skill
用户: 使用 tilelang-debug-helper 调试这个文件
用户: 使用 requesting-code-review 审查这段代码
```

手动调用适用于：
- 明确知道需要哪个 Skill
- 自动触发没有正确识别
- 需要组合使用多个 Skills

## 组合使用

Skills 可以组合使用完成复杂任务，充分发挥各自的优势。

### 场景 1: 开发新算子

```
# 步骤 1: 创建开发框架
用户: 我要开发一个新的 Flash Attention 算子
# → AI 可能使用 skill-creator 创建开发流程

AI: 好的，我来帮你创建 Flash Attention 算子的开发框架...
[AI 创建文件结构、基础代码、测试框架]

# 步骤 2: 实现核心逻辑
用户: 现在开始实现核心逻辑，参考 examples/flash_attention/ 中的实现

AI: 好的，让我先查看参考实现...
[AI 分析参考代码，实现核心逻辑]

# 步骤 3: 代码审查
用户: 算子写好了，帮我 review 一下
# → 触发 requesting-code-review

AI: 发现几个问题：
1. 内存布局检查不够完善
2. 缺少边界条件处理
3. 可以添加性能优化建议

用户: 好的，我来修复这些问题
[用户修复代码]

# 步骤 4: 再次审查
用户: 修复完成，再次 review
# → 再次触发 requesting-code-review

AI: 现在看起来不错，可以测试了

# 步骤 5: 测试和调试
用户: 测试时发现性能问题，帮我调试
# → 触发 tilelang-debug-helper

AI: 已添加调试代码，运行后会打印 PID，等待 GDB 附加...
[用户使用 VSCode 附加 GDB 进行调试]

# 步骤 6: 最终审查
用户: 调试完成，问题已解决，最终 review 一下
# → 最终触发 requesting-code-review

AI: 代码已通过最终审查，可以提交了
```

### 场景 2: 快速修复 Bug

```
# 步骤 1: 描述问题
用户: examples/gemm/example_gemm.py 在处理 1024x1024 矩阵时结果不正确，
预期结果应该是单位矩阵，但实际结果包含非对角线元素

# 步骤 2: 调试
# → AI 触发 tilelang-debug-helper

AI: 我来添加调试代码，帮你定位问题...

# 步骤 3: 分析问题
用户: 运行后发现是 L0C 寄存器没有正确清零

# 步骤 4: 修复
用户: 我来修复这个问题，在循环开始前添加 L0C 清零

# 步骤 5: 验证
用户: 修复完成，帮我 review 一下
# → 触发 requesting-code-review

AI: 修复正确，代码审查通过
```

### 场景 3: 创建自定义 Skill

```
# 步骤 1: 创建 Skill
用户: 我想创建一个 skill 来处理 CMake 配置
# → 触发 skill-creator

AI: 好的，我来帮你创建一个 CMake 配置 skill...
[AI 创建 skill 草稿]

# 步骤 2: 测试 Skill
用户: 测试一下这个 skill

AI: 好的，我来测试这个 skill...
[AI 运行测试用例]

# 步骤 3: 改进 Skill
用户: 测试发现有些情况处理不好，帮我改进
# → 再次触发 skill-creator

AI: 好的，我来改进这个 skill...
[AI 改进 skill]

# 步骤 4: 最终验证
用户: 改进完成，再测试一下

AI: 测试通过！skill 已经可以使用了
```

## 最佳实践

### 1. 明确表达意图

清晰说明需要做什么，帮助 AI 选择合适的 Skill。

```
❌ 不好的示例：
用户: 这个有问题

✅ 好的示例：
用户: 这个 GEMM 示例运行时出现段错误，帮我调试一下
```

### 2. 提供上下文

给出相关文件路径和错误信息，帮助 AI 更好地理解问题。

```
❌ 不好的示例：
用户: 帮我调试这个文件

✅ 好的示例：
用户: examples/gemm/example_gemm.py 中的 GEMM 算子在第 50 行出现段错误，
错误信息是：Segmentation fault (core dumped)，帮我调试
```

### 3. 分步骤进行

复杂任务分解为多个步骤，每步使用合适的 Skill。

```
❌ 不好的示例：
用户: 帮我完成这个复杂的任务

✅ 好的示例：
用户: 我要完成这个复杂任务，分三步：
1. 先创建开发框架
2. 实现核心逻辑
3. 最后进行代码审查
```

### 4. 及时反馈

对 AI 的输出提供反馈，帮助改进结果。

```
❌ 不好的示例：
用户: （不提供反馈）

✅ 好的示例：
用户: 你生成的调试代码有问题，PID 打印的位置不对，
应该在 main 函数开始时就打印，请修改
```

### 5. 利用自动触发

充分利用自动触发机制，让 AI 自动选择合适的 Skill。

```
✅ 好的示例：
用户: 我刚写完这个功能
# → AI 自动触发 requesting-code-review

❌ 不好的示例：
用户: 使用 requesting-code-review 审查我刚才写的代码
```

## 完整对话示例

### 示例 1: 从零开发算子

```
用户: 我要开发一个新的 GEMM 算子，支持矩阵乘法

AI: 好的，我来帮你开发 GEMM 算子。让我先查看一下现有的 GEMM 示例...

[AI 分析现有代码]

AI: 我看到了现有的 GEMM 实现，我会基于此创建新版本。
你需要什么特性？

用户: 需要支持以下特性：
1. 支持任意大小的矩阵
2. 使用 L1 缓存优化
3. 支持批处理

AI: 好的，我来实现这些特性...

[AI 实现代码]

AI: 代码已实现完成，需要我 review 一下吗？

用户: 好的，review 一下

[AI 触发 requesting-code-review]

AI: 代码审查结果：

🔍 发现的问题：
1. 批处理逻辑有边界条件问题
2. L1 缓存大小计算不准确
3. 缺少输入验证

✅ 做得好的地方：
- 代码结构清晰
- 注释详细
- 使用了正确的 TileLang 原语

用户: 好的，我来修复这些问题

[用户修复代码]

用户: 修复完成，再次 review

[AI 再次触发 requesting-code-review]

AI: 代码审查通过！现在可以测试了。

用户: 测试时发现性能问题，帮我调试

[AI 触发 tilelang-debug-helper]

AI: 我来添加调试代码...

[AI 添加调试代码]

AI: 运行这个调试版本会打印 PID，等待 GDB 附加。

[用户运行调试版本，使用 VSCode 附加 GDB]

用户: 调试发现是 L1 缓存配置问题，我修复了

AI: 好的，最终 review 一下？

[AI 最终触发 requesting-code-review]

AI: 最终审查通过！代码可以提交了。
```

### 示例 2: 快速问题定位

```
用户: 我的 Flash Attention 算子结果不正确

AI: 我来帮你定位问题。先查看一下代码...

[AI 查看代码]

AI: 我看到了代码，添加调试代码帮你定位问题。

[AI 触发 tilelang-debug-helper]

AI: 已添加调试代码，运行后会打印 PID，等待 GDB 附加。

[用户运行调试版本]

用户: 运行后发现是注意力计算中的 softmax 实现有问题

AI: 好的，我来修复 softmax 实现...

[AI 修复代码]

AI: 修复完成，review 一下？

[AI 触发 requesting-code-review]

AI: 修复正确，代码审查通过
```

## 常见问题

### Q: 如何知道哪个 Skill 被触发了？

A: AI 会在响应中明确说明使用了哪个 Skill，例如：
```
AI: 我正在使用 tilelang-debug-helper 来帮你调试...
```

### Q: 如果自动触发不工作怎么办？

A: 可以手动指定 Skill：
```
用户: 使用 tilelang-debug-helper 调试这个文件
```

### Q: 可以同时使用多个 Skill 吗？

A: 可以，但通常是按顺序使用，一个任务完成后使用下一个。

### Q: 如何查看所有可用的 Skills？

A: 查看 `.agents/skills/README.md` 文件。

### Q: 可以创建自己的 Skill 吗？

A: 可以，使用 `skill-creator` 来创建和测试自定义 Skills。

## 更多信息

- [Skills 概览](../.agents/skills/README.md)
- [Skills 参考](../reference/skills-reference.md)
- [Skill 开发指南](https://github.com/anthropics/skills)

# Skills 参考

详细的 Skills 功能说明和使用指南。

## tilelang-install-skill

### 完整功能

- 系统兼容性检查
- SSH 密钥配置
- 仓库克隆
- 子模块镜像配置
- 子模块初始化和更新
- 安装脚本执行
- 安装验证

### 前置条件

- Linux 操作系统（不支持 macOS 或 Windows）
- Git 已安装
- Python 3.10 或更高
- Bash shell
- GitHub 仓库访问权限

### 详细步骤

#### 1. 检查系统环境

验证操作系统是否为 Linux，不支持 macOS 或 Windows。

#### 2. 检查 Git 安装

确保 Git 已安装，否则没有 sudo 权限无法安装。

#### 3. 检查 Python 版本

确保 Python 版本 >= 3.10。

#### 4. 配置 SSH 密钥（如果需要）

检查是否已配置 SSH 密钥：
- 如果已配置，跳过此步骤
- 如果未配置，提示用户配置或提供配置指南

#### 5. 克隆 tilelang-ascend 仓库

使用默认或用户指定的仓库地址克隆代码。

#### 6. 配置子模块镜像

修改 `.gitmodules` 文件，使用镜像加速子模块下载。

#### 7. 初始化子模块

运行 `git submodule init` 初始化子模块。

#### 8. 更新子模块

运行 `git submodule update --recursive` 更新所有子模块。

#### 9. 执行安装脚本

运行 `install_ascend.sh` 进行实际安装。

#### 10. 验证安装

检查安装是否成功，验证关键组件。

### 使用示例

```
用户: 帮我在算力平台上安装 TileLang
AI: 好的，我来帮你安装 TileLang...

[AI 执行上述步骤]

AI: TileLang 安装完成！验证结果：
✓ Python 版本: 3.10.12
✓ TileLang 版本: 0.1.0
✓ CANN 版本: 8.0.RC3
```

### 常见问题

**问题**: Git 未安装

**解决**: 
```bash
sudo apt-get install git
```

**问题**: SSH 密钥未配置

**解决**:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# 将公钥添加到 GitHub
```

---

## tilelang-debug-helper

### 功能说明

为 TileLang 示例添加 GDB 调试支持，使其可以在 VSCode 中进行调试。

### 添加的代码

#### 1. 打印进程 ID (PID)

```python
import os
print(f"Process ID: {os.getpid()}")
print("Waiting for GDB to attach...")
```

#### 2. 等待 GDB 附加

```python
import signal
import time

# 等待 GDB 附加
while True:
    time.sleep(1)
```

#### 3. 保持进程运行

确保进程不会在 GDB 附加前退出。

### 使用流程

#### 步骤 1: 读取原始示例文件

读取需要调试的示例文件，通常位于 `examples/` 目录。

#### 步骤 2: 添加调试代码

在适当位置添加调试代码：
- 在 main 函数开始处添加 PID 打印
- 添加等待 GDB 附加的代码

#### 步骤 3: 创建调试版本

创建新的调试版本文件，通常命名为 `example_debug.py`。

#### 步骤 4: 运行调试版本

运行调试版本，会打印 PID 并等待 GDB 附加。

#### 步骤 5: 使用 VSCode 附加 GDB

在 VSCode 中配置 GDB 并附加到进程。

### VSCode 配置

需要配置 `.vscode/launch.json`：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Attach with GDB",
      "type": "cppdbg",
      "request": "attach",
      "program": "${workspaceFolder}/build/libtilelang.so",
      "MIMode": "gdb",
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ]
    }
  ]
}
```

### 使用示例

```
用户: examples/gemm/example_gemm.py 有问题，帮我调试
AI: 好的，我来为这个示例添加调试代码...

[AI 读取文件，添加调试代码]

AI: 已创建调试版本 examples/gemm/example_gemm_debug.py
运行这个文件会打印 PID，等待 GDB 附加。

用户: 运行调试版本
bash examples/gemm/example_gemm_debug.py
# 输出: Process ID: 12345
# 输出: Waiting for GDB to attach...

[用户在 VSCode 中附加 GDB 到进程 12345]

用户: 已附加 GDB，可以调试了
```

### 调试技巧

1. **设置断点**: 在 C++ 代码中设置断点
2. **查看变量**: 使用 `print` 命令查看变量值
3. **单步执行**: 使用 `step` 或 `next` 命令
4. **查看调用栈**: 使用 `bt` 命令

---

## skill-creator

### 功能说明

创建新 Skills 和迭代改进现有 Skills。

### 开发流程

#### 1. 确定 Skill 功能和实现方式

明确 Skill 要解决的问题和实现方式。

#### 2. 编写 Skill 草稿

编写初始版本的 Skill，包括：
- Skill 名称和描述
- 前置条件
- 使用步骤
- 示例对话

#### 3. 创建测试提示词

创建一组测试提示词，覆盖 Skill 的主要功能。

#### 4. 运行并评估结果

运行 Skill 并评估结果：
- 定性评估：人工检查结果质量
- 定量评估：使用 eval-viewer 工具

#### 5. 根据反馈重写 Skill

根据评估结果改进 Skill。

#### 6. 扩展测试集

添加更多测试用例，覆盖边界情况。

#### 7. 重复直到满意

重复评估和改进，直到 Skill 达到预期效果。

### 评估方法

#### 定性评估

人工检查 Skill 的输出质量：
- 是否理解用户意图
- 是否给出正确的建议
- 是否提供有用的信息

#### 定量评估

使用 eval-viewer 工具进行定量评估：
```bash
python eval-viewer/generate_review.py
```

查看评估结果：
- 准确率
- 完整性
- 一致性

#### 性能基准

分析 Skill 的性能：
- 响应时间
- 方差分析
- 一致性检查

### 使用示例

```
用户: 我想创建一个新的 skill 来处理 JSON 文件
AI: 好的，我来帮你创建一个 JSON 处理 skill...

[AI 创建 skill 草稿]

AI: 我创建了以下 skill:
- 名称: json-processor
- 功能: 读取、解析和处理 JSON 文件
- 触发条件: 提及 JSON、解析、处理等关键词

[AI 创建测试用例]

AI: 我创建了一些测试用例，要运行评估吗？

用户: 好的，运行评估
[AI 运行评估]

AI: 评估结果：
✓ 准确率: 95%
✓ 完整性: 90%
✓ 一致性: 88%

需要改进的地方：
1. 错误处理不够完善
2. 大文件处理性能有待提升

[AI 改进 skill]

AI: 已改进 skill，再次评估？
```

---

## requesting-code-review

### 功能说明

在关键节点进行代码审查，使用 superpowers:code-reviewer 子代理。

### 核心原则

**Review early, review often.**

### 必须审查的场景

#### 1. 子代理驱动的开发

每个任务完成后必须进行代码审查。

#### 2. 完成主要功能

实现主要功能后必须进行代码审查。

#### 3. 合并到主分支前

合并到 main 分支前必须进行代码审查。

### 可选但有价值的场景

#### 1. 遇到困难时

获得新视角，发现可能遗漏的问题。

#### 2. 复杂功能实现前

提前发现设计问题。

#### 3. 代码重构后

确保重构没有引入新问题。

### 审查内容

代码审查会检查：

1. **代码质量**
   - 命名规范
   - 代码风格
   - 注释完整性

2. **功能正确性**
   - 逻辑错误
   - 边界条件
   - 错误处理

3. **性能问题**
   - 性能瓶颈
   - 资源泄漏
   - 优化建议

4. **安全性**
   - 安全漏洞
   - 输入验证
   - 权限检查

### 使用示例

```
用户: 我刚完成了 GEMM 算子的实现
[AI 自动触发 requesting-code-review]

AI: 我来审查一下你的代码...

[AI 调用 code-reviewer]

AI: 代码审查结果：

🔍 发现的问题：

1. **内存泄漏**
   - 位置: examples/gemm/example_gemm.py:45
   - 问题: 分配的内存没有释放
   - 建议: 在函数结束前添加内存释放代码

2. **边界条件**
   - 位置: examples/gemm/example_gemm.py:78
   - 问题: 没有检查输入矩阵是否为空
   - 建议: 添加函数开头检查

3. **性能优化**
   - 位置: examples/gemm/example_gemm.py:120
   - 问题: 可以使用向量化优化
   - 建议: 使用 T.Parallel 进行向量化

✅ 做得好的地方：
- 代码结构清晰
- 注释详细
- 错误处理完善

用户: 好的，我来修复这些问题
[用户修复代码]

用户: 修复完成，再次 review
[AI 再次触发 requesting-code-review]

AI: 代码审查通过！可以提交了。
```

### 审查最佳实践

1. **及时审查**: 不要等到最后才审查
2. **小步审查**: 每完成一个小功能就审查
3. **重视反馈**: 认真对待审查意见
4. **持续改进**: 根据审查结果改进代码

---

## xlsx

### 功能说明

处理和分析 Excel 文件。

### 使用场景

1. **读取 Excel 数据**
   - 读取 .xlsx 文件
   - 解析工作表
   - 提取数据

2. **数据转换**
   - 数据类型转换
   - 数据清洗
   - 数据格式化

3. **数据分析**
   - 统计分析
   - 数据聚合
   - 趋势分析

4. **生成报告**
   - 创建新 Excel 文件
   - 写入数据
   - 格式化输出

### 使用示例

```
用户: 帮我分析这个 Excel 文件中的数据
[上传 file.xlsx]

AI: 好的，我来分析这个 Excel 文件...

[AI 读取并分析文件]

AI: 分析结果：

📊 文件信息：
- 文件名: file.xlsx
- 工作表数: 3
- 总行数: 1500
- 总列数: 10

📈 数据统计：
- Sheet1: 500 行 × 10 列
- Sheet2: 600 行 × 8 列
- Sheet3: 400 行 × 12 列

🔍 数据发现：
1. Sheet1 中有 5 个空值
2. Sheet2 的数据类型需要转换
3. Sheet3 包含异常值

需要进一步处理吗？
```

### 支持的功能

- 读取 .xlsx 文件
- 写入 .xlsx 文件
- 数据类型转换
- 数据筛选和排序
- 数据聚合和统计
- 图表生成

---

## 更多信息

- [Skill 开发指南](https://github.com/anthropics/skills)
- [Skills 市场](https://skills.sh/)
- [Skills 使用指南](../development/skills.md)

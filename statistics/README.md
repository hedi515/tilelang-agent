# 统计数据

本目录包含 TileLang 相关的统计数据和分析报告。

## 目录结构

```
statistics/
├── README.md                        # 统计数据说明
├── 202602/                          # 2026年2月统计数据
│   ├── tilelang_ascend_stats.md     # 统计报告
│   └── tilelang_ascend_stats.xlsx   # 原始数据
├── 202603/                          # 2026年3月统计数据（待生成）
└── github_repo_stats_prompt.md      # 统计分析提示词
```

## 统计内容

### GitHub 仓库统计

包含以下指标的统计分析：

- 代码提交趋势
- 贡献者活跃度
- Issue 和 PR 状态
- 代码变更统计
- 项目活跃度评估

### 数据格式

- **Markdown 报告** - 人类可读的统计报告
- **Excel 文件** - 原始数据，可用于进一步分析

## 使用方法

### 查看统计报告

```bash
# 查看最新统计报告
cat statistics/202603/tilelang_ascend_stats.md

# 查看历史统计报告
cat statistics/202602/tilelang_ascend_stats.md
```

### 生成新统计

使用 `github_repo_stats_prompt.md` 中的提示词生成新的统计报告：

```bash
# 使用 xlsx skill 处理数据
opencode "分析 statistics/202603/tilelang_ascend_stats.xlsx，生成报告"
```

### 自定义分析

基于 Excel 数据进行自定义分析：

```bash
# 使用 Python 分析
python3 << EOF
import pandas as pd

# 读取数据
df = pd.read_excel('statistics/202603/tilelang_ascend_stats.xlsx')

# 自定义分析
# ...

# 保存结果
df.to_excel('custom_analysis.xlsx', index=False)
EOF
```

## 统计周期

- **月度统计** - 每月生成一次
- **命名格式** - `YYYYMM` (例如: 202602, 202603)

## 统计指标

### 代码提交

- 提交数量
- 提交趋势
- 活跃时间分布
- 文件变更统计

### 贡献者

- 贡献者数量
- 贡献者活跃度
- 贡献者排名
- 新增贡献者

### Issue 和 PR

- Issue 数量和状态
- PR 数量和状态
- 响应时间
- 解决率

### 代码质量

- 代码行数变化
- 文件数量变化
- 测试覆盖率
- 代码复杂度

## 工具和脚本

### generate_excel.py

生成 Excel 格式的统计数据。

### generate_report.py

基于 Excel 数据生成 Markdown 报告。

## 注意事项

1. 统计数据仅供参考，可能不包含所有历史数据
2. Excel 文件可能包含敏感信息，注意保密
3. 定期更新统计数据以保持时效性
4. 分析时注意数据的时间范围和统计方法

## 相关资源

- [TileLang-Ascend 仓库](https://github.com/tile-ai/tilelang-ascend)
- [GitHub API 文档](https://docs.github.com/en/rest)
- [pandas 文档](https://pandas.pydata.org/)

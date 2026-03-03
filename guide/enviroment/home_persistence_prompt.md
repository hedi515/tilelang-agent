# Home目录持久化配置

## 任务描述
配置home目录持久化，参考文档：tilelang-agent/guide/enviroment/home_persistence.md

## 执行步骤

1. **获取项目目录**
   - 查找包含 `tilelang-agent` 目录的项目根目录
   - 设置项目目录变量：`PROJECT_DIR`

2. **读取文档和脚本内容，确认配置**
   - 读取 `$PROJECT_DIR/tilelang-agent/guide/enviroment/home_persistence.md`
   - 读取 `$PROJECT_DIR/tilelang-agent/scripts/backup_home.sh`
   - 读取 `$PROJECT_DIR/tilelang-agent/scripts/init_home.sh`

3. **执行备份脚本**
   ```bash
   sudo bash $PROJECT_DIR/tilelang-agent/scripts/backup_home.sh
   ```

4. **执行初始化脚本**
   ```bash
   sudo bash $PROJECT_DIR/tilelang-agent/scripts/init_home.sh
   ```

## 重要注意事项

- 脚本会自动跳过不存在的文件/目录，无需手动创建
- 先确定项目目录，再拼接脚本路径
- 脚本路径：`$PROJECT_DIR/tilelang-agent/scripts/`
- 如果遇到错误，检查错误信息并根据提示处理

## 预期结果

- 备份脚本会复制home目录内容到 `/mnt/workspace/home`
- 初始化脚本会创建符号链接，将持久化目录链接回home目录
- 重启后只需执行初始化脚本即可恢复配置

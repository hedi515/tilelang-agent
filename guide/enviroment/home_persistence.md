# 使用说明

1. 初次运行时，先执行备份

```shell
sudo bash $PROJECT_DIR/tilelang-agent/scripts/backup_home.sh
```

**注意**：有些内容不会被备份，不会备份的内容在脚本中的排除列表 `EXCLUDE_LIST` 里

2. 建立软连接到备份的目录

```shell
sudo bash $PROJECT_DIR/tilelang-agent/scripts/init_home.sh
```

**注意**：
- 会被链接过去的目录/子目录/文件，配置在脚本中的 `MAPPED_PATHS` 中，可以自行修改
- 有些文件/目录被占用，无法完全链接过去，比如 `.codearts-server`
- 有些没有必要
- 有些文件/目录在环境初始时并不存在，使用过程中才会创建，脚本会自动跳过这些不存在的文件/目录，无需手动创建
- `$PROJECT_DIR` 为项目根目录，包含 `tilelang-agent` 目录

3. 每次重启后，执行步骤2中的脚本即可恢复配置

----

该 WIKI 来源于：https://gitcode.com/zhanw_coding/cann-tool-box/blob/master/web-ide/README.md
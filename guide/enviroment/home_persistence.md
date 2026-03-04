# Home 目录持久化使用说明

## 概述

本方案通过软链接将容器内的 `/home/developer` 目录中的关键配置文件/目录持久化到 `/mnt/workspace/home`，确保容器重启后配置不丢失。

## 备份和恢复流程

### 1. 执行初始化脚本（首次运行会自动备份）

```shell
sudo bash $PROJECT_DIR/tilelang-agent/scripts/init_home.sh
```

**脚本功能**：
- **首次运行**：自动将 `/home/developer` 中的配置文件备份到 `/mnt/workspace/home`
- **后续运行**：通过软链接将持久化目录映射回 `/home/developer`
- **SSH 特殊处理**：`.ssh` 目录不使用软链接，而是直接复制并同步（SSH 的 StrictModes 检查查不支持符号链接）
- **自动冲突处理**：将冲突文件移动到 `/home/developer.bak`

**会被持久化的内容**（在 `init_home.sh` 的 `MAPPED_PATHS` 中配置）：
- `.bashrc` - Bash 配置文件
- `.bash_aliases` - Bash 别名配置
- `.bun` - Bun 包管理器缓存
- `.config` - 应用配置目录
- `.gitconfig` - Git 配置文件
- `.opencode` - OpenCode 配置
- `.pip` - Python 包管理器缓存
- `.bash_history` - Bash 历史记录

### ⚠️ .ssh 目录特殊处理（重要）

**`.ssh` 目录不支持软链接，采用双向同步机制**：

#### 为什么 .ssh 目录不能使用软链接？

SSH 服务器的 `StrictModes` 安全检查（默认开启）会验证 `.ssh` 目录和密钥文件的权限：

1. **权限检查要求**：
   - `.ssh` 目录权限必须是 `700` 或更严格（仅所有者可读写执行）
   - 私钥文件权限必须是 `600` 或更严格（仅所有者可读写）
   - 公钥文件权限必须是 `644` 或更严格

2. **符号链接问题**：
   - SSH 服务器在检查权限时，会解析符号链接
   - 如果链接指向的文件权限不符合要求，SSH 连接会被拒绝
   - 符号链接本身可能绕过权限检查，存在安全风险

3. **安全机制目的**：
   - 防止权限配置错误导致密钥泄露
   - 确保只有文件所有者能访问敏感的 SSH 密钥
   - 防止符号链接攻击（symlink attacks）

#### .ssh 目录的同步机制

脚本采用**双向同步**而非软链接：

1. **首次运行**：从 `/home/developer/.ssh` 复制到 `/mnt/workspace/home/.ssh`（备份）
2. **后续运行**：从 `/mnt/workspace/home/.ssh` 复制到 `/home/developer/.ssh`（恢复）
3. **authorized_keys 特殊处理**：自动合并并去重，确保不丢失密钥
4. **权限自动修复**：自动设置正确的权限和所有权

**会被同步的 SSH 文件**：
- `id_rsa` / `id_ed25519` - 私钥文件
- `id_rsa.pub` / `id_ed25519.pub` - 公钥文件
- `config` - SSH 配置文件
- `known_hosts` - 已知主机列表
- `authorized_keys` - 授权密钥列表（自动合并去重）

### 2. 每次重启后，执行初始化脚本

```shell
sudo bash $PROJECT_DIR/tilelang-agent/scripts/init_home.sh
```

**重要**：容器重启后必须执行此脚本，否则配置会丢失。

## 注意事项

### 文件/目录处理规则
- 有些文件/目录被占用，无法完全链接过去，比如 `.codearts-server`
- 有些文件/目录在环境初始时并不存在，使用过程中才会创建，脚本会自动跳过这些不存在的文件/目录，无需手动创建
- `$PROJECT_DIR` 为项目根目录，包含 `tilelang-agent` 目录

### SSH 目录特殊处理
- `.ssh` 目录不使用软链接，而是直接复制到持久化目录
- 脚本会自动合并 `authorized_keys` 文件（去重）
- 自动修复私钥权限为 `600`
- 确保 `.ssh` 目录所有权为 `developer:developer`

### 手动备份和恢复

#### 手动备份单个配置
```shell
cp -a /home/developer/.bashrc /mnt/workspace/home/
```

#### 手动恢复单个配置
```shell
cp -a /mnt/workspace/home/.bashrc /home/developer/
```

#### 查看当前软链接状态
```shell
ls -la /home/developer/ | grep "^l"
```

#### 查看备份目录内容
```shell
ls -la /mnt/workspace/home/
```

## 故障排查

### SSH 连接失败
如果执行 `init_home.sh` 后无法 SSH 连接，检查 `.ssh` 目录权限：
```shell
sudo ls -la /home/developer/.ssh/
sudo chown -R developer:developer /home/developer/.ssh/
```

### 软链接损坏
如果软链接指向错误，可以删除并重新执行初始化：
```shell
rm /home/developer/.bashrc
sudo bash $PROJECT_DIR/tilelang-agent/scripts/init_home.sh
```

### 备份目录为空
如果 `/mnt/workspace/home` 为空，重新执行备份：
```shell
sudo bash $PROJECT_DIR/tilelang-agent/scripts/backup_home.sh
```

----

该 WIKI 参考于：https://gitcode.com/zhanw_coding/cann-tool-box/blob/master/web-ide/README.md
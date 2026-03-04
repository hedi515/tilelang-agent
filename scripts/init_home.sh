#!/bin/bash
# ======================================================
# 容器启动初始化脚本（增强安全版）
# ======================================================

set -e 

# ---------- 用户配置区域 ----------
SOURCE_HOME="/home/developer"
TARGET_HOME="/mnt/workspace/home"
BACKUP_HOME="${SOURCE_HOME}.bak"

# 需要通过软链接持久化的路径（不含 .ssh）
MAPPED_PATHS=(
    ".bashrc"
    ".bash_aliases"
    ".bun"
    ".config"
    ".gitconfig"
    ".opencode"
    ".pip"
    ".bash_history"
)

CURRENT_USER="developer"
CURRENT_GROUP="developer"

# ---------- 特殊处理 .ssh 目录（核心逻辑） ----------
echo "🔒 正在配置 SSH 安全目录..."

ssh_src="$SOURCE_HOME/.ssh"
ssh_dst="$TARGET_HOME/.ssh"

# 1. 确保目标和源目录存在（真实目录）
mkdir -p "$ssh_dst" "$ssh_src"
chmod 700 "$ssh_dst" "$ssh_src"

# 2. 同步常规 SSH 文件 (私钥、配置、已知主机)
# 使用 -u 仅更新较新的文件，-p 保留权限
for file in id_rsa id_ed25519 config known_hosts; do
    if [ -f "$ssh_dst/$file" ]; then
        cp -up "$ssh_dst/$file" "$ssh_src/"
    elif [ -f "$ssh_src/$file" ]; then
        cp -up "$ssh_src/$file" "$ssh_dst/"
    fi
done

# 3. 特殊处理 authorized_keys (合并与去重)
auth_file_src="$ssh_src/authorized_keys"
auth_file_dst="$ssh_dst/authorized_keys"

if [ -f "$auth_file_dst" ] || [ -f "$auth_file_src" ]; then
    echo "正在合并并去重 authorized_keys..."
    # 合并两个文件到一个临时文件
    touch "$auth_file_src" "$auth_file_dst"
    cat "$auth_file_src" "$auth_file_dst" | sort -u > "${auth_file_src}.tmp"
    
    # 写回源和目标
    mv "${auth_file_src}.tmp" "$auth_file_src"
    cp "$auth_file_src" "$auth_file_dst"
    
    # 强制设置权限
    chmod 600 "$auth_file_src" "$auth_file_dst"
fi

# 4. 修复所有私钥权限
find "$ssh_src" -type f -name "id_*" -exec chmod 600 {} \;

# 确保所有权正确
sudo chown -R $CURRENT_USER:$CURRENT_GROUP "$ssh_src"

echo "✓ SSH 密钥与 authorized_keys 已就绪"

# ---------- 处理符号链接映射（其余目录） ----------
cd /

for relpath in "${MAPPED_PATHS[@]}"; do
    src="$SOURCE_HOME/$relpath"
    dst="$TARGET_HOME/$relpath"

    # 目标不存在则首次备份
    if [ ! -e "$dst" ]; then
        if [ -e "$src" ] && [ ! -L "$src" ]; then
            echo "首次备份 $relpath..."
            mkdir -p "$(dirname "$dst")"
            cp -a "$src" "$dst"
        else
            continue
        fi
    fi

    # 如果是目录/文件冲突，则移动到备份区
    if [ -e "$src" ] && [ ! -L "$src" ]; then
        echo "处理冲突: $relpath"
        backup_path="$BACKUP_HOME/$relpath"
        mkdir -p "$(dirname "$backup_path")"
        mv "$src" "$backup_path"
    elif [ -L "$src" ] && [ "$(readlink "$src")" != "$dst" ]; then
        rm "$src"
    fi

    # 创建软链接
    if [ ! -L "$src" ]; then
        mkdir -p "$(dirname "$src")"
        ln -s "$dst" "$src"
        sudo chown -h $CURRENT_USER:$CURRENT_GROUP "$src"
    fi
done

echo "✨ 环境初始化完成。所有配置已同步且权限已校验。"
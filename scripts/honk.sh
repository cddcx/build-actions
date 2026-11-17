#!/bin/bash

# 定义辅助函数（如果环境中没有 log/die/endgroup，建议定义或使用 echo）
log() { echo "$@"; }
die() { echo "ERROR: $@"; exit 1; }
# 如果是在 GitHub Actions 环境中，可以使用以下函数来折叠日志
start_group() { echo "::group::$1"; }
end_group() { echo "::endgroup::"; }

HONK_DIR="package/honk/honk"
HONK_OUT="package/honk/honk/files/honk-core.bin"

# 1. 解决 git clone 冲突：先检查并清理旧目录
TARGET_CLONE_DIR="package/honk"
if [ -d "$TARGET_CLONE_DIR" ]; then
    echo "⚠️ 目录 $TARGET_CLONE_DIR 已存在，正在清理..."
    rm -rf "$TARGET_CLONE_DIR"
fi

# 执行克隆
echo "📦 克隆 luci-app-honk..."
git clone https://github.com/QiuSimons/luci-app-honk "$TARGET_CLONE_DIR"

# 2. 检查预编译文件是否存在
if [ -s "$HONK_OUT" ]; then
    log " ↷ honk-core.bin 已存在，跳过预放"
else
    # 3. 修复 'group' 命令错误：替换为正确的日志分组或普通 echo
    # 如果是 GitHub Actions，使用 start_group；如果是普通 shell，使用 echo
    if command -v start_group &> /dev/null; then
        start_group "预放 honk-core.bin（免 zig 工具链）"
    else
        echo "--- 预放 honk-core.bin（免 zig 工具链） ---"
    fi

    # 下载核心文件
    curl -fsSL --retry 3 -o /tmp/honk-core.tar.gz \
      "https://github.com/daeuniverse/honk/releases/download/v0.1.0-beta.6/honk-core-v0.1.0-beta.6-x86_64-unknown-linux-musl-stock-native-api.tar.gz"
    
    # 校验完整性
    echo "sha256:d0e8b42ea1e5238f1bcb9707c22d178d417e519f5921db913d3c35aa359409f4  /tmp/honk-core.tar.gz" | sha256sum -c - || die "SHA256 校验失败"

    # 解压并提取
    rm -rf /tmp/honkpkg && mkdir -p /tmp/honkpkg
    tar -xzf /tmp/honk-core.tar.gz -C /tmp/honkpkg
    
    # 查找文件
    core="$(find /tmp/honkpkg -type f -name honk-core -print -quit)"
    if [ -z "$core" ]; then
        die "tarball 内未找到 honk-core，release 结构可能已变"
    fi

    # 确保目标目录存在
    mkdir -p "$(dirname "$HONK_OUT")"
    
    # 复制文件
    cp "$core" "$HONK_OUT"
    
    # 结束日志分组
    if command -v end_group &> /dev/null; then
        end_group
    fi
    
    log " ✅ 已预放 honk-core.bin ($(du -h "$HONK_OUT" | cut -f1))"
fi



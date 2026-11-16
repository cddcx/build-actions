#!/bin/bash
git clone https://github.com/QiuSimons/luci-app-honk package/honk

HONK_DIR="package/honk/honk"
HONK_OUT="package/honk/honk/files/honk-core.bin"
if [ -s "$HONK_OUT" ]; then
    log " ↷ honk-core.bin 已存在，跳过预放"
else
    group "预放 honk-core.bin（免 zig 工具链）"
    curl -fsSL --retry 3 -o /tmp/honk-core.tar.gz \
      "https://github.com/daeuniverse/honk/releases/download/v0.1.0-beta.6/honk-core-v0.1.0-beta.6-aarch64-unknown-linux-musl-stock-native-api.tar.gz"
    echo "be9152ee2034be834200af2abb1bbc9616210d94b948eafa8680f77d87be88a7  /tmp/honk-core.tar.gz" | sha256sum -c -
    rm -rf /tmp/honkpkg && mkdir -p /tmp/honkpkg
    tar -xzf /tmp/honk-core.tar.gz -C /tmp/honkpkg
    core="$(find /tmp/honkpkg -type f -name honk-core -print -quit)"
    [ -n "$core" ] || die "tarball 内未找到 honk-core，release 结构可能已变"
    cp "$core" "$HONK_OUT"
    log " ✅ 已预放 honk-core.bin ($(du -h "$HONK_OUT" | cut -f1))"
    endgroup
fi


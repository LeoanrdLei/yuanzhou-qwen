#!/bin/bash
# 字数统计脚本（中文字符计数）
# 用法: ./scripts/wordcount.sh <文件或目录>

target="${1:-manuscript}"

count_file() {
    local file="$1"
    # macOS 兼容：用 perl 统计中文字符数
    local chinese=$(perl -CSD -ne '$c += () = /[\p{Han}]/g; END { print $c }' "$file" 2>/dev/null)
    local total=${chinese:-0}
    local basename=$(basename "$file")
    printf "%-50s %6d 字\n" "$basename" "$total"
    echo "$total"
}

if [ -f "$target" ]; then
    count_file "$target"
elif [ -d "$target" ]; then
    grand_total=0
    file_count=0
    for f in "$target"/*.md; do
        [ -f "$f" ] || continue
        result=$(count_file "$f")
        num=$(echo "$result" | tail -1)
        grand_total=$((grand_total + num))
        file_count=$((file_count + 1))
    done
    echo "──────────────────────────────────────────────────"
    printf "%-50s %6d 字\n" "合计（${file_count} 个文件）" "$grand_total"
else
    echo "错误: $target 不存在"
    exit 1
fi

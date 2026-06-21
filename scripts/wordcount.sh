#!/bin/bash
# 字数统计脚本（中文字符 + 英文单词）
# 用法: ./scripts/wordcount.sh <文件或目录>

target="${1:-manuscript}"

count_file() {
    local file="$1"
    # 统计中文字符数（Unicode CJK范围）
    local chinese=$(grep -oP '[\x{4e00}-\x{9fff}\x{3400}-\x{4dbf}]' "$file" 2>/dev/null | wc -l)
    # 统计英文单词数
    local english=$(grep -oP '[a-zA-Z]+' "$file" 2>/dev/null | wc -l)
    local total=$((chinese + english))
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
        count=$(count_file "$f")
        # 提取数字
        num=$(echo "$count" | grep -oP '\d+$')
        grand_total=$((grand_total + num))
        file_count=$((file_count + 1))
    done
    echo "──────────────────────────────────────────────────"
    printf "%-50s %6d 字\n" "合计（${file_count} 个文件）" "$grand_total"
else
    echo "错误: $target 不存在"
    exit 1
fi

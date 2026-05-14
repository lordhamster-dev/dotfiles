#!/bin/bash

# --- 配置区 ---
# 书签文件的路径
BOOKMARKS_FILE="$HOME/Sync/Obsidian/3-Resources/Bookmarks.md"
# 默认浏览器 (或者使用 xdg-open)
BROWSER="xdg-open"

# 检查文件是否存在
if [ ! -f "$BOOKMARKS_FILE" ]; then
    notify-send "Error" "书签文件未找到: $BOOKMARKS_FILE"
    exit 1
fi

declare -A urls

# 预定义正则（Bash =~ 中括号需转义）
link_re='\[([^]]+)\]\((http[^)]+)\)'
tag_re='\[\[([^]]+)\]\]'

# 解析 Markdown 文件，提取标题、标签和链接
while IFS= read -r line; do
    # 匹配 [标题](http链接)
    if [[ $line =~ $link_re ]]; then
        title="${BASH_REMATCH[1]}"
        url="${BASH_REMATCH[2]}"

        # 提取所有 [[标签]]
        tag_str=""
        remaining="$line"
        while [[ $remaining =~ $tag_re ]]; do
            tag_str="$tag_str [[${BASH_REMATCH[1]}]]"
            remaining="${remaining#*\]\]}"
        done

        # 组装显示字符串（标题 + 标签，不含链接）
        display="${title}${tag_str}"
        urls["$display"]="$url"
    fi
done < "$BOOKMARKS_FILE"

# 调用 fuzzel 让用户选择（仅显示标题和标签，隐藏链接）
choice=$(printf '%s\n' "${!urls[@]}" | sort -f | fuzzel -d -i -p " ")

# 如果用户做出了选择，提取链接并打开
if [ -n "$choice" ]; then
    url="${urls[$choice]}"
    $BROWSER "$url"
fi
